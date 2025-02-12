CREATE TABLE [dbo].[TB_Patient_Copi]
(
[IdPatient] [int] NOT NULL,
[IdIdentificationType] [tinyint] NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[FirstName] [varchar] (60) NOT NULL,
[SecondName] [varchar] (60) NULL,
[FirstLastName] [varchar] (60) NOT NULL,
[SecondLastName] [varchar] (60) NULL
)
GO
ALTER TABLE [dbo].[TB_Patient_Copi] ADD CONSTRAINT [PK__TB_Patie__B7E7B5A44E5CBEA1] PRIMARY KEY CLUSTERED ([IdPatient])
GO
