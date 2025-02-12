SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/04/2023
-- Description: Parametrización de configuración 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_ManualBalancing]
(
	@Active bit
)
AS
BEGIN
    SET NOCOUNT ON

	UPDATE TB_Business
		SET ManualBalancing = @Active
END
GO
