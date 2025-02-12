CREATE TABLE [RYS].[SampleTracking]
(
[IDSampleTracking] [int] NOT NULL IDENTITY(1, 1),
[Id_SampleRegistration] [int] NULL,
[Id_SampleType] [int] NULL,
[Id_Section] [smallint] NULL,
[Id_AttentionCenter] [smallint] NULL,
[CreationDate] [datetime] NULL,
[Id_User] [int] NULL,
[UpdateDate] [datetime] NULL,
[IdArea] [int] NOT NULL CONSTRAINT [DF__SampleTra__IdAre__69B26EB3] DEFAULT ((1)),
[Internal] [bit] NULL CONSTRAINT [DF__SampleTra__Inter__6AA692EC] DEFAULT ((0)),
[LabelCode] [varchar] (20) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [RYS].[UPD_SampleTracking]
   ON  [RYS].[SampleTracking]
    AFTER UPDATE
AS 

BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		insert into rys.HistorySampleTracking (IDSampleTracking,IdArea,Id_AttentionCenter,CreationDate,
												UpdateDate,Id_User, Internal, LabelCode)
		select	IDSampleTracking,IdArea,Id_AttentionCenter,isnull(UpdateDate,CreationDate),
				DATEADD(HOUR,-5,GETDATE()), Id_User, Internal, LabelCode
		from	deleted
		
	END TRY 
	BEGIN CATCH
	  declare @mesagge varchar (200)

		set @mesagge = (select	('Could not add update in sample tracking audit history '''
								+ isnull(cast(IDSampleTracking as varchar),'')+''','''
								+isnull(cast(IdArea as varchar),'')+''','''
								+isnull(cast(Id_AttentionCenter as varchar),'')+''','''
								+isnull(cast(CreationDate as varchar),'')+''','''
								+isnull(cast(Id_User as varchar),'')+''','''
								+isnull(cast(UpdateDate as varchar),'')+''','''
								+isnull(cast(Internal as varchar),'')+''','''
								+isnull(cast(Labelcode as varchar),'')+''','''
								+error_message()+', Line: '+cast(error_line() as varchar))
						from	deleted)

		print  @mesagge

	END CATCH
END


--select * from RYS.SampleTracking where IDSampleTracking = 16
--UPDATE [RYS].[SampleTracking] set Id_AttentionCenter=4 where IDSampleTracking = 16
--select * from RYS.SampleTracking where IDSampleTracking = 16
--SELECT * FROM RYS.HistorySampleTracking where IdHistorySampleTracking >= 30 and  IDSampleTracking = 16
GO
ALTER TABLE [RYS].[SampleTracking] ADD CONSTRAINT [PK__SampleTr__6DCB014B6FC4FE41] PRIMARY KEY CLUSTERED ([IDSampleTracking])
GO
CREATE NONCLUSTERED INDEX [Id_SampleRegistration_Id_SampleType] ON [RYS].[SampleTracking] ([Id_SampleRegistration], [Id_SampleType])
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [RYS].[SampleTracking] ([LabelCode])
GO
ALTER TABLE [RYS].[SampleTracking] ADD CONSTRAINT [FK_SampleTracking_TB_Area] FOREIGN KEY ([IdArea]) REFERENCES [RYS].[TB_Area] ([IdArea])
GO
ALTER TABLE [RYS].[SampleTracking] ADD CONSTRAINT [FK_SampleTracking_TB_AttentionCenter] FOREIGN KEY ([Id_AttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [RYS].[SampleTracking] ADD CONSTRAINT [FK_SampleTracking_TB_SampleRegistration] FOREIGN KEY ([Id_SampleRegistration]) REFERENCES [dbo].[TB_SampleRegistration] ([IdSampleRegistration])
GO
ALTER TABLE [RYS].[SampleTracking] ADD CONSTRAINT [FK_SampleTracking_TB_SampleType] FOREIGN KEY ([Id_SampleType]) REFERENCES [dbo].[TB_SampleType] ([IdSampleType])
GO
