CREATE TABLE [ANT].[TB_CodificationResults]
(
[IdCodificationResults] [int] NOT NULL IDENTITY(1, 1),
[Abbreviation] [varchar] (10) NOT NULL,
[Text] [varchar] (max) NOT NULL,
[Status] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[ModificationDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[IdSection] [varchar] (max) NULL
)
GO
ALTER TABLE [ANT].[TB_CodificationResults] ADD CONSTRAINT [PK__TB_Codif__6AF616F788F59F4E] PRIMARY KEY CLUSTERED ([IdCodificationResults])
GO
ALTER TABLE [ANT].[TB_CodificationResults] ADD CONSTRAINT [FK_TB_CodificationResults_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
