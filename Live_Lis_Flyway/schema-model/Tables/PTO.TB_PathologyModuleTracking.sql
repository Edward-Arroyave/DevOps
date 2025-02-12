CREATE TABLE [PTO].[TB_PathologyModuleTracking]
(
[IdPathologyModuleTracking] [int] NOT NULL IDENTITY(1, 1),
[IdPathologyProcess] [int] NOT NULL,
[IdPathologyProcessStates] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[IdPatient_Exam] [int] NOT NULL,
[Movement] [varchar] (100) NOT NULL,
[MovementDate] [datetime] NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF__TB_Pathol__Visib__554161B2] DEFAULT ((1))
)
GO
ALTER TABLE [PTO].[TB_PathologyModuleTracking] ADD CONSTRAINT [PK_TB_PathologyModuleTracking] PRIMARY KEY CLUSTERED ([IdPathologyModuleTracking])
GO
ALTER TABLE [PTO].[TB_PathologyModuleTracking] ADD CONSTRAINT [FK_TB_PathologyModuleTracking_TB_PathologyProcess] FOREIGN KEY ([IdPathologyProcess]) REFERENCES [PTO].[TB_PathologyProcess] ([IdPathologyProcess])
GO
ALTER TABLE [PTO].[TB_PathologyModuleTracking] ADD CONSTRAINT [FK_TB_PathologyModuleTracking_TB_PathologyProcessStates] FOREIGN KEY ([IdPathologyProcessStates]) REFERENCES [PTO].[TB_PathologyProcessStates] ([IdPathologyProcessStates])
GO
ALTER TABLE [PTO].[TB_PathologyModuleTracking] ADD CONSTRAINT [FK_TB_PathologyModuleTracking_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_PathologyModuleTracking] ADD CONSTRAINT [FK_TB_PathologyModuleTracking_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
