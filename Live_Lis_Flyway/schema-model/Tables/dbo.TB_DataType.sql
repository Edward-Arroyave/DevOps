CREATE TABLE [dbo].[TB_DataType]
(
[IdDataType] [tinyint] NOT NULL IDENTITY(1, 1),
[DataType] [varchar] (16) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DataType] ADD CONSTRAINT [PK_TB_DataType] PRIMARY KEY CLUSTERED ([IdDataType])
GO
