CREATE TABLE [dbo].[TB_PackageTransport]
(
[IdPackageTransport] [int] NOT NULL IDENTITY(1, 1),
[IdRequest] [int] NOT NULL,
[Transporter] [varchar] (100) NULL,
[GuideNumber] [varchar] (30) NULL,
[Fridgereference] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_PackageTransport] ADD CONSTRAINT [PK_TB_PackageTransport] PRIMARY KEY CLUSTERED ([IdPackageTransport])
GO
ALTER TABLE [dbo].[TB_PackageTransport] ADD CONSTRAINT [FK_TB_PackageTransport_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
