CREATE TABLE [dbo].[TB_QuoteForm]
(
[IdQuoteForm] [int] NOT NULL IDENTITY(1, 1),
[LogoImage] [varchar] (max) NULL,
[QuoteFormName] [varchar] (100) NOT NULL,
[IdCompany] [int] NOT NULL,
[QuoteFormValidity] [int] NULL,
[IdValidityFormat] [tinyint] NOT NULL,
[AdditionalFormHeader] [varchar] (max) NULL,
[AdditionalFormPatient] [varchar] (max) NULL,
[AdditionalFormExam] [varchar] (max) NULL,
[AdditionalFormObs] [varchar] (max) NULL,
[AdditionalFormFooter] [varchar] (max) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_QuoteF__Activ__392F32E9] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_QuoteF__Creat__3A235722] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUser] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_QuoteForm] ADD CONSTRAINT [PK__TB_Quote__0C903553AF6FEB07] PRIMARY KEY CLUSTERED ([IdQuoteForm])
GO
ALTER TABLE [dbo].[TB_QuoteForm] ADD CONSTRAINT [FK_TB_QuoteForm_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_QuoteForm] ADD CONSTRAINT [FK_TB_QuoteForm_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_QuoteForm] ADD CONSTRAINT [FK_TB_QuoteForm_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
