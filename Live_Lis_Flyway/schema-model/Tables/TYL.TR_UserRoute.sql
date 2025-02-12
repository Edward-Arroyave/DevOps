CREATE TABLE [TYL].[TR_UserRoute]
(
[IDUserRoute] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdRoute] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL,
[Associated] [bit] NULL CONSTRAINT [DF__TR_UserRo__Assoc__13298592] DEFAULT ((0))
)
GO
ALTER TABLE [TYL].[TR_UserRoute] ADD CONSTRAINT [PK__TR_UserR__6C3E48C19922D378] PRIMARY KEY CLUSTERED ([IDUserRoute])
GO
ALTER TABLE [TYL].[TR_UserRoute] ADD CONSTRAINT [FK_TR_UserRoute_TB_Route] FOREIGN KEY ([IdRoute]) REFERENCES [TYL].[TB_Route] ([IdRoute])
GO
