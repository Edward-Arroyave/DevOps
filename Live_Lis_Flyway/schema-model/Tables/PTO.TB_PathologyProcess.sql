CREATE TABLE [PTO].[TB_PathologyProcess]
(
[IdPathologyProcess] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (40) NULL,
[TemplateFlag] [bit] NULL,
[WorksheetFlag] [bit] NULL,
[TrackingFlag] [bit] NULL,
[ProcessSequence] [smallint] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_PathologyProcess] ADD CONSTRAINT [PK_TB_PATHOLOGYPROCESS] PRIMARY KEY CLUSTERED ([IdPathologyProcess])
GO
ALTER TABLE [PTO].[TB_PathologyProcess] ADD CONSTRAINT [FK_TB_PathologyProcess_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
