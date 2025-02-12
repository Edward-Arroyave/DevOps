CREATE TABLE [dbo].[TR_TariffScheme_Service]
(
[IdTariffSchemeService] [int] NOT NULL IDENTITY(1, 1),
[IdTariffScheme] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdService] [int] NULL,
[IdExam] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [decimal] (10, 2) NULL,
[Value_UVR] [decimal] (5, 2) NULL,
[InitialVigenceDate] [date] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Hiring] [varchar] (10) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Update_Ingress] 
   ON  [dbo].[TR_TariffScheme_Service]
   AFTER UPDATE
AS 
	DECLARE @IdTariffScheme int, @Aux int = 1, @IdContract int
	DECLARE @Contracts table (Id int identity, IdContract int)
BEGIN
	SET NOCOUNT ON;

	SET @IdTariffScheme = (SELECT DISTINCT IdTariffScheme FROM inserted)
	
	INSERT INTO @Contracts (IdContract)
	SELECT IdContract 
	FROM TB_Contract 
	WHERE IdTariffScheme = @IdTariffScheme

	IF UPDATE (Value)-- OR UPDATE(IdGenerateCopay_CM) OR UPDATE(Value_UVR)
		BEGIN
		--SELECT * FROM inserted
		--SELECT * FROM TR_TariffScheme_Service_Tmp
			
			IF (SELECT DISTINCT InitialVigenceDate FROM inserted) IS NOT NULL
				BEGIN
					IF (SELECT DISTINCT InitialVigenceDate FROM inserted) < DATEADD(HOUR,-5,GETDATE())
						BEGIN
							WHILE @Aux <= (SELECT MAX(Id) FROM @Contracts)
								BEGIN
									SET @IdContract = (SELECT IdContract FROM @Contracts WHERE Id = @Aux)
									
									UPDATE B
										SET B.Value = D.Value
									FROM TB_Request A
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_Contract C
										ON C.IdContract = A.IdContract
									INNER JOIN TR_TariffScheme_Service D
										ON ISNULL(D.IdTariffScheme,0) = ISNULL(C.IdTariffScheme,0)
											AND ISNULL(D.IdService,0) = ISNULL(B.IdService,0)
											AND ISNULL(D.IdExam,0) = ISNULL(B.IdExam,0)
											AND ISNULL(D.IdExamGroup,0) = ISNULL(B.IdExamGroup,0)
									INNER JOIN TR_BillingOfSale_Request E
										ON E.IdRequest = A.IdRequest
									INNER JOIN TB_BillingOfSale F
										ON F.IdBillingOfSale = E.IdBillingOfSale
									WHERE A.IdContract = @IdContract
										AND A.RequestDate >= D.InitialVigenceDate
										AND F.IdElectronicBilling IS NULL

									UPDATE A	
										SET TotalValueCompany = B.TotalValueCompany
									FROM TR_BillingOfSale_Request A
									INNER JOIN TB_BillingOfSale C
										ON C.IdBillingOfSale = A.IdBillingOfSale
									INNER JOIN (
												SELECT A.IdRequest, SUM(D.Value) TotalValueCompany
												FROM TB_Request A
												INNER JOIN TR_Request_Exam B
													ON B.IdRequest = A.IdRequest
												INNER JOIN TB_Contract C
													ON C.IdContract = A.IdContract
												INNER JOIN TR_TariffScheme_Service D
													ON ISNULL(D.IdTariffScheme,0) = ISNULL(C.IdTariffScheme,0)
														AND ISNULL(D.IdService,0) = ISNULL(B.IdService,0)
														AND ISNULL(D.IdExam,0) = ISNULL(B.IdExam,0)
														AND ISNULL(D.IdExamGroup,0) = ISNULL(B.IdExamGroup,0)
												WHERE A.IdContract = @IdContract
													AND A.RequestDate >= C.InitialValidityTariffServDate
												GROUP BY A.IdRequest
												) B
										ON B.IdRequest = A.IdRequest
									WHERE C.IdElectronicBilling IS NULL

									UPDATE A	
										SET TotalValueCompany =  B.TotalValueCompany
									FROM TB_BillingOfSale A
									INNER JOIN (
												SELECT B.IdBillingOfSale, SUM(B.TotalValueCompany) AS TotalValueCompany
												FROM TB_Request A
												INNER JOIN TR_BillingOfSale_Request B
													ON B.IdRequest = A.IdRequest
												INNER JOIN TB_Contract C
													ON C.IdContract = A.IdContract
												WHERE A.IdContract = 1
													AND A.RequestDate >= C.InitialValidityTariffServDate
												GROUP BY B.IdBillingOfSale
												) B
										ON B.IdBillingOfSale = A.IdBillingOfSale
									WHERE A.IdElectronicBilling IS NULL

									SET @Aux = @Aux + 1
								END 
						END
				END
		END
END
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [PK_TR_TariffScheme_Service] PRIMARY KEY CLUSTERED ([IdTariffSchemeService])
GO
CREATE NONCLUSTERED INDEX [Active_IdTariffScheme_IdTypeOfProcedure] ON [dbo].[TR_TariffScheme_Service] ([Active], [IdTariffScheme], [IdTypeOfProcedure]) INCLUDE ([Hiring], [IdExam], [IdExamGroup], [IdService], [Value], [Value_UVR])
GO
CREATE NONCLUSTERED INDEX [IDX_TR_TariffScheme_Service_AII] ON [dbo].[TR_TariffScheme_Service] ([Active], [IdTariffScheme], [IdTypeOfProcedure]) INCLUDE ([Hiring], [IdExam], [IdExamGroup], [IdService], [Value], [Value_UVR])
GO
CREATE NONCLUSTERED INDEX [IdTariffScheme_IdExam_IdExamGroup] ON [dbo].[TR_TariffScheme_Service] ([IdTariffScheme], [IdExam], [IdExamGroup]) INCLUDE ([Hiring], [IdService], [IdTypeOfProcedure], [Value])
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [FK_TR_TariffScheme_Service_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [FK_TR_TariffScheme_Service_TB_Service] FOREIGN KEY ([IdService]) REFERENCES [dbo].[TB_Service] ([IdService])
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [FK_TR_TariffScheme_Service_TB_TariffScheme] FOREIGN KEY ([IdTariffScheme]) REFERENCES [dbo].[TB_TariffScheme] ([IdTariffScheme])
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [FK_TR_TariffScheme_Service_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service] ADD CONSTRAINT [FK_TR_TariffScheme_Service_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
