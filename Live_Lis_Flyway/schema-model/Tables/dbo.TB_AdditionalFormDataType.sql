CREATE TABLE [dbo].[TB_AdditionalFormDataType]
(
[IdAdditionalFormDataType] [tinyint] NOT NULL IDENTITY(1, 1),
[AdditionalFormDataType] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AdditionalFormDataType] ADD CONSTRAINT [PK_TB_AdditionalFormDataType] PRIMARY KEY CLUSTERED ([IdAdditionalFormDataType])
GO
