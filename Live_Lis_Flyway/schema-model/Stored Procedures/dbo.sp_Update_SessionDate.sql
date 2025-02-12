SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 07/03/2021
-- Description: Procedimiento almacenado para actualizar la fecha de sesión
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_SessionDate]
(
	@IdUser int,
	@AccessSystem int -- 1 = live lis 2 = Web Resultados
)
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
		BEGIN
			UPDATE TB_User
				SET SessionDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdUser = @IdUser

			INSERT INTO History.TH_Binnacle (ActionDate, UserName, Action, AccessSystem)
			SELECT DATEADD(HOUR,-5,GETDATE()), UserName, 'LogIn', CASE WHEN @AccessSystem = 1 THEN 'live lis' WHEN @AccessSystem = 2 THEN 'Web Resultados' END
			FROM TB_User
			WHERE IdUser = @IdUser

			--Actualización variables bloqueo
			IF @AccessSystem = 1
				BEGIN
					UPDATE TB_User set blocking = 0, LockDate = NULL, Time = 0, Attempts = 0 WHERE IdUser = @IdUser;
				END
			
		END
END
GO
