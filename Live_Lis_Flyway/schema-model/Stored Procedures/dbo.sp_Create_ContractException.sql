SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 18/01/2023
-- Description: Procedimiento almacenado para crear excepciones a examen de un contrato.
-- =============================================
--DECLARE @ContractException ContractException,  @Message varchar(50), @Flag bit
--INSERT INTO @ContractException (IdTypeOfProcedure, IdExam, IdService, IdExamGroup, ValueException)
--VALUES (1,5446,NULL,NULL,250000),(4,NULL,NULL,1,25000)

--EXEC [sp_Create_ContractException] 4,@ContractException,2, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ContractException]
(
	@IdContract int, 
	@ContractException ContractException READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF (SELECT TOP 1 IdExam FROM @ContractException) IS NULL AND (SELECT TOP 1 IdExamGroup FROM @ContractException) IS NULL
		BEGIN
			UPDATE TB_ContractException
				SET Active = 'False',
					UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
					IdUserAction =  @IdUserAction
			WHERE IdContract = @IdContract
		END
	ELSE
		BEGIN
			MERGE TB_ContractException TARGET
			USING (SELECT DISTINCT * FROM @ContractException) SOURCE
				ON TARGET.IdContract = @IdContract
					AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
					AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
					AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
			WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IdContract, IdTypeOfProcedure, IdExam, IdService, IdExamGroup, ValueException, Active, CreationDate, IdUserAction)
				VALUES(
					@IdContract,
					SOURCE.IdTypeOfProcedure,
					SOURCE.IdExam,
					SOURCE.IdService,
					SOURCE.IdExamGroup,
					SOURCE.ValueException,
					1,
					DATEADD(HOUR,-5,GETDATE()),
					@IdUserAction
					)
			WHEN MATCHED
			THEN
				UPDATE
					SET TARGET.ValueException = SOURCE.ValueException,
						TARGET.Active = 1,
						TARGET.UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
						TARGET.IdUserAction = @IdUserAction
			WHEN NOT MATCHED BY SOURCE AND TARGET.IdContract = @IdContract AND TARGET.Active = 1
				THEN
					UPDATE	
						SET TARGET.Active = 0,
							TARGET.UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
							TARGET.IdUserAction = @IdUserAction;
		END

	SET @Message = 'Successfully created contract exception'
	SET @Flag = 1

END
GO
