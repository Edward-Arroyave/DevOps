/****** Object:  StoredProcedure [dbo].[sp_LoadReasonsPostponement]    Script Date: 19/02/2025 12:05:23 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 03/02/2025
-- Description: Procedimiento almacenado para cargue masivo de razon de porponer
-- =============================================
/*
DECLARE @LoadReasonForPostponement LoadReasonForPostponement, @Message varchar(50), @Flag bit
INSERT INTO @LoadReasonForPostponement (PostponementCode, PostponementName)
VALUES 
('12345','Prueba posponer'),
('54321','Cargue prueba')
EXEC [sp_LoadReasonsPostponement] @LoadReasonForPostponement,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadReasonsPostponement]
(
	@LoadReasonForPostponement LoadReasonForPostponement READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

		SELECT DISTINCT A.PostponementCode, A.PostponementName,DATEADD(HOUR,-5,GETDATE()) CreationDate ,@IdUserAction IdUserAction, 1 Active
		FROM @LoadReasonForPostponement A
		INNER JOIN TB_ReasonsForPostponement B
		   ON B.PostponementName = A.PostponementName

		INSERT INTO TB_ReasonsForPostponement (PostponementCode, PostponementName, CreationDate, IdUserCreation, Active)
		SELECT DISTINCT A.PostponementCode, A.PostponementName,DATEADD(HOUR,-5,GETDATE()),@IdUserAction, 1 
		FROM @LoadReasonForPostponement A
		LEFT JOIN TB_ReasonsForPostponement B
		   ON B.PostponementName = A.PostponementName
		WHERE B.IdReasonsForPostponement IS NULL

		IF @@ROWCOUNT <> 0
          BEGIN
			SET @Flag = 1;
			SET @Message = 'Razon para posponer cargado con exito.'
		  END
        ELSE
          BEGIN
            SET @Flag = 0;
            SET @Message = 'Información ya existente, no se realiza cargue.';
		  END



END

GO

