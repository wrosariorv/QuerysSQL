use Multivende


CREATE TABLE [dbo].[RVF_TBL_API_LOG](
	[ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Proceso] [nvarchar](100) NOT NULL,
	[JsonRequest] [nvarchar](max) NULL,
	[JsonResponse] [nvarchar](max) NULL,
 CONSTRAINT [PK_RVF_TBL_API_LOG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO
-----------------------------------------------------


drop table [dbo].[RVF_TBL_API_STOCK_HEADER]

drop table [dbo].[RVF_TBL_API_STOCK_DETAIL]

ALTER TABLE [dbo].[RVF_TBL_API_STOCK_DETAIL]
drop CONSTRAINT [FK_RVF_TBL_API_STOCK_DETAIL_STOCK_HEADER]

CREATE TABLE [dbo].[RVF_TBL_API_STOCK](
	[ID] [BIGINT]  NOT NULL, -- Agrupador
	[WarehouseID] [nvarchar](250) NOT NULL,
	[PartNum] [nvarchar](50) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Estado][nvarchar](50) NOT NULL,
	[InformadoMV] [datetime] NULL,
	[InformadoEpicor] [datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_API_STOCK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[WarehouseID] ASC,
	[PartNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RVF_TBL_API_STOCK] ADD  DEFAULT (getdate()) FOR [InformadoEpicor]

---------------------------------------------------

CREATE TABLE [dbo].[RVF_TBL_API_PRICE](
	[ID] [BIGINT]  NOT NULL, -- Agrupador
	[ProductPriceListID] [nvarchar](250) NOT NULL,
	[PartNum] [nvarchar](50) NOT NULL,
	[Neto] [decimal](17,5) NOT NULL,
	[Tax] [decimal](17,5) NOT NULL,
	[Gross] [decimal](17,5) NOT NULL,
	[PriceWithDiscount] [decimal](17,5) NOT NULL,
	[Estado][nvarchar](50) NOT NULL,
	[InformadoEpicor] [datetime] NOT NULL,
	[InformadoMV] [datetime] NULL,
 CONSTRAINT [PK_RVF_TBL_API_PRICE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ProductPriceListID] ASC,
	[PartNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RVF_TBL_API_PRICE] ADD  DEFAULT (getdate()) FOR [InformadoEpicor]

/***********************************
Productos relacion Multivende Epicor
*************************************/

CREATE TABLE [dbo].[RVF_TBL_API_PODUCTOS](
	[ProductVersionId] [nvarchar](250) NOT NULL,
	[PartNum] [nvarchar](50) NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_API_PODUCTOS] PRIMARY KEY CLUSTERED 
(
	[PartNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO
ALTER TABLE [dbo].[RVF_TBL_API_PODUCTOS] ADD  DEFAULT (getdate()) FOR [Fecha]

/***********************************
Lista de Precios Multivende.
*************************************/

CREATE TABLE [dbo].[RVF_TBL_API_LISTAS_PRECIOS](
	[ProductPriceListID] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](200) NOT NULL,
	[ListaPrecioEpicor] [nvarchar](100) NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_API_LISTAS_PRECIOS] PRIMARY KEY CLUSTERED 
(
	[ProductPriceListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RVF_TBL_API_LISTAS_PRECIOS] ADD  DEFAULT (getdate()) FOR [Fecha]
GO


/***********************************
Precios actuales Epicor 
*************************************/
CREATE TABLE [dbo].[RVF_TBL_API_PRECIOS_EPICOR](
	[ListaPrecioEpicor] [nvarchar](250) NOT NULL,
	[PartNum] [nvarchar](50) NOT NULL,
	[Precio] [decimal](17,5) NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_API_PRECIOS_EPICOR] PRIMARY KEY CLUSTERED 
(
	[ListaPrecioEpicor] ASC,
	[PartNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO
ALTER TABLE [dbo].[RVF_TBL_API_PRECIOS_EPICOR] ADD  DEFAULT (getdate()) FOR [Fecha]
/***********************************
Precios actualesDiarios Multivende 
*************************************/
CREATE TABLE [dbo].[RVF_TBL_API_PRECIOS_MULTIVENDE](
	[ID] INT IDENTITY(1,1) NOT NULL,
	[ProductPriceListID] [nvarchar](250) NOT NULL,
	[PartNum] [nvarchar](50) NOT NULL,
	[Neto] [decimal](17,5) NOT NULL,
	[Tax] [decimal](17,5) NOT NULL,
	[Gross] [decimal](17,5) NOT NULL,
	[PriceWithDiscount] [decimal](17,5) NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_API_PRECIOS_MULTIVENDE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ProductPriceListID] ASC,
	[PartNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO
ALTER TABLE [dbo].[RVF_TBL_API_PRECIOS_MULTIVENDE] ADD  DEFAULT (getdate()) FOR [Fecha]