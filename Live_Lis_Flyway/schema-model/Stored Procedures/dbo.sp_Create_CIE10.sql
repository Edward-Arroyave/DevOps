SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/09/2022
-- Description: Procedimiento almacenado para insertar en base de datos diagnósticos CIE10
-- =============================================
--DECLARE @Salida varchar(100), @Bandera bit
--EXEC [sp_Create_CIE10] 1,0,NULL,'','',@Salida out, @Bandera out
--SELECT @Salida, @Bandera
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_CIE10]
(
	@CIE10Type int,
	@IdCIE10Code int,
    @ParentIdCIE10 int = NULL,
	@CIE10Code varchar(9),
	@CIE10Name varchar(100),
	@IdUserAction int, 
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	--- CIE10 Código 3
	IF @CIE10Type = 1
		BEGIN
			IF @IdCIE10Code = 0
				BEGIN
					IF NOT EXISTS (SELECT IdCIE10_Code3 FROM TB_CIE10_Code3 WHERE CIE10_Code3 = @CIE10Code AND CIE10_Code3Name = @CIE10Name)
						BEGIN
							IF NOT EXISTS(SELECT CIE10_Code3 FROM TB_CIE10_Code3 WHERE CIE10_Code3 = @CIE10Code)
								BEGIN
									IF NOT EXISTS (SELECT CIE10_Code3Name FROM TB_CIE10_Code3 WHERE CIE10_Code3Name = @CIE10Name)
										BEGIN
											INSERT INTO TB_CIE10_Code3(CIE10_Code3, CIE10_Code3Name, Active, CreationDate, IdUserAction)
											VALUES (@CIE10Code, @CIE10Name, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

											SET @Message = 'Successfully created CIE10 Code 3'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'CIE10 code 3 name already exists'
											SET @Flag =0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'CIE10 Code 3 already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'CIE10 Code 3 and name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT IdCIE10_Code3 FROM TB_CIE10_Code3 WHERE CIE10_Code3 = @CIE10Code AND IdCIE10_Code3 != @IdCIE10Code)
						BEGIN
							IF NOT EXISTS (SELECT IdCIE10_Code3 FROM TB_CIE10_Code3 WHERE CIE10_Code3Name = @CIE10Name AND IdCIE10_Code3 != @IdCIE10Code)
								BEGIN
									UPDATE TB_CIE10_Code3
										SET CIE10_Code3 = @CIE10Code,
											CIE10_Code3Name = @CIE10Name,
											Active = 1,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction= @IdUserAction
									WHERE IdCIE10_Code3 = @IdCIE10Code

									SET @Message = 'Successfully updated CIE10 code 3'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'CIE10 code 3 name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'CIE10 Code 3 already exists'
							SET @Flag = 0
						END
				END
		END
	--- CIE10 Código 4
	ELSE IF @CIE10Type = 2
		BEGIN
			IF @IdCIE10Code = 0
				BEGIN
					IF NOT EXISTS (SELECT IdCIE10_Code4 FROM TB_CIE10_Code4 WHERE CIE10_Code4 = @CIE10Code AND CIE10_Code4Name = @CIE10Name)
						BEGIN
							IF NOT EXISTS(SELECT CIE10_Code4 FROM TB_CIE10_Code4 WHERE CIE10_Code4 = @CIE10Code)
								BEGIN
									IF NOT EXISTS (SELECT CIE10_Code4Name FROM TB_CIE10_Code4 WHERE CIE10_Code4Name = @CIE10Name)
										BEGIN
											INSERT INTO TB_CIE10_Code4(IdCIE10_Code3, CIE10_Code4, CIE10_Code4Name, Active, CreationDate, IdUserAction)
											VALUES (@ParentIdCIE10, @CIE10Code, @CIE10Name, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

											SET @Message = 'Successfully created CIE10 Code 4'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'CIE10 code 4 Name already exists'
											SET @Flag =0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'CIE10 Code 4 already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'CIE10 Code 4 and name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT IdCIE10_Code4 FROM TB_CIE10_Code4 WHERE CIE10_Code4 = @CIE10Code AND IdCIE10_Code4 != @IdCIE10Code)
						BEGIN
							IF NOT EXISTS (SELECT IdCIE10_Code4 FROM TB_CIE10_Code4 WHERE CIE10_Code4Name = @CIE10Name AND IdCIE10_Code4 != @IdCIE10Code)
								BEGIN
									UPDATE TB_CIE10_Code4
										SET IdCIE10_Code3 = @ParentIdCIE10,
											CIE10_Code4 = @CIE10Code,
											CIE10_Code4Name = @CIE10Name,
											Active = 1,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction
									WHERE IdCIE10_Code4 = @IdCIE10Code

									SET @Message = 'Successfully updated CIE10 Code 4'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'CIE10 code 4 Name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'CIE10 Code 4 already exists'
							SET @Flag = 0
						END
				END
		END
END
GO
