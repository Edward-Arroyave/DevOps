SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/04/2022
-- Description: Procedimiento almacenado para listar tipos de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceType]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdServiceType, ServiceType
	FROM TB_ServiceType
END
GO
