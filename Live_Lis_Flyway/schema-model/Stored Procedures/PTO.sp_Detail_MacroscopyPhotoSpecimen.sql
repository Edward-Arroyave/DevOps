SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/06/2022
-- Description: Procedimiento almacenado para retornar detalle de espécimen fotográfico de macroscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_MacroscopyPhotoSpecimen]
(
	@IdMacroscopyPhotoSpecimen int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdMacroscopyPhotoSpecimen, IdMacroscopy, PhotoSpecimen
	FROM PTO.TB_MacroscopyPhotoSpecimen
	WHERE IdMacroscopyPhotoSpecimen = @IdMacroscopyPhotoSpecimen
END
GO
