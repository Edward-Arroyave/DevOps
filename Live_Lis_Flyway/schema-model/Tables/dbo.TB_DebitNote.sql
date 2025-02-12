CREATE TABLE [dbo].[TB_DebitNote]
(
[IdDebitNote] [int] NOT NULL IDENTITY(1, 1),
[DebitNoteNumber] [varchar] (20) NULL,
[IdContract] [int] NOT NULL,
[CreateDate] [datetime] NOT NULL,
[Amount] [decimal] (20, 2) NULL,
[BalanceReceivable] [decimal] (20, 2) NULL,
[IdDebitNoteState] [smallint] NOT NULL,
[IdDebitNoteConcept] [smallint] NOT NULL,
[AuthorizesName] [varchar] (200) NOT NULL,
[PaymentReason] [varchar] (max) NOT NULL,
[IdCreationUser] [int] NOT NULL,
[IdAnullUser] [int] NULL,
[AnullDate] [datetime] NULL,
[AnullReason] [varchar] (200) NULL
)
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [PK__TB_Debit__BDFEF687BEBD0D95] PRIMARY KEY CLUSTERED ([IdDebitNote])
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [FK_TB_DebitNote_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [FK_TB_DebitNote_TB_DebitNoteConcept] FOREIGN KEY ([IdDebitNoteConcept]) REFERENCES [dbo].[TB_DebitNoteConcept] ([IdDebitNoteConcept])
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [FK_TB_DebitNote_TB_DebitNoteState] FOREIGN KEY ([IdDebitNoteState]) REFERENCES [dbo].[TB_DebitNoteState] ([IdDebitNoteState])
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [FK_TB_DebitNote_TB_User] FOREIGN KEY ([IdCreationUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_DebitNote] ADD CONSTRAINT [FK_TB_DebitNote_TB_UserAnull] FOREIGN KEY ([IdAnullUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
