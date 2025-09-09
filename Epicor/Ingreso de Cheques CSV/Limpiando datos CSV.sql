SELECT PARSENAME(REPLACE(Razon_Social, '&amp;', '.'), 2) AS Razon_Social, Numero_cheque
FROM OPENROWSET(BULK '\\CORPFILESRV01\Grupos\Padrones\CSV\dario0011000075943309202302221232277210000786749642503ConsultaChequesRecibidos.csv', FORMATFILE = '\\CORPFILESRV01\Grupos\Padrones\CSV\Formato.XML',SINGLE_BLOB) AS DATA


SELECT	--PARSENAME(REPLACE(LTRIM(Razon_Social), '&amp;', '&'), 2) AS Razon_Social,
		REPLACE(LTRIM(Razon_Social), '&amp;', '') AS Razon_Social,	
		LTRIM(Numero_cheque),
		LTRIM(Banco_Emisor),
		LTRIM(Estado),
		LTRIM(Monto),
		LTRIM(Fecha_Pago),
		LTRIM(Cuit_Emisor),
		LTRIM(Fecha_Emisión),
		LTRIM(CBU_Emisor),
		LTRIM(Tipo_Cheque),
		LTRIM(Caracter_Cheque),
		LTRIM(Agrupador_ID),
		LTRIM(Concepto_Pago),
		LTRIM(Motivo_Pago),
		LTRIM(Motivo_Rechazo),
		LTRIM(Codigo_Rechazo),
		LTRIM(Orden_no_pagar),
		LTRIM(Cmc7),
		LTRIM(Id_Echeq),
		LTRIM(codigo_Visualizacion),
		LTRIM(Modo_Cheque),
		LTRIM(Endoso_Fecha),
		LTRIM(Endoso_Tipo_Doc),
		LTRIM(Endoso_Documento),
		LTRIM(Endoso_Razon_Social),
		LTRIM(Endoso_Estado),
		LTRIM(Referencia_Pago),
		LTRIM(Certificado_Emitido),
		LTRIM(CBU_Custodia),
		LTRIM(Cuenta_Custodia),
		LTRIM(Fecha_Emisión_Cesion),
		LTRIM(Ultima_modificacion),
		LTRIM(Tipo_Documento_Cedente),
		LTRIM(Documento_Cedente),
		LTRIM(Nombre_Cedente),
		LTRIM(Tipo_Documento_Cesionario),
		LTRIM(Número_Documento_Cesionario),
		LTRIM(Nombre_Cesionario),
		LTRIM(Domicilio_Cesionario),
		LTRIM(Motivo_Repudio),
		LTRIM(Estado_Cesion),
		LTRIM(Avalado),
		LTRIM(Avalistas),
		LTRIM(Mandato_cobro),
		LTRIM(Mandato_negociacion),
		LTRIM(Ultimo_mandato),
		LTRIM(Solicitante_devolucion),
		REPLACE(LTRIM(En_solicitud_devolucion), '\n', '') AS En_solicitud_devolucion	


FROM OPENROWSET(BULK N'\\CORPFILESRV01\Grupos\Padrones\CSV\dario EXTRAE CARACTERES ESPECIALES - Valores malos.csv',
    FORMATFILE = N'\\CORPFILESRV01\Grupos\Padrones\CSV\Formato.XML',
    FIRSTROW=2,
    FORMAT='CSV') AS DATA
WHERE
Numero_cheque like '94%'



SELECT	--PARSENAME(REPLACE(LTRIM(Razon_Social), '&amp;', '&'), 2) AS Razon_Social,
		REPLACE(VALOR, '&quot;', '')+'\n' AS PRIMERA	
		--,LTRIM(VALOR2) as SEGUNDA
		--,CONCAT (REPLACE(LTRIM(VALOR), '&quot;', ''),LTRIM(VALOR2)) AS CODIGO1
		-----------------------------------------------------------------
		--,REPLACE(LTRIM(VALOR3), '&quot;', '') AS TERCERA,	
		--LTRIM(VALOR4) as CUARTA,
		--CONCAT (REPLACE(LTRIM(VALOR3), 'null&quot;;', ''),LTRIM(VALOR4)) AS CODIGO2


FROM OPENROWSET(BULK N'\\CORPFILESRV01\Grupos\Padrones\CSV\dario EXTRAE CARACTERES ESPECIALES.csv',
    FORMATFILE = N'\\CORPFILESRV01\Grupos\Padrones\CSV\Quito_&quot;.xml',
    FIRSTROW=2,
    FORMAT='CSV') AS DATA
	where VALOR like'%&quot%'