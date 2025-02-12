CREATE EXTERNAL TABLE [carehis].[TB_Department_Ext]
(
[IdDepartment] [int] NOT NULL,
[DepartmentCode] [varchar] (2) NOT NULL,
[DepartmentName] [varchar] (60) NOT NULL,
[IdCountry] [int] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Department'
)
GO
