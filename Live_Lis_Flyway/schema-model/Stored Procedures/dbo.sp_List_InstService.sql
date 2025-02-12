SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/04/2022
-- Description: Procedimiento almacenado para listar servicios con código institucional de acuerdo con el servicio CUPS.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_InstService]
(
	@IdService int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdInstService, InstServiceName
	FROM TB_Institutional_Service
	WHERE IdService = @IdService
END
GO
