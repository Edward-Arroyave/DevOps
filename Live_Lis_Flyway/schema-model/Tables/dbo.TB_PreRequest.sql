CREATE TABLE [dbo].[TB_PreRequest]
(
[IdPreRequest] [int] NOT NULL IDENTITY(1, 1),
[PreRequestNumber] [varchar] (12) NOT NULL,
[IdPatient] [int] NOT NULL,
[PreRequestDate] [datetime] NOT NULL,
[IdPreRequestStatus] [tinyint] NOT NULL,
[IdCompany] [int] NULL,
[IdContract] [int] NULL,
[ExpirationDate] [date] NULL,
[ReasonForCancellation] [varchar] (255) NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Origin] [smallint] NOT NULL,
[Manual] [bit] NULL,
[IdAttentionCenter] [int] NULL,
[IdFiled] [int] NULL,
[OrderingNumber] [varchar] (200) NULL,
[Comment] [varchar] (max) NULL
)
GO
ALTER TABLE [dbo].[TB_PreRequest] ADD CONSTRAINT [PK_TB_PreRequest] PRIMARY KEY CLUSTERED ([IdPreRequest])
GO
CREATE NONCLUSTERED INDEX [Origin] ON [dbo].[TB_PreRequest] ([Origin]) INCLUDE ([IdFiled], [IdPatient], [IdPreRequestStatus], [PreRequestDate], [PreRequestNumber])
GO
ALTER TABLE [dbo].[TB_PreRequest] ADD CONSTRAINT [FK_TB_PreRequest_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_PreRequest] ADD CONSTRAINT [FK_TB_PreRequest_TB_PreRequestStatus] FOREIGN KEY ([IdPreRequestStatus]) REFERENCES [dbo].[TB_PreRequestStatus] ([IdPreRequestStatus])
GO
ALTER TABLE [dbo].[TB_PreRequest] ADD CONSTRAINT [FK_TB_PreRequest_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_PreRequest] ADD CONSTRAINT [TB_PreRequest_TB_PrerequestOrigin] FOREIGN KEY ([Origin]) REFERENCES [dbo].[TB_PrerequestOrigin] ([IdPrerequestOrigin])
GO
