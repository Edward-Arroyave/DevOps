SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimientos almacenados para listar subcategoria de servicios.
-- =============================================
--EXEC [sp_List_ServiceSubCategory]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceSubCategory]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceSubCategory, ServiceSubCategory
	FROM TB_ServiceSubCategory
	WHERE Active = 'True'
END
GO
