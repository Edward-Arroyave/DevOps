CREATE TYPE [dbo].[SpecialPermission] AS TABLE
(
[IdUser] [int] NULL,
[IdMenu] [int] NULL,
[Validate] [bit] NULL,
[Invalidate] [bit] NULL,
[Confirm] [bit] NULL,
[Disconfirm] [bit] NULL,
[Download] [bit] NULL,
[PrintOut] [bit] NULL,
[ConsultResults] [bit] NULL,
[Edit] [bit] NULL,
[DeleteHistory] [bit] NULL,
[AcceptGlosse] [bit] NULL,
[NoMandatorySupport] [bit] NULL,
[IdReports] [varchar] (100) NULL,
[ChangeRequest] [bit] NULL,
[FixedAmount] [bit] NULL,
[CancelInvoice] [bit] NULL,
[Recalculate] [bit] NULL,
[AuditReports] [varchar] (100) NULL
)
GO
