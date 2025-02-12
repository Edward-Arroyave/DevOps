CREATE TABLE [POSANT].[TB_EmailClientRoute]
(
[IdEmailClientRoute] [int] NOT NULL IDENTITY(1, 1),
[IdRouteClient] [int] NOT NULL,
[Email] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_EmailClientRoute] ADD CONSTRAINT [PK__TB_Email__7D8BD555BAF2C39F] PRIMARY KEY CLUSTERED ([IdEmailClientRoute])
GO
ALTER TABLE [POSANT].[TB_EmailClientRoute] ADD CONSTRAINT [FK__TB_EmailC__IdRou__7EE295C3] FOREIGN KEY ([IdRouteClient]) REFERENCES [POSANT].[TB_RouteClient] ([IdRouteClient])
GO
