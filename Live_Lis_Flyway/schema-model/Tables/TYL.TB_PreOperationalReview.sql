CREATE TABLE [TYL].[TB_PreOperationalReview]
(
[IdPreOperationalReview] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[Post] [varchar] (30) NOT NULL,
[Area] [varchar] (30) NOT NULL,
[IdAttentionCenter] [smallint] NOT NULL,
[Plate] [varchar] (6) NOT NULL,
[Mileage] [bigint] NOT NULL,
[ValidDrivingLicense] [tinyint] NOT NULL,
[TrafficLicense] [tinyint] NOT NULL,
[CurrentSoat] [tinyint] NOT NULL,
[CurrentTechnomechanicalReview] [tinyint] NOT NULL,
[Whistle] [tinyint] NOT NULL,
[Directional] [tinyint] NOT NULL,
[MainLights] [tinyint] NOT NULL,
[StopLights] [tinyint] NOT NULL,
[Dashboard] [tinyint] NOT NULL,
[LateralMirrors] [tinyint] NOT NULL,
[BrakeAndClutch] [tinyint] NOT NULL,
[Tires] [tinyint] NOT NULL,
[Liquids] [tinyint] NOT NULL,
[Helmet] [tinyint] NOT NULL,
[Vest] [tinyint] NOT NULL,
[Gloves] [tinyint] NOT NULL,
[SecurityBoots] [tinyint] NOT NULL,
[OthersElements] [varchar] (500) NOT NULL,
[Obs] [varchar] (max) NULL,
[IdUserRoute] [int] NOT NULL
)
GO
ALTER TABLE [TYL].[TB_PreOperationalReview] ADD CONSTRAINT [PK__TB_PreOp__0C24481F82A1FF8A] PRIMARY KEY CLUSTERED ([IdPreOperationalReview])
GO
ALTER TABLE [TYL].[TB_PreOperationalReview] ADD CONSTRAINT [FK_TB_PreOperationalReview_TB_AttentionCenter] FOREIGN KEY ([IdAttentionCenter]) REFERENCES [dbo].[TB_AttentionCenter] ([IdAttentionCenter])
GO
ALTER TABLE [TYL].[TB_PreOperationalReview] ADD CONSTRAINT [FK_TB_PreOperationalReview_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
