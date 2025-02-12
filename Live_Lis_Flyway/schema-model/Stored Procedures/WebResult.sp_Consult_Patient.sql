SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/10/2023
-- Description: Procedimiento almacenado para consultar gestión de paciente
-- =============================================
--EXEC [WebResult].[sp_Consult_Patient] '','','','','',''
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_Patient]
(
	@IdIdentificationType int,
	@IdentificationNumber varchar(20),
	@PatientName varchar(100),
	@PatientStatus varchar(1),
	@DataProcessingPolicy varchar(1),
	@AccessResultWeb varchar(1),
	@PageSize INT = 200,
	@NumberPage int = 1
)
AS
	declare @SKIPPEDROWS INT, @OriginalSize int

BEGIN
    SET NOCOUNT ON

	SET @OriginalSize = 200
	SET @SKIPPEDROWS = (@NumberPage-1)*@OriginalSize
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 06/02/2024
-- Description: Se quita el top en la consulta debido a agregacion de paginacion de resultados y se agrega a la consulta COUNT(*) OVER () TotalRecords
-- Pruebas:		Realizadas con El Inge Willinton Morales
-- Antes:	SELECT TOP 400 C.IdBillingOfSale
-- Ahora:	SELECT C.IdBillingOfSale
-- =============================================
	SELECT	IdPatient, IdentificationTypeCode, IdentificationNumber, PatientName, AccessResultWeb, DataProcessingPolicy, ResultWeb_SessionDate, Active_LIS AS Active,
			COUNT(*) OVER () TotalRecords
	FROM (
			SELECT A.IdPatient, A.IdIdentificationType, C.IdentificationTypeCode, A.IdentificationNumber, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) AS PatientName, A.AccessResultWeb, 
				CASE WHEN B.AcceptDataProcessingPolicy = 1 THEN 
					CASE WHEN B.ExpirationDataProcessingPolicy >= CONVERT(date,DATEADD(HOUR,-5,GETDATE())) THEN 1 
						ELSE 0 END 
				ELSE 0 END AS DataProcessingPolicy, A.ResultWeb_SessionDate, A.Active_LIS
			FROM carehis.TB_Patient_Ext A
			INNER JOIN carehis.TR_Patient_DataProcPolicy_Ext B
				ON B.IdPatient = A.IdPatient
			INNER JOIN carehis.TB_IdentificationType_Ext C
				ON C.IdIdentificationType = A.IdIdentificationType
			WHERE B.DataBaseSource = 2
		) SOURCE
	WHERE CASE WHEN @IdIdentificationType = '' THEN '' ELSE IdIdentificationType END = @IdIdentificationType
		AND CASE WHEN @IdentificationNumber = '' THEN '' ELSE IdentificationNumber END = @IdentificationNumber
		AND CASE WHEN @PatientName = '' THEN '' ELSE PatientName END LIKE '%' + @PatientName + '%'
		AND CASE WHEN @PatientStatus = '' THEN '' ELSE Active_LIS END = @PatientStatus
		AND CASE WHEN @DataProcessingPolicy = '' THEN '' ELSE DataProcessingPolicy END = @DataProcessingPolicy
		AND CASE WHEN @AccessResultWeb = '' THEN '' ELSE AccessResultWeb END = @AccessResultWeb
	order by IdPatient desc

	OFFSET @SKIPPEDROWS ROWS
	FETCH NEXT @PageSize ROWS ONLY

END
GO
