CREATE TABLE [Reports].[TB_BillingReport]
(
[FechaFactura] [datetime] NULL,
[FechaRecepcion] [datetime] NULL,
[FechaSolicitud] [datetime] NULL,
[NumeroSolicitud] [varchar] (50) NULL,
[SolicitudExterna] [varchar] (50) NULL,
[IdPaciente] [int] NULL,
[Paciente] [varchar] (255) NULL,
[TipoIdentificacion] [varchar] (50) NULL,
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
[CodigoContratacion] [varchar] (50) NULL
)
GO
CREATE NONCLUSTERED INDEX [idx_TB_BillingReport_FechaSolicitud] ON [Reports].[TB_BillingReport] ([FechaSolicitud])
GO
