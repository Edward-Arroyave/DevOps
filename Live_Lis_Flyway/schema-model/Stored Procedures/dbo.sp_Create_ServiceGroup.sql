SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para crear grupos de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ServiceGroup]
(
	@ServiceGroupLevel int,
	@IdServiceGroup int,
	@ServiceGroupCode varchar(10) = NULL,
	@ServiceGroupName varchar(800),
	@IdServiceGroupMain int = NULL,
	@IdUserAction int,
	@Message varchar(50) out, 
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @ServiceGroupLevel = 1
		BEGIN
			IF @IdServiceGroup = 0
				BEGIN
					IF NOT EXISTS (SELECT IdServiceGroup FROM TB_ServiceGroup WHERE ServiceGroupCode = @ServiceGroupCode AND ServiceGroupName = @ServiceGroupName)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupCode FROM TB_ServiceGroup WHERE ServiceGroupCode = @ServiceGroupCode)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupName FROM TB_ServiceGroup WHERE ServiceGroupName = @ServiceGroupName)
										BEGIN
											SET @ServiceGroupCode = (SELECT COUNT(ServiceGroupCode) FROM TB_ServiceGroup) + 1

											INSERT INTO TB_ServiceGroup (ServiceGroupCode, ServiceGroupName, CreationDate, IdUserAction, Active)
											VALUES (@ServiceGroupCode, @ServiceGroupName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

											SET @Message = 'Successfully created service group'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group code and name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT ServiceGroupName FROM TB_ServiceGroup WHERE ServiceGroupCode = @ServiceGroupCode AND ServiceGroupName = @ServiceGroupName AND IdServiceGroup != @IdServiceGroup)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupName FROM TB_ServiceGroup WHERE ServiceGroupCode = @ServiceGroupCode AND IdServiceGroup != @IdServiceGroup)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupName FROM TB_ServiceGroup WHERE ServiceGroupName = @ServiceGroupName AND IdServiceGroup != @IdServiceGroup)
										BEGIN
											UPDATE TB_ServiceGroup
												SET ServiceGroupCode = @ServiceGroupCode,
													ServiceGroupName = @ServiceGroupName,
													UpdateDate = DATEADD(HOUR,-5,GETDATE()),
													IdUserAction = @IdUserAction
											WHERE IdServiceGroup = @IdServiceGroup
											
											SET @Message = 'Successfully updated service group'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group code and name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group name already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE IF @ServiceGroupLevel = 2			
		BEGIN
			IF @IdServiceGroup = 0
				BEGIN
					IF NOT EXISTS (SELECT ServiceGroupLevel2Name FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Code = @ServiceGroupCode AND  ServiceGroupLevel2Name = @ServiceGroupName)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupLevel2Code FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Code = @ServiceGroupCode)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupLevel2Name FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Name = @ServiceGroupName)
										BEGIN
											INSERT INTO TB_ServiceGroupLevel2 (ServiceGroupLevel2Code, ServiceGroupLevel2Name, IdServiceGroup, CreationDate, IdUserAction, Active)
											VALUES (@ServiceGroupCode, @ServiceGroupName, @IdServiceGroupMain, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)
											
											SET @Message = 'Successfully created service group level 2'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group level 2 name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group level 2 code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group level 2 name and code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT ServiceGroupLevel2Name FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Code = @ServiceGroupCode AND ServiceGroupLevel2Name = @ServiceGroupName AND IdServiceGroupLevel2 != @IdServiceGroup)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupLevel2Name FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Code = @ServiceGroupCode AND IdServiceGroupLevel2 != @IdServiceGroup)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupLevel2Name FROM TB_ServiceGroupLevel2 WHERE ServiceGroupLevel2Name = @ServiceGroupName AND IdServiceGroupLevel2 != @IdServiceGroup)
										BEGIN 
											UPDATE TB_ServiceGroupLevel2
												SET ServiceGroupLevel2Code = @ServiceGroupCode,
													ServiceGroupLevel2Name = @ServiceGroupName,
													IdServiceGroup = @IdServiceGroupMain,
													UpdateDate = DATEADD(HOUR,-5,GETDATE()),
													IdUserAction = @IdUserAction
											WHERE IdServiceGroupLevel2 = @IdServiceGroup

											SET @Message = 'Successfully updated service group level 2'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group level 2 name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group level 2 code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group level 2 code and name already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE IF @ServiceGroupLevel = 3
		BEGIN
			IF @IdServiceGroup = 0
				BEGIN
					IF NOT EXISTS (SELECT ServiceGroupLevel3Name FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Code = @ServiceGroupCode AND ServiceGroupLevel3Name = @ServiceGroupName)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupLevel3Code FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Code = @ServiceGroupCode)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupLevel3Name FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Name = @ServiceGroupName)
										BEGIN
											INSERT INTO TB_ServiceGroupLevel3 (ServiceGroupLevel3Code, ServiceGroupLevel3Name, IdServiceGroupLevel2, CreationDate, IdUserAction, Active)
											VALUES (@ServiceGroupCode, @ServiceGroupName, @IdServiceGroupMain, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

											SET @Message = 'Successfully created service group level 3'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group level 3 code and name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group level 3 code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group level 3 name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT ServiceGroupLevel3Name FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Code = @ServiceGroupCode AND ServiceGroupLevel3Name = @ServiceGroupName AND IdServiceGroupLevel3 != @IdServiceGroup)
						BEGIN
							IF NOT EXISTS (SELECT ServiceGroupLevel3Code FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Code = @ServiceGroupCode AND IdServiceGroupLevel3 != @IdServiceGroup)
								BEGIN
									IF NOT EXISTS (SELECT ServiceGroupLevel3Name FROM TB_ServiceGroupLevel3 WHERE ServiceGroupLevel3Name = @ServiceGroupName AND IdServiceGroupLevel3 != @IdServiceGroup)
										BEGIN
											UPDATE TB_ServiceGroupLevel3
												SET ServiceGroupLevel3Code = @ServiceGroupCode,
													ServiceGroupLevel3Name = @ServiceGroupName,
													IdServiceGroupLevel2 = @IdServiceGroupMain,
													UpdateDate = DATEADD(HOUR,-5,GETDATE()),
													IdUserAction = @IdUserAction
											WHERE IdServiceGroupLevel3 = @IdServiceGroup

											SET @Message = 'Successfully updated service group level 3' 
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Service group level 3 code and name already exists'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Service group level 3 code already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Service group level 3 name already exists'
							SET @Flag = 0
						END
				END
		END
END
GO
