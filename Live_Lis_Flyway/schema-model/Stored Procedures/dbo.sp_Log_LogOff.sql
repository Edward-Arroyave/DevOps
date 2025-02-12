SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/03/2022
-- Description: Procedimiento almacenado para almacenar registro de cierre de sesión.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Log_LogOff]
(
	@IdUser int,
	@AccessSystem int -- 1 = live lis 2 = Web Resultados
)
AS	
	DECLARE @UserName varchar(25)
BEGIN
    SET NOCOUNT ON

	SET @UserName = (SELECT UserName FROM TB_User WHERE IdUser = @IdUser)

    INSERT INTO History.TH_Binnacle (ActionDate, UserName, Action, AccessSystem)
	VALUES (DATEADD(HOUR,-5,GETDATE()), @UserName, 'LogOff', CASE WHEN @AccessSystem = 1 THEN 'live lis' WHEN @AccessSystem = 2 THEN 'Web Resultados' END)
END
GO
