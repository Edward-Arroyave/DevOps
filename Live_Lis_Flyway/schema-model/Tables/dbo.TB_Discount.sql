CREATE TABLE [dbo].[TB_Discount]
(
[IdDiscount] [int] NOT NULL IDENTITY(1, 1),
[DiscountName] [varchar] (20) NOT NULL,
[Cumulative] [bit] NOT NULL,
[IdContract] [int] NULL,
[ExpirationDate] [datetime] NULL,
[Amount] [int] NULL,
[Percentage] [decimal] (5, 2) NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Discou__Activ__7D6F4E9D] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Discou__Creat__7E6372D6] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUserCreation] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserUpdate] [int] NULL,
[IdDiscountCategory] [int] NOT NULL,
[DiscountCode] [varchar] (10) NULL,
[Removed] [bit] NOT NULL CONSTRAINT [DF__TB_Discou__Remov__7F57970F] DEFAULT ((0)),
[InitialDate] [datetime] NULL,
[Remaining] [bigint] NULL
)
GO
ALTER TABLE [dbo].[TB_Discount] ADD CONSTRAINT [PK__TB_Disco__C6A0EA32BFDECD9C] PRIMARY KEY CLUSTERED ([IdDiscount])
GO
ALTER TABLE [dbo].[TB_Discount] ADD CONSTRAINT [FK_TB_Discount_TB_DiscountCategory] FOREIGN KEY ([IdDiscountCategory]) REFERENCES [dbo].[TB_DiscountCategory] ([IdDiscountCategory])
GO
