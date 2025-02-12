SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimientos almacenados para listar categoria de servicios.
-- =============================================
--EXEC [sp_List_ServiceCategory]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceCategory]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceCategory, ServiceCategory
	FROM TB_ServiceCategory
	WHERE Active = 'True'
END
GO
