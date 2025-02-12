SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimientos almacenados para listar las descripciones de los servicios.
-- =============================================
--EXEC [sp_List_ServiceDescription]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceDescription]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceDescription, ServiceDescription
	FROM TB_ServiceDescription
END
GO
