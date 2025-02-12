SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar comunidad etnica.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_EthnicCommunity]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdEthnicCommunity, CONCAT(EthnicCommunityCode,': ', EthnicCommunity) EthnicCommunity
	FROM TB_EthnicCommunity
	WHERE Active = 'True'

END
GO
