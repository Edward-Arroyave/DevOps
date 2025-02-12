CREATE TABLE [RYS].[TB_Area]
(
[IdArea] [int] NOT NULL IDENTITY(1, 1),
[AreaName] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Area__Active__705F6C42] DEFAULT ((1)),
[CreationDate] [datetime] NULL CONSTRAINT [DF__TB_Area__Creatio__7153907B] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [RYS].[TB_Area] ADD CONSTRAINT [PK__TB_Area__2FC141AAD79396D1] PRIMARY KEY CLUSTERED ([IdArea])
GO
