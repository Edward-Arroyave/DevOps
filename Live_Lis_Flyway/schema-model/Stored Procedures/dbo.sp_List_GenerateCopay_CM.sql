SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/04/2022
-- Description: Procedimiento almacenado para listar genera copago o cuota moderadora.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_GenerateCopay_CM]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdGenerateCopay_CM, GenerateCopay_CM
	FROM TB_GenerateCopay_CM
END
GO
