SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar los paises.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Country]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdCountry, CountryName
	FROM TB_Country
END

GO
