CREATE TABLE [dbo].[TB_Brand]
(
[IdCountry] [int] NOT NULL IDENTITY(1, 1),
[NumericalCode] [varchar] (3) NOT NULL,
[CountryName] [varchar] (50) NOT NULL,
[Alpha2Code] [varchar] (2) NULL,
[Alpha3Code] [varchar] (3) NOT NULL,
[Indicative] [varchar] (10) NULL,
[TimeZone] [varchar] (100) NULL,
[CurrentUTC] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TB_Brand] ADD CONSTRAINT [PK_TB_Brand] PRIMARY KEY CLUSTERED ([IdCountry])
GO
