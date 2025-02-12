CREATE TABLE [PTO].[TB_Novelty]
(
[IdNovelty] [int] NOT NULL IDENTITY(1, 1),
[DescriptionNovelty] [varchar] (100) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_Novelty] ADD CONSTRAINT [PK_TB_Novelty] PRIMARY KEY NONCLUSTERED ([IdNovelty])
GO
ALTER TABLE [PTO].[TB_Novelty] ADD CONSTRAINT [FK_TB_Novelty_Reference_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
