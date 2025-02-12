SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para asociar sedes a un usuario.
-- =============================================
--DECLARE @Message varchar(100), @Flag bit
--EXEC [sp_Relate_User_AttentionCenter] 4, '1,7,8',4, @Message out, @Flag out
--SELECT @Message, @Flag 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Relate_User_AttentionCenter]
(
	@IdUser int,
	@AttentionCenter varchar(30),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdAttentionCenter int, @Position int
	DECLARE @TableAttentionCenter table (IdUser_AttentionCenter int identity, IdUser int, IdAttentionCenter int, ActionDate datetime, IdUserAction int)
BEGIN
    SET NOCOUNT ON
	
	IF (@AttentionCenter != '')
		BEGIN
			SET @AttentionCenter = @AttentionCenter + ','

			WHILE PATINDEX('%,%', @AttentionCenter) <> 0
				BEGIN
					SELECT @Position = PATINDEX('%,%', @AttentionCenter)
					SELECT @IdAttentionCenter = LEFT (@AttentionCenter, @Position -1)

					SET @IdAttentionCenter = (SELECT IdAttentionCenter FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)

						BEGIN
							INSERT INTO @TableAttentionCenter (IdUser, IdAttentionCenter, ActionDate, IdUserAction)
							VALUES (@IdUser, @IdAttentionCenter, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
							--(SELECT DISTINCT IdUser, @IdAttentionCenter, DATEADD(HOUR,-5,GETDATE()), @IdUserAction FROM TR_User_AttentionCenter WHERE IdUser = @IdUser)
						END

					SELECT @AttentionCenter = STUFF(@AttentionCenter, 1, @Position, '')
				END
		END
			
	MERGE TR_User_AttentionCenter AS TARGET
	USING
		(SELECT IdUser_AttentionCenter, IdUser, IdAttentionCenter, ActionDate, IdUserAction, 1 AS Active FROM @TableAttentionCenter) SOURCE
	ON TARGET.IdUser = SOURCE.IdUser
		AND TARGET.IdAttentionCenter = SOURCE.IdAttentionCenter
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdUser, IdAttentionCenter, CreationDate, IdUserAction, Active)
		VALUES
			(
			SOURCE.IdUser,
			SOURCE.IdAttentionCenter,
			SOURCE.ActionDate,
			SOURCE.IdUserAction,
			SOURCE.Active
			)
		WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser AND TARGET.Active = 1
			THEN
				UPDATE 
					SET TARGET.Active = 0,
						TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
						TARGET.IdUserAction = @IdUserAction
		WHEN MATCHED AND TARGET.Active = 0 --AND TARGET.IdUser = @IdUser
			THEN
				UPDATE
					SET TARGET.Active = 1,
						TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
						TARGET.IdUserAction = @IdUserAction;



	SET @Message = 'User related attention center were updated successfully'
	SET @Flag = 1
	
END
GO
