CREATE TABLE [dbo].[TB_CompanySeg_SubSeg]
(
[IdCompanySeg_SubSeg] [tinyint] NOT NULL IDENTITY(1, 1),
[IdCompanySegment] [tinyint] NOT NULL,
[IdCompanySubSegment] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CompanySeg_SubSeg] ADD CONSTRAINT [PK_TB_CompanySeg_SubSeg] PRIMARY KEY CLUSTERED ([IdCompanySeg_SubSeg])
GO
