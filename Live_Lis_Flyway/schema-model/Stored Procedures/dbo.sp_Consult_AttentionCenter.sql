SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para listar los centros de atención creados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_AttentionCenter]
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdAttentionCenter, A.AttentionCenterCode, A.AttentionCenterName, A.Address, B.CityName, A.Active
	FROM TB_AttentionCenter A
	LEFT JOIN TB_City B
		ON B.IdCity = A.IdCity
END
GO
