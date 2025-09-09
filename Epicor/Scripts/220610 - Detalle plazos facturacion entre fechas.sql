USE [RVF_Local]
GO


/**********************************************

Autor: Eduardo Salva

**********************************************/

 /*

ALTER PROCEDURE			[dbo].[RVF_PRC_COMER_DETALLE_PLAZOS_VENTAS]	
																@Empresa			VARCHAR(15)		=		'CO01', 
																@FechaDesde			DATE,   
																@FechaHasta			DATE,  
																@UN					VARCHAR(15), 		
																@Intercompany		VARCHAR(15)		=		'0', 
																@VentasOtros		VARCHAR(15)		=		'1'	

AS

 */

SET DATEFORMAT DMY

DECLARE	
						--------------------------------------------------------------
-- /*
						@Empresa			VARCHAR(15)			=		'CO01', 
						@FechaDesde			DATE				=		'01/05/2022', 
						@FechaHasta			DATE				=		'31/05/2022', 
						@UN					VARCHAR(15)			=		'', 
						@Intercompany		VARCHAR(15)			=		'0', 
						@VentasOtros		VARCHAR(15)			=		'1', 	
-- */
						--------------------------------------------------------------

						@UNIni				VARCHAR(15), 
						@UNFin				VARCHAR(15), 
						@IntercompanyIni	VARCHAR(15), 
						@IntercompanyFin	VARCHAR(15),
						@VentasOtrosIni		VARCHAR(15), 
						@VentasOtrosFin		VARCHAR(15)

------------------------------------------------------------------------------------------------------------------

IF		@UN		=	''	
		BEGIN		
				SELECT		@UNIni			=		'', 
							@UNFin			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@UNIni			=		@UN	, 
							@UNFin			=		@UN	
		END 

------------------------------------------------------------------------------------------------------------------

IF		@Intercompany		=	'Todos'	
		BEGIN		
				SELECT		@IntercompanyIni			=		'0', 
							@IntercompanyFin			=		'99999'
		END 
	ELSE
		BEGIN		
				SELECT		@IntercompanyIni			=		@Intercompany	, 
							@IntercompanyFin			=		@Intercompany	
		END 

------------------------------------------------------------------------------------------------------------------

IF		@VentasOtros		=	'Todos'	
		BEGIN		
				SELECT		@VentasOtrosIni			=		'0', 
							@VentasOtrosFin			=		'99999'
		END 
	ELSE
		BEGIN		
				SELECT		@VentasOtrosIni			=		@VentasOtros	, 
							@VentasOtrosFin			=		@VentasOtros	
		END 

------------------------------------------------------------------------------------------------------------------

SELECT					Company, InvoiceNum, LegalNumber, InvoiceAmt, InvoiceDate, DueDate, 
						MONTH(InvoiceDate)									AS		Mes_Facturacion, 
						MONTH(DueDate)										AS		Mes_Vencimiento, 
						DATEDIFF(DD, InvoiceDate, DueDate)					AS		Dias_Financiacion, 
						DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))		AS		Mes_Financiacion, 
						-----------------------------------------------------------------------------
						CASE 
							WHEN	DATEDIFF(DD, InvoiceDate, DueDate)	<=	7						THEN	InvoiceAmt
							ELSE																			0
						END													AS		'FinHasta7Dias', 
						CASE 
							WHEN	DATEDIFF(DD, InvoiceDate, DueDate)	BETWEEN		8	AND		15	THEN	InvoiceAmt
							ELSE																			0
						END													AS		'FinHasta15Dias',
						CASE
							WHEN	 DATEDIFF(DD, InvoiceDate, DueDate)	BETWEEN		16	AND		30	THEN	InvoiceAmt
							ELSE																			0
						END													AS		'FinHasta30Dias',
						CASE 
							WHEN	DATEDIFF(DD, InvoiceDate, DueDate)	>	30						THEN	InvoiceAmt
							ELSE																			0
						END													AS		'FinMas30Dias', 
						-----------------------------------------------------------------------------
						CASE 
							WHEN	DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))	=	0			THEN	InvoiceAmt
							ELSE																			0
						END													AS		'VtoMesActual', 
						CASE 
							WHEN	DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))	=	1			THEN	InvoiceAmt
							ELSE																			0
						END													AS		'VtoMesActual+1', 
						CASE 
							WHEN	DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))	=	2			THEN	InvoiceAmt
							ELSE																			0
						END													AS		'VtoMesActual+2', 
						CASE 
							WHEN	DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))	=	3			THEN	InvoiceAmt
							ELSE																			0
						END													AS		'VtoMesActual+3', 
						CASE 
							WHEN	DATEDIFF(DD,MONTH(InvoiceDate), MONTH(DueDate))	>	3			THEN	InvoiceAmt
							ELSE																			0
						END													AS		'VtoMesActual+N' 

FROM					(
						SELECT					Company, InvoiceNum, LegalNumber, InvoiceDate, DueDate, 
												SUM(TotalVenta)										AS		InvoiceAmt
						FROM					RVF_VW_COMER_ESTADISTICAS			WITH (NoLock)
						WHERE					Company				=			@Empresa
							AND					InvoiceDate			BETWEEN		@FechaDesde			AND			@FechaHasta
							AND					UN					BETWEEN		@UNIni				AND			@UNFin	
							AND					EsIntercompany		BETWEEN		@IntercompanyIni	AND			@IntercompanyFin
							AND					EsVenta				BETWEEN		@VentasOtrosIni		AND			@VentasOtrosFin
						GROUP BY				Company, InvoiceNum, LegalNumber, InvoiceDate, DueDate 
						)		A

------------------------------------------------------------------------------------------------------------------
