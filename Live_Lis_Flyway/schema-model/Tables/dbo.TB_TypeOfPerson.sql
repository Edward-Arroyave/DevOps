CREATE TABLE [dbo].[TB_TypeOfPerson]
(
[IdTypeOfPerson] [tinyint] NOT NULL IDENTITY(1, 1),
[TypeOfPersonCode] [varchar] (1) NOT NULL,
[TypeOfPerson] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfPerson] ADD CONSTRAINT [PK_TB_TypeOfPerson] PRIMARY KEY CLUSTERED ([IdTypeOfPerson])
GO
