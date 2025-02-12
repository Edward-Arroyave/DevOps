SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 29/03/2022
-- Description: Procedimiento almacenado para retornar detalle de un módulo del menú creado.
-- =============================================
--

/*
declare  @Message varchar (50), @Flag bit
EXEC [dbo].[sp_Detail_Menu_Module] 1 , @Message out, @Flag out
select @Message out, @Flag out
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Menu_Module]
(
	@IdMenu int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
	IF EXISTS (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdMenu)
		BEGIN
			SELECT	A.IdMenu, A.MenuName, A.DescriptionMenu, A.ParentIdMenu, B.MenuName AS ParentMenuName, A.OrderNumber, /*BreadCrumb,*/ 
					A.MenuURL, A.IdMenuIcon, A.Level, /*Component,*/ A.IdProfile, A.PaymentMethod
			FROM TB_Menu A
			LEFT JOIN TB_Menu B
				ON B.IdMenu = A.ParentIdMenu
			WHERE A.IdMenu = @IdMenu

			SET @Message = 'Detail menu module'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Menu module does not exist'
			SET @Flag = 0
		END
END
GO
