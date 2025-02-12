SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para listar las entidades o compañías
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Company]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdCompany, CONCAT_WS(' - ', CompanyCode, CompanyName) AS CompanyName
	FROM TB_Company
	WHERE Active = 'True'
END
GO
