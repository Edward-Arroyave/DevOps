CREATE TABLE [dbo].[TB_DoctorOffice]
(
[IdDoctorOffice] [int] NOT NULL IDENTITY(1, 1),
[DoctorOfficeCode] [varchar] (5) NOT NULL,
[DoctorOfficeName] [varchar] (50) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[IdLocationDoctorOffice] [tinyint] NOT NULL,
[FaceToFace] [bit] NOT NULL,
[Virtual] [bit] NOT NULL,
[Available] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DoctorOffice] ADD CONSTRAINT [PK_TB_DoctorOffice] PRIMARY KEY CLUSTERED ([IdDoctorOffice])
GO
ALTER TABLE [dbo].[TB_DoctorOffice] ADD CONSTRAINT [FK_TR_DoctorOffice_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [dbo].[TB_DoctorOffice] ADD CONSTRAINT [FK_TR_DoctorOffice_TB_LocationDoctorOffice] FOREIGN KEY ([IdLocationDoctorOffice]) REFERENCES [dbo].[TB_LocationDoctorOffice] ([IdLocationDoctorOffice])
GO
ALTER TABLE [dbo].[TB_DoctorOffice] ADD CONSTRAINT [FK_TR_DoctorOffice_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
