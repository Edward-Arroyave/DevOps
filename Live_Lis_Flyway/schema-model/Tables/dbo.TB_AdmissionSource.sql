CREATE TABLE [dbo].[TB_AdmissionSource]
(
[IdAdmissionSource] [tinyint] NOT NULL IDENTITY(1, 1),
[AdmissionSource] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AdmissionSource] ADD CONSTRAINT [PK_TB_AdmissionSource] PRIMARY KEY CLUSTERED ([IdAdmissionSource])
GO
