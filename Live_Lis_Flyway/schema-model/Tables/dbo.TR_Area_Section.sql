CREATE TABLE [dbo].[TR_Area_Section]
(
[IdArea_Section] [int] NOT NULL IDENTITY(1, 1),
[IdArea] [int] NOT NULL,
[IdSection] [smallint] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_Area_Section] ADD CONSTRAINT [PK_TR_Area_Section] PRIMARY KEY CLUSTERED ([IdArea_Section])
GO
ALTER TABLE [dbo].[TR_Area_Section] ADD CONSTRAINT [FK_TR_Area_Section_TB_Area] FOREIGN KEY ([IdArea]) REFERENCES [RYS].[TB_Area] ([IdArea])
GO
ALTER TABLE [dbo].[TR_Area_Section] ADD CONSTRAINT [FK_TR_Area_Section_TB_Section] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[TB_Section] ([IdSection])
GO
