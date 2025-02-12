SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/06/2022
-- Description: Procedimiento almacenado para consultar los abonos a entidades.
-- =============================================
--EXEC [sp_Consult_InstallmentContract] '','','','0'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_InstallmentContract]
(
    @Company varchar(5),
    @InitialDate date,
	@FinalDate date,
	@Status varchar(5)
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON     

	IF @InitialDate != '' AND @FinalDate != ''
		BEGIN
			SET @InitialDateTime = @InitialDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END
	
	SELECT DISTINCT B.IdInstallmentContract, B.IdInstallmentContract InstallmentContractNumber, C.CompanyName, B.CreationDate, B.ContractAmount, B.IdPaymentMethod, F.PaymentMethodName,
		CASE WHEN B.Active = 'True' THEN 'Activo' ELSE 'Anulado' END Status
    FROM TB_InstallmentContract B
    INNER JOIN TB_Company C
        ON C.IdCompany = B.IdCompany
    INNER JOIN TR_InstallmentContract_Contract G
        ON G.IdInstallmentContract = B.IdInstallmentContract
    INNER JOIN TB_Contract D
        ON D.IdContract = G.IdContract
    INNER JOIN TB_PaymentMethod F
        ON F.IdPaymentMethod = B.IdPaymentMethod
    WHERE CASE WHEN @Company = '' THEN '' ELSE C.IdCompany END = @Company
        AND ((B.CreationDate BETWEEN @InitialDateTime AND @FinalDateTime)
			AND (@InitialDateTime != '' OR @FinalDateTime != '')
					OR (@InitialDateTime = '' AND @FinalDateTime = ''))
        AND CASE WHEN @Status = '' THEN '' ELSE B.Active END = @Status
		AND isnull(visible,1) not in (0)
    ORDER BY B.CreationDate DESC 
END
GO
