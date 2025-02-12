SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para consultar grupos de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ServiceGroup]
(
    @ServiceGroupLevel int
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF @ServiceGroupLevel = 1
		BEGIN
			SELECT IdServiceGroup, ServiceGroupCode, ServiceGroupName, Active
			FROM TB_ServiceGroup
		END
	ELSE IF @ServiceGroupLevel = 2
		BEGIN
			SELECT A.IdServiceGroupLevel2, A.ServiceGroupLevel2Code, A.ServiceGroupLevel2Name, B.ServiceGroupName, A.Active
			FROM TB_ServiceGroupLevel2 A
			INNER JOIN TB_ServiceGroup B
				ON B.IdServiceGroup = A.IdServiceGroup
		END
	ELSE IF @ServiceGroupLevel = 3
		BEGIN
			SELECT A.IdServiceGroupLevel3, A.ServiceGroupLevel3Code, A.ServiceGroupLevel3Name, B.ServiceGroupLevel2Name, A.Active
			FROM TB_ServiceGroupLevel3 A
			INNER JOIN TB_ServiceGroupLevel2 B
				ON B.IdServiceGroupLevel2 = A.IdServiceGroupLevel2
		END
END
GO
