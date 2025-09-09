USE [Automatica]
GO

drop table RV_TBL_SIP_LICENCIAS_GENERADAS

CREATE TABLE [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [uniqueidentifier] NULL,
	[Tipo] [nvarchar](50) NULL,
	[Licencia] [nvarchar](max) NULL,
	[Estado] [nvarchar](100) NULL,
	[Request] [nvarchar](max) NULL,
	[Fecha] [datetime] NULL,
	[Response] [nvarchar](max) NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_RV_TBL_SIP_LICENCIAS_GENERADAS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


SET IDENTITY_INSERT [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS] ON;

INSERT INTO [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS] (ID, GroupID, Tipo, Licencia, Estado, Request, Fecha, Response, FechaModificacion)
SELECT 
    ID, GroupID, Tipo, Licencia, Estado, Request, Fecha, Response, FechaModificacion
FROM
    [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS_BK];

SET IDENTITY_INSERT [dbo].[RV_TBL_SIP_LICENCIAS_GENERADAS] OFF;




select * from RV_TBL_SIP_LICENCIAS_GENERADAS


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RV_TBL_SIP_LOG_MENSAJE]') AND type in (N'U'))
DROP TABLE [dbo].[RV_TBL_SIP_LOG_MENSAJE]
GO


CREATE TABLE [dbo].[RV_TBL_SIP_LOG_MENSAJE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](10) NULL,
	[Detalle] [varchar](250) NULL,
	[DetalleUsuario] [varchar](250) NULL,
	[TipoLog] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SET IDENTITY_INSERT [dbo].[RV_TBL_SIP_LOG_MENSAJE] ON;

INSERT INTO [dbo].[RV_TBL_SIP_LOG_MENSAJE] (ID, Codigo, Detalle, DetalleUsuario, TipoLog)
SELECT 
    ID, Codigo, Detalle, DetalleUsuario, TipoLog
FROM
    [dbo].[RV_TBL_SIP_LOG_MENSAJE_BK];

SET IDENTITY_INSERT [dbo].[RV_TBL_SIP_LOG_MENSAJE] OFF;
