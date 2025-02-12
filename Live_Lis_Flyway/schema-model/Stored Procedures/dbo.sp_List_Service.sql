SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/04/2022
-- Description: Procedimiento almacenado para listar servicios de acuerdo con el tipo de servicio.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Service]
(
	@IdServiceType int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdService, ServiceName
	FROM TB_Service
	WHERE IdServiceType = @IdServiceType
END
GO
