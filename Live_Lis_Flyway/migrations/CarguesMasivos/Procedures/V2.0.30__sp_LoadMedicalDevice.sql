/****** Object:  StoredProcedure [dbo].[sp_LoadMedicalDevice]    Script Date: 19/02/2025 12:06:48 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de dispositivo medico.
-- =============================================
/*
DECLARE @LoadMedicalDevice LoadMedicalDevice, @Message varchar(50), @Flag bit
INSERT INTO @LoadMedicalDevice (SectionName)
VALUES 
('Prueba1'),
('Dato 1')
EXEC [sp_LoadMedicalDevice] @LoadMedicalDevice,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadMedicalDevice]
(
	@LoadMedicalDevice LoadMedicalDevice READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

		SELECT DISTINCT A.MedicalDevice, 1 Active,DATEADD(HOUR,-5,GETDATE()) CreationDate, @IdUserAction IdUserAction, 0 DefaultDevice
		FROM @LoadMedicalDevice A
		INNER JOIN TB_MedicalDevice B
		   ON B.MedicalDevice = A.MedicalDevice


		INSERT INTO TB_MedicalDevice(MedicalDevice, Active, CreationDate, IdUserAction, DefaultDevice)
		SELECT DISTINCT A.MedicalDevice, 1,DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 0 
		FROM @LoadMedicalDevice A
		LEFT JOIN TB_MedicalDevice B
		   ON B.MedicalDevice = A.MedicalDevice
		WHERE B.IdMedicalDevice IS NULL

		IF @@ROWCOUNT <> 0
          BEGIN
			SET @Flag = 1;
			SET @Message = 'Dispositivo médico cargado con exito.'
		  END
        ELSE
          BEGIN
            SET @Flag = 0;
            SET @Message = 'Información ya existente, no se realiza cargue.';
		  END

END

GO

