SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 28/08/2024
-- Description: Procedimiento almacenado para actualizar tabla de copia_pacientes para reportes LIS
-- =============================================
CREATE PROCEDURE [dbo].[sp_Patient_Update]
AS
BEGIN
    SET NOCOUNT ON

	MERGE TB_Patient_Copi AS TARGET
	USING carehis.TB_Patient_Ext AS SOURCE 
		ON TARGET.IdPatient = SOURCE.IdPatient
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdPatient, IdIdentificationType,IdentificationNumber,FirstName, SecondName, FirstLastName, SecondLastName)
		VALUES (
				SOURCE.IdPatient,
				SOURCE.IdIdentificationType,
				SOURCE.IdentificationNumber, 
				SOURCE.FirstName,
				SOURCE.SecondName, 
				SOURCE.FirstLastName, 
				SOURCE.SecondLastName
				)
		WHEN MATCHED
			THEN
				UPDATE
					SET TARGET.IdIdentificationType = SOURCE.IdIdentificationType, 
						TARGET.IdentificationNumber = SOURCE.IdentificationNumber, 
						TARGET.FirstName = SOURCE.FirstName, 
						TARGET.SecondName = SOURCE.SecondName, 
						TARGET.FirstLastName = SOURCE.FirstLastName, 
						TARGET.SecondLastName = SOURCE.SecondLastName;

END
GO
