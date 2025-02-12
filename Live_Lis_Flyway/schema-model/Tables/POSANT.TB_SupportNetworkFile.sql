CREATE TABLE [POSANT].[TB_SupportNetworkFile]
(
[IdSupportNetworkFile] [int] NOT NULL IDENTITY(1, 1),
[IdSupportNetwork] [int] NOT NULL,
[UrlFile] [varchar] (max) NOT NULL,
[SupportNetworkFileName] [varchar] (100) NULL
)
GO
ALTER TABLE [POSANT].[TB_SupportNetworkFile] ADD CONSTRAINT [PK__TB_Suppo__7855C1C16202C225] PRIMARY KEY CLUSTERED ([IdSupportNetworkFile])
GO
ALTER TABLE [POSANT].[TB_SupportNetworkFile] ADD CONSTRAINT [FK__TB_Suppor__IdSup__0777DBC4] FOREIGN KEY ([IdSupportNetwork]) REFERENCES [POSANT].[TB_SupportNetwork] ([IdSupportNetwork])
GO
