CREATE TABLE [RYS].[HistorySampleTracking]
(
[IdHistorySampleTracking] [int] NOT NULL IDENTITY(1, 1),
[IDSampleTracking] [int] NULL,
[Id_Section] [int] NULL,
[Id_AttentionCenter] [int] NULL,
[CreationDate] [datetime] NULL,
[Id_User] [int] NULL,
[Active] [bit] NULL CONSTRAINT [DF__HistorySa__Activ__5C587395] DEFAULT ((1)),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__HistorySa__Updat__5D4C97CE] DEFAULT (dateadd(hour,(-5),getdate())),
[IdArea] [int] NULL,
[Internal] [bit] NULL CONSTRAINT [DF__HistorySa__Inter__6B9AB725] DEFAULT ((0)),
[LabelCode] [varchar] (20) NULL
)
GO
ALTER TABLE [RYS].[HistorySampleTracking] ADD CONSTRAINT [PK__HistoryS__0A3676CFBA49A4EB] PRIMARY KEY CLUSTERED ([IdHistorySampleTracking])
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [RYS].[HistorySampleTracking] ([UpdateDate]) INCLUDE ([IDSampleTracking], [Id_Section], [Id_AttentionCenter], [CreationDate], [Id_User], [Active], [IdArea], [Internal], [LabelCode])
GO
ALTER TABLE [RYS].[HistorySampleTracking] ADD CONSTRAINT [FK_HistorySampleTracking_TB_SampleTracking] FOREIGN KEY ([IDSampleTracking]) REFERENCES [RYS].[SampleTracking] ([IDSampleTracking])
GO
