CREATE TABLE [dbo].[TB_Cover]
(
[IdCover] [int] NOT NULL IDENTITY(1, 1),
[CoverName] [varchar] (100) NOT NULL,
[PDF] [varchar] (150) NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Cover__Active__129F75AD] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Cover__Creati__139399E6] DEFAULT (dateadd(hour,(-5),getdate())),
[IdCreationUser] [int] NOT NULL,
[IdUserAction] [int] NULL,
[UpdateDate] [datetime] NULL,
[FirstSignature] [bit] NULL,
[SecondSignature] [bit] NULL,
[DoubleSignature] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_Cover] ADD CONSTRAINT [PK__TB_Cover__FC993448E78C830C] PRIMARY KEY CLUSTERED ([IdCover])
GO
ALTER TABLE [dbo].[TB_Cover] ADD CONSTRAINT [FK_TB_Cover_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Cover] ADD CONSTRAINT [FK_TB_Cover_TB_User1] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
