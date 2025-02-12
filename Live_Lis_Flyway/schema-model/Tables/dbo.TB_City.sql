CREATE TABLE [dbo].[TB_City]
(
[IdCity] [int] NOT NULL IDENTITY(1, 1),
[CityCode] [varchar] (5) NOT NULL,
[CityName] [varchar] (30) NOT NULL,
[IdDepartment] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_City] ADD CONSTRAINT [PK_TB_City] PRIMARY KEY CLUSTERED ([IdCity])
GO
ALTER TABLE [dbo].[TB_City] ADD CONSTRAINT [FK_TB_City_TB_Department] FOREIGN KEY ([IdDepartment]) REFERENCES [dbo].[TB_Department] ([IdDepartment])
GO
