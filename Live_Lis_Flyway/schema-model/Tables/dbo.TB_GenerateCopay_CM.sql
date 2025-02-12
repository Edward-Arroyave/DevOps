CREATE TABLE [dbo].[TB_GenerateCopay_CM]
(
[IdGenerateCopay_CM] [tinyint] NOT NULL IDENTITY(1, 1),
[GenerateCopay_CM] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_GenerateCopay_CM] ADD CONSTRAINT [PK_TB_GenerateCopay_CM] PRIMARY KEY CLUSTERED ([IdGenerateCopay_CM])
GO
