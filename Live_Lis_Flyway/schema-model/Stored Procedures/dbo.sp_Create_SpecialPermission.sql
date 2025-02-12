SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/09/2022
-- Description: Procedimiento almacenado para asignar o actualizar permisos especiales del módulo de patologías
-- =============================================
--DECLARE @SpecialPermission SpecialPermission
--INSERT INTO @SpecialPermission (IdUser, IdMenu, Validate, Invalidate, Confirm, Disconfirm, Download, PrintOut, ConsultResults, Edit)
--VALUES (4,134,1,1,1,0,1,0,0), (4,136,0,0,0,0,0,0,1)
--EXEC [sp_Create_SpecialPermission] @SpecialPermission
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_SpecialPermission]
(
	@SpecialPermission SpecialPermission READONLY
)
AS
BEGIN
    SET NOCOUNT ON

	MERGE TB_SpecialPermission AS TARGET
	USING
		(SELECT IdUser, IdMenu, Validate, Invalidate, Confirm, Disconfirm, Download, PrintOut, ConsultResults, Edit, DeleteHistory, AcceptGlosse, NoMandatorySupport, 
				IdReports, ChangeRequest, FixedAmount, CancelInvoice, Recalculate, AuditReports
		FROM @SpecialPermission) SOURCE
	ON TARGET.IdUser = SOURCE.IdUser
		AND TARGET.IdMenu = SOURCE.IdMenu
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdUser, IdMenu, Validate, Invalidate, Confirm, Disconfirm, Download, PrintOut, ConsultResults, Edit, DeleteHistory, AcceptGlosse, NoMandatorySupport, 
				IdReports, ChangeRequest, FixedAmount, CancelInvoice, Recalculate, AuditReports)
		VALUES (
				SOURCE.IdUser,
				SOURCE.IdMenu,
				SOURCE.Validate,
				SOURCE.Invalidate,
				SOURCE.Confirm, 
				SOURCE.Disconfirm, 
				SOURCE.Download, 
				SOURCE.PrintOut, 
				SOURCE.ConsultResults,
				SOURCE.Edit,
				SOURCE.DeleteHistory,
				SOURCE.AcceptGlosse,
				SOURCE.NoMandatorySupport,
				SOURCE.IdReports,
				SOURCE.ChangeRequest,
				SOURCE.FixedAmount,
				SOURCE.CancelInvoice,
				SOURCE.Recalculate,
				SOURCE.AuditReports
				)
	WHEN MATCHED AND TARGET.IdUser = (SELECT TOP 1 IdUser FROM @SpecialPermission)
	THEN
		UPDATE
			SET TARGET.Validate = SOURCE.Validate,
				TARGET.Invalidate = SOURCE.Invalidate,
				TARGET.Confirm = SOURCE.Confirm,
				TARGET.Disconfirm = SOURCE.Disconfirm,
				TARGET.Download = SOURCE.Download,
				TARGET.PrintOut = SOURCE.PrintOut,
				TARGET.ConsultResults = SOURCE.ConsultResults,
				TARGET.Edit = SOURCE.Edit,
				TARGET.DeleteHistory = SOURCE.DeleteHistory,
				TARGET.AcceptGlosse = SOURCE.AcceptGlosse,
				TARGET.NoMandatorySupport = SOURCE.NoMandatorySupport,
				TARGET.IdReports = SOURCE.IdReports,
				TARGET.ChangeRequest = SOURCE.ChangeRequest,
				TARGET.FixedAmount = SOURCE.FixedAmount,
				TARGET.CancelInvoice = SOURCE.CancelInvoice,
				TARGET.Recalculate = SOURCE.Recalculate,
				TARGET.AuditReports = SOURCE.AuditReports;
				
END
GO
