CREATE TABLE [POSANT].[TB_SupportNetwork]
(
[IdSupportNetwork] [int] NOT NULL IDENTITY(1, 1),
[SupportNetworkName] [varchar] (50) NOT NULL,
[IdSection] [smallint] NOT NULL,
[AddressNetwork] [varchar] (100) NOT NULL,
[IdCountry] [int] NOT NULL,
[IdDepartment] [int] NOT NULL,
[IdCity] [int] NOT NULL,
[Email] [varchar] (50) NOT NULL,
[Telephone] [varchar] (50) NOT NULL,
[CellPhone] [varchar] (50) NOT NULL,
[CellPhoneAlternative] [varchar] (50) NULL,
[Observations] [varchar] (max) NULL,
[Monday] [bit] NULL,
[Tuesday] [bit] NULL,
[Wednesday] [bit] NULL,
[Thursday] [bit] NULL,
[Friday] [bit] NULL,
[Saturday] [bit] NULL,
[Sunday] [bit] NULL,
[TemperatureCelsius] [decimal] (18, 0) NOT NULL,
[TemperatureFahrenheit] [decimal] (18, 0) NOT NULL,
[NameConveyor] [varchar] (100) NOT NULL,
[TelephoneConveyor] [varchar] (50) NOT NULL,
[CellPhoneConveyor] [varchar] (50) NOT NULL,
[CellPhoneConveyorAlternative] [varchar] (50) NULL,
[EmailConveyor] [varchar] (50) NOT NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [POSANT].[TB_SupportNetwork] ADD CONSTRAINT [PK__TB_Suppo__5D8F58796D75DA6E] PRIMARY KEY CLUSTERED ([IdSupportNetwork])
GO
ALTER TABLE [POSANT].[TB_SupportNetwork] ADD CONSTRAINT [FK__TB_Suppor__IdCit__01BF026E] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [POSANT].[TB_SupportNetwork] ADD CONSTRAINT [FK__TB_Suppor__IdCou__02B326A7] FOREIGN KEY ([IdCountry]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [POSANT].[TB_SupportNetwork] ADD CONSTRAINT [FK__TB_Suppor__IdDep__03A74AE0] FOREIGN KEY ([IdDepartment]) REFERENCES [dbo].[TB_Department] ([IdDepartment])
GO
ALTER TABLE [POSANT].[TB_SupportNetwork] ADD CONSTRAINT [FK__TB_Suppor__IdSec__049B6F19] FOREIGN KEY ([IdSection]) REFERENCES [dbo].[TB_Section] ([IdSection])
GO
