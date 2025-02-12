CREATE TABLE [dbo].[TR_AdditionalForm_AdditionalFormField]
(
[IdAdditionalForm_AdditionalFormField] [int] NOT NULL IDENTITY(1, 1),
[IdAdditionalForm] [int] NOT NULL,
[IdAdditionalFormField] [int] NOT NULL,
[IdAccordionOrganization] [tinyint] NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_AdditionalForm_AdditionalFormField] ADD CONSTRAINT [PK_TR_AdditionalForm_AdditionalFormField] PRIMARY KEY CLUSTERED ([IdAdditionalForm_AdditionalFormField])
GO
ALTER TABLE [dbo].[TR_AdditionalForm_AdditionalFormField] ADD CONSTRAINT [FK_TR_AdditionalForm_AdditionalFormField_TB_AccordionOrganization] FOREIGN KEY ([IdAccordionOrganization]) REFERENCES [dbo].[TB_AccordionOrganization] ([IdAccordionOrganization])
GO
ALTER TABLE [dbo].[TR_AdditionalForm_AdditionalFormField] ADD CONSTRAINT [FK_TR_AdditionalForm_AdditionalFormField_TB_AdditionalForm] FOREIGN KEY ([IdAdditionalForm]) REFERENCES [dbo].[TB_AdditionalForm] ([IdAdditionalForm])
GO
ALTER TABLE [dbo].[TR_AdditionalForm_AdditionalFormField] ADD CONSTRAINT [FK_TR_AdditionalForm_AdditionalFormField_TB_AdditionalFormField] FOREIGN KEY ([IdAdditionalFormField]) REFERENCES [dbo].[TB_AdditionalFormField] ([IdAdditionalFormField])
GO
