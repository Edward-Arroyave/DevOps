CREATE TABLE [dbo].[TB_ExpectedValue]
(
[IdExpectedValue] [smallint] NOT NULL IDENTITY(1, 1),
[ExpectedValue] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ExpectedValue] ADD CONSTRAINT [PK__TB_Expec__BCE9DC889F617A3D] PRIMARY KEY CLUSTERED ([IdExpectedValue])
GO
ALTER TABLE [dbo].[TB_ExpectedValue] ADD CONSTRAINT [FK_TB_ExpectedValue_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
