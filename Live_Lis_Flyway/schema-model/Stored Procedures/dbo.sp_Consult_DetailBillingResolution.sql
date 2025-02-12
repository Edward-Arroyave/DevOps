SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para consultar detalle de resoluciones de facturación creadas.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_DetailBillingResolution]
(
	@IdBillingResolution int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdDetailBillingResolution, B.RegisteredName, A.DetailName, A.Prefix, A.Consecutive, A.Active, C.EconomicActivityName, A.PrefixCN
	FROM TB_DetailBillingResolution A
	INNER JOIN TB_BillingResolution B
		ON B.IdBillingResolution = A.IdBillingResolution
	INNER JOIN TB_EconomicActivity C 
		ON A.IdEconomicActivity = C.IdEconomicActivity
	WHERE A.IdBillingResolution = @IdBillingResolution
		AND A.Active = 'True'
END
GO
