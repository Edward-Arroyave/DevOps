CREATE TABLE [POSANT].[TB_PositivityOrders]
(
[IdPositivityOrders] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[ReviewStatus] [varchar] (50) NULL,
[MedicalAct] [varchar] (50) NULL,
[Management] [varchar] (50) NULL,
[Qualification] [varchar] (50) NULL,
[Observations] [varchar] (500) NULL,
[Contadted] [bit] NULL,
[Scheduled] [bit] NULL,
[VirtualConsultation] [bit] NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
