CREATE TABLE [dbo].[TB_Filing]
(
[IdFiling] [int] NOT NULL IDENTITY(1, 1),
[FilingDate] [datetime] NOT NULL,
[Obs] [varchar] (500) NULL CONSTRAINT [DF__TB_Filing__Obs__7E0E6D1B] DEFAULT (CONVERT([varchar],dateadd(hour,(-5),getdate()))),
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Filing] ADD CONSTRAINT [PK__TB_Filin__0574583C48BFE619] PRIMARY KEY CLUSTERED ([IdFiling])
GO
ALTER TABLE [dbo].[TB_Filing] ADD CONSTRAINT [FK_TB_Filing_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
