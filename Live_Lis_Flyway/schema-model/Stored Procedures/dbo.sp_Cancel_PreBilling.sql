SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/03/20242
-- Description: Procedimiento almacenado anulación masiva de prefacturas.
-- =============================================
--DECLARE @Salida varchar(100), @Bandera varchar(100)
--EXEC [sp_Cancel_PreBilling] '826,827', @Salida out, @Bandera out
--SELECT @Salida, @Bandera
-- =============================================
CREATE PROCEDURE [dbo].[sp_Cancel_PreBilling]
(
	@PreBilling varchar(max),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT DISTINCT IdElectronicBilling FROM STRING_SPLIT(@PreBilling, ',') INNER JOIN TB_PreBilling A ON A.IdPreBilling = value WHERE IdElectronicBilling IS NULL)
		BEGIN
			--UPDATE A
			--	SET A.Active = 'False'
			--FROM STRING_SPLIT(@PreBilling, ',')
			--INNER JOIN TB_PreBilling A
			--	ON A.IdPreBilling = value
			
			--UPDATE A
			--	SET A.Active = 'False'
			--FROM STRING_SPLIT(@PreBilling, ',')
			--INNER JOIN TR_PreBilling_BillingOfSale A
			--	ON A.IdPreBilling = value

			UPDATE C
				SET PreBilling = 0
			FROM STRING_SPLIT(@PreBilling, ',')
			INNER JOIN TB_PreBilling A
				ON A.IdPreBilling = value
			INNER JOIN TR_PreBilling_BillingOfSale B
				ON A.IdPreBilling = B.IdPreBilling
			INNER JOIN TB_BillingOfSale C
				ON B.IdBillingOfSale = C.IdBillingOfSale

			SET @Message = 'Successfully cancel pre billing'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'It is not possible to cancel pre billing'
			SET @Flag = 0
		END
END

--SELECT * FROM TB_PreBilling WHERE IdPreBilling IN  (827,826)
GO
