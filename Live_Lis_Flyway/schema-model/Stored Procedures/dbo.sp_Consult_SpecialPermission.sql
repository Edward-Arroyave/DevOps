SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/09/2022
-- Description: Procedimiento almacenado para listar los permisos especiales de patologías asociados a un usuario.
-- =============================================
--EXEC [dbo].[sp_Consult_SpecialPermission] 4
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_SpecialPermission]
(
	@IdUser int,
	@source int
)
AS
BEGIN
    SET NOCOUNT ON

	if @source=1
	begin
		SELECT	A.IdSpecialPermission, A.IdUser, A.IdMenu, B.MenuName, A.Validate, A.Invalidate, A.Confirm, A.Disconfirm, A.Download, A.PrintOut, A.ConsultResults, A.IdReports,
				ChangeRequest, FixedAmount, CancelInvoice, Recalculate, AuditReports
		FROM TB_SpecialPermission A
		INNER JOIN TB_Menu B
			ON B.IdMenu = A.IdMenu
		WHERE A.IdUser = @IdUser
	end
	else
	if @source=2
	begin
		SELECT	A.IdSpecialPermission, A.IdUser, A.IdMenu, B.MenuName, A.Validate, A.Invalidate, A.Confirm, A.Disconfirm, A.Download, A.PrintOut, A.ConsultResults, A.Edit, A.IdReports,
				ChangeRequest, FixedAmount, CancelInvoice, Recalculate, AuditReports
		FROM TB_SpecialPermission A
		INNER JOIN TB_Menu B
			ON B.IdMenu = A.IdMenu
		WHERE A.IdUser = @IdUser
	end
	else
	if @source=3
	begin
		SELECT	A.IdSpecialPermission, A.IdUser, A.IdMenu, B.MenuName, A.Validate, A.Invalidate, A.Confirm, A.Disconfirm, A.Download, A.PrintOut, A.ConsultResults, A.DeleteHistory, A.IdReports,
				ChangeRequest, FixedAmount, CancelInvoice, Recalculate, AuditReports
		FROM TB_SpecialPermission A
		INNER JOIN TB_Menu B
			ON B.IdMenu = A.IdMenu
		WHERE A.IdUser = @IdUser
	end
END
GO
