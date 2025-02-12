SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/10/2022
-- Description: Procedimiento almacenado para crear formularios extra.
-- =============================================
--DECLARE @AdditionalFormField AdditionalFormField, @Message varchar(50), @Flag bit

--INSERT INTO @AdditionalFormField (AdditionalFormField, Obligatory, IdAdditionalFormDataType, AdditionalFormFieldOption, IdDefaultList, IdAccordionOrganization)
--VALUES ('Prueba List País',1,1,NULL,1,1), ('Prueba List Departamento',1,1,NULL,2,2), ('Prueba Lista',1,1,'0',NULL,3), ('Prueba Lista',1,1,'1',NULL,3), ('Prueba Lista',1,1,'2',NULL,3)--, ('Prueba campo 050123',0,2,NULL,1)--, ('Ciudad',1,1,'Medellin',0), ('Ciudad',1,1,'Cali',2), ('Télefono',0,2,NULL,0)

--EXEC [dbo].[sp_Create_AdditionalForm] 154, 2,'Formulario DBA 18042023',NULL,@AdditionalFormField,57,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_AdditionalForm]
(
	@IdAdditionalForm int,
	@IdAdditionalFormType int,
	@AdditionalForm varchar(100),
	@IdCompany int = NULL,
	@AdditionalFormField AdditionalFormField READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	TRUNCATE TABLE TB_AdditionalFormFielOption_Tmp

	IF @IdAdditionalForm = 0
		BEGIN
			IF NOT EXISTS (SELECT IdAdditionalForm	FROM TB_AdditionalForm WHERE AdditionalForm = @AdditionalForm)
				BEGIN
					INSERT INTO TB_AdditionalForm (IdAdditionalFormType, AdditionalForm, IdCompany, Active, CreationDate, IdUserAction)
					VALUES (@IdAdditionalFormType, @AdditionalForm, @IdCompany, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @IdAdditionalForm = SCOPE_IDENTITY()

					---Guardar información en tabla temporal
					INSERT INTO TB_AdditionalFormFielOption_Tmp (AdditionalFormField, Obligatory, IdAdditionalFormDataType, AdditionalFormFieldOption, IdDefaultList, IdAccordionOrganization, IdAdditionalForm)
					SELECT DISTINCT AdditionalFormField, Obligatory, IdAdditionalFormDataType, AdditionalFormFieldOption, IdDefaultList, IdAccordionOrganization, @IdAdditionalForm FROM @AdditionalFormField

					--- Validar campos existentes
					INSERT INTO TB_AdditionalFormField (AdditionalFormField, Obligatory, IdAdditionalFormDataType, IdDefaultList)	
					--SELECT DISTINCT AdditionalFormField, Obligatory, IdAdditionalFormDataType FROM TB_AdditionalFormFielOption_Tmp --WHERE Status = 1
					SELECT DISTINCT A.AdditionalFormField, A.Obligatory, A.IdAdditionalFormDataType, A.IdDefaultList
					FROM TB_AdditionalFormFielOption_Tmp A 
					LEFT JOIN TB_AdditionalFormField B 
						ON B.AdditionalFormField = A.AdditionalFormField 
							AND B.IdAdditionalFormDataType = A.IdAdditionalFormDataType
							AND ISNULL(B.IdDefaultList,0) = ISNULL(A.IdDefaultList,0)
					WHERE B.IdAdditionalFormField IS NULL


					--- Insertar Id del campo creado
					UPDATE B	
						SET B.IdAdditionalFormField = A.IdAdditionalFormField
					--SELECT *
					FROM TB_AdditionalFormField A
					INNER JOIN TB_AdditionalFormFielOption_Tmp B
						ON B.AdditionalFormField = A.AdditionalFormField
							AND B.IdAdditionalFormDataType = A.IdAdditionalFormDataType
							AND ISNULL(B.IdDefaultList,0) = ISNULL(A.IdDefaultList,0)

					--- Relacionar campos con formulario extra
					INSERT INTO TR_AdditionalForm_AdditionalFormField (IdAdditionalForm, IdAdditionalFormField, IdAccordionOrganization, Active)
					SELECT DISTINCT @IdAdditionalForm, IdAdditionalFormField, IdAccordionOrganization, 1 FROM TB_AdditionalFormFielOption_Tmp

					--- Relacianar opciones con campos
					INSERT INTO TB_AdditionalFormFieldOption (AdditionalFormFieldOption, IdAdditionalFormField, IdAdditionalForm)
					SELECT DISTINCT AdditionalFormFieldOption, IdAdditionalFormField, @IdAdditionalForm FROM TB_AdditionalFormFielOption_Tmp WHERE IdAdditionalFormDataType = 1 AND IdDefaultList IS NULL

				--	TRUNCATE TABLE TB_AdditionalFormFielOption_Tmp

					SET @Message = 'Successfully created additional form'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Additional form already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT IdAdditionalForm FROM TB_AdditionalForm WHERE AdditionalForm = @AdditionalForm AND IdAdditionalForm != @IdAdditionalForm)
				BEGIN
					UPDATE TB_AdditionalForm
						SET IdAdditionalFormType = @IdAdditionalFormType,
							AdditionalForm = @AdditionalForm,
							IdCompany = @IdCompany,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdAdditionalForm = @IdAdditionalForm

					---Guardar información en tabla temporal
					INSERT INTO TB_AdditionalFormFielOption_Tmp (AdditionalFormField, Obligatory, IdAdditionalFormDataType, AdditionalFormFieldOption, IdDefaultList, IdAccordionOrganization, IdAdditionalForm)
					SELECT DISTINCT AdditionalFormField, Obligatory, IdAdditionalFormDataType, AdditionalFormFieldOption, IdDefaultList, IdAccordionOrganization, @IdAdditionalForm FROM @AdditionalFormField

					----- Validar campos existentes
					--- Crear campos
					INSERT INTO TB_AdditionalFormField (AdditionalFormField, Obligatory, IdAdditionalFormDataType, IdDefaultList)	
					--SELECT DISTINCT AdditionalFormField, Obligatory, IdAdditionalFormDataType FROM TB_AdditionalFormFielOption_Tmp --WHERE Status = 1
					SELECT DISTINCT A.AdditionalFormField, A.Obligatory, A.IdAdditionalFormDataType, A.IdDefaultList
					FROM TB_AdditionalFormFielOption_Tmp A 
					LEFT JOIN TB_AdditionalFormField B 
						ON B.AdditionalFormField = A.AdditionalFormField 
							AND B.IdAdditionalFormDataType = A.IdAdditionalFormDataType
							AND ISNULL(B.IdDefaultList,0) = ISNULL(A.IdDefaultList,0)
					WHERE B.IdAdditionalFormField IS NULL


					--- Insertar Id del campo creado
					UPDATE B	
						SET B.IdAdditionalFormField = A.IdAdditionalFormField
					--SELECT *
					FROM TB_AdditionalFormField A
					INNER JOIN TB_AdditionalFormFielOption_Tmp B
						ON B.AdditionalFormField = A.AdditionalFormField
							AND B.IdAdditionalFormDataType = A.IdAdditionalFormDataType
							AND ISNULL(B.IdDefaultList,0) = ISNULL(A.IdDefaultList,0)

					--SELECT *
					UPDATE A	
						SET A.Status =  CASE WHEN B.IdAdditionalFormField IS NULL THEN 1 ELSE 0 END
					FROM TB_AdditionalFormFielOption_Tmp A
					LEFT JOIN TR_AdditionalForm_AdditionalFormField B
						ON B.IdAdditionalFormField = A.IdAdditionalFormField
							AND B.IdAdditionalForm = @IdAdditionalForm

					
					INSERT INTO TR_AdditionalForm_AdditionalFormField (IdAdditionalForm, IdAdditionalFormField, IdAccordionOrganization, Active)
					SELECT DISTINCT @IdAdditionalForm, IdAdditionalFormField, IdAccordionOrganization, 1 FROM TB_AdditionalFormFielOption_Tmp WHERE Status = 1

					--- Relacianar opciones con campos
					INSERT INTO TB_AdditionalFormFieldOption (AdditionalFormFieldOption, IdAdditionalFormField, IdAdditionalForm)
					SELECT DISTINCT AdditionalFormFieldOption, IdAdditionalFormField, @IdAdditionalForm FROM TB_AdditionalFormFielOption_Tmp WHERE IdAdditionalFormDataType = 1 AND IdDefaultList IS NULL

					--TRUNCATE TABLE TB_AdditionalFormFielOption_Tmp

					SET @Message = 'Successfully update additional form'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Additional form already exists'
					SET @Flag = 0
				END
		END
END
GO
