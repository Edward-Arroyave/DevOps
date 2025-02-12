SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado que retorna información de una resolución de facturación para editar.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_BillingResolution]
(
	@IdBillingResolution int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBillingResolution, Number, RegisteredName, NIT, Address, Date
	FROM TB_BillingResolution
	WHERE IdBillingResolution = @IdBillingResolution
END
GO
