CREATE TABLE [dbo].[TB_PreRequestStatus]
(
[IdPreRequestStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[PreRequestStatus] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PreRequestStatus] ADD CONSTRAINT [PK_TB_PreRequestStatus] PRIMARY KEY CLUSTERED ([IdPreRequestStatus])
GO
