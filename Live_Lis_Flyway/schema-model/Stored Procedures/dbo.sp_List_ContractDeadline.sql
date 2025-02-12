SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 24/06/2022
-- Description: Procedimiento almacenado para listar plazos de contrato.
-- =============================================
--EXEC [sp_List_ContractType] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_ContractDeadline]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdContractDeadline, ContractDeadline
	FROM TB_ContractDeadline
END
GO
