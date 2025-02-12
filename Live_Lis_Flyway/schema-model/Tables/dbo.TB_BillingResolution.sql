CREATE TABLE [dbo].[TB_BillingResolution]
(
[IdBillingResolution] [int] NOT NULL IDENTITY(1, 1),
[Number] [varchar] (15) NOT NULL,
[RegisteredName] [varchar] (60) NOT NULL,
[NIT] [varchar] (12) NOT NULL,
[Address] [varchar] (100) NOT NULL,
[Date] [date] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BillingResolution] ADD CONSTRAINT [PK_TB_BillingResolution] PRIMARY KEY CLUSTERED ([IdBillingResolution])
GO
ALTER TABLE [dbo].[TB_BillingResolution] ADD CONSTRAINT [FK_TB_BillingResolution_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
