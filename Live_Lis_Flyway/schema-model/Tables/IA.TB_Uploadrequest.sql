CREATE TABLE [IA].[TB_Uploadrequest]
(
[IdUploadrequest] [int] NOT NULL IDENTITY(1, 1),
[IdWorksheet] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[LastName] [varchar] (50) NOT NULL,
[IdentificationNumber] [varchar] (20) NOT NULL,
[IdIdentificationType] [tinyint] NOT NULL,
[Exam] [varchar] (200) NULL,
[Birthdate] [datetime] NULL,
[IdBiologicalSex] [tinyint] NULL,
[Address] [varchar] (200) NULL,
[PhoneNumer] [bigint] NULL,
[Regime] [varchar] (20) NULL,
[RegistrationStatus] [varchar] (15) NULL,
[Age] [int] NULL,
[DateCreate] [datetime] NULL,
[IdRequest] [int] NULL,
[IdExam] [int] NULL,
[IdState] [int] NOT NULL CONSTRAINT [DF__TB_Upload__IdSta__42639768] DEFAULT ((1))
)
GO
ALTER TABLE [IA].[TB_Uploadrequest] ADD CONSTRAINT [PK__TB_Uploa__40365EFBCDC8C30C] PRIMARY KEY CLUSTERED ([IdUploadrequest])
GO
ALTER TABLE [IA].[TB_Uploadrequest] ADD CONSTRAINT [FK_TB_Uploadrequest_TB_BiologicalSex] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [IA].[TB_Uploadrequest] ADD CONSTRAINT [FK_TB_Uploadrequest_TB_IdentificationType] FOREIGN KEY ([IdIdentificationType]) REFERENCES [dbo].[TB_IdentificationType] ([IdIdentificationType])
GO
ALTER TABLE [IA].[TB_Uploadrequest] ADD CONSTRAINT [FK_TB_Uploadrequest_tb_Worksheet] FOREIGN KEY ([IdWorksheet]) REFERENCES [IA].[TB_Worksheet] ([IdWorksheet])
GO
ALTER TABLE [IA].[TB_Uploadrequest] ADD CONSTRAINT [TB_Uploadrequest_TB_State] FOREIGN KEY ([IdState]) REFERENCES [IA].[TB_State] ([IdState])
GO
