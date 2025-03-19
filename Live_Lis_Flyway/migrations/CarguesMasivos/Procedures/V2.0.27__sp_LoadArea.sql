/****** Object:  StoredProcedure [dbo].[sp_LoadArea]    Script Date: 19/02/2025 12:04:26 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 03/02/2025
-- Description: Procedimiento almacenado para cargue masivo de area.
-- =============================================
/*
DECLARE @LoadArea LoadArea, @Message varchar(50), @Flag bit
INSERT INTO @LoadArea (PostponementCode, PostponementName)
VALUES 
('12345','Prueba posponer'),
('54321','Cargue prueba')
EXEC [sp_LoadArea] @LoadArea,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadArea]
(
	@LoadArea LoadArea READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
		SELECT DISTINCT A.AreaName,DATEADD(HOUR,-5,GETDATE()) CreationDate,@IdUserAction IdUserAction, 1 Active 
		FROM @LoadArea A
		INNER JOIN TB_Area B
		   ON B.AreaName = A.AreaName

		INSERT INTO TB_Area(AreaName, CreationDate, IdUserAction, Active)
		SELECT DISTINCT A.AreaName,DATEADD(HOUR,-5,GETDATE()),@IdUserAction, 1 
		FROM @LoadArea A
		LEFT JOIN TB_Area B
		   ON B.AreaName = A.AreaName
		WHERE B.IdArea IS NULL

		IF @@ROWCOUNT <> 0
          BEGIN
			SET @Flag = 1;
			SET @Message = 'Area cargada con exito.'
		  END
        ELSE
          BEGIN
            SET @Flag = 0;
            SET @Message = 'Información ya existente, no se realiza cargue.';
		  END


END

GO

