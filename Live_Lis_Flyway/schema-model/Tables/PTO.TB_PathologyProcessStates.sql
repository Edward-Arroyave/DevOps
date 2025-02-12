CREATE TABLE [PTO].[TB_PathologyProcessStates]
(
[IdPathologyProcessStates] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (30) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_PathologyProcessStates] ADD CONSTRAINT [PK_TB_PATHOLOGYPROCESSSTATES] PRIMARY KEY CLUSTERED ([IdPathologyProcessStates])
GO
ALTER TABLE [PTO].[TB_PathologyProcessStates] ADD CONSTRAINT [FK_TB_PathologyProcessStates_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
