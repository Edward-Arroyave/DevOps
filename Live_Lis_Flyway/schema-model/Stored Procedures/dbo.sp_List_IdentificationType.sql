SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar los tipos de identificación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_IdentificationType]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdIdentificationType, CONCAT_WS(' - ', IdentificationTypeCode, IdentificationTypeDesc) IdentificationType
	FROM TB_IdentificationType
END
GO
