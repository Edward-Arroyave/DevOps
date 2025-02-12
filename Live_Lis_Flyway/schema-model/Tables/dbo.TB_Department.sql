CREATE TABLE [dbo].[TB_Department]
(
[IdDepartment] [int] NOT NULL IDENTITY(1, 1),
[DepartmentCode] [varchar] (2) NOT NULL,
[DepartmentName] [varchar] (60) NOT NULL,
[IdCountry] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Department] ADD CONSTRAINT [PK_TB_Department] PRIMARY KEY CLUSTERED ([IdDepartment])
GO
ALTER TABLE [dbo].[TB_Department] ADD CONSTRAINT [FK_TB_Department_TB_Country] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
