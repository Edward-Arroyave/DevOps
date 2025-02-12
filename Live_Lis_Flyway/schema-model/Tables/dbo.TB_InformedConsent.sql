CREATE TABLE [dbo].[TB_InformedConsent]
(
[IdInformedConsent] [tinyint] NOT NULL IDENTITY(1, 1),
[InformedConsent] [varchar] (200) NOT NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Inform__Activ__450AF9E9] DEFAULT ((1)),
[IdUserAction] [int] NULL,
[IdBiologicalSex] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_InformedConsent] ADD CONSTRAINT [PK_TB_InformedConsent] PRIMARY KEY CLUSTERED ([IdInformedConsent])
GO
