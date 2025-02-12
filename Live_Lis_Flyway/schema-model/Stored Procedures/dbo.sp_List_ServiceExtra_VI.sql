SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimientos almacenados para listar extra IV.
-- =============================================
--EXEC [sp_List_ServiceExtra_VI]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceExtra_VI]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceExtra_VI, CONCAT(ServiceExtra_VICode,' ', ServiceExtra_VI) ServiceDescription
	FROM TB_ServiceExtra_VI
END
GO
