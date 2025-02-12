CREATE TABLE [TYL].[TR_ClientRoute]
(
[IdClientRoute] [int] NOT NULL IDENTITY(1, 1),
[IdRoute] [int] NOT NULL,
[IdClient] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUser] [int] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [TYL].[TR_ClientRoute] ADD CONSTRAINT [PK__TR_Clien__640B7217F9777143] PRIMARY KEY CLUSTERED ([IdClientRoute])
GO
ALTER TABLE [TYL].[TR_ClientRoute] ADD CONSTRAINT [FK_TR_ClientRoute_TB_Route] FOREIGN KEY ([IdRoute]) REFERENCES [TYL].[TB_Route] ([IdRoute])
GO
