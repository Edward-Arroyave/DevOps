CREATE TABLE [PTO].[TB_PathologyClassification]
(
[IdPathologyClassification] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_Pathol__Visib__5170D0CE] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_PathologyClassification] ADD CONSTRAINT [PK_TB_PathologyCLassification] PRIMARY KEY CLUSTERED ([IdPathologyClassification])
GO
ALTER TABLE [PTO].[TB_PathologyClassification] ADD CONSTRAINT [FK_TB_PathologyClassification_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
