CREATE TABLE [ANT].[TB_AnalyticalParameteList]
(
[IdAnaliticalParameterList] [int] NOT NULL IDENTITY(1, 1),
[NameAnaliticalParameter] [varchar] (50) NOT NULL,
[DescriptionAnaliticalList] [varchar] (max) NULL,
[IdUser] [int] NOT NULL,
[IdSeccionList] [varbinary] (max) NULL,
[IdExamList] [varbinary] (max) NULL,
[IdAttentionCenterList] [varbinary] (max) NULL,
[IdCompany] [varbinary] (max) NULL,
[TrazabiliteDate] [datetime] NOT NULL,
[IdSampleType] [varbinary] (max) NULL,
[IdAfiliationType] [varbinary] (max) NULL,
[IdDataContract] [varbinary] (max) NULL,
[IdServiceType] [varbinary] (max) NULL,
[ModuleIdentifier] [tinyint] NULL,
[State] [nvarchar] (30) NULL,
[IdIdentificationType] [int] NULL,
[IdentificationNumber] [nvarchar] (20) NULL,
[RequestNumber] [nvarchar] (20) NULL
)
GO
ALTER TABLE [ANT].[TB_AnalyticalParameteList] ADD CONSTRAINT [PK_TB_AnalyticalParameteList] PRIMARY KEY NONCLUSTERED ([IdAnaliticalParameterList])
GO
ALTER TABLE [ANT].[TB_AnalyticalParameteList] ADD CONSTRAINT [FK_TB_AnalyticalParameteList_REFERENCE_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
