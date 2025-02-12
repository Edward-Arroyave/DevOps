CREATE TABLE [dbo].[TB_BiologicalSex]
(
[IdBiologicalSex] [tinyint] NOT NULL IDENTITY(1, 1),
[BiologicalSexCode] [varchar] (3) NOT NULL,
[BiologicalSex] [varchar] (30) NOT NULL,
[Abbreviation] [varchar] (1) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BiologicalSex] ADD CONSTRAINT [PK_TB_BiologicalSex] PRIMARY KEY CLUSTERED ([IdBiologicalSex])
GO
