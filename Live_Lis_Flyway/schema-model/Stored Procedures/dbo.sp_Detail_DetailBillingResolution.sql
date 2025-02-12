SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado que retorna información del detalle de resolución de facturación para editar.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_DetailBillingResolution]
(
	@IdDetailBillingResolution int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdDetailBillingResolution, A.IdBillingResolution, B.RegisteredName, A.DetailName, A.Prefix, A.PrefixCN, A.Consecutive, A.InitialNumber, A.FinalNumber, A.InitialDate, A.FinalDate, A.IdEconomicActivity, C.EconomicActivityName, A.ResolutionText
	FROM TB_DetailBillingResolution A
	INNER JOIN TB_BillingResolution B
		ON B.IdBillingResolution = A.IdBillingResolution
	INNER JOIN TB_EconomicActivity C
		ON C.IdEconomicActivity = A.IdEconomicActivity
	WHERE A.IdDetailBillingResolution = @IdDetailBillingResolution
END
GO
