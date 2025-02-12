CREATE TABLE [dbo].[TB_AccordionOrganization]
(
[IdAccordionOrganization] [tinyint] NOT NULL IDENTITY(1, 1),
[AccordionOrganization] [varchar] (17) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AccordionOrganization] ADD CONSTRAINT [PK_TB_AccordionOrganization] PRIMARY KEY CLUSTERED ([IdAccordionOrganization])
GO
