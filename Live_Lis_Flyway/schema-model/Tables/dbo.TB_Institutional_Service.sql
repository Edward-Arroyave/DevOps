CREATE TABLE [dbo].[TB_Institutional_Service]
(
[IdInstService] [int] NOT NULL IDENTITY(1, 1),
[IdService] [int] NOT NULL,
[InstServiceCode] [varchar] (5) NOT NULL,
[InstServiceName] [varchar] (500) NOT NULL,
[Active] [bit] NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TB_Institutional_Service] ADD CONSTRAINT [PK_TB_Institutional_Service] PRIMARY KEY CLUSTERED ([IdInstService])
GO
ALTER TABLE [dbo].[TB_Institutional_Service] ADD CONSTRAINT [FK_TB_Institutional_Service_TB_Service] FOREIGN KEY ([IdService]) REFERENCES [dbo].[TB_Service] ([IdService])
GO
ALTER TABLE [dbo].[TB_Institutional_Service] ADD CONSTRAINT [FK_TB_Institutional_Service_TB_User1] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
