SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 22/09/2022
-- Description: Procedimiento almacenado para consultar los diagnósticos CIE10
-- =============================================
-- EXEC [sp_Consult_CIE10] 2,'FIEBRE'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_CIE10]
(
	@CIE10Type int,
	@Keyword varchar(50)
)
AS
BEGIN
    SET NOCOUNT ON

	IF @CIE10Type = 1
		BEGIN
			SELECT TOP 1000 IdCIE10_Code3, CIE10_Code3, CIE10_Code3Name, Active
			FROM TB_CIE10_Code3
			WHERE CASE WHEN @Keyword = '' THEN '' ELSE CIE10_Code3Name END LIKE '%'+@Keyword+'%'
				OR CASE WHEN @Keyword = '' THEN '' ELSE CIE10_Code3 END LIKE '%'+@Keyword+'%'
		END
	ELSE IF @CIE10Type = 2
		BEGIN
			SELECT TOP 1000 A.IdCIE10_Code4, A.CIE10_Code4, A.CIE10_Code4Name, B.CIE10_Code3Name, A.Active
			FROM TB_CIE10_Code4 A
			INNER JOIN TB_CIE10_Code3 B
				ON B.IdCIE10_Code3 = A.IdCIE10_Code3
			WHERE CASE WHEN @Keyword = '' THEN '' ELSE CIE10_Code4Name END LIKE '%'+@Keyword+'%'
				OR CASE WHEN @Keyword = '' THEN '' ELSE CIE10_Code4 END LIKE '%'+@Keyword+'%'
		END
END
GO
