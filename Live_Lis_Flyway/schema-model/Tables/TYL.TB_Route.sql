CREATE TABLE [TYL].[TB_Route]
(
[IdRoute] [int] NOT NULL IDENTITY(1, 1),
[RouteName] [varchar] (20) NULL,
[IdUser] [int] NULL,
[IdCity] [int] NOT NULL CONSTRAINT [DF__TB_Route__IdCity__08ABF71F] DEFAULT ((1)),
[CreateDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL,
[Deleted] [bit] NULL CONSTRAINT [DF__TB_Route__Delete__09A01B58] DEFAULT ((0))
)
GO
ALTER TABLE [TYL].[TB_Route] ADD CONSTRAINT [PK__TB_Route__A5E13300916A72A4] PRIMARY KEY CLUSTERED ([IdRoute])
GO
ALTER TABLE [TYL].[TB_Route] ADD CONSTRAINT [TB_Route_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
