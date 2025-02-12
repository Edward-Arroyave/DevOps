SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/08/2022
-- Description: Procedimiento almacenado para listar responsabilidades fiscales-
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_FiscalResponsibility]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdFiscalResponsibility, FiscalResponsibilityCode, FiscalResponsibility
	FROM TB_FiscalResponsibility
END
GO
