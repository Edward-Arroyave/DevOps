CREATE TABLE [dbo].[TB_Neighborhood]
(
[IdNeighborhood] [smallint] NOT NULL IDENTITY(1, 1),
[NeighborhoodCode] [varchar] (5) NULL,
[Neighborhood] [varchar] (50) NOT NULL,
[IdLocality] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Neighborhood] ADD CONSTRAINT [PK_TB_Neighborhood] PRIMARY KEY CLUSTERED ([IdNeighborhood])
GO
ALTER TABLE [dbo].[TB_Neighborhood] ADD CONSTRAINT [FK_TB_Neighborhood_TB_Locality] FOREIGN KEY ([IdLocality]) REFERENCES [dbo].[TB_Locality] ([IdLocality])
GO
