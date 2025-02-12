CREATE TABLE [dbo].[TB_TypeOfTest]
(
[IdTypeOfTest] [tinyint] NOT NULL IDENTITY(1, 1),
[TypeOfTest] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfTest] ADD CONSTRAINT [PK_TB_TypeOfTest] PRIMARY KEY CLUSTERED ([IdTypeOfTest])
GO
