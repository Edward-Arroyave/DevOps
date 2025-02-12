SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 06/04/2024
-- Description: Procedimiento almacenado para realizar el recalculo de tarifas en un plan y todas las solicitudes del plan en un rango de fechas
-- =============================================
/*
begin tran
EXEC sp_Tariff_Recalculation 245,75,'2024-04-09',''
rollback
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Tariff_Recalculation]
(

    @IdContract int,
	@IdNewTariffScheme int,
	@InitialDate datetime,
	@IdUserAction Int,	
	@WhoAuthorized Varchar (100)=''
	--,@Message varchar(100) out,
	--@Flag bit out
)
AS
BEGIN

--begin try
    /*
	DECLARE @Salida varchar(100), @Bandera varchar(100)
	EXEC sp_TariffRecalculation 240,4,'',2, @Salida out, @Bandera out
	SELECT @Salida, @Bandera
	*/
    SET NOCOUNT ON
 /*   DECLARE @IdContractType Smallint, @ContractAmount Bigint, @ValueCurrentExams Bigint, @ValueNewExams Bigint, @Difference Bigint, @IdCompany Int, 
			@IdBillingBox Int, @IdInstallmentContract Int, @ContractBalance Bigint, @CountExam int=0

	SET @IdBillingBox = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND BillingBoxStatus = 1)

	SELECT	@IdCompany = (c.IdCompany),
			@IdContractType= (c.IdContractType),
			@ContractAmount=(c.ContractAmount),
			@ContractBalance = (c.ContractBalance),
			@ValueCurrentExams=(sum(isnull(re.Value,0))), 
			@ValueNewExams=(sum(CASE WHEN re.IdExamGroup IS NULL THEN isnull(ce.ValueException,isnull(ss.Value,0)) ELSE isnull(cg.ValueException,isnull(ssg.Value,0)) END ) )
	FROM	TR_Request_Exam re
			INNER JOIN TB_Request req on re.IdRequest = req.IdRequest
			INNER JOIN TB_Contract c on req.IdContract = c.IdContract
			LEFT JOIN TR_TariffScheme_Service ss on re.IdExam = ss.IdExam and ss.IdTariffScheme = @IdNewTariffScheme
			LEFT JOIN TR_TariffScheme_Service ssG on re.IdExamGroup = ssG.IdExamGroup and ssG.IdTariffScheme = @IdNewTariffScheme
			LEFT JOIN  TB_ExamGroup eg on re.IdExamGroup = eg.IdExamGroup
			INNER JOIN TR_BillingOfSale_Request E ON E.IdRequest = re.IdRequest
			INNER JOIN TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
			LEFT JOIN  TB_ContractException ce on re.IdExam = ce.IdExam and c.IdContract = ce.IdContract and ce.active = 1
			LEFT JOIN  TB_ContractException CG on re.IdExamGroup = CG.IdExamGroup and c.IdContract = ce.IdContract and ce.active = 1
	WHERE	c.idcontract = @IdContract --and ss.IdTariffScheme=@NewTariffScheme
	AND		req.RequestDate>=@InitialDate
	AND		F.IdElectronicBilling IS NULL
	GROUP BY c.IdCompany,c.IdContractType, c.ContractAmount, c.ContractBalance

	SET @CountExam = (SELECT	COUNT(*)
				FROM	TR_Request_Exam re
						INNER JOIN TB_Request req on re.IdRequest = req.IdRequest
						INNER JOIN TB_Contract c on req.IdContract = c.IdContract
						LEFT JOIN TR_TariffScheme_Service ss on re.IdExam = ss.IdExam and ss.IdTariffScheme = @IdNewTariffScheme
						LEFT JOIN  TB_ExamGroup eg on re.IdExamGroup = eg.IdExamGroup
						INNER JOIN TR_BillingOfSale_Request E ON E.IdRequest = re.IdRequest
						INNER JOIN TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
				WHERE	c.idcontract = @IdContract --and ss.IdTariffScheme=@NewTariffScheme
				AND		req.RequestDate>=@InitialDate
				AND		ss.IdExam is null
				AND		eg.IdExamGroup is NULL
				AND		F.IdElectronicBilling IS NULL)

--Validacion para error por si esta nullo
	IF @IdContractType IS NULL
	BEGIN
		UPDATE TB_ContractTariffScheme set Executed = 0 , Obs = 'No information found for this tariff scheme' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
		--SET @Message = 'No information found for this tariff scheme'
		--SET @Flag = 0
	END
--Validar si el particular tambien tiene cambio de tarifas
	IF @IdContractType = 1
		BEGIN
			UPDATE TB_ContractTariffScheme set Executed = 0 , Obs = 'No information found for this tariff scheme contract is particular' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
		--	SET @Message = 'No information found for this tariff scheme'
			--SET @Flag = 0
		END
	ELSE
		BEGIN
			IF @CountExam > 0
				BEGIN
					DECLARE @Exams Varchar (500)

					SET @Exams = (select STUFF(( SELECT ',' + EX.ExamCode 
									FROM	TR_Request_Exam re
											INNER JOIN TB_Exam EX on re.IdExam = EX.IdExam
											INNER JOIN TB_Request req on re.IdRequest = req.IdRequest
											INNER JOIN TB_Contract c on req.IdContract = c.IdContract
											LEFT JOIN TR_TariffScheme_Service ss on re.IdExam = ss.IdExam and ss.IdTariffScheme = @IdNewTariffScheme
											LEFT JOIN  TB_ExamGroup eg on re.IdExamGroup = eg.IdExamGroup
											INNER JOIN TR_BillingOfSale_Request E ON E.IdRequest = re.IdRequest
											INNER JOIN TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
									WHERE	c.idcontract = @IdContract --and ss.IdTariffScheme=@NewTariffScheme
									AND		req.RequestDate>=@InitialDate
									AND		ss.IdExam is null
									AND		eg.IdExamGroup is NULL
									AND		F.IdElectronicBilling IS NULL
									GROUP BY EX.ExamCode
									FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1,1,'') AS ProfileName)

					--UPDATE TB_ContractTariffScheme set Executed = 0 , Obs = 'There are exams that are not configured in the new tariff scheme' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
					UPDATE TB_ContractTariffScheme set Executed = 0 , Obs = 'Se deben configurar los examenes '+@Exams+' en el nuevo esquema tarifario' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
					--SET @Message = 'There are exams that are not configured in the new tariff scheme'
					--SET @Flag = 0
				END
			ELSE IF (@ValueCurrentExams<@ValueNewExams) and CASE WHEN @IdContractType = 3 THEN @ContractAmount-(@ValueNewExams-@ValueCurrentExams) ELSE @ContractBalance-(@ValueNewExams-@ValueCurrentExams) END<0
				BEGIN
					UPDATE TB_ContractTariffScheme set Executed = 0 , Obs = 'The rate cannot be recalculated because the contract amount would remain negative' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
					--SET @Message = 'The rate cannot be recalculated because the contract amount would remain negative'
					--SET @Flag = 0
				END
			ELSE
				BEGIN

					SET @Difference = CASE WHEN @ValueNewExams <= @ValueCurrentExams THEN (@ValueCurrentExams-@ValueNewExams) ELSE (@ValueNewExams - @ValueCurrentExams) END

					UPDATE  re set re.Value= case when re.IdExam is null then isnull(cg.ValueException,ssg.Value) else isnull(ce.ValueException,ss.Value) end
					FROM	TR_Request_Exam re
							INNER JOIN TB_Request req on re.IdRequest = req.IdRequest
							INNER JOIN TB_Contract c on req.IdContract = c.IdContract
							LEFT JOIN TR_TariffScheme_Service ss on re.IdExam = ss.IdExam and ss.IdTariffScheme = @IdNewTariffScheme
							LEFT JOIN  TR_TariffScheme_Service ssg on re.IdExamGroup = ssg.IdExamGroup and ssg.IdTariffScheme = @IdNewTariffScheme
							LEFT JOIN  TB_ExamGroup eg on re.IdExamGroup = eg.IdExamGroup
							INNER JOIN TR_BillingOfSale_Request E ON E.IdRequest = re.IdRequest
							INNER JOIN TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
							LEFT JOIN  TB_ContractException ce on re.IdExam = ce.IdExam and c.IdContract = ce.IdContract and ce.active = 1
							LEFT JOIN  TB_ContractException cg on re.IdExamGroup = cg.IdExamGroup and c.IdContract = cg.IdContract and ce.active = 1
					where	c.idcontract = @IdContract
					AND		req.RequestDate>=@InitialDate
					AND		F.IdElectronicBilling IS NULL

					IF @IdContractType = 3 and @Difference > 0
						BEGIN
							INSERT INTO TB_InstallmentContract (InstallmentContractNumber, IdCompany,  ContractAmount, IdPaymentMethod, Crossway, IdBillingBox, Active, CreationDate, IdUserAction)
							VALUES (999999999, @IdCompany, @Difference, 1, 0, @IdBillingBox, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
			
							SET @IdInstallmentContract = SCOPE_IDENTITY ()

							INSERT INTO TR_InstallmentContract_Contract(IdInstallmentContract, IdContract, IdInstallmentContractType, ContractAmount, Crossway, Active, CreationDate, IdUserAction)
							VALUES (@IdInstallmentContract, @IdContract, 3, @Difference, 0, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

							UPDATE	TB_Contract set ContractAmount = CASE WHEN @ValueNewExams <= @ValueCurrentExams THEN ContractAmount + (@ValueCurrentExams-@ValueNewExams) 
																													ELSE ContractAmount - (@ValueNewExams - @ValueCurrentExams) END, 
													WhoAuthorized = @WhoAuthorized,
													IdTariffScheme= @IdNewTariffScheme
									where	IdContract=@IdContract
						END
					ELSE
						BEGIN

									UPDATE	TB_Contract set ContractBalance = CASE WHEN @ValueNewExams <= @ValueCurrentExams THEN ContractBalance + (@ValueCurrentExams-@ValueNewExams) ELSE ContractBalance - (@ValueNewExams - @ValueCurrentExams) END, 
												WhoAuthorized = @WhoAuthorized,
												IdTariffScheme= @IdNewTariffScheme
									where	IdContract=@IdContract

	END
			
					DECLARE @valores TABLE (id int identity, idreq int, valor bigint) 
					insert into @valores
					select E.idrequest, sum(case when ss.IdExam is null then isnull(ce.ValueException,ssg.Value) else isnull(ce.ValueException,ss.Value) end)
					FROM	TR_Request_Exam re
							INNER JOIN TB_Request req on re.IdRequest = req.IdRequest
							INNER JOIN TB_Contract c on req.IdContract = c.IdContract
							LEFT JOIN TR_TariffScheme_Service ss on re.IdExam = ss.IdExam and ss.IdTariffScheme = @IdNewTariffScheme
							LEFT JOIN  TR_TariffScheme_Service ssg on re.IdExamGroup = ssg.IdExamGroup and ssg.IdTariffScheme = @IdNewTariffScheme
							LEFT JOIN  TB_ExamGroup eg on re.IdExamGroup = eg.IdExamGroup
							INNER JOIN TR_BillingOfSale_Request E ON E.IdRequest = re.IdRequest
							INNER JOIN TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
							LEFT JOIN  TB_ContractException ce on re.IdExam = ce.IdExam and c.IdContract = ce.IdContract and ce.active = 1
					where	c.idcontract = @IdContract
					AND		req.RequestDate>=@InitialDate
					AND		F.IdElectronicBilling IS NULL
					group by E.idrequest 

/*
					declare @count int = (select COUNT(*) from @valores)
					declare @id int, @idreq int, @valor bigint
					WHILE @count > 0
						begin
							set @Id  = (select top 1 id from @valores order by idreq asc)
							select  @idreq = idreq,
									@valor = valor
							from	@valores
							where	id = @Id

							UPDATE TR_BillingOfSale_Request SET TotalValueCompany = @valor WHERE idrequest = @idreq
							UPDATE A SET A.TotalValueCompany = @valor FROM TR_BillingOfSale_Request B INNER JOIN TB_BillingOfSale A ON A.IdBillingOfSale=B.IdBillingOfSale WHERE B.IdRequest = @idreq
						
							delete from @valores where id = @id
						
							set @count = (select COUNT(*) from @valores)
						end
*/

					ALTER TABLE TR_BillingOfSale_Request DISABLE TRIGGER TG_Request_Contract

					update E set TotalValueCompany = valor
					FROM	TR_BillingOfSale_Request E
							INNER JOIN @valores F on E.IdRequest = F.idreq

					UPDATE A SET A.TotalValueCompany = valor 
					FROM	TR_BillingOfSale_Request B 
							INNER JOIN TB_BillingOfSale A ON A.IdBillingOfSale=B.IdBillingOfSale
							INNER JOIN @valores F on B.IdRequest = F.idreq

					ALTER TABLE TR_BillingOfSale_Request ENABLE TRIGGER TG_Request_Contract		

					UPDATE TB_ContractTariffScheme set Executed = 1 , Obs = 'Recálculo ejecutado correctamente' where idcontract = @IdContract and IdTariffScheme = @IdNewTariffScheme
				
					--SET @Message = 'Change executed'
					--SET @Flag = 1
					END
		END
		*/
		--end try

		--begin catch
		--	declare @mesagge varchar (200)

		--	set @mesagge = ''+error_message()+', Line: '+cast(error_line() as varchar)

		--	insert into dbo.error  
		--	values (@mesagge)

		--end catch

END
GO
