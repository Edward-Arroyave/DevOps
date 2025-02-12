SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para listar grupo de facturación.
-- =============================================
-- EXEC [dbo].[sp_List_BillingGroup]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_BillingGroup]
AS
BEGIN
    SET NOCOUNT ON

    SELECT IdBillingGroup, BillingGroup
	FROM TB_BillingGroup
	WHERE Active = 'True'
END
GO
