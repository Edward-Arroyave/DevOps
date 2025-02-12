SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnS_GetAge] (@InitialDate DATETIME, @FinalDate DATETIME)
RETURNS VARCHAR(255)
AS
BEGIN

	DECLARE @DfMin BIGINT, @Year INT, @Month INT, @Days INT, @Hours INT, @Minutes INT, @Seconds INT, @Result INT, @Final_Result VARCHAR(255)
	
	SET @DfMin= DATEDIFF(DAY,@InitialDate+0.5, @FinalDate)
	SET @Year = @DfMin/365
	SET @Result = @DfMin%365
	SET @Month = @Result/43800
	SET @Result = @Result%43800
	SET @Days = @Result/1440
	SET @Result = @Result %1440
	SET @Hours = @Result /60
	SET @Result = @Result%60
	SET @Minutes = @Result
	

	SET @Final_Result= CONVERT(varchar(10),@Year)+' Año(s), ' +CONVERT(VARCHAR(10),@Month)+' Mes(es), '+CONVERT(varchar(10),@Days)+' Día(s)'
	
	RETURN @Final_Result

END
GO
