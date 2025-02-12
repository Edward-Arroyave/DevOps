CREATE TABLE [dbo].[TB_RefValueChangeStatus]
(
[IdRefValueChangeStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[RefValueChangeStatus] [varchar] (10) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_RefValueChangeStatus] ADD CONSTRAINT [PK_TB_RefValueChangeStatus] PRIMARY KEY CLUSTERED ([IdRefValueChangeStatus])
GO
