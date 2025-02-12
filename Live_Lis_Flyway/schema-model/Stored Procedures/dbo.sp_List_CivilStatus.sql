SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para listar estado civil.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_CivilStatus]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdCivilStatus, CONCAT(CivilStatusCode,': ', CivilStatus) CivilStatus
	FROM TB_CivilStatus
END
GO
