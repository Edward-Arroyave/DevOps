CREATE TABLE [dbo].[TB_Locality]
(
[IdLocality] [tinyint] NOT NULL IDENTITY(1, 1),
[LocalityCode] [varchar] (3) NULL,
[Locality] [varchar] (50) NOT NULL,
[IdCity] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Locality] ADD CONSTRAINT [PK_TB_Locality] PRIMARY KEY CLUSTERED ([IdLocality])
GO
ALTER TABLE [dbo].[TB_Locality] ADD CONSTRAINT [FK_TB_Locality_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
