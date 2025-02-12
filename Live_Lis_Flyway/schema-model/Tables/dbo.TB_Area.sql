CREATE TABLE [dbo].[TB_Area]
(
[IdArea] [int] NOT NULL IDENTITY(1, 1),
[AreaName] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Area] ADD CONSTRAINT [PK_TB_Area] PRIMARY KEY CLUSTERED ([IdArea])
GO
