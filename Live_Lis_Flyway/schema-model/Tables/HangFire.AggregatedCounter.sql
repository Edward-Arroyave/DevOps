CREATE TABLE [HangFire].[AggregatedCounter]
(
[Key] [nvarchar] (100) NOT NULL,
[Value] [bigint] NOT NULL,
[ExpireAt] [datetime] NULL
)
GO
ALTER TABLE [HangFire].[AggregatedCounter] ADD CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED ([Key])
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_AggregatedCounter_ExpireAt] ON [HangFire].[AggregatedCounter] ([ExpireAt]) WHERE ([ExpireAt] IS NOT NULL)
GO
