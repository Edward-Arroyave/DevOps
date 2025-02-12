CREATE TABLE [IA].[TB_Worksheet]
(
[IdWorksheet] [int] NOT NULL IDENTITY(1, 1),
[CodeLoad] [nvarchar] (20) NOT NULL,
[DateLoad] [datetime] NOT NULL,
[DateUpdate] [datetime] NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdContract] [int] NOT NULL,
[PatientAmount] [int] NOT NULL,
[ExamAmount] [int] NOT NULL,
[IdState] [int] NOT NULL,
[IdUser] [int] NOT NULL,
[Url] [varchar] (max) NULL
)
GO
ALTER TABLE [IA].[TB_Worksheet] ADD CONSTRAINT [PK__TB_Works__221768B003EB7104] PRIMARY KEY CLUSTERED ([IdWorksheet])
GO
ALTER TABLE [IA].[TB_Worksheet] ADD CONSTRAINT [FK_TB_Worksheet_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [IA].[TB_Worksheet] ADD CONSTRAINT [FK_TB_Worksheet_TB_contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [IA].[TB_Worksheet] ADD CONSTRAINT [FK_TB_Worksheet_TB_State] FOREIGN KEY ([IdState]) REFERENCES [IA].[TB_State] ([IdState])
GO
ALTER TABLE [IA].[TB_Worksheet] ADD CONSTRAINT [FK_TB_Worksheet_TB_user] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
