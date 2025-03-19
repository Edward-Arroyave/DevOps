/****** Object:  StoredProcedure [dbo].[sp_LoadSection]    Script Date: 19/02/2025 12:03:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de sección.
-- =============================================
/*
DECLARE @LoadSection LoadSection, @Message varchar(50), @Flag bit
INSERT INTO @LoadSection (SectionName)
VALUES 
('Prueba1'),
('Dato 1')
EXEC [sp_LoadSection] @LoadSection,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadSection]
(
	@LoadSection LoadSection READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	
		SELECT DISTINCT A.SectionName, 1 Active,DATEADD(HOUR,-5,GETDATE()) CreationDate, @IdUserAction IdUserAction
		FROM @LoadSection A
		INNER JOIN TB_Section B
		   ON B.SectionName = A.SectionName


		INSERT INTO TB_Section(SectionName, Active, CreationDate, IdUserAction)
		SELECT DISTINCT A.SectionName, 1,DATEADD(HOUR,-5,GETDATE()), @IdUserAction 
		FROM @LoadSection A
		LEFT JOIN TB_Section B
		   ON B.SectionName = A.SectionName
		WHERE B.IdSection IS NULL

		IF @@ROWCOUNT <> 0
        BEGIN
			SET @Flag = 1;
			SET @Message = 'Sección cargada con exito.'
		        END
        ELSE
        BEGIN
            SET @Flag = 0;
            SET @Message = 'Información ya existente, no se realiza cargue.';
		END


END
GO

