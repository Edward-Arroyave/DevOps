CREATE EXTERNAL TABLE [carehis].[TB_Country_Ext]
(
[IdCountry] [int] NOT NULL,
[NumericalCode] [varchar] (3) NOT NULL,
[CountryName] [varchar] (50) NOT NULL,
[Alpha2Code] [varchar] (2) NULL,
[Alpha3Code] [varchar] (3) NOT NULL,
[Indicative] [varchar] (10) NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_Country'
)
GO
