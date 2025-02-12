CREATE TABLE [PTO].[TB_LeafFractions]
(
[IdLeafFractions] [int] NOT NULL IDENTITY(1, 1),
[IdBlockFractions] [int] NOT NULL,
[IdPatient_Exam] [int] NOT NULL,
[LeafName] [varchar] (30) NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_LeafFr__Visib__4F88885C] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_LeafFractions] ADD CONSTRAINT [PK_TB_LEAFFRACTIONS] PRIMARY KEY CLUSTERED ([IdLeafFractions])
GO
ALTER TABLE [PTO].[TB_LeafFractions] ADD CONSTRAINT [FK_TB_LeafFractions_BlockFractions] FOREIGN KEY ([IdBlockFractions]) REFERENCES [PTO].[TB_BlockFractions] ([IdBlockFractions])
GO
ALTER TABLE [PTO].[TB_LeafFractions] ADD CONSTRAINT [FK_TB_LeafFractions_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_LeafFractions] ADD CONSTRAINT [FK_TB_LeafFractions_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
