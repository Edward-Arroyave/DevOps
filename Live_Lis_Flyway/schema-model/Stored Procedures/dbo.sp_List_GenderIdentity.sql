SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar entidad de genero.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_GenderIdentity]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdGenderIdentity, CONCAT(GenderIdentityCode,': ', GenderIdentity) GenderIdentity
	FROM TB_GenderIdentity
END
GO
