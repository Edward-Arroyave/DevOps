CREATE TABLE [dbo].[TB_SpecialPermission]
(
[IdSpecialPermission] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdMenu] [smallint] NOT NULL,
[Validate] [bit] NOT NULL,
[Invalidate] [bit] NOT NULL,
[Confirm] [bit] NOT NULL,
[Disconfirm] [bit] NOT NULL,
[Download] [bit] NOT NULL,
[PrintOut] [bit] NOT NULL,
[ConsultResults] [bit] NOT NULL,
[Edit] [bit] NULL CONSTRAINT [DF__TB_Special__Edit__41A47D59] DEFAULT ((0)),
[DeleteHistory] [bit] NULL CONSTRAINT [DF__TB_Specia__Delet__65E1DDCF] DEFAULT ((0)),
[NoMandatorySupport] [bit] NULL CONSTRAINT [DF__TB_Specia__NoMan__491094F7] DEFAULT ((0)),
[AcceptGlosse] [bit] NOT NULL CONSTRAINT [DF__TB_Specia__Accep__0060C9E1] DEFAULT ((0)),
[IdReports] [varchar] (100) NULL,
[ChangeRequest] [bit] NULL CONSTRAINT [DF__TB_Specia__Chang__629B5CD0] DEFAULT ((0)),
[FixedAmount] [bit] NULL CONSTRAINT [DF__TB_Specia__Fixed__638F8109] DEFAULT ((0)),
[CancelInvoice] [bit] NULL CONSTRAINT [DF__TB_Specia__Cance__06D8BD46] DEFAULT ((0)),
[Recalculate] [bit] NULL CONSTRAINT [DF__TB_Specia__Recal__32B73F84] DEFAULT ((0)),
[AuditReports] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TB_SpecialPermission] ADD CONSTRAINT [PK_TB_SpecialPermission_1] PRIMARY KEY CLUSTERED ([IdSpecialPermission])
GO
ALTER TABLE [dbo].[TB_SpecialPermission] ADD CONSTRAINT [FK_TB_SpecialPermission_TB_Menu] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[TB_Menu] ([IdMenu])
GO
ALTER TABLE [dbo].[TB_SpecialPermission] ADD CONSTRAINT [FK_TB_SpecialPermission_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
