SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/08/2022
-- Description: Procedimiento almacenado para crear cotizaciones.
-- =============================================
/*
begin tran
DECLARE @ExamQuote_Exam ExamQuote_Exam, @IdBillingOfSaleOut int, @Message varchar(50), @Flag bit
INSERT INTO @ExamQuote_Exam (IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value) 
VALUES(1,4118,8382,NULL,1250000)
EXEC [sp_Create_ExamQuote] 2186,1,'1111','Natalia','Arias','','natalia.arias@dominio.co','Calle 123',NULL,0,0,
@ExamQuote_Exam,4, null, null, null, null, null, null, @IdBillingOfSaleOut out, @Message out, @Flag out
SELECT @IdBillingOfSaleOut, @Message, @Flag
rollback

*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ExamQuote]
(
	@IdContract int,  
	@IdIdentificationType int, 
	@IdentificationNumber varchar(20), 
	@Names varchar(120), 
	@LastNames varchar(120), 
	@TelephoneNumber varchar(15), 
	@Email varchar(100), 
	@Address varchar(100), 
	@Observations varchar(max)	= NULL, 
	@BeContacted bit, 
	@QuoteWhatsapp bit,
	@ExamQuote_Exam ExamQuote_Exam READONLY,
	@IdUserAction int,
	@ExpirationDate datetime=null,
	@IdUser int = null,
	@IdValidityFormat tinyint = null,
	@ExamQuoteValidity tinyint = null,
	@IdAttentionCenter tinyint = null,
	@AdditionalForm varchar (max) = '',
	@Points int = null,
	@IdDiscount int = null,
	@IdExamQuoteOut int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @ExamQuoteNumber int = 1, @DueDate date, @Days int, @IdExamQuote int, @QuoteFormValidity int =null, @IdValidityFormar int = null
	DECLARE @IVA decimal (4,2) = 0
BEGIN
    SET NOCOUNT ON

	IF (select IVA from TB_GeneralConfiguration) = 1
				BEGIN
					SET @IVA = (select isnull(ivapercentage,1) from TB_GeneralConfiguration)
				END

	SET @ExamQuoteNumber = @ExamQuoteNumber + (SELECT COUNT(*) FROM TB_ExamQuote)
	
	set	@QuoteFormValidity = (select QuoteFormValidity from TB_QuoteForm q inner join TB_Contract c on q.IdQuoteForm = c.IdQuoteForm where IdContract = @IdContract)
	set @IdValidityFormar =(select IdValidityFormat from TB_QuoteForm q inner join TB_Contract c on q.IdQuoteForm = c.IdQuoteForm where IdContract = @IdContract)

	SET @expirationdate = case when @IdValidityFormar = 1 then DATEADD(day,@QuoteFormValidity,DATEADD(HOUR,-5,GETDATE()))
								when @IdValidityFormar = 2 then DATEADD(MONTH,@QuoteFormValidity,DATEADD(HOUR,-5,GETDATE())) 
								when @IdValidityFormar = 3 then DATEADD(YEAR,@QuoteFormValidity,DATEADD(HOUR,-5,GETDATE())) 
							else null end

--select * from TB_QuoteForm
	--- Definir vigencia de cotización.
	--IF (SELECT IdQuoteValidity FROM TB_Contract WHERE IdContract = @IdContract) IS NOT NULL
	--	BEGIN
	--		SET @Days = (SELECT SUBSTRING(B.QuoteValidity,1,2) FROM TB_Contract A INNER JOIN TB_QuoteValidity B ON B.IdQuoteValidity = A.IdQuoteValidity  WHERE IdContract = @IdContract)
	--		SET @DueDate = (DATEADD(DAY,@Days,DATEADD(HOUR,-5,GETDATE())))
	--	END
	--ELSE
	--	BEGIN
	--		SET @DueDate = NULL
	--	END
		
	--- Crear cotización
	INSERT INTO TB_ExamQuote (IdContract, ExamQuoteNumber, ExamQuoteDate, IdIdentificationType, IdentificationNumber, Names, LastNames, 
				TelephoneNumber, Email, Address, Observations, BeContacted, QuoteWhatsapp, IdExamQuoteStatus, DueDate, CreationDate, IdUserAction,
				ExpirationDate, IdUser, IdValidityFormat, ExamQuoteValidity, IdAttentionCenter, AdditionalForm, IdDoctor, Points, IdDiscount)
	VALUES (@IdContract, @ExamQuoteNumber, DATEADD(HOUR,-5,GETDATE()), @IdIdentificationType, @IdentificationNumber, @Names, @LastNames, 
				@TelephoneNumber, @Email, @Address, @Observations, @BeContacted, @QuoteWhatsapp, 
				case when datediff(day,GETDATE(),@expirationdate) <= 5 THEN 2 else 1 end, 
				@expirationdate, DATEADD(HOUR,-5,GETDATE()), @IdUserAction,
				@ExpirationDate, @IdUser, @IdValidityFormat, @ExamQuoteValidity, @IdAttentionCenter, @AdditionalForm, @IdUser, @Points, @IdDiscount)

	SET @IdExamQuote = SCOPE_IDENTITY()

	--- Relacionar examenes a cotización
	MERGE TR_ExamQuote_Exam AS TARGET
	USING @ExamQuote_Exam SOURCE
		ON TARGET.IdExamQuote = @IdExamQuote
			AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
			AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
			AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdExamQuote, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, Value, IVA, TotalValue, IdDiscount_Service, OriginalValue, Points, PlanValidity, IdValidityFormat)
		VALUES(
			@IdExamQuote,
			SOURCE.IdTypeOfProcedure,
			SOURCE.IdExam,
			SOURCE.IdService,
			SOURCE.IdExamGroup,
			SOURCE.Value,
			@IVA,
			isnull(SOURCE.Value,0) + (isnull(SOURCE.Value,0) * (@IVA / 100)),
			SOURCE.IdDiscount_Service,
			SOURCE.OriginalValue,
			SOURCE.Points,
			SOURCE.PlanValidity,
			SOURCE.IdValidityFormat
		);

	SET @Message = 'Successfully created exam quote'
	SET @Flag = 1
	SET @IdExamQuoteOut=@IdExamQuote

END
GO
