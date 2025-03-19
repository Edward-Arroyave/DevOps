/****** Object:  StoredProcedure [dbo].[sp_LoadCommercialHouses]    Script Date: 19/02/2025 12:06:02 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de casa comercial.
-- =============================================
/*
DECLARE @LoadCommercialHouse LoadCommercialHouse, @Message varchar(50), @Flag bit
INSERT INTO @LoadCommercialHouse (CommercialHouseName)
VALUES 
('Casa prueba'),
('Casa registro')
EXEC [sp_LoadCommercialHouses] @LoadCommercialHouse,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadCommercialHouses]
(
	@LoadCommercialHouse LoadCommercialHouse READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

		SELECT DISTINCT A.CommercialHouseName, 1 Active,DATEADD(HOUR,-5,GETDATE()) CreationDate, @IdUserAction IdUserAction
		FROM @LoadCommercialHouse A
		INNER JOIN TB_CommercialHouses B
		   ON B.Name = A.CommercialHouseName


		INSERT INTO TB_CommercialHouses(Name, Active, CreationDate, IdCreationUser, IdUserAction)
		SELECT DISTINCT A.CommercialHouseName, 1,DATEADD(HOUR,-5,GETDATE()), @IdUserAction,@IdUserAction
		FROM @LoadCommercialHouse A
		LEFT JOIN TB_CommercialHouses B
		   ON B.Name = A.CommercialHouseName
		WHERE B.IdCommercialHouses IS NULL

		IF @@ROWCOUNT <> 0
          BEGIN
			SET @Flag = 1;
			SET @Message = 'Casa comercial cargada con exito.'
		  END
        ELSE
          BEGIN
            SET @Flag = 0;
            SET @Message = 'Información ya existente, no se realiza cargue.';
		  END

END

GO

