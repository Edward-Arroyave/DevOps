CREATE EXTERNAL TABLE [carehis].[TB_SocialSecurityCompany_Ext]
(
[IdSocialSecurityCompany] [int] NOT NULL,
[SocialSecurityCompanyCode] [varchar] (6) NOT NULL,
[SocialSecurityCompanyName] [varchar] (100) NOT NULL,
[Subsystem] [varchar] (4) NOT NULL,
[Active] [bit] NOT NULL
)
WITH
(
DATA_SOURCE = [HIS_DEMO],
SCHEMA_NAME = N'dbo',
OBJECT_NAME = N'TB_SocialSecurityCompany'
)
GO
