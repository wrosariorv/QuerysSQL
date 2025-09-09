CREATE TABLE [dbo].[RVF_TBL_API_VENTAS_WEB](
	
	
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CanalEntrada][nvarchar](50) NOT NULL,
	[NumeroOC][nvarchar](100) NOT NULL,
	[NumeroDocumento][nvarchar](20) NOT NULL,
	--------------------------------------
	[Nombre][nvarchar](100) NOT NULL,
	[Domicilio][nvarchar](100) NOT NULL,
	[Ciudad][nvarchar](100) NOT NULL,
	[Provincia][nvarchar](100) NOT NULL,
	[CodigoPostal][nvarchar](10) NOT NULL,
	[CodigoProvincia][nvarchar](100) NOT NULL,
	---------------------------------------------
	[Entrega_Nombre][nvarchar](100) NOT NULL,
	[Entrega_domicilio1][nvarchar](100) NOT NULL,
	[Entrega_domicilio2][nvarchar](100)  NULL,
	[Entrega_domicilio3][nvarchar](100) NULL,
	[Entrega_Ciudad][nvarchar](100)NOT NULL,
	[Entrega_Provincia][nvarchar](100) NOT NULL,
	[Entrega_CP][nvarchar](10) NOT NULL,
	[Entrega_Documento][nvarchar](20) NOT NULL,
	--------------------------------------------
	[Comentario][nvarchar](100) NULL,
	[FechaVEnta][Datetime] NOT Null,
	[Linea][INT] NOT Null,
	[CodigoProducto][nvarchar](100) NOT NULL,
	[Cantidad][int] NOT null,
	[PrecioUnitario]Decimal (20,9) NOT null,
	[RequierFactura][Bit]  NOT Null,
	[CostoEnvio]Decimal (20,9) NOT Null,
	----------------------------------------------
	[Company][nvarchar](16) NULL,
	[ProyectID] [nvarchar](100)  NULL,
	[FechaAltaOV][Datetime] Null,
	[Estado][nvarchar](100) NOT NULL,
	[NumeroOV][nvarchar](100) NULL,
	[CustNum][nvarchar](16) NULL,
	[Integrado][bit] null
	

PRIMARY KEY CLUSTERED 
(

	[id] ASC,
	[CanalEntrada] ASC,
	[NumeroOC]ASC,
	[NumeroDocumento]ASC






)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO