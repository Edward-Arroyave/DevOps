CREATE TABLE [dbo].[TB_BillingGroup]
(
[IdBillingGroup] [int] NOT NULL IDENTITY(1, 1),
[BillingGroupCode] [varchar] (5) NOT NULL,
[BillingGroup] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BillingGroup] ADD CONSTRAINT [PK_TB_BillingGroup] PRIMARY KEY CLUSTERED ([IdBillingGroup])
GO
