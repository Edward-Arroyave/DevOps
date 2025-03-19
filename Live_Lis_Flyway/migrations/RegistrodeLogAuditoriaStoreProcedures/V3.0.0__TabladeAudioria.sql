

IF not exists (select * from sysobjects where type = 'U' and name = 'TB_StoreProcedureAudit')
	begin
		create table TB_StoreProcedureAudit(
		Id int identity (1,1) primary key not null,
		IdProcedure int null,
		ProcedureName varchar (200)  null,
		ProcedureCode text  null,
		Action varchar (100)  null,
		UserRunning varchar (100)  null,
		IP varchar (30),
		Host varchar (50),
		ExecutionDate datetime  null
		)
	end
