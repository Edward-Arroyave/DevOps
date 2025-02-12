SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/05/2022
-- Description: Procedimientos almacenados para listar grupos de servicios nivel 2.
-- =============================================
--EXEC [sp_List_ServiceGroupLevel2]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceGroupLevel2]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceGroupLevel2, ServiceGroupLevel2Name
	FROM TB_ServiceGroupLevel2
	WHERE Active = 'True'
END
GO
