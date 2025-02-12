CREATE TABLE [dbo].[TB_AdditionalFormField]
(
[IdAdditionalFormField] [int] NOT NULL IDENTITY(1, 1),
[AdditionalFormField] [varchar] (50) NOT NULL,
[Obligatory] [bit] NULL,
[IdAdditionalFormDataType] [tinyint] NOT NULL,
[IdDefaultList] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TB_AdditionalFormField] ADD CONSTRAINT [PK_TB_AdditionalFormField] PRIMARY KEY CLUSTERED ([IdAdditionalFormField])
GO
ALTER TABLE [dbo].[TB_AdditionalFormField] ADD CONSTRAINT [FK_TB_AdditionalFormField_TB_AdditionalFormDataType] FOREIGN KEY ([IdAdditionalFormDataType]) REFERENCES [dbo].[TB_AdditionalFormDataType] ([IdAdditionalFormDataType])
GO
ALTER TABLE [dbo].[TB_AdditionalFormField] ADD CONSTRAINT [FK_TB_AdditionalFormField_TB_DefaultList] FOREIGN KEY ([IdDefaultList]) REFERENCES [dbo].[TB_DefaultList] ([IdDefaultList])
GO
