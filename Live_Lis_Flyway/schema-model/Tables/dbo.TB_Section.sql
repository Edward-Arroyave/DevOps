CREATE TABLE [dbo].[TB_Section]
(
[IdSection] [smallint] NOT NULL IDENTITY(1, 1),
[IdSectionType] [tinyint] NULL,
[SectionCode] [varchar] (5) NULL,
[SectionName] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Section_Active] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Section] ADD CONSTRAINT [PK_TB_Section] PRIMARY KEY CLUSTERED ([IdSection])
GO
ALTER TABLE [dbo].[TB_Section] ADD CONSTRAINT [FK_TB_Section_TB_SectionType] FOREIGN KEY ([IdSectionType]) REFERENCES [dbo].[TB_SectionType] ([IdSectionType])
GO
ALTER TABLE [dbo].[TB_Section] ADD CONSTRAINT [FK_TB_Section_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
