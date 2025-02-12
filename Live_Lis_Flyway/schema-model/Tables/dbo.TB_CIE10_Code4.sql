CREATE TABLE [dbo].[TB_CIE10_Code4]
(
[IdCIE10_Code4] [int] NOT NULL IDENTITY(1, 1),
[IdCIE10_Code3] [int] NOT NULL,
[CIE10_Code4] [varchar] (5) NOT NULL,
[CIE10_Code4Name] [varchar] (255) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[AlternativeCode] [varchar] (5) NULL
)
GO
ALTER TABLE [dbo].[TB_CIE10_Code4] ADD CONSTRAINT [PK_TB_CIE10] PRIMARY KEY CLUSTERED ([IdCIE10_Code4])
GO
ALTER TABLE [dbo].[TB_CIE10_Code4] ADD CONSTRAINT [FK_TB_CIE10_Code4_TB_CIE10_Code3] FOREIGN KEY ([IdCIE10_Code3]) REFERENCES [dbo].[TB_CIE10_Code3] ([IdCIE10_Code3])
GO
ALTER TABLE [dbo].[TB_CIE10_Code4] ADD CONSTRAINT [FK_TB_CIE10_Code4_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
