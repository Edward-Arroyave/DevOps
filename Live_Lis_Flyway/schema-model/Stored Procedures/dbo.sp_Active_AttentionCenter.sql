SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para activar o desactivar un centro de atención.
-- =============================================
-- exec [dbo].[sp_Active_AttentionCenter] 18,'true',1023,'',''
CREATE PROCEDURE [dbo].[sp_Active_AttentionCenter]
(
	@IdAttentionCenter int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdAttentionCenter FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
		BEGIN
			IF NOT EXISTS (SELECT IdAttentionCenter FROM TR_User_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
				BEGIN
					IF NOT EXISTS (SELECT IdAttentionCenter FROM TR_Exam_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
						BEGIN
							UPDATE TB_AttentionCenter
								SET Active = @Active,
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdAttentionCenter = @IdAttentionCenter

							SET @Message = 'Successfully updated Attention Center'
							SET @Flag = 1
						END
					ELSE
						BEGIN
						if @Active = 'False'
							begin
								SET @Message = 'Attention Center has associated exams' 
								SET @Flag = 0
							end
							else
							begin
								SET @Message = 'Successfully updated ' 
								SET @Flag = 1
							end
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Attention Center has associated users'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Attention Center not found'
			SET @Flag = 0
		END
END
GO
