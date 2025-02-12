CREATE TABLE [dbo].[TB_AdditionalFormFieldOption]
(
[IdAdditionalFormFieldOption] [int] NOT NULL IDENTITY(1, 1),
[AdditionalFormFieldOption] [varchar] (200) NOT NULL,
[IdAdditionalFormField] [int] NOT NULL,
[IdAdditionalForm] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_AdditionalFormFieldOption] ADD CONSTRAINT [PK_TB_AdditionalFormFieldOption] PRIMARY KEY CLUSTERED ([IdAdditionalFormFieldOption])
GO
ALTER TABLE [dbo].[TB_AdditionalFormFieldOption] ADD CONSTRAINT [FK_TB_AdditionalFormFieldOption_TB_AdditionalForm] FOREIGN KEY ([IdAdditionalForm]) REFERENCES [dbo].[TB_AdditionalForm] ([IdAdditionalForm])
GO
ALTER TABLE [dbo].[TB_AdditionalFormFieldOption] ADD CONSTRAINT [FK_TB_AdditionalFormFieldOption_TB_AdditionalFormField] FOREIGN KEY ([IdAdditionalFormField]) REFERENCES [dbo].[TB_AdditionalFormField] ([IdAdditionalFormField])
GO
