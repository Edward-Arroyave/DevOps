CREATE TABLE [INTER].[HomologationOrigin]
(
[IdHomologationOrigin] [int] NOT NULL IDENTITY(1, 1),
[IdPrerequestOrigin] [smallint] NOT NULL,
[ExamCodeLis] [varchar] (10) NOT NULL,
[ExamCodeExternal] [varchar] (10) NOT NULL,
[AnalyteCodeLis] [varchar] (10) NOT NULL,
[AnalyteCodeExternal] [varchar] (10) NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__Homologat__Creat__50F1ADE1] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[HomologationOrigin] ADD CONSTRAINT [PK__Homologa__0206210485A74582] PRIMARY KEY CLUSTERED ([IdHomologationOrigin])
GO
ALTER TABLE [INTER].[HomologationOrigin] ADD CONSTRAINT [FK_HomologationOrigin_PrerrequestOrigin] FOREIGN KEY ([IdPrerequestOrigin]) REFERENCES [dbo].[TB_PrerequestOrigin] ([IdPrerequestOrigin])
GO
ALTER TABLE [INTER].[HomologationOrigin] ADD CONSTRAINT [FK_HomologationOrigin_Users] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
