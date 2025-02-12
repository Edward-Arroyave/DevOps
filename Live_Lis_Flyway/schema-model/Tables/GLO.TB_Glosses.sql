CREATE TABLE [GLO].[TB_Glosses]
(
[IDGlosse] [int] NOT NULL IDENTITY(1, 1),
[CreateDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[ReceptionDate] [datetime] NULL,
[ExpirationDate] [datetime] NULL,
[IDElectronicBilling] [int] NOT NULL,
[IdGlosseState] [int] NOT NULL,
[GlosseValue] [decimal] (20, 2) NULL,
[AceptedGlosseValue] [decimal] (20, 2) NULL,
[Release] [bit] NULL,
[IdUserCreation] [int] NOT NULL,
[IdUserAccepted] [int] NULL,
[IdGeneralConcept] [int] NOT NULL,
[IDSpecificConcept] [int] NOT NULL,
[Obs] [varchar] (200) NULL,
[CancellationReason] [varchar] (max) NULL
)
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [PK__TB_Gloss__A8C9902EECE793BE] PRIMARY KEY CLUSTERED ([IDGlosse])
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [FK_TB_Glosses_TB_ElectronicBilling] FOREIGN KEY ([IDElectronicBilling]) REFERENCES [dbo].[TB_ElectronicBilling] ([IdElectronicBilling])
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [FK_TB_Glosses_TB_GeneralConcept] FOREIGN KEY ([IdGeneralConcept]) REFERENCES [GLO].[TB_GeneralConcept] ([IdGeneralConcept])
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [FK_TB_Glosses_TB_GlosseState] FOREIGN KEY ([IdGlosseState]) REFERENCES [GLO].[TB_GlosseState] ([IDGlosseState])
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [FK_TB_Glosses_TB_SpecificConcept] FOREIGN KEY ([IDSpecificConcept]) REFERENCES [GLO].[TB_SpecificConcepts] ([IdSpecificConcept])
GO
ALTER TABLE [GLO].[TB_Glosses] ADD CONSTRAINT [FK_TB_Glosses_TB_User] FOREIGN KEY ([IdUserCreation]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
