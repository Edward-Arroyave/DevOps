CREATE TABLE [dbo].[TB_ReferenceType]
(
[IdReferenceType] [smallint] NOT NULL IDENTITY(1, 1),
[ReferenceName] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TB_ReferenceType] ADD CONSTRAINT [PK__TB_Refer__A0916C010637E52B] PRIMARY KEY CLUSTERED ([IdReferenceType])
GO
