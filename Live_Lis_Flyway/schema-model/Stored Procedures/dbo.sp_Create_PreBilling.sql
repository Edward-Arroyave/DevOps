SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 23/08/2022
-- Description: Procedimiento almacenado para crear prefactura a entidades.
-- =============================================
/*
DECLARE @IdPreBillingOut varchar(50), @Salida varchar(100), @Bandera varchar(100), @IdContractType int, @Electronic varchar(max) 
EXEC [sp_Create_PreBilling] 1,3,294,1,'2024-05-27','2024-05-27',null,0,'23884,23886,23887,23888,23889,23890,23891,23892,23893,23894,23895,23896,23897,23898,23899,23900,23901,23902,23903,23904,23905,23906,23907,23908,23909,23910,23911,23912,23913,23914,23915,23916,23917,23918,23919,23920,23921,23922,23923,23924,23925,23926,23927,23928,23929,23930,23931,23932,23933,23934,23935,23936,23937,23938,23939,23940,23941,23942,23943,23944,23945,23946,23947,23948,23949,23950,23951,23952,23953,23954,23955,23956,23957,23958,23959,23960,23961,23962,23963,23964,23965,23966,23967,23968,23969,23970,23971,23972,23973,23974,23975,23976,23977,23978,23979,23980,23981,23982,23983,23984,23985,23986,23987,23988,23989,23990,23991,23992,23993,23994,23995,23996,23997,23998,23999,24000,24001,24002,24003,24004,24005,24006,24007,24008,24009,24010,24011,24012,24013,24014,24015,24016,24017,24018,24019,24020,24021,24022,24023,24024,24025,24026,24027,24028,24029,24030,24031,24032,24033,24034,24035,24036,24037,24038,24039,24040,24041,24042,24043,24044,24045,24046,24047,24048,24049,24050,24051,24052,24053,24054,24055,24056,24057,24058,24059,24060,24061,24062,24063,24064,24065,24066,24067,24068,24069,24070,24071,24072,24073,24074,24075,24076,24077,24078,24079,24080,24081,24082,24083,24084,24085,24086,24087,24088,24089,24090,24091,24092,24093,24094,24095,24096,24097,24098,24099,24100,24101,24102,24103,24104,24105,24106,24107,24108,24109,24110,24111,24112,24113,24114,24115,24116,24117,24118,24119,24120,24121,24122,24123,24124,24125,24126,24127,24128,24129,24130,24131,24132,24133,24134,24135,24136,24137,24138,24139,24140,24141,24142,24143,24144,24145,24146,24147,24148,24149,24150,24151,24152,24153,24154,24155,24156,24157,24158,24159,24160,24161,24162,24163,24164,24165,24166,24167,24168,24169,24170,24171,24172,24173,24174,24175,24176,24177,24178,24179,24180,24181,24182,24183,24184,24185,24186,24187,24188,24189,24190,24191,24192,24193,24194,24195,24196,24197,24198,24199,24200,24201,24202,24203,24204,24205,24206,24207,24208,24209,24210,24211,24212,24213,24214,24215,24216,24217,24218,24219,24220,24221',44,@IdPreBillingOut out, @IdContractType out, @Electronic out, @Salida out, @Bandera out
SELECT @IdPreBillingOut, @Salida, @Bandera, @Electronic
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_PreBilling]
(
	@IdAttentionCenter int,
	@IdCompany int,
	@IdContract int,
	@IdServiceType int,
	@InitialDate date,
	@FinalDate date,
	@IdPaymentMethod int = NULL,
	@BillToParticular bit,
	@BillingOfSale varchar(max),
	@IdUserAction int,
	@IdPreBillingOut varchar(max) out,
	@IdContractType tinyint out,
	@Electronic varchar(max) out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdPreBilling int, @IdBillingOfSale int, @Position int, @CountBilling int
	DECLARE @PreBillingOut table (IdPreBilling int)
BEGIN
    SET NOCOUNT ON

	-- Facturación individual
	IF @BillToParticular = 'True'
		BEGIN
			IF @BillingOfSale != ''
				BEGIN
					SET @BillingOfSale = @BillingOfSale + ','

					WHILE PATINDEX('%,%', @BillingOfSale) <> 0
						BEGIN
							SELECT @Position = PATINDEX('%,%', @BillingOfSale)

							SELECT @IdBillingOfSale = LEFT(@BillingOfSale,@Position-1)

							SET @IdBillingOfSale = (SELECT IdBillingOfSale FROM TB_BillingOfSale WHERE IdBillingOfSale = @IdBillingOfSale)
							
							IF EXISTS(SELECT B.IdPreBilling FROM TR_PreBilling_BillingOfSale A 
								INNER JOIN TB_PreBilling B ON B.IdPreBilling = A.IdPreBilling
								INNER JOIN TB_ElectronicBilling C ON C.IdElectronicBilling = B.IdElectronicBilling
								WHERE A.IdBillingOfSale=@IdBillingOfSale AND C.IdInvoiceStatus != 3) 
								BEGIN
									SET @IdPreBilling = (SELECT TOP 1 B.IdPreBilling FROM TR_PreBilling_BillingOfSale A 
															INNER JOIN TB_PreBilling B
																ON B.IdPreBilling = A.IdPreBilling
															INNER JOIN TB_ElectronicBilling C
																ON C.IdElectronicBilling = B.IdElectronicBilling
														WHERE A.IdBillingOfSale=@IdBillingOfSale AND C.IdInvoiceStatus != 3 ORDER BY B.IdPreBilling DESC )

									INSERT INTO @PreBillingOut
									VALUES (@IdPreBilling)

									UPDATE TB_PreBilling SET Active=1 WHERE IdPreBilling=@IdPreBilling;
								END
							ELSE IF EXISTS(SELECT B.IdPreBilling FROM TR_PreBilling_BillingOfSale A 
								INNER JOIN TB_PreBilling B ON B.IdPreBilling = A.IdPreBilling
								WHERE A.IdBillingOfSale=@IdBillingOfSale AND B.IdElectronicBilling IS NULL)
								BEGIN
									SET @IdPreBilling = (SELECT TOP 1 B.IdPreBilling FROM TR_PreBilling_BillingOfSale A INNER JOIN TB_PreBilling B ON B.IdPreBilling = A.IdPreBilling 
															WHERE A.IdBillingOfSale=@IdBillingOfSale AND B.IdElectronicBilling IS NULL ORDER BY B.IdPreBilling DESC )

									INSERT INTO @PreBillingOut
									VALUES (@IdPreBilling)

									UPDATE TB_PreBilling SET Active=1 WHERE IdPreBilling=@IdPreBilling;
								END
							ELSE
								BEGIN 
									INSERT INTO TB_PreBilling (PreBillingDate, IdAttentionCenter, IdCompany, IdContract, IdServiceType, InitialDate, FinalDate, IdPaymentMethod, BillToParticular, Active, CreationDate, IdUserAction)
									VALUES (DATEADD(HOUR,-5,GETDATE()), @IdAttentionCenter, @IdCompany, @IdContract, @IdServiceType, @InitialDate, @FinalDate, @IdPaymentMethod, @BillToParticular, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

									SET @IdPreBilling = SCOPE_IDENTITY()

									INSERT INTO @PreBillingOut
									VALUES (@IdPreBilling)

									INSERT INTO TR_PreBilling_BillingOfSale (IdPreBilling, IdBillingOfSale, Active, CreationDate)
									VALUES (@IdPreBilling, @IdBillingOfSale, 1, DATEADD(HOUR,-5,GETDATE()))
								END

							UPDATE TB_BillingOfSale
								SET PreBilling = 'True'
							WHERE IdBillingOfSale = @IdBillingOfSale

							SET @BillingOfSale = STUFF(@BillingOfSale, 1, @Position, '')
						END
				END

			SET @IdPreBillingOut = (
									SELECT STUFF((
										SELECT ',' + CONVERT(VARCHAR(10),IdPreBilling)
										FROM @PreBillingOut
										FOR XML PATH('')
									),1,1,'') )

			SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
			SET @Message = 'Successfully created pre billing'
			SET @Flag = 1

		END
	-- Facturación agrupada
	ELSE IF @BillToParticular = 'False'
		BEGIN
			-- Validar que no existan prebillings activos
			IF EXISTS(SELECT B.IdPreBilling FROM TR_PreBilling_BillingOfSale A 
							INNER JOIN TB_PreBilling B
								ON B.IdPreBilling = A.IdPreBilling
							INNER JOIN TB_ElectronicBilling C
								ON C.IdElectronicBilling = B.IdElectronicBilling
						WHERE A.IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ',')) AND C.IdInvoiceStatus != 3 )
				BEGIN
					-- CONTAR CUANTOS BILLING ENTRARON
					SET @CountBilling = LEN(@BillingOfSale) - LEN(REPLACE(@BillingOfSale, ',', '')) + 1;

					-- OBTENER PREBILLING
					SET @IdPreBilling = (SELECT TOP 1 B.IdPreBilling FROM TR_PreBilling_BillingOfSale A 
							INNER JOIN TB_PreBilling B
								ON B.IdPreBilling = A.IdPreBilling
							INNER JOIN TB_ElectronicBilling C
								ON C.IdElectronicBilling = B.IdElectronicBilling
						WHERE A.IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ',')) AND C.IdInvoiceStatus != 3)

					-- COMPARAR SI LOS BILLINGS ENTRANTES SON LOS MISMOS QUE LOS QUE SE ENCUENTRAN REGISTRADOS
					IF((SELECT COUNT(B.IdPreBilling) FROM TR_PreBilling_BillingOfSale A 
							INNER JOIN TB_PreBilling B
								ON B.IdPreBilling = A.IdPreBilling
							INNER JOIN TB_ElectronicBilling C
								ON C.IdElectronicBilling = B.IdElectronicBilling
						WHERE A.IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ',')) AND C.IdInvoiceStatus != 3) = @CountBilling)
					BEGIN
					-- SE ACTUALIZAN LOS BILLING PARA QUE NO SE VUELVAN A LISTAR PARA ENVIAR
						UPDATE TB_BillingOfSale
							SET PreBilling = 'True'
						WHERE IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ','))
					END
					ELSE
					BEGIN
						-- SI NO SON LOS MISMOS BILLING ENTRANTES
						-- VALIDAR QUE LOS QUE ENVIARON NO TENGAN FACTURA ELECTRONICA ACTIVA
						IF EXISTS(SELECT B.IdPreBilling FROM TB_PreBilling B INNER JOIN TB_ElectronicBilling A ON A.IdElectronicBilling=B.IdElectronicBilling WHERE B.IdPreBilling = @IdPreBilling AND A.Active = 1 AND A.IdInvoiceStatus != 3)
						BEGIN 
							
							SET @Electronic = (
								SELECT STUFF((
										SELECT ',' + CONVERT(VARCHAR(10),IdBillingOfSale)
										FROM TR_PreBilling_BillingOfSale
										WHERE IdPreBilling=@IdPreBilling
										FOR XML PATH('')
									),1,1,'')
							)

							UPDATE A
							SET A.PreBilling = 'True', A.IdElectronicBilling = C.IdElectronicBilling
							FROM TB_BillingOfSale A
								INNER JOIN TR_PreBilling_BillingOfSale B
									ON A.IdBillingOfSale = B.IdBillingOfSale
								INNER JOIN TB_PreBilling C
									ON B.IdPreBilling = C.IdPreBilling
							WHERE C.IdPreBilling = @IdPreBilling

						END
						ELSE
						BEGIN 
							UPDATE TR_PreBilling_BillingOfSale SET Active=0 WHERE IdPreBilling=@IdPreBilling AND Active=1

							UPDATE TB_PreBilling SET Active=0 WHERE IdPreBilling=@IdPreBilling AND Active=1
							
							SET @IdPreBilling = NULL;
						END
					END
					
				END
			ELSE IF EXISTS(SELECT IdPreBilling FROM TR_PreBilling_BillingOfSale WHERE IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ',')) AND Active=1)
				BEGIN
					-- CONTAR CUANTOS BILLING ENTRARON
					SET @CountBilling = LEN(@BillingOfSale) - LEN(REPLACE(@BillingOfSale, ',', '')) + 1;

					-- OBTENER PREBILLING
					SET @IdPreBilling = (SELECT TOP 1 IdPreBilling FROM TR_PreBilling_BillingOfSale WHERE IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ',')) AND Active=1)

					-- COMPARAR SI LOS BILLINGS ENTRANTES SON LOS MISMOS QUE LOS QUE SE ENCUENTRAN REGISTRADOS
					IF((SELECT COUNT(*) FROM TR_PreBilling_BillingOfSale WHERE IdPreBilling=@IdPreBilling) = @CountBilling)
					BEGIN
					-- SE ACTUALIZAN LOS BILLING PARA QUE NO SE VUELVAN A LISTAR PARA ENVIAR
						UPDATE TB_BillingOfSale
							SET PreBilling = 'True'
						WHERE IdBillingOfSale IN (SELECT value FROM STRING_SPLIT(@BillingOfSale, ','))
					END
					ELSE
					BEGIN
						UPDATE TR_PreBilling_BillingOfSale SET Active=0 WHERE IdPreBilling=@IdPreBilling AND Active=1

						UPDATE TB_PreBilling SET Active=0 WHERE IdPreBilling=@IdPreBilling AND Active=1
							
						SET @IdPreBilling = NULL;
					END
					
				END

			IF @IdPreBilling IS NULL
				BEGIN 
					INSERT INTO TB_PreBilling (PreBillingDate, IdAttentionCenter, IdCompany, IdContract, IdServiceType, InitialDate, FinalDate, IdPaymentMethod, BillToParticular, Active, CreationDate, IdUserAction)
					VALUES (DATEADD(HOUR,-5,GETDATE()), @IdAttentionCenter, @IdCompany, @IdContract, @IdServiceType, @InitialDate, @FinalDate, @IdPaymentMethod, @BillToParticular, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @IdPreBilling = SCOPE_IDENTITY()

					IF @BillingOfSale != ''
						BEGIN
							SET @BillingOfSale = @BillingOfSale + ','

							WHILE PATINDEX('%,%', @BillingOfSale) <> 0
								BEGIN
									SELECT @Position = PATINDEX('%,%', @BillingOfSale)

									SELECT @IdBillingOfSale = LEFT(@BillingOfSale,@Position-1)

									SET @IdBillingOfSale = (SELECT IdBillingOfSale FROM TB_BillingOfSale WHERE IdBillingOfSale = @IdBillingOfSale)

									INSERT INTO TR_PreBilling_BillingOfSale (IdPreBilling, IdBillingOfSale, Active, CreationDate)
									VALUES (@IdPreBilling, @IdBillingOfSale,1, DATEADD(HOUR,-5,GETDATE()))

									UPDATE TB_BillingOfSale
										SET PreBilling = 'True'
									WHERE IdBillingOfSale = @IdBillingOfSale

									SET @BillingOfSale = STUFF(@BillingOfSale, 1, @Position, '')
								END
						END
				END

			IF @Electronic IS NOT NULL
			BEGIN
				SET @Message = 'Existen Billing con factura ya asociada.'
				SET @Flag = 1
			END
			ELSE
			BEGIN
				SET @IdPreBillingOut = @IdPreBilling
				SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
				SET @Message = 'Successfully created pre billing'
				SET @Flag = 1
			END
		END
END
GO
