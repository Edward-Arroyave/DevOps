SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para listar zona de compañia.
-- =============================================
---EXEC [dbo].[sp_List_CompanyZone]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_CompanyZone]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdCompanyZone, CompanyZone
	FROM TB_CompanyZone
	WHERE Active = 'True'

END
GO
