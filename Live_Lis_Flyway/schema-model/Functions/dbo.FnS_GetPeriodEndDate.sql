SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnS_GetPeriodEndDate] (@Fecha datetime)  
RETURNS datetime  
AS  
  
  
BEGIN  
DECLARE @Texto varchar(50)  
SET @Texto=convert(varchar,datepart(yy,@Fecha))+'/'+convert(varchar,datepart(mm,@Fecha))+'/01'
SET @Fecha=convert(datetime,@Texto)  
  
SET @Fecha=DATEADD(SS,-1,DATEADD(MM,1,@Fecha))  
  
RETURN @Fecha  
END
GO
