CREATE TABLE [dbo].[TB_DiscountCategory]
(
[IdDiscountCategory] [int] NOT NULL IDENTITY(1, 1),
[DiscountCategoryName] [varchar] (20) NOT NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Discou__Activ__7A92E1F2] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TB_DiscountCategory] ADD CONSTRAINT [PK__TB_Disco__A520179A101A39E7] PRIMARY KEY CLUSTERED ([IdDiscountCategory])
GO
