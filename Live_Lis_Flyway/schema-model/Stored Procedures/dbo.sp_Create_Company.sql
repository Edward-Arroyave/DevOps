SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2021
-- Description: Procedimiento almacenado para crear compañías o entidades.
-- =============================================

-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Company]
(
	@IdCompany int,
	@CompanyCode varchar(20),
	@CompanyName varchar(120),
	@IdEconomicActivity int = NULL,
	@NIT varchar(12) = NULL,
	@VerificationDigit varchar(1) = NULL, 
	@Address varchar(100) = NULL,
	@TelephoneNumber varchar(30) = NULL,
	@Email varchar(100) = NULL,
	@CreditQuota varchar(20) = NULL,
	@CreditBalance varchar(20) = NULL,
	@IdCommercialZone int = NULL,
	@IdCity int = NULL,
	@PortfolioContact varchar(120) = NULL,
	@PortfolioContactTelephoneNumber varchar(15) = NULL,
	@PolicyNumber varchar(20) = NULL,
	@BillingContact varchar(100) = NULL,
	@FiscalResponsibility varchar(100) = NULL,
	@ValidateCreditQuota bit = NULL,
	@AttentPreRequisite bit,
	@AttentionPreRequisite varchar(max) = NULL,
	@BillRequirement bit,
	@BillingRequirements varchar(max) = NULL, 
	@IdCompanySegment int = NULL, 
	@IdCompanySubSegment int = NULL, 
	@IdMarketGroup int = NULL, 
	@TelephoneNumberQuality varchar(20) = NULL, 
	@CompanyIntranet bit = NULL, 
	@IdUserAction int,
	@IdIdentificationType int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdFiscalResponsibility int, @Position int
	DECLARE @TableFiscalResponsibility table(IdCompany int, IdFiscalResponsibility int, Active bit, DateAction datetime, IdUserAction int)
BEGIN
	IF @IdCompany = 0
		BEGIN
			IF NOT EXISTS (SELECT IdCompany FROM TB_Company WHERE CompanyCode = @CompanyCode AND CompanyName = @CompanyName)
				BEGIN
					IF NOT EXISTS (SELECT CompanyCode FROM TB_Company WHERE CompanyCode =  @CompanyCode)
						BEGIN
							IF NOT EXISTS (SELECT CompanyName FROM TB_Company WHERE CompanyName = @CompanyName)
								BEGIN
									IF NOT EXISTS (SELECT IdCompany FROM TB_Company WHERE NIT = @NIT)
										BEGIN
											INSERT INTO TB_Company (CompanyCode, CompanyName, IdEconomicActivity, IdIdentificationType, NIT, VerificationDigit, Address, TelephoneNumber, Email, CreditQuota, CreditBalance, IdCommercialZone, IdCity, PortfolioContact, PortfolioContactTelephoneNumber, PolicyNumber, BillingContact, ValidateCreditQuota, AttentPreRequisite, AttentionPreRequisite, BillRequirement, BillingRequirements, IdCompanySegment, IdCompanySubSegment, IdMarketGroup, TelephoneNumberQuality, CompanyIntranet, CreationDate, IdUserAction, Active)
											VALUES (@CompanyCode, @CompanyName, @IdEconomicActivity, @IdIdentificationType, @NIT, @VerificationDigit, @Address, @TelephoneNumber, @Email, @CreditQuota, @CreditBalance, @IdCommercialZone, @IdCity, @PortfolioContact, @PortfolioContactTelephoneNumber, @PolicyNumber, @BillingContact, @ValidateCreditQuota, @AttentPreRequisite, @AttentionPreRequisite, @BillRequirement, @BillingRequirements, @IdCompanySegment, @IdCompanySubSegment, @IdMarketGroup, @TelephoneNumberQuality, @CompanyIntranet, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

											SET @IdCompany = SCOPE_IDENTITY()

											IF (@FiscalResponsibility != '')
												BEGIN
													SET @FiscalResponsibility = @FiscalResponsibility + ','
													
													WHILE PATINDEX('%,%', @FiscalResponsibility) <> 0
														BEGIN
															SELECT @Position = PATINDEX('%,%', @FiscalResponsibility)
															SELECT @IdFiscalResponsibility = LEFT(@FiscalResponsibility, @Position -1)
															SET @IdFiscalResponsibility = (SELECT IdFiscalResponsibility FROM TB_FiscalResponsibility WHERE IdFiscalResponsibility = @IdFiscalResponsibility)

															INSERT INTO TR_Company_FiscalResponsibility (IdCompany, IdFiscalResponsibility, Active, CreationDate, IdUserAction)
															VALUES (@IdCompany, @IdFiscalResponsibility, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

															SELECT @FiscalResponsibility = STUFF(@FiscalResponsibility, 1, @Position, '')
														END
												END

											SET @Message = 'Successfully created company'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'NIT of the company already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Company name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Company code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Company code and name already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT CompanyCode FROM TB_Company WHERE CompanyCode = @CompanyCode AND IdCompany != @IdCompany)
				BEGIN
					IF NOT EXISTS (SELECT CompanyName FROM TB_Company WHERE CompanyName = @CompanyName AND IdCompany != @IdCompany)
						BEGIN
							IF NOT EXISTS (SELECT NIT FROM TB_Company WHERE NIT = @NIT AND IdCompany != @IdCompany)
								BEGIN
									UPDATE TB_Company
										SET CompanyCode = @CompanyCode,								
											CompanyName = @CompanyName,
											IdEconomicActivity = @IdEconomicActivity,
											NIT = @NIT,
											VerificationDigit = @VerificationDigit,
											Address = @Address,
											TelephoneNumber = @TelephoneNumber, 
											Email = @Email,
											CreditQuota = @CreditQuota, 
											CreditBalance = @CreditBalance,
											IdCommercialZone = @IdCommercialZone,
											IdCity = @IdCity,
											PortfolioContact = @PortfolioContact,
											PortfolioContactTelephoneNumber = @PortfolioContactTelephoneNumber,
											PolicyNumber = @PolicyNumber,
											BillingContact = @BillingContact,
											ValidateCreditQuota = @ValidateCreditQuota,
											AttentPreRequisite = @AttentPreRequisite,
											AttentionPreRequisite = @AttentionPreRequisite,
											BillRequirement = @BillRequirement,
											BillingRequirements = @BillingRequirements,
											IdCompanySegment = @IdCompanySegment,
											IdCompanySubSegment = @IdCompanySubSegment,
											IdMarketGroup = @IdMarketGroup,
											TelephoneNumberQuality = @TelephoneNumberQuality,
											CompanyIntranet = @CompanyIntranet,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											IdIdentificationType = @IdIdentificationType
									WHERE IdCompany = @IdCompany

									IF (@FiscalResponsibility != '')
										BEGIN
											SET @FiscalResponsibility = @FiscalResponsibility + ','
											
											WHILE PATINDEX('%,%', @FiscalResponsibility) <> 0
												BEGIN
													SELECT @Position = PATINDEX('%,%', @FiscalResponsibility)
													SELECT @IdFiscalResponsibility = LEFT(@FiscalResponsibility, @Position -1)
													SET @IdFiscalResponsibility = (SELECT IdFiscalResponsibility FROM TB_FiscalResponsibility WHERE IdFiscalResponsibility = @IdFiscalResponsibility)

													INSERT INTO @TableFiscalResponsibility (IdCompany, IdFiscalResponsibility, Active, DateAction, IdUserAction)
													--(SELECT IdCompany, @IdFiscalResponsibility, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction FROM TR_Company_FiscalResponsibility WHERE IdCompany = @IdCompany)
													VALUES (@IdCompany, @IdFiscalResponsibility, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

													SELECT @FiscalResponsibility = STUFF(@FiscalResponsibility, 1, @Position, '')

												END

												MERGE TR_Company_FiscalResponsibility AS TARGET
												USING @TableFiscalResponsibility SOURCE
													ON TARGET.IdCompany = SOURCE.IdCompany
														AND TARGET.IdFiscalResponsibility = SOURCE.IdFiscalResponsibility
												WHEN NOT MATCHED BY TARGET
												THEN
													INSERT (IdCompany, IdFiscalResponsibility, Active, CreationDate, IdUserAction)
													VALUES
														(
														SOURCE.IdCompany,
														SOURCE.IdFiscalResponsibility,
														SOURCE.Active,
														SOURCE.DateAction,
														SOURCE.IdUserAction
														)
												WHEN NOT MATCHED BY SOURCE AND TARGET.IdCompany = @IdCompany AND TARGET.Active = 1
													THEN
														UPDATE 
															SET TARGET.Active = 0,
																TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
																TARGET.IdUserAction = @IdUserAction
												WHEN MATCHED AND TARGET.Active = 0
													THEN
														UPDATE
															SET TARGET.Active = 1,
																TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
																TARGET.IdUserAction = @IdUserAction;
											END
										ELSE
											BEGIN
												UPDATE TR_Company_FiscalResponsibility
													SET Active = 0,
														UpdateDate = DATEADD(HOUR,-5,GETDATE()),
														IdUserAction = @IdUserAction
													WHERE IdCompany = @IdCompany 
											END

									SET @Message = 'Successfully updated company'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'NIT of the company already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Company name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Company code already exists'
					SET @Flag = 0
				END
		END
END
GO
