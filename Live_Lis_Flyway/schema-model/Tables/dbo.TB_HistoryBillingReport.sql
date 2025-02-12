CREATE TABLE [dbo].[TB_HistoryBillingReport]
(
[IdCompany] [int] NULL,
[IdContract] [int] NULL,
[IdRequest_Exam] [int] NULL,
[IdBillingOfSale_Request] [int] NULL,
[NIT] [varchar] (50) NULL,
[ANO] [int] NULL,
[MES] [int] NULL,
[DIA] [int] NULL,
[FechaFactura] [datetime] NULL,
[FechaRecepcion] [datetime] NULL,
[FechaSolicitud] [datetime] NULL,
[NumeroSolicitud] [varchar] (50) NULL,
[SolicitudExterna] [varchar] (50) NULL,
[Paciente] [varchar] (255) NULL,
[Identificacion] [varchar] (50) NULL,
[NumeroIdentificacion] [varchar] (50) NULL,
[CodigoExamen] [varchar] (50) NULL,
[NombreExamen] [varchar] (255) NULL,
[CUPS] [varchar] (50) NULL,
[NumeroFactura] [varchar] (50) NULL,
[Valor] [decimal] (18, 2) NULL,
[Copago] [decimal] (18, 2) NULL,
[CM] [decimal] (18, 2) NULL,
[CodigoPlan] [varchar] (50) NULL,
[NombrePlan] [varchar] (255) NULL,
[Tercero] [varchar] (255) NULL,
[EstadoSolicitud] [varchar] (50) NULL,
[EstadoFactura] [varchar] (50) NULL,
[Sede] [varchar] (255) NULL,
[FormaDePago] [varchar] (50) NULL,
[GrupoFacturacion] [varchar] (50) NULL,
[CodigoContratacion] [varchar] (10) NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_TB_HistoryBillingReport_FechaFactura] ON [dbo].[TB_HistoryBillingReport] ([FechaFactura])
GO
CREATE NONCLUSTERED INDEX [IX_TB_HistoryBillingReport_FechaSolicitud] ON [dbo].[TB_HistoryBillingReport] ([FechaSolicitud])
GO
CREATE NONCLUSTERED INDEX [IX_TB_HistoryBillingReport_IdCompany_IdContract] ON [dbo].[TB_HistoryBillingReport] ([IdCompany], [IdContract])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_HistoryBillingReport_Unique] ON [dbo].[TB_HistoryBillingReport] ([NumeroSolicitud], [CodigoExamen], [IdRequest_Exam], [IdBillingOfSale_Request])
GO
