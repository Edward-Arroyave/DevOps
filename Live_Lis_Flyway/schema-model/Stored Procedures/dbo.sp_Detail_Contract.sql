SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/04/2022
-- Description: Procedimiento almacenado para retornar información de un contrato para ser editado.
-- =============================================
/*
DECLARE @Message varchar(50), @Flag bit
EXEC [sp_Detail_Contract] 53, @Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Contract]
(
	@IdContract int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdContract FROM TB_Contract WHERE IdContract = @IdContract)
		BEGIN
			SELECT	A.IdContract, A.ContractCode, A.ContractNumber, A.ContractName, A.IdContractType, B.ContractType, A.IdCompany, C.CompanyName, A.IdTariffScheme, D.TariffSchemeName, A.IdContractAmountType, 
					F.ContractAmountType, ISNULL(A.ContractAmount,0) ContractAmount, ISNULL(A.PatientAmount,0) PatientAmount, A.ContractBalance, A.PositiveBalance, A.CustomerBalance, 
					A.InitialValidity, A.ExpirationDate, A.IdSellerCode, N.SellerCode, A.IdContractDeadline, E.ContractDeadline, A.BillToParticular, A.IdGenerateCopay_CM, H.GenerateCopay_CM, A.FileClinicHistory, 
					A.FileAuthorization, A.FileMedicalOrder, A.RequirementsForAttention, A.IdAdditionalForm, A.IdQuoteValidity, G.QuoteValidity, A.ElectronicUser, A.IdPaymentMethod, I.PaymentMethodName, 
					A.IdBillingGroup, J.BillingGroup, A.InitialPaymentDay, A.FinalPaymentDay, A.IdCommercialTeam, M.CommercialTeamName, A.AttentPreRequisite, A.AttentionPreRequisite, A.BillRequirement, 
					A.BillingRequirements, A.IdBusinessUnit, L.BusinessUnit, AccountingAccount, A.IdAttentionModel, K.AttentionModel,  A.SeparationOfServices, A.IdCity, A.FilingAddress,
					CY.IdDepartment, M.CommercialTeamName, K.AttentionModel, L.BusinessUnit, CY.CityName, DP.DepartmentName, G.QuoteValidity, A.IdQuoteForm, A.ApplyDiscount
			FROM TB_Contract A
			LEFT JOIN TB_City CY ON A.IdCity = CY.IdCity
			LEFT JOIN TB_Department DP ON CY.IdDepartment = DP.IdDepartment
			LEFT JOIN TB_ContractType B
				ON B.IdContractType = A.IdContractType
			INNER JOIN TB_Company C
				ON C.IdCompany =  A.IdCompany
			INNER JOIN TB_TariffScheme D
				ON D.IdTariffScheme = A.IdTariffScheme
			LEFT JOIN TB_ContractDeadline E
				ON E.IdContractDeadline = A.IdContractDeadline
			LEFT JOIN TB_ContractAmountType F
				ON F.IdContractAmountType = A.IdContractAmountType
			LEFT JOIN TB_QuoteValidity G
				ON G.IdQuoteValidity = A.IdQuoteValidity
			LEFT JOIN TB_GenerateCopay_CM H
				ON H.IdGenerateCopay_CM = A.IdGenerateCopay_CM
			LEFT JOIN TB_PaymentMethod I
				ON I.IdPaymentMethod = A.IdPaymentMethod
			LEFT JOIN TB_BillingGroup J
				ON J.IdBillingGroup = A.IdBillingGroup
			LEFT JOIN TB_AttentionModel K
				ON K. IdAttentionModel = A.IdAttentionModel
			LEFT JOIN TB_BusinessUnit L
				ON L.IdBusinessUnit = A.IdBusinessUnit
			LEFT JOIN TB_CommercialTeam M
				ON M.IdCommercialTeam = A.IdCommercialTeam
			LEFT JOIN TB_SellerCode N
				ON a.IdSellerCode = N.IdSellerCode
			WHERE A.IdContract = @IdContract

			SET @Message = 'Contract found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Contract does not exists'
			SET @Flag = 0
		END
END
GO
