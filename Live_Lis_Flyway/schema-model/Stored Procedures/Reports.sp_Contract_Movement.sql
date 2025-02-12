SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [Reports].[sp_Contract_Movement]
(
	@IdCompany int, 
	@IdContract int
)
AS
BEGIN
    SET NOCOUNT ON

	IF OBJECT_ID ('tempdb..#Movimientos') IS NOT NULL
		BEGIN
			DROP TABLE #Movimientos
		END
	
	SELECT A.IdContract, D.IdCompany, D.ContractCode, D.ContractName, D.IdContractType, E.ContractType, 
		CASE D.IdContractType WHEN 4 THEN CASE D.IdContractAmountType WHEN 2 THEN 100000000000 END ELSE ISNULL(D.ContractAmount,0) END AS ContractAmount,
		D.ContractBalance, A.IdRequest, NULL IdInstallmentContract, /*A.RequestNumber AS NumeroMovimiento,*/ A.RequestDate AS FechaMovimiento, 0 AS Entrada, C.TotalValueCompany AS Salida, 0 AS Saldo
		INTO #Movimientos
	FROM TB_Request AS A
	INNER JOIN TR_BillingOfSale_Request AS B
		ON A.IdRequest = B.IdRequest
	INNER JOIN TB_BillingOfSale AS C
		ON B.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TB_Contract AS D
		ON A.IdContract = D.IdContract 
	INNER JOIN TB_ContractType AS E
		ON D.IdContractType = E.IdContractType
	WHERE A.RequestDate >= '2024-03-11'
		AND A.IdRequestStatus != 2
		--AND D.IdContractType = 3
		AND CASE WHEN @IdCompany = '' THEN '' ELSE D.IdCompany END = @IdCompany
		AND CASE WHEN @IdContract = '' THEN '' ELSE D.IdContract END = @IdContract
	
	UNION ALL
	
	SELECT A.IdContract, A.IdCompany, A.ContractCode, A.ContractName, A.IdContractType, D.ContractType, 
		CASE A.IdContractType WHEN 4 THEN CASE A.IdContractAmountType WHEN 2 THEN 100000000000 END ELSE ISNULL(A.ContractAmount,0) END AS ContractAmount,
		A.ContractBalance, NULL, B.IdInstallmentContract, /*C.InstallmentContractNumber,*/ B.CreationDate, B.ContractAmount, 0, 0
	FROM TB_Contract AS A
	INNER JOIN TR_InstallmentContract_Contract AS B
		ON A.IdContract = B.IdContract
	INNER JOIN TB_InstallmentContract AS C
		ON B.IdInstallmentContract = C.IdInstallmentContract
	INNER JOIN TB_ContractType AS D
		ON A.IdContractType = D.IdContractType
	WHERE B.CreationDate >= '2024-03-11'
		AND B.Active = 'True'
		---AND A.IdContractType = 3
		AND CASE WHEN @IdCompany = '' THEN '' ELSE A.IdCompany END = @IdCompany
		AND CASE WHEN @IdContract = '' THEN '' ELSE A.IdContract END = @IdContract
	ORDER BY 1,  5
	
	
	IF OBJECT_ID ('tempdb..#Movimientos2') IS NOT NULL
		BEGIN
			DROP TABLE #Movimientos2 
		END
	
	SELECT IDENTITY(int, 1, 1) Id, ContractCode, ContractName, IdContractType, ContractType, ContractAmount, ContractBalance, IdRequest, IdInstallmentContract, FechaMovimiento, CONVERT(bigint,Entrada) AS Entrada, CONVERT(bigint,Salida) AS Salida, CONVERT(bigint,Saldo) AS Saldo
		INTO #Movimientos2
	FROM #Movimientos
	ORDER BY ContractCode, FechaMovimiento
	
	DECLARE @Id int
	
	DECLARE Movimientos_Contratos CURSOR FOR 
	SELECT Id FROM #Movimientos2 ORDER BY Id
	
	OPEN Movimientos_Contratos
	FETCH NEXT FROM Movimientos_Contratos INTO @Id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	UPDATE A
		SET Saldo = B.Saldo + A.Entrada - A.Salida
	FROM #Movimientos2 A
	INNER JOIN (
				SELECT TOP 100 PERCENT Id, ContractCode, 
					CASE WHEN ContractCode = LAG(ContractCode, 1) OVER (ORDER BY Id) THEN LAG(Saldo, 1) OVER (ORDER BY Id) ELSE Saldo END AS Saldo
				FROM #Movimientos2
				ORDER BY Id
				) B
		ON B.Id = A.Id
	WHERE A.Id = @Id
	
	FETCH NEXT FROM Movimientos_Contratos INTO @Id
	END
	
	CLOSE Movimientos_Contratos
	DEALLOCATE Movimientos_Contratos
	
	--- Salida de información 
	SELECT ContractCode, ContractName, IdContractType, ContractType, ContractAmount, ContractBalance, IdRequest, IdInstallmentContract, FechaMovimiento, Entrada, Salida, Saldo 
	FROM #Movimientos2 ORDER BY Id
END
GO
