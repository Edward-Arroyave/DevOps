CREATE TYPE [dbo].[UserContract] AS TABLE
(
[IdContract] [int] NOT NULL,
[WaitingResult] [bit] NOT NULL,
[PartialResult] [bit] NOT NULL,
[FinishedResult] [bit] NOT NULL
)
GO
