CREATE TABLE [dbo].[TB_SampleRegistrationDetail]
(
[IdSampleRegistrationDetail] [int] NOT NULL IDENTITY(1, 1),
[IdSampleRegistration] [int] NOT NULL,
[LabelCode] [varchar] (15) NOT NULL,
[LabelCodeAlternative] [varchar] (20) NULL,
[RegistrationDate] [datetime] NULL,
[IdSampleRegistrationStatus] [tinyint] NULL,
[Reason] [varchar] (max) NULL,
[Active] [bit] NULL,
[IdUserAction] [int] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TG_SampleRegistrationDetailNotifications]
   ON  [dbo].[TB_SampleRegistrationDetail]
   AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IDSTATUS INT= 0
	DECLARE @IDSTATUSINSERT INT = 0

	IF EXISTS (SELECT * FROM [POSANT].[TB_RejectSamples] WHERE SampleNumber IN (SELECT LabelCode FROM inserted) and Active = 1)
	BEGIN
		SELECT TOP 1 @IDSTATUSINSERT = IdSampleRegistrationStatus FROM inserted
		select top 1 @IDSTATUS = IdSampleRegistrationStatus from [dbo].[TB_SampleRegistrationDetail] where IdSampleRegistrationStatus!= 4 AND LabelCode IN (SELECT TOP 1 LabelCode FROM inserted) order by RegistrationDate

		INSERT INTO [POSANT].[TB_NotificationPending] ([SampleNumber], [StatusSample], [StatusNotification], [StatusDate], [CreationDate], [IdUserAction])
		SELECT LabelCode, 
		CASE @IDSTATUSINSERT
		WHEN 3 THEN 'Aplazado - Tomar a Tomada' 
		WHEN 1 THEN 'Tomada a Recibida'
		WHEN 2 THEN 'Tomada a Aplazado - Recibir'
		WHEN 4 THEN 
			CASE @IDSTATUS 
			WHEN 1 THEN 'Recibida a Aplazado - Tomar' 
			WHEN 3 THEN 'Tomada a Aplazado - Tomar'
			ELSE 'Cambios desde preanalitica'
			END
		ELSE 'Cambios desde preanalitica'
		END, 1, DATEADD(HOUR,-5,GETDATE()), DATEADD(HOUR,-5,GETDATE()), IdUserAction
		FROM inserted
	END
END


GO
ALTER TABLE [dbo].[TB_SampleRegistrationDetail] ADD CONSTRAINT [PK_TB_SampleRegistrationDetail] PRIMARY KEY CLUSTERED ([IdSampleRegistrationDetail])
GO
CREATE NONCLUSTERED INDEX [IdSampleRegistration] ON [dbo].[TB_SampleRegistrationDetail] ([IdSampleRegistration])
GO
ALTER TABLE [dbo].[TB_SampleRegistrationDetail] ADD CONSTRAINT [FK_TB_SampleRegistrationDetail_TB_SampleRegistration] FOREIGN KEY ([IdSampleRegistration]) REFERENCES [dbo].[TB_SampleRegistration] ([IdSampleRegistration])
GO
ALTER TABLE [dbo].[TB_SampleRegistrationDetail] ADD CONSTRAINT [FK_TB_SampleRegistrationDetail_TB_SampleRegistrationStatus] FOREIGN KEY ([IdSampleRegistrationStatus]) REFERENCES [dbo].[TB_SampleRegistrationStatus] ([IdSampleRegistrationStatus])
GO
ALTER TABLE [dbo].[TB_SampleRegistrationDetail] ADD CONSTRAINT [FK_TB_SampleRegistrationDetail_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
