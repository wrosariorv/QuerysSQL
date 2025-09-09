if exists (select name from tempdb.sys.tables where name like '%#RVF_CSV_DATA%')
drop table #RVF_CSV_DATA


CREATE TABLE RVF_CSV_DATA (

    Razon_Social					nvarchar (MAX) NOT NULL,	
	Numero_cheque					nvarchar (1000),
	Banco_Emisor					nvarchar (1000),
	Estado							nvarchar (1000),
	Monto							nvarchar (1000),
	Fecha_Pago						nvarchar (1000),
	Cuit_Emisor						nvarchar (1000),
	Fecha_Emisión					nvarchar (1000),
	CBU_Emisor						nvarchar (1000),
	Tipo_Cheque						nvarchar (1000),
	Caracter_Cheque					nvarchar (1000),
	Agrupador_ID					nvarchar (1000),
	Concepto_Pago					nvarchar (1000),
	Motivo_Pago						nvarchar (1000),
	Motivo_Rechazo					nvarchar (1000),
	Codigo_Rechazo					nvarchar (1000),
	Orden_no_pagar					nvarchar (1000),
	Cmc7							nvarchar (1000),
	Id_Echeq						nvarchar (1000),
	codigo_Visualizacion			nvarchar (1000),	
	Modo_Cheque						nvarchar (1000),
	Endoso_Fecha					nvarchar (1000),
	Endoso_Tipo_Doc					nvarchar (1000),
	Endoso_Documento				nvarchar (1000),
	Endoso_Razon_Social				nvarchar (1000),
	Endoso_Estado					nvarchar (1000),
	Referencia_Pago					nvarchar (1000),
	Certificado_Emitido				nvarchar (1000),
	CBU_Custodia					nvarchar (1000),
	Cuenta_Custodia					nvarchar (1000),
	Fecha_Emisión_Cesion			nvarchar (1000),
	Ultima_modificacion				nvarchar (1000),
	Tipo_Documento_Cedente			nvarchar (1000),
	Documento_Cedente				nvarchar (1000),
	Nombre_Cedente					nvarchar (1000),
	Tipo_Documento_Cesionario		nvarchar (1000),
	Número_Documento_Cesionario		nvarchar (1000),
	Nombre_Cesionario				nvarchar (1000),
	Domicilio_Cesionario			nvarchar (1000),
	Motivo_Repudio					nvarchar (1000),
	Estado_Cesion					nvarchar (1000),
	Avalado							nvarchar (1000),
	Avalistas						nvarchar (1000),
	Mandato_cobro					nvarchar (1000),
	Mandato_negociacion				nvarchar (1000),
	Ultimo_mandato					nvarchar (1000),
	Solicitante_devolucion			nvarchar (1000),
	En_solicitud_devolucion			nvarchar (1000)
)	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP TABLE RVF_CSV_DATA

Select 

DELETE RVF_CSV_DATA
BULK INSERT RVF_CSV_DATA
FROM '\\CORPFILESRV01\Grupos\Padrones\CSV\CSV de Cobranzas.csv'
WITH (
			FIELDTERMINATOR = ';',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2


		);

select * from RVF_CSV_DATA

BULK INSERT #RVF_CSV_DATA
FROM '\\CORPFILESRV01\Grupos\Padrones\CSV\CSV de Cobranzas.csv'
WITH (

FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0A'

);

	Select * FROM #RVF_CSV_DATA


DECLARE @contenido VARCHAR(MAX)
SET @contenido = (SELECT top 1 * FROM OPENROWSET(BULK '\\CORPFILESRV01\Grupos\Padrones\CSV\Despacho CO01 CDEE 213209 14-24-28.csv',SINGLE_BLOB)  AS archivo)
SELECT @contenido

DECLARE @contenido VARCHAR(MAX)
SET @contenido = (SELECT TOP 1 * FROM OPENROWSET(BULK '\\CORPFILESRV01\Grupos\Padrones\CSV\Despacho CO01 CDEE 213209 14-24-28.csv', SINGLE_BLOB) AS archivo)


SELECT *
FROM OPENROWSET(BULK N'D:\XChange\test-csv.csv',
    FORMATFILE = N'D:\XChange\test-csv.fmt',
    FIRSTROW=2,
    FORMAT='CSV') AS cars;


--Funciona
DELETE  RVF_CSV_DATA
BULK
INSERT RVF_CSV_DATA
FROM '\\CORPFILESRV01\Grupos\Padrones\CSV\CSV de Cobranzas.csv'
WITH (
  FIELDTERMINATOR = ' ',
  ROWTERMINATOR = '\n',
  FIRSTROW = 1,
  TABLOCK,
  CODEPAGE='65001',
  DATAFILETYPE='char',
  KEEPNULLS,
  MAXERRORS=0,
  ORDER (column1),
  ROWS_PER_BATCH=1048576
);