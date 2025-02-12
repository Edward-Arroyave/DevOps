CREATE TABLE [dbo].[TB_PrerequestOrigin]
(
[IdPrerequestOrigin] [smallint] NOT NULL IDENTITY(1, 1),
[OriginName] [varchar] (20) NULL
)
GO
ALTER TABLE [dbo].[TB_PrerequestOrigin] ADD CONSTRAINT [PK__TB_Prere__EF21645FD4917B45] PRIMARY KEY CLUSTERED ([IdPrerequestOrigin])
GO
