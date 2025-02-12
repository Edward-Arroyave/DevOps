CREATE TABLE [dbo].[TB_AdditionalFormType]
(
[IdAdditionalFormType] [tinyint] NOT NULL IDENTITY(1, 1),
[AdditionalFormType] [varchar] (10) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AdditionalFormType] ADD CONSTRAINT [PK_TB_AdditionalFormType] PRIMARY KEY CLUSTERED ([IdAdditionalFormType])
GO
