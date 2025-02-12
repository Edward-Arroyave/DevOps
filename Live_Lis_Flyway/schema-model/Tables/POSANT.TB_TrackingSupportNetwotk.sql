CREATE TABLE [POSANT].[TB_TrackingSupportNetwotk]
(
[IdTrackingSupportNetwotk] [int] NOT NULL IDENTITY(1, 1),
[IdSupportNetwork] [int] NOT NULL,
[TrackingDate] [datetime] NOT NULL,
[Responsible] [varchar] (100) NOT NULL,
[TrackingFileUrl] [varchar] (max) NOT NULL,
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[TrackingFileName] [varchar] (100) NULL
)
GO
ALTER TABLE [POSANT].[TB_TrackingSupportNetwotk] ADD CONSTRAINT [PK__TB_Track__5421226B69078ABC] PRIMARY KEY CLUSTERED ([IdTrackingSupportNetwotk])
GO
ALTER TABLE [POSANT].[TB_TrackingSupportNetwotk] ADD CONSTRAINT [FK__TB_Tracki__IdUse__742FFD26] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [POSANT].[TB_TrackingSupportNetwotk] ADD CONSTRAINT [FK__TB_Tracki__IdSup__0E24D953] FOREIGN KEY ([IdSupportNetwork]) REFERENCES [POSANT].[TB_SupportNetwork] ([IdSupportNetwork])
GO
