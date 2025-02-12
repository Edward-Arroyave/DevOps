SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para retornar los datos de un servicio creado.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Service]
(
	@IdService int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdService FROM TB_Service WHERE IdService = @IdService)
		BEGIN
			SELECT A.IdService, A.CUPS, A.ServiceName, A.IdServiceDescription, A.Extra_I, A.Extra_II, A.IdServiceGroupLevel3, B.ServiceGroupLevel3Code, A.IdServiceSubCategory, C.ServiceSubCategory, A.IdServiceSpeciality, D.ServiceSpeciality
			FROM TB_Service A
			INNER JOIN TB_ServiceGroupLevel3 B
				ON B.IdServiceGroupLevel3 = A.IdServiceGroupLevel3
			INNER JOIN TB_ServiceSubCategory C
				ON C.IdServiceSubCategory = A.IdServiceSubCategory
			LEFT JOIN TB_ServiceSpeciality D
				ON D.IdServiceSpeciality = A.IdServiceSpeciality
			WHERE A.IdService = @IdService

			SET @Message = 'Service found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Service does not exists'
			SET @Flag = 0
		END
END
GO
