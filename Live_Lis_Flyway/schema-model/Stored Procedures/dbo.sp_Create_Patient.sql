SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para crear paciente.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Patient]
(
	@IdPatient int,
    @IdIdentificationType int, 
	@IdentificationNumber varchar(20), 
	@FirstName varchar(60), 
	@SecondName varchar(60)  = NULL, 
	@FirstLastName varchar(60), 
	@SecondLastName varchar(60) = NULL,  
	@IdNationality  int,
	@BirthDate datetime, 
	@IdBiologicalSex int, 
	@IdGenderIdentity int,
	@Pregnancy bit  = NULL,
	@IdCivilStatus int,
	@IdCountry int,
	@IdResidenceCity int = NULL,
	@IdTerritorialZone int,
	@IdNeighborhood int = NULL,
	@IdSocialStratum int,
	@Address varchar(100), 
	@TelephoneNumber varchar(15), 
	@TelephoneNumber2 varchar(15) = NULL, 
	@Email varchar(100), 
	@IdOccupation int, 
	@IdEthnicCommunity int, 
	@IdEthnicity int, 
	@IdDisabilityCategory int,
	@IdHealthProviderEntity int,
	@IdAffiliationType int,
	@DataProcessingPolicy bit,
	@IdUserAction int,
	--@IdPatient_Out int out,
	@Message varchar(80) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF @IdPatient = 0
		BEGIN
			IF NOT EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				BEGIN
					INSERT INTO TB_Patient (IdIdentificationType, IdentificationNumber, BirthDate, FirstName, SecondName, FirstLastName, SecondLastName, IdBiologicalSex, IdGenderIdentity, Pregnancy, Email, TelephoneNumber, TelephoneNumber2, Address, IdCountry, IdCity, IdTerritorialZone, IdNeighborhood, IdSocialStratum, IdHealthProviderEntity, IdAffiliationType, IdCivilStatus, IdNationality, IdOccupation, IdDisabilityCategory, IdEthnicity, IdEthnicCommunity, DataProcessingPolicy, CreationDate, IdUserAction)
					VALUES (@IdIdentificationType, @IdentificationNumber, @BirthDate, @FirstName, @SecondName, @FirstLastName, @SecondLastName, @IdBiologicalSex, @IdGenderIdentity, @Pregnancy, @Email, @TelephoneNumber, @TelephoneNumber2, @Address, @IdCountry, @IdResidenceCity, @IdTerritorialZone, @IdNeighborhood, @IdSocialStratum, @IdHealthProviderEntity, @IdAffiliationType, @IdCivilStatus, @IdNationality, @IdOccupation, @IdDisabilityCategory, @IdEthnicity, @IdEthnicCommunity, @DataProcessingPolicy, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
					
					SET @Message = 'Successfully created patient'
					SET @Flag = 1
					--SET @IdPatient_Out = IDENT_CURRENT('TB_Patient')
				END
			ELSE
				BEGIN
					SET @Message = 'Identification type and Identification number already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			UPDATE TB_Patient
				SET IdIdentificationType = @IdIdentificationType, 
					IdentificationNumber = @IdentificationNumber, 
					BirthDate = @BirthDate, 
					FirstName = @FirstName, 
					SecondName = @SecondName, 
					FirstLastName = @FirstLastName, 
					SecondLastName = @SecondLastName, 
					IdBiologicalSex = @IdBiologicalSex, 
					IdGenderIdentity = @IdGenderIdentity, 
					Pregnancy = @Pregnancy, 
					Email = @Email, 
					TelephoneNumber = @TelephoneNumber, 
					TelephoneNumber2 = @TelephoneNumber2, 
					Address = @Address, 
					IdCountry = @IdCountry, 
					IdCity = @IdResidenceCity, 
					IdTerritorialZone = @IdTerritorialZone, 
					IdNeighborhood = @IdNeighborhood, 
					IdSocialStratum = @IdSocialStratum, 
					IdHealthProviderEntity = @IdHealthProviderEntity, 
					IdAffiliationType = @IdAffiliationType, 
					IdCivilStatus = @IdCivilStatus, 
					IdNationality = @IdNationality, 
					IdOccupation = @IdOccupation, 
					IdDisabilityCategory = @IdDisabilityCategory, 
					IdEthnicity = @IdEthnicity, 
					IdEthnicCommunity = @IdEthnicCommunity, 
					DataProcessingPolicy = @DataProcessingPolicy,
					UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdPatient = @IdPatient

			SET @Message = 'Successfully updated patient'
			SET @Flag = 1
		END
END
GO
