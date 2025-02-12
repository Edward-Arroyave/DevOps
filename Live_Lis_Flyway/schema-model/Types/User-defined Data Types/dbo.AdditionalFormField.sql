CREATE TYPE [dbo].[AdditionalFormField] AS TABLE
(
[AdditionalFormField] [varchar] (50) NOT NULL,
[Obligatory] [bit] NOT NULL,
[IdAdditionalFormDataType] [tinyint] NOT NULL,
[AdditionalFormFieldOption] [varchar] (200) NULL,
[IdDefaultList] [tinyint] NULL,
[IdAccordionOrganization] [tinyint] NULL
)
GO
