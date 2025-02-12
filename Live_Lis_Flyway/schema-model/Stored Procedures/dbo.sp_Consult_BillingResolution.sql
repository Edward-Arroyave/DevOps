SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para consultar resoluciones de facturación creadas.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_BillingResolution]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBillingResolution, Number, RegisteredName, NIT, Date, Active
	FROM TB_BillingResolution
END

GO
