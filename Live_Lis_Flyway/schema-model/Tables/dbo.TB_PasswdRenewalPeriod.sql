CREATE TABLE [dbo].[TB_PasswdRenewalPeriod]
(
[IdPasswdRenewalPeriod] [tinyint] NOT NULL IDENTITY(1, 1),
[PasswdRenewalPeriod] [varchar] (15) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PasswdRenewalPeriod] ADD CONSTRAINT [PK_TB_PasswdRenewalPeriod] PRIMARY KEY CLUSTERED ([IdPasswdRenewalPeriod])
GO
