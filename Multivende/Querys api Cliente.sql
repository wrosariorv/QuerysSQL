USE [RVF_Local]
GO

/****** Object:  Table [dbo].[RVF_TBL_API_CLIENTES]    Script Date: 30/12/2021 11:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RVF_TBL_API_CLIENTES](
	[Compania] [nvarchar](8) NOT NULL,
	[CodigoCliente] [nvarchar](10) NOT NULL,
	[CodigoInternoCliente] [int] NOT NULL,
	[RazonSocial] [nvarchar](50) NOT NULL,
	[CUIT] [nvarchar](20) NOT NULL,
	[SituacionIVA] [nvarchar](4) NOT NULL,
	[CodCondicionVenta] [nvarchar](4) NOT NULL,
	[Inhabilitado] [varchar](2) NOT NULL
 CONSTRAINT [PK_RVF_TBL_API_CLIENTES] PRIMARY KEY CLUSTERED ,auto_increment
(
	[CodigoInternoCliente] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
GO

--drop table RVF_TBL_API_CLIENTES
GO


insert into RVF_TBL_API_CLIENTES
select [Compania],[CodigoCliente],[CodigoInternoCliente]=1,[RazonSocial],[CUIT],[SituacionIVA],[CodCondicionVenta],[Inhabilitado]

from RVF_VW_MOVI_CLIENTES
where CodigoInternoCliente between 1 and 10

delete RVF_TBL_API_CLIENTES
where CodigoInternoCliente>16

select * from RVF_TBL_API_CLIENTES
order by 3

insert into RVF_TBL_API_DOMICILIO_CLIENTES
select a.Compania,a.CodigoCliente,b.CUIT,a.CodigoDomicilio,a.Direccion,a.Ciudad,a.UnidadNeg, imagen='' 
from RVF_VW_MOVI_DOMICILIO_DE_CLIENTE a
inner join RVF_VW_MOVI_CLIENTES b
on		a.Compania = b.Compania
and		a.CodigoCliente= b.CodigoCliente
where a.CodigoCliente in (select b.CodigoCliente from RVF_TBL_API_CLIENTES b)

select * from RVF_TBL_API_DOMICILIO_CLIENTES

select * from RVF_TBL_API_DOMICILIO_CLIENTES
order by 2
Select * from RVF_TBL_API_CLIENTES
ALTER TABLE RVF_TBL_API_CLIENTES drop COLUMN CodigoInternoCliente 

ALTER TABLE RVF_TBL_API_CLIENTES ADD CodigoInternoCliente int NOT NULL IDENTITY (1,1) PRIMARY KEY


CREATE TABLE [dbo].[RVF_TBL_API_DOMICILIO_CLIENTES](
	[Compania] [nvarchar](16) NOT NULL,
	[CodigoCliente] [nvarchar](10) NOT NULL,
	[CodigoDomicilio] [nvarchar](28) NOT NULL,
	[Direccion] [nvarchar](100) NOT NULL,
	[Ciudad] [nvarchar](100) NOT NULL,
	[UnidadNeg] [nvarchar](4) NOT NULL,
	[Imagen] [nvarchar](100) NULL,
--Foreign key ([CodigoCliente]) References  [dbo].[RVF_TBL_API_CLIENTES]([CodigoCliente]),
--CONSTRAINT FK_DomicilioID Foreign key ([CodigoCliente])References [dbo].[RVF_TBL_API_CLIENTES] ([CodigoCliente]),
PRIMARY KEY
(
	[CodigoCliente]ASC,
	[CodigoDomicilio]ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[RVF_TBL_API_USUARIO](
	
	
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioA] [nvarchar](50) NOT NULL,
	[PasswordHash] Varbinary(MAX) NOT NULL,
	[PasswordSalt] varbinary(MAX) NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[id]ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

select * from sys.objects where name like '%WEB%'

CREATE TABLE [dbo].[RVF_TBL_API_VENTAS_WEB](
	
	[ProyectID] [nvarchar](100)  NULL,
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
	[Linea][INT]not null,
	[CodigoProducto][nvarchar](100) NOT NULL,
	[Cantidad]int NOT null,
	[PrecioUnitario]Decimal (20,9) NOT null,
	[RequierFactura][Bit] not null,
	[CostoEnvio]Decimal (20,9)not null,
	----------------------------------------------
	[Company][nvarchar](16) NULL,
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

select * from RVF_TBL_API_VENTAS_WEB

select * from [CORPEPIDB].[EpicorErp].[ICE].[UD11]

--delete RVF_TBL_API_VENTAS_WEB
where id!=1

Alter table RVF_TBL_API_VENTAS_WEB alter column Cantidad int
Alter table RVF_TBL_API_VENTAS_WEB alter column ProjectID nvarchar (100)
Alter table RVF_TBL_API_VENTAS_WEB alter column RequiereFactura bit
-----------------------------------------------------
Alter table RVF_TBL_API_VENTAS_WEB alter column CodigoPostal nvarchar (20)
Alter table RVF_TBL_API_VENTAS_WEB alter column CanalEntrada nvarchar (100)
Alter table RVF_TBL_API_VENTAS_WEB alter column Entrega_CP nvarchar (20)
Alter table RVF_TBL_API_VENTAS_WEB alter column Company nvarchar (20)
Alter table RVF_TBL_API_VENTAS_WEB alter column CustNum nvarchar (20)

SET IDENTITY_INSERT RVF_TBL_API_VENTAS_WEB ON
 insert into RVF_TBL_API_VENTAS_WEB
--select * into RVF_TBL_API_VENTAS_WEB_BK
select
CanalEntrada
,NumeroOC
,NumeroDocumento
,Nombre
,Domicilio
,Ciudad
,Provincia
,CodigoPostal
,CodigoProvincia
,Entrega_Nombre
,Entrega_domicilio1
,Entrega_domicilio2
,Entrega_domicilio3
,Entrega_Ciudad
,Entrega_Provincia
,Entrega_CP
,Entrega_Documento
,Comentario
,FechaVEnta
,Linea
,CodigoProducto
,Cantidad
,PrecioUnitario
,RequiereFactura
,CostoEnvio
,Company
,ProjectID
,FechaAltaOV
,Estado
,NumeroOV
,CustNum
,Integrado from RVF_TBL_API_VENTAS_WEB_BK


INSERT INTO [CORPEPIDB].[EpicorERP].[ICE].[UD11](ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,Key5,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,Key4,ShortChar15,Date01,Number01,ShortChar16,Number02,Number03,CheckBox01,Number04,Key3,Company,Key1,Date02,ShortChar17,ShortChar18,ShortChar19,CheckBox02)
VALUE ('Calros Gonzales', 'PIONEROS FUEGUINOS 425 3 A','RIO GRANDE','TIERRA DEL FUEGO','9420','24','36708662','Pedro Pérez','Colon 250','','','Santiago de Chile','Santiago','9419','36708660','12345678','2021-12-24 13:55:00.713',1,'3000-005601',2,325000.000000000,False,35050.000000000,'TCLStore','CL01','TCP-Commerce','2021-12-24 13:59:00','Pendiente','',False)


select * from [CORPEPIDB].[EpicorERP].[ICE].[UD11]

SET DATEFORMAT DMY
INSERT INTO		[CORPEPIDB].[EpicorERP].[ICE].[UD11](ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,Key5,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,Key4,ShortChar15,Date01,
				Number01,ShortChar16,Number02,Number03,CheckBox01,Number04,Key3,company,Key1,Key2,Date02,ShortChar17,ShortChar18,ShortChar19,CheckBox02)
VALUES			('AGUEDA VEGA HECTOR MANUEL','PIONEROS FUEGUINOS 425 3 A','RIO GRANDE','TIERRA DEL FUEGO','9420','24','36708660','AGUEDA VEGA HECTOR MANUEL','Billinghurst 245','','','Santiago de Chile','Santiago','9420','36708660','12345678','Prueba Insert','2021-12-24 13:55:00.713',
				 1.000000000,'1620-001310',2.000000000,250000.000000000,1,24793.000000000,'TCLStore','CL01','TCP-Commerce','1','2021-12-24 13:59:00','Pendiente','','',0	)

INSERT INTO		[CORPEPIDB].[EpicorERP].[ICE].[UD11](ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,Key5,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,Key4,ShortChar15,Date01,
				Number01,ShortChar16,Number02,Number03,CheckBox01,Number04,Key3,company,Key1,Key2,Date02,ShortChar17,ShortChar18,ShortChar19,CheckBox02)
SELECT			Nombre,Domicilio,Ciudad,Provincia,CodigoPostal,CodigoProvincia,NumeroDocumento,Entrega_Nombre,Entrega_domicilio1,Entrega_domicilio2,Entrega_domicilio3,Entrega_Ciudad,Entrega_Provincia,Entrega_CP,Entrega_Documento,NumeroOC,Comentario,FechaVEnta,Linea,CodigoProducto
				,Cantidad,PrecioUnitario,RequiereFactura,CostoEnvio,CanalEntrada,Company,ProjectID,id,FechaAltaOV,Estado,NumeroOV,CustNum,Integrado
FROM			RVF_TBL_API_VENTAS_WEB
WHERE			NumeroOC = '123456783'


select ProjectID,ID,CanalEntrada,NumeroOC,NumeroDocumento,Entrega_domicilio2,FechaAltaOV from RVF_TBL_API_VENTAS_WEB
select * from RVF_TBL_API_VENTAS_WEB

EXEC RVF_PRC_API_INSERTA_PEDIDO_UD 'TCLStore','123456783','36708662'


select * from [CORPEPIDB].[EpicorERP].[ICE].[UD11]

delete [CORPEPIDB].[EpicorERP].[ICE].[UD11]
where Key2 != 1

SET DATEFORMAT DMY
INSERT INTO		[CORPEPIDB].[EpicorERP].[ICE].[UD11](ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,Key5,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,Key4,ShortChar15,Date01,
				Number01,ShortChar16,Number02,Number03,CheckBox01,Number04,Key3,company,Key1,Key2,Date02,ShortChar17,ShortChar18,ShortChar19,CheckBox02)
VALUES			('AGUEDA VEGA HECTOR MANUEL','PIONEROS FUEGUINOS 425 3 A','RIO GRANDE','TIERRA DEL FUEGO','9420','24','36708660','AGUEDA VEGA HECTOR MANUEL','Billinghurst 245','','','Santiago de Chile','Santiago','9420','36708660','12345678','Prueba Insert','2021-12-24 13:55:00.713',
				 1.000000000,'1620-001310',2.000000000,250000.000000000,1,24793.000000000,'TCLStore','CL01','TCP-Commerce','1','2021-12-24 13:59:00','Pendiente','','',0	)


Select * from RVF_TBL_API_USUARIO