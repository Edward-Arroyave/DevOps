CREATE TABLE [POSANT].[TB_RouteClient]
(
[IdRouteClient] [int] NOT NULL IDENTITY(1, 1),
[IdRoute] [int] NOT NULL,
[IdCompany] [int] NOT NULL,
[SedeClient] [varchar] (100) NOT NULL,
[AddressClient] [varchar] (100) NULL,
[TelephoneClient] [varchar] (20) NULL,
[IdCity] [int] NULL,
[IdDepartment] [int] NULL,
[IdIdentificationTypeReceive] [tinyint] NULL,
[IdentificationNumberReceive] [varchar] (20) NULL,
[NamesReceive] [varchar] (100) NULL,
[LastNamesReceive] [varchar] (100) NULL,
[IdCountryShipping] [int] NULL,
[IdCityShipping] [int] NULL,
[IdDepartmentShipping] [int] NULL,
[IdLocalityShipping] [tinyint] NULL,
[IdNeighborhoodShipping] [smallint] NULL,
[AddressShipping] [varchar] (100) NULL,
[TelephoneShipping] [varchar] (20) NULL,
[CellPhoneShiping] [varchar] (20) NULL,
[SendType] [bit] NULL,
[SendTime] [int] NULL,
[SendFrecuency] [int] NULL,
[Monday] [bit] NULL,
[Tuesday] [bit] NULL,
[Wednesday] [bit] NULL,
[Thursday] [bit] NULL,
[Friday] [bit] NULL,
[Saturday] [bit] NULL,
[Sunday] [bit] NULL
)
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [PK__TB_Route__D909B950311ADC47] PRIMARY KEY CLUSTERED ([IdRouteClient])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdCit__7370E317] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdCit__74650750] FOREIGN KEY ([IdCityShipping]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdCom__75592B89] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdCou__764D4FC2] FOREIGN KEY ([IdCountryShipping]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdDep__774173FB] FOREIGN KEY ([IdDepartment]) REFERENCES [dbo].[TB_Department] ([IdDepartment])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdDep__78359834] FOREIGN KEY ([IdDepartmentShipping]) REFERENCES [dbo].[TB_Department] ([IdDepartment])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdIde__7929BC6D] FOREIGN KEY ([IdIdentificationTypeReceive]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdLoc__7A1DE0A6] FOREIGN KEY ([IdLocalityShipping]) REFERENCES [dbo].[TB_Locality] ([IdLocality])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdNei__7B1204DF] FOREIGN KEY ([IdNeighborhoodShipping]) REFERENCES [dbo].[TB_Neighborhood] ([IdNeighborhood])
GO
ALTER TABLE [POSANT].[TB_RouteClient] ADD CONSTRAINT [FK__TB_RouteC__IdRou__7C062918] FOREIGN KEY ([IdRoute]) REFERENCES [POSANT].[TB_Route] ([IdRoute])
GO
