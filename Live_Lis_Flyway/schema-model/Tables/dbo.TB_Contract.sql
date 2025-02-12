CREATE TABLE [dbo].[TB_Contract]
(
[IdContract] [int] NOT NULL IDENTITY(1, 1),
[ContractCode] [varchar] (100) NOT NULL,
[ContractNumber] [int] NULL,
[ContractName] [varchar] (100) NOT NULL,
[IdContractType] [tinyint] NULL,
[IdCompany] [int] NOT NULL,
[IdTariffScheme] [int] NOT NULL,
[InitialValidityTariffServDate] [date] NULL,
[IdContractAmountType] [tinyint] NULL,
[ContractAmount] [bigint] NULL,
[ContractBalance] [bigint] NULL,
[PositiveBalance] [decimal] (20, 2) NULL,
[PatientAmount] [decimal] (20, 2) NULL,
[CustomerBalance] [decimal] (20, 2) NULL,
[InitialValidity] [datetime] NOT NULL,
[ExpirationDate] [datetime] NOT NULL,
[IdSellerCode] [int] NULL,
[IdContractDeadline] [tinyint] NULL,
[IdGenerateCopay_CM] [tinyint] NULL,
[BillToParticular] [bit] NULL,
[FileClinicHistory] [bit] NULL,
[FileAuthorization] [bit] NOT NULL,
[FileMedicalOrder] [bit] NOT NULL,
[RequirementsForAttention] [varchar] (150) NULL,
[IdAdditionalForm] [int] NULL,
[IdQuoteValidity] [tinyint] NULL,
[ElectronicUser] [varchar] (100) NULL,
[IdPaymentMethod] [tinyint] NULL,
[IdBillingGroup] [int] NULL,
[InitialPaymentDay] [int] NULL,
[FinalPaymentDay] [int] NULL,
[IdCommercialTeam] [tinyint] NULL,
[AttentPreRequisite] [bit] NULL,
[AttentionPreRequisite] [varchar] (max) NULL,
[BillRequirement] [bit] NULL,
[BillingRequirements] [varchar] (max) NULL,
[IdBusinessUnit] [tinyint] NULL,
[AccountingAccount] [varchar] (20) NULL,
[UpdateReason] [varchar] (max) NULL,
[WhoAuthorized] [varchar] (255) NULL,
[IdAttentionModel] [tinyint] NULL,
[IdContractOdoo] [int] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[SeparationOfServices] [bit] NULL,
[IdCity] [int] NULL,
[FilingAddress] [varchar] (200) NULL,
[IdQuoteForm] [int] NULL,
[ApplyDiscount] [bit] NOT NULL CONSTRAINT [DF__TB_Contra__Apply__51FAE0B3] DEFAULT ((0))
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_UpdateContract_Ingress] 
   ON  [dbo].[TB_Contract]
   AFTER UPDATE
AS 
	DECLARE @IdContract int, @IdTariffSchemeOld int, @IdTariffScheme int
BEGIN
	SET NOCOUNT ON;

	SET @IdContract = (SELECT IdContract FROM inserted)
	SET @IdTariffSchemeOld = (SELECT DISTINCT IdTariffScheme FROM deleted)
	SET @IdTariffScheme = (SELECT DISTINCT IdTariffScheme FROM inserted)

	IF UPDATE (IdTariffScheme)-- OR UPDATE(IdGenerateCopay_CM) OR UPDATE(Value_UVR)
		BEGIN
			IF @IdTariffSchemeOld <> @IdTariffScheme
				BEGIN	
					IF (SELECT InitialValidityTariffServDate FROM inserted) IS NOT NULL
						BEGIN
							IF (SELECT InitialValidityTariffServDate FROM inserted) < DATEADD(HOUR,-5,GETDATE())
								BEGIN
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
									INNER JOIN TR_BillingOfSale_Request E
										ON E.IdRequest = A.IdRequest
									INNER JOIN TB_BillingOfSale F
										ON F.IdBillingOfSale = E.IdBillingOfSale
									WHERE A.IdContract = @IdContract
										AND A.RequestDate >= C.InitialValidityTariffServDate
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
								END
						END
				END
		END
END
GO
DISABLE TRIGGER [dbo].[TG_UpdateContract_Ingress] ON [dbo].[TB_Contract]
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [PK_TB_Contract] PRIMARY KEY CLUSTERED ([IdContract])
GO
CREATE NONCLUSTERED INDEX [TB_Contract_Active_IdCompany] ON [dbo].[TB_Contract] ([Active], [IdCompany]) INCLUDE ([BillToParticular], [ContractAmount], [ContractBalance], [ContractCode], [ContractName], [ExpirationDate], [FileAuthorization], [FileClinicHistory], [FileMedicalOrder], [IdAdditionalForm], [IdContractType], [IdGenerateCopay_CM], [IdQuoteForm], [InitialValidity], [RequirementsForAttention], [SeparationOfServices])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_AdditionalForm] FOREIGN KEY ([IdAdditionalForm]) REFERENCES [dbo].[TB_AdditionalForm] ([IdAdditionalForm])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_AttentionModel] FOREIGN KEY ([IdAttentionModel]) REFERENCES [dbo].[TB_AttentionModel] ([IdAttentionModel])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_BillingGroup] FOREIGN KEY ([IdBillingGroup]) REFERENCES [dbo].[TB_BillingGroup] ([IdBillingGroup])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_BusinessUnit] FOREIGN KEY ([IdBusinessUnit]) REFERENCES [dbo].[TB_BusinessUnit] ([IdBusinessUnit])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_tb_contract_TB_City] FOREIGN KEY ([IdCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_ContractAmountType] FOREIGN KEY ([IdContractAmountType]) REFERENCES [dbo].[TB_ContractAmountType] ([IdContractAmountType])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_ContractDeadline] FOREIGN KEY ([IdContractDeadline]) REFERENCES [dbo].[TB_ContractDeadline] ([IdContractDeadline])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_ContractType] FOREIGN KEY ([IdContractType]) REFERENCES [dbo].[TB_ContractType] ([IdContractType])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_GenerateCopay_CM] FOREIGN KEY ([IdGenerateCopay_CM]) REFERENCES [dbo].[TB_GenerateCopay_CM] ([IdGenerateCopay_CM])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_QuoteValidity] FOREIGN KEY ([IdQuoteValidity]) REFERENCES [dbo].[TB_QuoteValidity] ([IdQuoteValidity])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_TariffScheme] FOREIGN KEY ([IdTariffScheme]) REFERENCES [dbo].[TB_TariffScheme] ([IdTariffScheme])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Contract] ADD CONSTRAINT [FK_TB_Contract_TB_UserSeller] FOREIGN KEY ([IdSellerCode]) REFERENCES [dbo].[TB_SellerCode] ([IdSellerCode])
GO
