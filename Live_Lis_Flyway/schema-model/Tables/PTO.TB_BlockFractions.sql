CREATE TABLE [PTO].[TB_BlockFractions]
(
[IdBlockFractions] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NOT NULL,
[BlockName] [varchar] (30) NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_BlockF__Visib__4CAC1BB1] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_BlockFractions] ADD CONSTRAINT [PK_TB_Fractions] PRIMARY KEY CLUSTERED ([IdBlockFractions])
GO
ALTER TABLE [PTO].[TB_BlockFractions] ADD CONSTRAINT [FK_TB_BlockFractions_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_BlockFractions] ADD CONSTRAINT [FK_TB_BlockFractions_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
