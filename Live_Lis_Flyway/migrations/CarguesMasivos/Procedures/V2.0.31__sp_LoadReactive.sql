/****** Object:  StoredProcedure [dbo].[sp_LoadReactive]    Script Date: 19/02/2025 12:07:33 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de reactivos.
-- =============================================
/*
DECLARE @LoadReactive LoadReactive,@Message varchar(50), @Flag bit
INSERT INTO @LoadReactive (ReferenceCode,Reactive)
VALUES 
('P1234','Prueba'),
('DN1234','Dato Nuevo')
EXEC [sp_LoadReactive] @LoadReactive,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadReactive]
(
	@LoadReactive LoadReactive READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.ReferenceCode,A.Reactive, 1 Active,DATEADD(HOUR,-5,GETDATE()) CreationDate, @IdUserAction IdUserAction
	FROM @LoadReactive A
	INNER JOIN TB_Reactive B
		ON B.Reactive = A.Reactive
	
	INSERT INTO TB_Reactive(ReferenceCode,Reactive, Active, CreationDate, IdUserAction)
	SELECT DISTINCT A.ReferenceCode,A.Reactive, 1,DATEADD(HOUR,-5,GETDATE()), @IdUserAction 
	FROM @LoadReactive A
	LEFT JOIN TB_Reactive B
	   ON B.Reactive = A.Reactive
	WHERE B.IdReactive IS NULL

	IF @@ROWCOUNT <> 0
      BEGIN
		SET @Flag = 1
		SET @Message = 'Reactivo cargada con exito.'
	  END
	 ELSE
        BEGIN
            SET @Flag = 0
            SET @Message = 'Información ya existente, no se realiza cargue.'
		END
END
GO

