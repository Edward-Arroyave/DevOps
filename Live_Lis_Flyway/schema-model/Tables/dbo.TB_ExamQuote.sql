CREATE TABLE [dbo].[TB_ExamQuote]
(
[IdExamQuote] [int] NOT NULL IDENTITY(1, 1),
[IdContract] [int] NOT NULL,
[ExamQuoteNumber] [int] NULL,
[ExamQuoteDate] [datetime] NOT NULL,
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[Names] [varchar] (120) NOT NULL,
[LastNames] [varchar] (120) NOT NULL,
[TelephoneNumber] [varchar] (15) NULL,
[Email] [varchar] (100) NULL,
[Address] [varchar] (100) NULL,
[Observations] [varchar] (max) NULL,
[BeContacted] [bit] NULL,
[QuoteWhatsapp] [bit] NULL,
[IdExamQuoteStatus] [tinyint] NOT NULL,
[DueDate] [date] NULL,
[IdRequest] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NULL,
[ExpirationDate] [datetime] NULL,
[IdUser] [int] NULL,
[SurNames] [varchar] (120) NULL,
[IdValidityFormat] [tinyint] NULL,
[ExamQuoteValidity] [int] NULL,
[IdAttentionCenter] [smallint] NULL,
[AdditionalForm] [varchar] (max) NULL,
[IdDiscount] [int] NULL,
[IdDoctor] [int] NULL,
[Points] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [PK_TB_ExamQuote] PRIMARY KEY CLUSTERED ([IdExamQuote])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_ExamQuoteStatus] FOREIGN KEY ([IdExamQuoteStatus]) REFERENCES [dbo].[TB_ExamQuoteStatus] ([IdExamQuoteStatus])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_ExamQuote] ADD CONSTRAINT [FK_TB_ExamQuote_TB_User_] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
