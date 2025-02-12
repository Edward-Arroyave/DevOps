SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/04/2022
-- Description: Procedimiento almacenado para consultar tipo de esquemas tarifarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_TariffSchemeType]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdTariffSchemeType, TariffSchemeTypeName, Active
	FROM TB_TariffSchemeType
END
GO
