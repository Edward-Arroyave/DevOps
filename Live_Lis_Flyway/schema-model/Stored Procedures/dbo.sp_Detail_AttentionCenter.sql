SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para listar los datos de un centro de atención.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_AttentionCenter]
(
	@IdAttentionCenter int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdAttentionCenter FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
		BEGIN
			SELECT A.IdAttentionCenter, A.AttentionCenterCode, A.AuthorizationCode, A.AttentionCenterName, A.IdBillingResolution, A.IdDetailBillingResolution, A.InitialNumber, A.FinalNumber, B.IdDepartment, A.IdCity, A.Address, A.TelephoneNumber, A.Active
			FROM TB_AttentionCenter A
			LEFT JOIN TB_City B
				ON B.IdCity = A.IdCity
			WHERE IdAttentionCenter = @IdAttentionCenter

			SET @Message = 'Attention Center found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Attention Center does not exists'
			SET @Flag = 0
		END
END
GO
