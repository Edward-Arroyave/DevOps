SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para listar EPS.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_EPSCompany]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdCompany, CONCAT(CompanyCode,': ', CompanyName) CompanyName
	FROM TB_Company
	WHERE Active = 'True'
		AND IdEconomicActivity = 1

END
GO
