CREATE TABLE [dbo].[TB_CIE10_Code3]
(
[IdCIE10_Code3] [int] NOT NULL IDENTITY(1, 1),
[CIE10_Code3] [varchar] (9) NOT NULL,
[CIE10_Code3Name] [varchar] (255) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CIE10_Code3] ADD CONSTRAINT [PK_TB_CIE10Category] PRIMARY KEY CLUSTERED ([IdCIE10_Code3])
GO
ALTER TABLE [dbo].[TB_CIE10_Code3] ADD CONSTRAINT [FK_TB_CIE10_Code3_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
