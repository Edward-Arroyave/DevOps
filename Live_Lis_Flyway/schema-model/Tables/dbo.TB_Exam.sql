CREATE TABLE [dbo].[TB_Exam]
(
[IdExam] [int] NOT NULL IDENTITY(1, 1),
[GroupType] [bit] NULL,
[IdTypeOfProcedure] [tinyint] NULL,
[ExamCode] [varchar] (10) NULL,
[ExamName] [varchar] (500) NULL,
[LevelOfComplexity] [int] NULL,
[IdExamType] [tinyint] NULL,
[IdSection] [smallint] NULL,
[IdBiologicalSex] [tinyint] NULL,
[MinAge] [int] NULL,
[MaxAge] [int] NULL,
[IdAgeTimeUnit] [tinyint] NULL,
[Priority] [bit] NULL,
[AmbientTemperature] [varchar] (15) NULL,
[RefrigeratedTemperture] [varchar] (15) NULL,
[FrozenTemperature] [varchar] (15) NULL,
[SampleConditions] [varchar] (255) NULL,
[IdExamTechnique] [int] NULL,
[DeliveryOpportunity] [varchar] (20) NULL,
[ControlOpportunity] [varchar] (20) NULL,
[IdUnitOfMeasurement] [tinyint] NULL,
[ResultsFormula] [varchar] (50) NULL,
[Comment] [varchar] (max) NULL,
[VisibleResult] [bit] NULL,
[Decimal] [int] NULL,
[Monday] [bit] NULL,
[Tuesday] [bit] NULL,
[Wednesday] [bit] NULL,
[Thursday] [bit] NULL,
[Friday] [bit] NULL,
[Saturday] [bit] NULL,
[Sunday] [bit] NULL,
[Confidential] [bit] NULL,
[PreparationOrObservation] [varchar] (max) NULL,
[ClinicalImportance] [varchar] (max) NULL,
[OtherObservations] [varchar] (max) NULL,
[TestComponents] [varchar] (255) NULL,
[PBS] [bit] NULL,
[SOATCode] [varchar] (12) NULL,
[EpidemiologicalNotification] [bit] NULL,
[TakingFrequency] [int] NULL,
[IdTimeUnit] [tinyint] NULL,
[IdAdditionalForm] [int] NULL,
[PaternityAccreditation] [bit] NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[TemplateUpdateSchedule] [datetime] NULL,
[IdTemplate] [int] NULL,
[Score] [int] NULL,
[PlanValidity] [int] NULL,
[IdValidityFormat] [tinyint] NULL,
[ActiveValidity] [bit] NULL,
[Title] [bit] NULL CONSTRAINT [DF__TB_Exam__Title__29D7E0C0] DEFAULT ((0)),
[ExamTitle] [varchar] (200) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_EXAM_PERMITS]
ON [dbo].[TB_Exam]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ID_SECTION INT
    DECLARE @ID_USER INT 
    DECLARE @ID_EXAM INT 
    DECLARE @WATCH BIT 
    DECLARE @EDIT BIT 
    DECLARE @CREATE BIT 
    DECLARE @DELETE BIT 
    DECLARE @FIRST_VALIDATE BIT 
    DECLARE @SECOND_VALIDATE BIT 
    DECLARE @INVALIDATE BIT 
    DECLARE @INVALIDATE_BLOCK_INDIVI BIT 
    DECLARE @INVALIDATE_BLOCK_UNIQUE BIT 
    DECLARE @INVALIDATE_BLOCK_WITHOUT BIT 
    DECLARE @FIRST_VALIDATE_BLOCK BIT 
    DECLARE @SECOND_VALIDATE_BLOCK BIT 



    SELECT @ID_SECTION = IdSection, @ID_EXAM = IdExam FROM inserted
    
    DECLARE curUsers CURSOR FOR
        SELECT IdUser
        FROM ANT.TB_ConfExamSectionPermits
        WHERE IdSection = @ID_SECTION AND PermitType = 'SECTION'

    OPEN curUsers
    FETCH NEXT FROM curUsers INTO @ID_USER

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT 
            @WATCH = Watch, 
            @EDIT = Edit, 
            @CREATE = Creat, 
            @DELETE = Delet, 
            @FIRST_VALIDATE = FirstValidate, 
            @SECOND_VALIDATE = SecondValidate,
            @INVALIDATE = Invalidate,
            @INVALIDATE_BLOCK_INDIVI = InvalidateBlockIndividualReason, 
            @INVALIDATE_BLOCK_UNIQUE = InvalidateBlockUniqueReason, 
            @INVALIDATE_BLOCK_WITHOUT = InvalidateBlockWithoutReason,
	    @FIRST_VALIDATE_BLOCK = FirstValidateBlock,
	    @SECOND_VALIDATE_BLOCK = SecondValidateBlock
        FROM ANT.TB_ConfExamSectionPermits 
        WHERE IdSection = @ID_SECTION AND IdUser = @ID_USER AND PermitType = 'SECTION'

        INSERT INTO [ANT].[TB_ConfExamSectionPermits]
        (
            [IdUser],
            [IdSection],
            [IdExam],
            [Watch],
            [Edit],
            [Creat],
            [Delet],
            [FirstValidate],
            [SecondValidate],
            [Invalidate],
            [InvalidateBlockIndividualReason],
            [InvalidateBlockUniqueReason],
            [InvalidateBlockWithoutReason],
	    [FirstValidateBlock],
	    [SecondValidateBlock],
            [PermitType]
        )
        VALUES
        (
            @ID_USER,
            @ID_SECTION,
            @ID_EXAM,
            @WATCH,
            @EDIT,
            @CREATE,
            @DELETE,
            @FIRST_VALIDATE,
            @SECOND_VALIDATE,
            @INVALIDATE,
            @INVALIDATE_BLOCK_INDIVI,
            @INVALIDATE_BLOCK_UNIQUE,
            @INVALIDATE_BLOCK_WITHOUT,
            @FIRST_VALIDATE_BLOCK,
	    @SECOND_VALIDATE_BLOCK,
            'EXAM'
        )

        FETCH NEXT FROM curUsers INTO @ID_USER
    END

    CLOSE curUsers
    DEALLOCATE curUsers
END
GO
ALTER TABLE [dbo].[TB_Exam] ADD CONSTRAINT [PK_TB_Exam_1] PRIMARY KEY CLUSTERED ([IdExam])
GO
CREATE NONCLUSTERED INDEX [IDX_Exam] ON [dbo].[TB_Exam] ([IdExam], [Active])
GO
ALTER TABLE [dbo].[TB_Exam] ADD CONSTRAINT [FK_TB_Exam_TB_Template] FOREIGN KEY ([IdTemplate]) REFERENCES [dbo].[TB_Template] ([IdTemplate])
GO
