CREATE TABLE [POSANT].[TB_QualitySupportNetworkFile]
(
[IdQualitySupportNetworkFile] [int] NOT NULL IDENTITY(1, 1),
[QualityFileName] [varchar] (100) NOT NULL,
[QualityFileUrl] [varchar] (max) NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_QualitySupportNetworkFile] ADD CONSTRAINT [PK__TB_Quali__6340B4425DF0CF51] PRIMARY KEY CLUSTERED ([IdQualitySupportNetworkFile])
GO
ALTER TABLE [POSANT].[TB_QualitySupportNetworkFile] ADD CONSTRAINT [FK__TB_Qualit__IdUse__78008E0A] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
