CREATE TABLE [GLO].[TB_Reason]
(
[IdReason] [int] NOT NULL IDENTITY(1, 1),
[NameReason] [varchar] (100) NULL
)
GO
ALTER TABLE [GLO].[TB_Reason] ADD CONSTRAINT [PK__TB_Reaso__AA09D6955AED78E7] PRIMARY KEY CLUSTERED ([IdReason])
GO
