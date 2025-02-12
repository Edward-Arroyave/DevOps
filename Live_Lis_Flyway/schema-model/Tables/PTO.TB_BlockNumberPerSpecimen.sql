CREATE TABLE [PTO].[TB_BlockNumberPerSpecimen]
(
[IdBlockNumberPerSpecimen] [int] NOT NULL IDENTITY(1, 1),
[IdBodyPart] [int] NOT NULL,
[BlockName] [varchar] (10) NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_BlockN__Visib__544D3D79] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_BlockNumberPerSpecimen] ADD CONSTRAINT [PK_TB_BlocknumberPerspecimen] PRIMARY KEY CLUSTERED ([IdBlockNumberPerSpecimen])
GO
ALTER TABLE [PTO].[TB_BlockNumberPerSpecimen] ADD CONSTRAINT [FK_TB_BlockNumberPerSpecimen_TB_BodyPart] FOREIGN KEY ([IdBodyPart]) REFERENCES [PTO].[TB_BodyPart] ([IdBodyPart])
GO
ALTER TABLE [PTO].[TB_BlockNumberPerSpecimen] ADD CONSTRAINT [FK_TB_BlockNumberPerSpecimen_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
