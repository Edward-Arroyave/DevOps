CREATE TABLE [TYL].[TB_ClientSample]
(
[IdClientSample] [int] NOT NULL IDENTITY(1, 1),
[IdRegisterClient] [int] NULL,
[IdSampleType] [int] NULL,
[AmountSample] [int] NULL
)
GO
ALTER TABLE [TYL].[TB_ClientSample] ADD CONSTRAINT [PK__TB_Clien__DED6616C5126DECB] PRIMARY KEY CLUSTERED ([IdClientSample])
GO
ALTER TABLE [TYL].[TB_ClientSample] ADD CONSTRAINT [FK_TB_ClientSample_TB_RegisterClient] FOREIGN KEY ([IdRegisterClient]) REFERENCES [TYL].[TB_RegisterClient] ([IdRegisterClient])
GO
