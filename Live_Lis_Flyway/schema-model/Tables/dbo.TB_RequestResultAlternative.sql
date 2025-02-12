CREATE TABLE [dbo].[TB_RequestResultAlternative]
(
[IdRequestResult] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[FileName] [varchar] (30) NOT NULL,
[ResultFile] [text] NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_RequestResultAlternative_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TB_RequestResultAlternative] ADD CONSTRAINT [PK_TB_RequestResultAlternative] PRIMARY KEY CLUSTERED ([IdRequestResult])
GO
ALTER TABLE [dbo].[TB_RequestResultAlternative] ADD CONSTRAINT [FK_TB_RequestResultAlternative_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
