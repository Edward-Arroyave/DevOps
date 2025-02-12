SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimientos almacenados para listar grupos de servicios nivel 3.
-- =============================================
--EXEC [sp_List_ServiceGroupLevel3] ''
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ServiceGroupLevel3]
(
	@Keyword varchar(50)
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdServiceGroupLevel3, CONCAT( ServiceGroupLevel3Code, ' ', ServiceGroupLevel3Name) ServiceGroupLevel3Name
	FROM TB_ServiceGroupLevel3
	WHERE (ServiceGroupLevel3Name LIKE '%'+ @Keyword +'%'
			OR ServiceGroupLevel3Code LIKE '%'+ @Keyword +'%')
		AND Active = 'True'
END
GO
