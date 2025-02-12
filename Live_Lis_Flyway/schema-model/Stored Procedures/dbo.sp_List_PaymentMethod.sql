SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/07/2022
-- Description: Procedimiento almacenado para consultar los métodos de pago.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_PaymentMethod]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPaymentMethod, PaymentMethodName, Image
	FROM TB_PaymentMethod
	WHERE Active = 'True'
END
GO
