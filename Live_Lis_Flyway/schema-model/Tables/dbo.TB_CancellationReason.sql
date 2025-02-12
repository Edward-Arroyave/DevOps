CREATE TABLE [dbo].[TB_CancellationReason]
(
[IdCancellationReason] [tinyint] NOT NULL IDENTITY(1, 1),
[IdCancellationReasonType] [tinyint] NOT NULL,
[CancellationReason] [varchar] (65) NOT NULL,
[Active] [bit] NULL CONSTRAINT [DF__TB_Cancel__Activ__6F363DDF] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TB_CancellationReason] ADD CONSTRAINT [PK_TB_CancellationReason] PRIMARY KEY CLUSTERED ([IdCancellationReason])
GO
ALTER TABLE [dbo].[TB_CancellationReason] ADD CONSTRAINT [FK_TB_CancellationReason_TB_CancellationReasonType] FOREIGN KEY ([IdCancellationReasonType]) REFERENCES [dbo].[TB_CancellationReasonType] ([IdCancellationReasonType])
GO
