SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar sexo biologico.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_BiologicalSex]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBiologicalSex, CONCAT(BiologicalSexCode,': ', BiologicalSex) BiologicalSex
	FROM TB_BiologicalSex
END
GO
