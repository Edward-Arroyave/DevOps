CREATE TABLE [dbo].[TB_TraditionalGrouping]
(
[IdTraditionalGrouping] [tinyint] NOT NULL IDENTITY(1, 1),
[TradicionalGrouping] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TraditionalGrouping] ADD CONSTRAINT [PK_TB_TraditionalGrouping] PRIMARY KEY CLUSTERED ([IdTraditionalGrouping])
GO
