CREATE TABLE [dbo].[TB_TypeOfTraveler]
(
[IdTypeOfTraveler] [tinyint] NOT NULL IDENTITY(1, 1),
[TypeOfTraveler] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TypeOfTraveler] ADD CONSTRAINT [PK_TB_TypeOfTraveler] PRIMARY KEY CLUSTERED ([IdTypeOfTraveler])
GO
