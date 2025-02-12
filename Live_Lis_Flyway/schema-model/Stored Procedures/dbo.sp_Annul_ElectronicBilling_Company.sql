SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/10/2022
-- Description: Procedimientos almacenado para anular prefactura a entidades.
-- =============================================
--EXEC [sp_Print_ElectronicBilling] 1550
-- =============================================
CREATE PROCEDURE [dbo].[sp_Annul_ElectronicBilling_Company]
(
	@IdPreBilling int,
	@IdUserAction int, 
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
		
		UPDATE TB_PreBilling
			SET Active = 'False',
				IdUserAction = @IdUserAction
		WHERE IdPreBilling = @IdPreBilling
		
		UPDATE TR_PreBilling_BillingOfSale
			SET Active = 'False'
		WHERE IdPreBilling = @IdPreBilling

		UPDATE C	
			SET C.PreBilling = 'False'
		FROM TR_PreBilling_BillingOfSale A
		INNER JOIN TB_PreBilling B
			ON B.IdPreBilling = A.IdPreBilling
		INNER JOIN TB_BillingOfSale C
			ON C.IdBillingOfSale = A.IdBillingOfSale
		WHERE A.IdPreBilling = @IdPreBilling


		SET @Message = 'Successfully updated PreBilling'
		SET @Flag = 1
END
GO
