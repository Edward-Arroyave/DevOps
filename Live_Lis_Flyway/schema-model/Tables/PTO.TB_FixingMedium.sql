CREATE TABLE [PTO].[TB_FixingMedium]
(
[IdFixingMedium] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_Fixing__Visib__4E946423] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_FixingMedium] ADD CONSTRAINT [PK_TB_FIXINGMEDIUM] PRIMARY KEY CLUSTERED ([IdFixingMedium])
GO
ALTER TABLE [PTO].[TB_FixingMedium] ADD CONSTRAINT [FK_TB_FixingMedium_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
