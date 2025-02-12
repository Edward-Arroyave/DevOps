SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimientos almacenados para listar grupos de servicios.
-- =============================================
--EXEC [sp_List_ServiceGroup]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceGroup]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceGroup, ServiceGroupName
	FROM TB_ServiceGroup
	WHERE Active = 'True'
END
GO
