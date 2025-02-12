SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para consultar servicios.
-- =============================================
-- EXEC [sp_Consult_Company]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Company]
AS
BEGIN
    SET NOCOUNT ON

    SELECT A.IdCompany, A.CompanyCode, A.CompanyName, B.EconomicActivityName, A.Active
	FROM TB_Company A
	LEFT JOIN TB_EconomicActivity B
		ON B.IdEconomicActivity = A.IdEconomicActivity
END
GO
