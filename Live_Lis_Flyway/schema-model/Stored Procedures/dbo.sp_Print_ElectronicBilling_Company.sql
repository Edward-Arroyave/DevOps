SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/06/2022
-- Description: Procedimientos almacenado para retornar información de factura electrónica para entidades.
-- =============================================
/*
DECLARE @Salida varchar(100), @Bandera varchar(100)
EXEC [sp_Print_ElectronicBilling_Company] 1863,3,@Salida out, @Bandera out
SELECT @Salida, @Bandera
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Print_ElectronicBilling_Company]
(
	@IdPreBilling int,
	@IdContractType int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @TotalAdvanceValue bigint, @PositiveBalance bigint, @IdContract int, @idrequest int = 0;
	
	DECLARE @BillToParticular INT, @SeparationOfServices INT

	SET @BillToParticular = (	SELECT	ISNULL(C.BillToParticular,0) 
								FROM	TB_Contract C 
										INNER JOIN TB_PreBilling P ON C.IdContract = P.IdContract 
								WHERE	P.IdPreBilling= @IdPreBilling)
	SET @SeparationOfServices = (	SELECT	ISNULL(C.SeparationOfServices,0) 
									FROM	TB_Contract C
											INNER JOIN TB_PreBilling P ON C.IdContract = P.IdContract 
									WHERE	P.IdPreBilling= @IdPreBilling)

BEGIN

    SET NOCOUNT ON

	--SET @IdContract = (SELECT DISTINCT D.IdContract FROM TB_PreBilling A INNER JOIN TR_PreBilling_BillingOfSale B ON B.IdPreBilling = A.IdPreBilling INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale INNER JOIN TB_Request D ON D.IdRequest = C.IdRequest WHERE A.IdPreBilling = @IdPreBilling)
	SET @IdContract = (SELECT TOP 1 IdContract FROM TB_PreBilling WHERE IdPreBilling = @IdPreBilling)
	IF @IdContractType = 3
		BEGIN
		/*
			SET @TotalAdvanceValue = (SELECT DISTINCT SUM(B.PreBillingValue) - SUM(B.PreBillingBalance)
										FROM TB_PreBilling A
										INNER JOIN TR_InstallmentContract_PreBilling B
											ON B.IdPreBilling = A.IdPreBilling
										INNER JOIN TR_InstallmentContract_Contract D
											ON D.IdInstallmentContract_Contract = B.IdInstallmentContract_Contract
										INNER JOIN TB_InstallmentContract C
											ON C.IdInstallmentContract = D.IdInstallmentContract
										WHERE A.IdPreBilling = @IdPreBilling)
		*/

		-- =============================================
		-- Ajuste para evitar error en generacion de facturas en negativo
		-- Dayron Fuentes - César Jiménez
		-- Fecha = 2024-08-16
		-- =============================================

			SET @TotalAdvanceValue = (SELECT	DISTINCT SUM(C.Value)
										FROM	TB_PreBilling A
												INNER JOIN TR_PreBilling_BillingOfSale B
												ON B.IdPreBilling = A.IdPreBilling
												INNER JOIN TR_BillingOfSale_Request D
												ON D.IdBillingOfSale = B.IdBillingOfSale
												INNER JOIN TR_Request_Exam C
												ON C.IdRequest = D.IdRequest
												AND C.Active = 1 AND C.Value IS NOT NULL
										WHERE A.IdPreBilling= @IdPreBilling)
										
		END
	ELSE IF @IdContractType = 4
		BEGIN
			SET @TotalAdvanceValue = (SELECT SUM(C.TotalValuePatient)
										FROM TB_PreBilling A
										INNER JOIN TR_PreBilling_BillingOfSale B
											ON B.IdPreBilling = A.IdPreBilling
										INNER JOIN TB_BillingOfSale C
											ON C.IdBillingOfSale = B.IdBillingOfSale
										WHERE A.IdPreBilling = @IdPreBilling)

			SET @PositiveBalance = (SELECT ISNULL(PositiveBalance,0)
										FROM TB_Contract
										WHERE IdContract = @IdContract)
		END
	ELSE IF @IdContractType = 2
		BEGIN
			SET @TotalAdvanceValue = (SELECT B.PositiveBalance
										FROM TB_PreBilling A
										INNER JOIN TB_Contract B
											ON B.IdContract = A.IdContract
										WHERE A.IdPreBilling = @IdPreBilling)
		END

		IF @BillToParticular = 1
		BEGIN
			set @idrequest = (	SELECT	DISTINCT I.IdRequest
								FROM	TB_PreBilling A
										INNER JOIN TR_PreBilling_BillingOfSale B ON B.IdPreBilling = A.IdPreBilling
										INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale
										INNER JOIN TR_BillingOfSale_Request H ON H.IdBillingOfSale = C.IdBillingOfSale
										INNER JOIN TB_Request I ON I.IdRequest = H.IdRequest
								where	A.IdPreBilling=@IdPreBilling)
		END
		

	--- Información de factura
	SELECT DISTINCT A.IdPreBilling, 
		(select	MIN(r.requestdate) 
		from	TR_PreBilling_BillingOfSale a
				inner join TR_BillingOfSale_Request b on a.IdBillingOfSale = b.IdBillingOfSale
				inner join TB_Request r on b.IdRequest = r.IdRequest
		where	a.IdPreBilling=@IdPreBilling) InitialDate,
		(select	max(r.requestdate) 
		from	TR_PreBilling_BillingOfSale a
				inner join TR_BillingOfSale_Request b on a.IdBillingOfSale = b.IdBillingOfSale
				inner join TB_Request r on b.IdRequest = r.IdRequest
		where	a.IdPreBilling=@IdPreBilling) FinalDate,
		B.CompanyName, C.IdentificationTypeCode_EB, B.NIT AS IdentificationNumber, B.Address, D.CityCode, E.ElectronicUser AS Email, B.TelephoneNumber, B.PortfolioContact, B.IdMarketGroup, K.MarketGroup, 
		E.IdContract, E.ContractCode, E.ContractName, E.ContractNumber, E.InitialValidity, E.ExpirationDate, E.IdAttentionModel, J.AttentionModel, E.IdContractOdoo,
		G.Prefix, G.PrefixCN, E.IdContractDeadline, H.ContractDeadline, H.OdooPaymentTerm,
		CASE WHEN @IdContractType IN (2,4) THEN I.PaymentMethodCode
			WHEN @IdContractType = 3 THEN
		STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(2), PM.PaymentMethodCode)
                   FROM TR_InstallmentContract_PreBilling H
				INNER JOIN TR_InstallmentContract_Contract J
					ON J.IdInstallmentContract_Contract = H.IdInstallmentContract_Contract
                   INNER JOIN TB_InstallmentContract I 
					ON I.IdInstallmentContract = J.IdInstallmentContract
                   INNER JOIN TB_PaymentMethod PM 
					ON PM.IdPaymentMethod = I.IdPaymentMethod
                   WHERE H.IdPreBilling = A.IdPreBilling
                   FOR XML PATH('')),1,1,'') END AS PaymentMethodCode,
		STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(10), I.IdBillingOfSale)
                    FROM TR_PreBilling_BillingOfSale I
                    WHERE I.IdPreBilling = A.IdPreBilling
                    FOR XML PATH('')),1,1,'') BillingOfSale,
		@TotalAdvanceValue AS TotalAdvanceValue, @PositiveBalance AS PositiveBalance, G.DetailName, B.IdCompany, E.IdBusinessUnit, BU.BusinessUnit, B.IdPartnerOdoo
	FROM TB_PreBilling A
	INNER JOIN TB_Company B
		ON B.IdCompany = A.IdCompany
	INNER JOIN TB_IdentificationType C
		ON C.IdIdentificationType = B.IdIdentificationType
	LEFT JOIN TB_City D
		ON D.IdCity = B.IdCity
	INNER JOIN TB_Contract E
		ON E.IdContract = A.IdContract
	INNER JOIN TB_AttentionCenter F
		ON F.IdAttentionCenter = A.IdAttentionCenter
	INNER JOIN TB_DetailBillingResolution G
		ON G.IdDetailBillingResolution = F.IdDetailBillingResolution
	LEFT JOIN TB_ContractDeadline H
		ON H.IdContractDeadline = E.IdContractDeadline
	LEFT JOIN TB_PaymentMethod I
		ON I.IdPaymentMethod = E.IdPaymentMethod
	LEFT JOIN TB_AttentionModel J
		ON J.IdAttentionModel = E.IdAttentionModel
	LEFT JOIN TB_MarketGroup K
		ON K.IdMarketGroup = B.IdMarketGroup
	LEFT JOIN TB_BusinessUnit BU
		ON BU.IdBusinessUnit = E.IdBusinessUnit
	WHERE A.IdPreBilling = @IdPreBilling

		
	IF	(select distinct isnull(SegmentedRequest,0) from TB_Request where IdRequest=@idrequest)>=1 --@BillToParticular = 1 AND @SeparationOfServices = 1
		BEGIN
			-- Información de servicios.
			/*
			SELECT DISTINCT I.IdRequest, --(SELECT TOP 1 G.CUPS) AS CUPS, 
					(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
					E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient
			FROM TB_PreBilling A
			INNER JOIN TR_PreBilling_BillingOfSale B
				ON B.IdPreBilling = A.IdPreBilling
			INNER JOIN TB_BillingOfSale C
				ON C.IdBillingOfSale = B.IdBillingOfSale
			INNER JOIN TR_BillingOfSale_Request H
				ON H.IdBillingOfSale = C.IdBillingOfSale
			INNER JOIN TB_Request I
				ON I.IdRequest = H.IdRequest
			INNER JOIN TR_Request_Exam D 
				ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
			INNER JOIN TB_Exam E
				ON E.IdExam = D.IdExam
			--LEFT JOIN TR_Service_Exam F
			--	ON E.IdExam = F.IdExam
			--		AND F.Active=1
			--LEFT JOIN TB_Service G	
			--	ON F.IdService = G.IdService
			WHERE A.IdPreBilling = @IdPreBilling
			*/
			SELECT DISTINCT I.IdRequest, --(SELECT TOP 1 G.CUPS) AS CUPS, 
					--(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
					ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when G.CUPS = '' then null else G.CUPS end, (	SELECT	TOP 1 G.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service G on E.IdService = G.IdService 
														where	E.IdExam = D.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,		
					E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
			FROM TB_PreBilling A
			INNER JOIN TR_PreBilling_BillingOfSale B 	ON B.IdPreBilling = A.IdPreBilling
			INNER JOIN TB_BillingOfSale C 	ON C.IdBillingOfSale = B.IdBillingOfSale
			INNER JOIN TR_BillingOfSale_Request H	ON H.IdBillingOfSale = C.IdBillingOfSale
			INNER JOIN TB_Request I	ON I.IdRequest = H.IdRequest
			INNER JOIN TR_Request_Exam D 	ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
			INNER JOIN TB_Exam E	ON E.IdExam = D.IdExam
			LEFT JOIN TR_Service_Exam F	ON E.IdExam = F.IdExam		AND F.Active=1
			INNER JOIN TB_CONTRACT CON 		on I.idcontract = CON.idcontract
			INNER JOIN TB_TariffScheme TS 		on CON.idtariffscheme = TS.idtariffscheme
			LEFT JOIN TR_TariffScheme_Service TSS		ON ts.IdTariffScheme = TSS.idtariffscheme and D.IdExam = TSS.IdExam and CON.idtariffscheme = tss.idtariffscheme
			LEFT JOIN TB_Service G		ON TSs.IdService = G.IdService
			WHERE A.IdPreBilling = @IdPreBilling

			UNION ALL

			SELECT	DISTINCT I.IdRequest, NULL, --E.ExamGroupCode, E.ExamGroupName,
					EX.ExamCode,
					EX.ExamName,
				--	D.Value,
					s.Value,
					D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, 
					I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
			FROM	TB_PreBilling A
					INNER JOIN TR_PreBilling_BillingOfSale B ON B.IdPreBilling = A.IdPreBilling
					INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale
					INNER JOIN TR_BillingOfSale_Request H ON H.IdBillingOfSale = C.IdBillingOfSale
					INNER JOIN TB_Request I ON I.IdRequest = H.IdRequest
					INNER JOIN TR_Request_Exam D ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
					INNER JOIN TB_ExamGroup E ON E.IdExamGroup = D.IdExamGroup
					INNER JOIN TR_ExamGroup_Exam G ON G.IdExamGroup = E.IdExamGroup
					INNER JOIN TB_Exam EX ON EX.IdExam = G.IdExam
					INNER JOIN TB_Contract CO ON CO.IdContract = I.IdContract 
					INNER JOIN TB_TariffScheme TS ON TS.IdTariffScheme = CO.IdTariffScheme
					LEFT JOIN TR_TariffScheme_Service TSS ON TSS.IdTariffScheme = TS.IdTariffScheme and ex.IdExam = tss.IdExam --and tss.active =1
					inner join TR_SegmentedRequest s on s.idexam = g.IdExam and i.IdRequest = s.IdRequest
			WHERE A.IdPreBilling = @IdPreBilling

			SET @Message = 'Successfully updated PreBilling'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			if (select count(*) from TR_SegmentedRequest where idrequest = @idrequest)>=1
			begin
				-- Información de servicios.
				/*SELECT DISTINCT I.IdRequest,-- (SELECT TOP 1 G.CUPS) AS CUPS, 
				(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
						E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient
				FROM TB_PreBilling A
				INNER JOIN TR_PreBilling_BillingOfSale B
					ON B.IdPreBilling = A.IdPreBilling
				INNER JOIN TB_BillingOfSale C
					ON C.IdBillingOfSale = B.IdBillingOfSale
				INNER JOIN TR_BillingOfSale_Request H
					ON H.IdBillingOfSale = C.IdBillingOfSale
				INNER JOIN TB_Request I
					ON I.IdRequest = H.IdRequest
				INNER JOIN TR_Request_Exam D
					ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
				INNER JOIN TB_Exam E
					ON E.IdExam = D.IdExam
				--LEFT JOIN TR_Service_Exam F
				--	ON E.IdExam = F.IdExam
				--		AND F.Active=1 AND D.Value is not null
				--LEFT JOIN TB_Service G
				--	ON F.IdService = G.IdService
				WHERE A.IdPreBilling = @IdPreBilling
				*/
				SELECT DISTINCT I.IdRequest,-- (SELECT TOP 1 G.CUPS) AS CUPS, 
				--(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
						ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when G.CUPS = '' then null else G.CUPS end, (	SELECT	TOP 1 G.CUPS 
															from	TR_Service_Exam E 
																	inner join TB_Service G on E.IdService = G.IdService 
															where	E.IdExam = D.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
						E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
				FROM	TB_PreBilling A
						INNER JOIN TR_PreBilling_BillingOfSale B
							ON B.IdPreBilling = A.IdPreBilling
						INNER JOIN TB_BillingOfSale C
							ON C.IdBillingOfSale = B.IdBillingOfSale
						INNER JOIN TR_BillingOfSale_Request H
							ON H.IdBillingOfSale = C.IdBillingOfSale
						INNER JOIN TB_Request I
							ON I.IdRequest = H.IdRequest
						INNER JOIN TR_Request_Exam D
							ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
						INNER JOIN TB_Exam E
							ON E.IdExam = D.IdExam
						LEFT JOIN TR_Service_Exam F	
							ON E.IdExam = F.IdExam		AND F.Active=1
						INNER JOIN TB_CONTRACT CON 		
							on I.idcontract = CON.idcontract
						INNER JOIN TB_TariffScheme TS 		
							on CON.idtariffscheme = TS.idtariffscheme
						LEFT JOIN TR_TariffScheme_Service TSS		
							ON ts.IdTariffScheme = TSS.idtariffscheme and D.IdExam = TSS.IdExam and CON.idtariffscheme = tss.idtariffscheme
						LEFT JOIN TB_Service G		
							ON TSs.IdService = G.IdService
				WHERE A.IdPreBilling = @IdPreBilling

				UNION ALL

				SELECT	DISTINCT I.IdRequest, NULL, --E.ExamGroupCode, E.ExamGroupName,
						EX.ExamCode,
						EX.ExamName,
					--	D.Value,
						s.Value,
						D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, 
						I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
				FROM	TB_PreBilling A
						INNER JOIN TR_PreBilling_BillingOfSale B ON B.IdPreBilling = A.IdPreBilling
						INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale
						INNER JOIN TR_BillingOfSale_Request H ON H.IdBillingOfSale = C.IdBillingOfSale
						INNER JOIN TB_Request I ON I.IdRequest = H.IdRequest
						INNER JOIN TR_Request_Exam D ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
						INNER JOIN TB_ExamGroup E ON E.IdExamGroup = D.IdExamGroup
						INNER JOIN TR_ExamGroup_Exam G ON G.IdExamGroup = E.IdExamGroup
						INNER JOIN TB_Exam EX ON EX.IdExam = G.IdExam
						INNER JOIN TB_Contract CO ON CO.IdContract = I.IdContract 
						INNER JOIN TB_TariffScheme TS ON TS.IdTariffScheme = CO.IdTariffScheme
						LEFT JOIN TR_TariffScheme_Service TSS ON TSS.IdTariffScheme = TS.IdTariffScheme and ex.IdExam = tss.IdExam --and tss.active =1
						INNER JOIN TR_SegmentedRequest s on s.idexam = g.IdExam and i.IdRequest = s.IdRequest
				WHERE A.IdPreBilling = @IdPreBilling

				SET @Message = 'Successfully updated PreBilling'
				SET @Flag = 1
			end
		else
			begin
			-- Información de servicios.
			/*SELECT DISTINCT I.IdRequest, --(SELECT TOP 1 G.CUPS) AS CUPS, 
					(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
					E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient
			FROM TB_PreBilling A
			INNER JOIN TR_PreBilling_BillingOfSale B
				ON B.IdPreBilling = A.IdPreBilling
			INNER JOIN TB_BillingOfSale C
				ON C.IdBillingOfSale = B.IdBillingOfSale
			INNER JOIN TR_BillingOfSale_Request H
				ON H.IdBillingOfSale = C.IdBillingOfSale
			INNER JOIN TB_Request I
				ON I.IdRequest = H.IdRequest
			INNER JOIN TR_Request_Exam D
				ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
			INNER JOIN TB_Exam E
				ON E.IdExam = D.IdExam
			--LEFT JOIN TR_Service_Exam F
			--	ON E.IdExam = F.IdExam
			--		AND F.Active=1 and D.Value is not null
			--LEFT JOIN TB_Service G
			--	ON F.IdService = G.IdService
				WHERE A.IdPreBilling = @IdPreBilling
				*/
				SELECT DISTINCT I.IdRequest, --(SELECT TOP 1 G.CUPS) AS CUPS, 
						--(SELECT TOP 1 G.CUPS from TR_Service_Exam F inner join TB_Service G on F.IdService = G.IdService where F.IdExam = E.IdExam And F.Active=1) AS CUPS,
						ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when G.CUPS = '' then null else G.CUPS end, (	SELECT	TOP 1 G.CUPS  
															from	TR_Service_Exam E 
																	inner join TB_Service G on E.IdService = G.IdService 
															where	E.IdExam = D.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
						E.ExamCode, E.ExamName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
				FROM	TB_PreBilling A
						INNER JOIN TR_PreBilling_BillingOfSale B
							ON B.IdPreBilling = A.IdPreBilling
						INNER JOIN TB_BillingOfSale C
							ON C.IdBillingOfSale = B.IdBillingOfSale
						INNER JOIN TR_BillingOfSale_Request H
							ON H.IdBillingOfSale = C.IdBillingOfSale
						INNER JOIN TB_Request I
							ON I.IdRequest = H.IdRequest
						INNER JOIN TR_Request_Exam D
							ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
						INNER JOIN TB_Exam E
							ON E.IdExam = D.IdExam
						LEFT JOIN TR_Service_Exam F	
							ON E.IdExam = F.IdExam		AND F.Active=1
						INNER JOIN TB_CONTRACT CON 		
							on I.idcontract = CON.idcontract
						INNER JOIN TB_TariffScheme TS 		
							on CON.idtariffscheme = TS.idtariffscheme
						LEFT JOIN TR_TariffScheme_Service TSS		
							ON ts.IdTariffScheme = TSS.idtariffscheme and D.IdExam = TSS.IdExam and CON.idtariffscheme = tss.idtariffscheme
						LEFT JOIN TB_Service G		
							ON TSs.IdService = G.IdService
				WHERE A.IdPreBilling = @IdPreBilling

				UNION ALL

				SELECT DISTINCT I.IdRequest, NULL, E.ExamGroupCode, E.ExamGroupName, D.Value, D.IdGenerateCopay_CM, C.TotalValuePatient AS Copay_CM, I.RequestDate, I.RequestNumber, I.IdPatient, I.RecoveryFee
				FROM TB_PreBilling A
				INNER JOIN TR_PreBilling_BillingOfSale B
					ON B.IdPreBilling = A.IdPreBilling
				INNER JOIN TB_BillingOfSale C
					ON C.IdBillingOfSale = B.IdBillingOfSale
				INNER JOIN TR_BillingOfSale_Request H
					ON H.IdBillingOfSale = C.IdBillingOfSale
				INNER JOIN TB_Request I
					ON I.IdRequest = H.IdRequest
				INNER JOIN TR_Request_Exam D
					ON D.IdRequest = I.IdRequest AND D.Active = 1 AND D.Value is not null
				INNER JOIN TB_ExamGroup E
					ON E.IdExamGroup = D.IdExamGroup
				WHERE A.IdPreBilling = @IdPreBilling

				SET @Message = 'Successfully updated PreBilling'
				SET @Flag = 1
			end
		END
END
GO
