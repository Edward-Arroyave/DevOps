CREATE TABLE [dbo].[TB_TypeOfStratefy]
(
[IdTypeOfStratefy] [tinyint] NOT NULL IDENTITY(1, 1),
[TypeOfStratefy] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfStratefy] ADD CONSTRAINT [PK_TB_ITypeOfStratefy] PRIMARY KEY CLUSTERED ([IdTypeOfStratefy])
GO
