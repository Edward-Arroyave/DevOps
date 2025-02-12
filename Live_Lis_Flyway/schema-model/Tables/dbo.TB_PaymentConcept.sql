CREATE TABLE [dbo].[TB_PaymentConcept]
(
[IdPaymentConcept] [tinyint] NOT NULL IDENTITY(1, 1),
[PaymentConceptName] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PaymentConcept] ADD CONSTRAINT [PK_TB_PaymentConcept] PRIMARY KEY CLUSTERED ([IdPaymentConcept])
GO
