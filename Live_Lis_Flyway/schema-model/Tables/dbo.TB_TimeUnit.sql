CREATE TABLE [dbo].[TB_TimeUnit]
(
[IdTimeUnit] [tinyint] NOT NULL IDENTITY(1, 1),
[TimeUnit] [varchar] (7) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TimeUnit] ADD CONSTRAINT [PK_TB_TimeUnit] PRIMARY KEY CLUSTERED ([IdTimeUnit])
GO
