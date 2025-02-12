SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para consultar servicios.
-- =============================================
-- EXEC [sp_Consult_Service]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Service]
AS
BEGIN
    SET NOCOUNT ON

    SELECT A.IdService, A.CUPS, A.ServiceName, B.ServiceDescription, C.ServiceSubCategory, A.Active
	FROM TB_Service A
	INNER JOIN TB_ServiceDescription B
		ON B.IdServiceDescription = A.IdServiceDescription
	LEFT JOIN TB_ServiceSubCategory C
		ON C.IdServiceSubCategory = A.IdServiceSubCategory
END
GO
