 /*

ALTER PROCEDURE			[dbo].[RVF_PRC_IMP_INSERTA_PEDIDOS_MOVIVENTAS]
AS

 */

 

--Inserto primero el detalle de las lineas de los pedidos

BEGIN

IF OBJECT_ID('tempdb.dbo.#RVF_PRC_MOVIVENTA_TEMP1','U')IS NOT NULL
TRUNCATE TABLE #RVF_PRC_MOVIVENTA_TEMP1

ELSE

CREATE TABLE		#RVF_PRC_MOVIVENTA_TEMP1	( 
														[Company] [varchar](10) NOT NULL,
														[QuoteNum] [varchar](50) NOT NULL,
														[QuoteLine] [int] NOT NULL,
														[PartNum] [varchar](50) NOT NULL,
														[SellingExpectedQty] [FLOAT] NOT NULL,
														[ListPrice] [DECIMAL](17,5) NOT NULL,
														[DiscountPercent] [FLOAT]  NULL
												)

INSERT INTO			#RVF_PRC_MOVIVENTA_TEMP1		

SELECT				MQD.[compania]																						AS Company,
					MQD.[nroCotizacion]																					AS QuoteNum	, 
					[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])				AS QuoteLine,
					--MQD.[nroLinea]																						AS Linea,
					MQD.[codProducto]																					AS PartNum,
					CAST(MQD.[cantidad] AS float)																		AS SellingExpectedQty,
					CAST(MQD.[precio] AS decimal(17,5))																	AS ListPrice,
					ISNULL(CAST(MQD.[descuento] AS float),0)															AS DiscountPercent  
					
FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		MQD			WITH (NoLock)
WHERE				MQD.nroCotizacion		IS NOT NULL


GROUP BY			MQD.[compania],	MQD.[nroCotizacion]
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

/**********************************
Registros Repetidos en la Linea
***********************************/
select compania, convert (int,nroCotizacion) AS nroCotizacion, [nroLinea], COUNT(*)
from [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]

GROUP BY	compania,nroCotizacion, [nroLinea] 
HAVING COUNT(*)>1
Order by 2
/********************************************
Registros Repetidos en la Linea a Mantener
*********************************************/
Select A.* from [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		A WITH(NoLock)

Inner JOIN		(

					select		B.[compania], convert (int,B.[nroCotizacion]) AS nroCotizacion, B.[nroLinea]
					from		[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]	B

					GROUP BY	B.[compania],B.[nroCotizacion], B.[nroLinea] 
					HAVING COUNT(*)>1
					

				)	W
ON		A.compania							=		W.compania
AND		convert (int,A.nroCotizacion)		=		W.nroCotizacion


Order by convert (int,A.nroCotizacion)


	Select			A.compania, A.nroCotizacion, A.[nroLinea]
	from			[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		A WITH(NoLock)
 	Inner JOIN		(

						select		B.[compania], convert (int,B.[nroCotizacion]) AS nroCotizacion, B.[nroLinea]
						from		[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]	B

						GROUP BY	B.[compania],B.[nroCotizacion], B.[nroLinea] 
						HAVING COUNT(*)>1

					)	W
	ON				A.compania							=		W.compania
	AND				convert (int,A.nroCotizacion)		=		W.nroCotizacion
	AND				A.[nroLinea]						=		W.[nroLinea]
	GROUP BY		A.compania, A.nroCotizacion, A.[nroLinea]
	Order by		 A.compania, CONVERT(int, A.nroCotizacion), A.[nroLinea]




/****************************************
Registros Repetidos en el Detalle
*****************************************/

Select A.* from [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		A WITH(NoLock)

Inner JOIN		(

						select		B.[compania], convert (int,B.[nroCotizacion]) AS nroCotizacion, B.[nroLinea]
						from		[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]	B

						GROUP BY	B.[compania],B.[nroCotizacion], B.[nroLinea] 
						HAVING COUNT(*)>1

				)	W
ON		A.compania							=		W.compania
AND		convert (int,A.nroCotizacion)		=		W.nroCotizacion
AND		A.[nroLinea]						=		W.[nroLinea]


Order by convert (int,A.nroCotizacion), A.[nroLinea]

/********************************************
Registros Repetidos en la cabezera a Eliminar
*********************************************/

	Select			A.compania, A.nroCotizacion, A.[nroLinea]
	from			[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		A WITH(NoLock)
 	Inner JOIN		(

						select		B.[compania], convert (int,B.[nroCotizacion]) AS nroCotizacion, B.[nroLinea]
						from		[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]	B

						GROUP BY	B.[compania],B.[nroCotizacion], B.[nroLinea] 
						HAVING COUNT(*)>1

					)	W
	ON				A.compania							=		W.compania
	AND				convert (int,A.nroCotizacion)		=		W.nroCotizacion
	AND				A.[nroLinea]						=		W.[nroLinea]
	GROUP BY		A.compania, A.nroCotizacion, A.[nroLinea]
	Order by		 A.compania, CONVERT(int, A.nroCotizacion), A.[nroLinea]

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

/**********************************
Registros Repetidos en la cabezera
***********************************/

SELECT		compania,convert (int,nroCotizacion),
			COUNT(*)
FROM		[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		 WITH(NoLock)
GROUP BY	compania,nroCotizacion 
HAVING COUNT(*)>1
Order by 2


/********************************************
Registros Repetidos en la cabezera a Mantener
*********************************************/
 WITH C AS
 (
  SELECT L.*, 
  ROW_NUMBER() OVER (PARTITION BY 
                    L.compania,L.nroCotizacion
                    ORDER BY L.compania,L.nroCotizacion,convert (datetime ,L.fecha) desc) AS DUPLICADO
	 from [CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		L WITH(NoLock)
	Inner JOIN		(

					SELECT				B.compania AS compania,convert (int,B.nroCotizacion) AS nroCotizacion--,COUNT(*)
					FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		B WITH(NoLock)
					GROUP BY			compania,nroCotizacion 
					HAVING COUNT(*)>1
					--Order by 2

				)	W
ON		L.compania							=		W.compania
AND		convert (int,L.nroCotizacion)		=		W.nroCotizacion

 )
 SELECT C.* FROM C 
 WHERE	DUPLICADO > 1
 ORder by CONVERT(int, C.nroCotizacion)

/****************************************
Registros Repetidos en la cabezera
*****************************************/

Select A.* from [CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		A WITH(NoLock)

Inner JOIN		(

					SELECT				B.compania AS compania,convert (int,B.nroCotizacion) AS nroCotizacion--,COUNT(*)
					FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		B WITH(NoLock)
					GROUP BY			compania,nroCotizacion 
					HAVING COUNT(*)>1
					--Order by 2

				)	W
ON		A.compania							=		W.compania
AND		convert (int,A.nroCotizacion)		=		W.nroCotizacion


Order by convert (int,A.nroCotizacion)

/********************************************
Registros Repetidos en la cabezera a Eliminar
*********************************************/
SELECT	X.*
FROM	[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		X WITH(NoLock)
Inner JOIN			(
						Select			A.compania, A.nroCotizacion, MAX(Convert (datetime, A.Fecha))AS FechaMayor --MIN( Convert (datetime, A.fecha))
						from			[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		A WITH(NoLock)
 						Inner JOIN		(

										SELECT				B.compania AS compania,convert (int,B.nroCotizacion) AS nroCotizacion--,COUNT(*)
										FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		B WITH(NoLock)
										GROUP BY			compania,nroCotizacion 
										HAVING COUNT(*)>1
										
										)	W
						ON				A.compania							=		W.compania
						AND				convert (int,A.nroCotizacion)		=		W.nroCotizacion
						GROUP BY		A.compania, A.nroCotizacion
						--Order by		 A.compania, CONVERT(int, A.nroCotizacion)
					)	Y
ON		X.compania							=		Y.compania
AND		convert (int,X.nroCotizacion)		=		Y.nroCotizacion
AND		Convert (datetime, X.Fecha)			=		Y.FechaMayor
Order by		 X.compania, CONVERT(int, X.nroCotizacion)

/********** Con CTE Recusivo *************/
WITH C AS
					(
						Select			A.compania, A.nroCotizacion, MAX(Convert (datetime, A.Fecha))AS FechaMayor --MIN( Convert (datetime, A.fecha))
						from			[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		A WITH(NoLock)
 						Inner JOIN		(

										SELECT				B.compania AS compania,convert (int,B.nroCotizacion) AS nroCotizacion--,COUNT(*)
										FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		B WITH(NoLock)
										GROUP BY			compania,nroCotizacion 
										HAVING COUNT(*)>1
										--Order by 2

										)	W
						ON				A.compania							=		W.compania
						AND				convert (int,A.nroCotizacion)		=		W.nroCotizacion
						GROUP BY		A.compania, A.nroCotizacion
						--Order by		 A.compania, CONVERT(int, A.nroCotizacion)
					)	

Select X.* from C
Inner JOIN		[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		X WITH(NoLock)
ON		X.compania							=		C.compania
AND		convert (int,X.nroCotizacion)		=		C.nroCotizacion
AND		Convert (datetime, X.Fecha)			=		C.FechaMayor
ORDER BY C.FechaMayor



-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
		/*

		INSERT INTO		[CORPEPISSRS01].[RVF_Local].[DBO].[RVF_TBL_IMP_QUOTE_DETAIL]	
						(	
						[Company] ,
						[QuoteNum] ,
						[QuoteLine] ,
						[PartNum] ,
						[SellingExpectedQty] ,
						[ListPrice] ,
						[DiscountPercent] 
						)

		*/


				SELECT				MQD.[compania]																				AS Company,
									MQD.[nroCotizacion]																			AS QuoteNum,
									[dbo].[RVF_FNC_Calcula_NroLinea] (MQD.[compania], MQD.[nroCotizacion], MQD.[nroLinea])		AS QuoteLine, 
									MQD.[codProducto]																			AS PartNum,
									CAST(MQD.[cantidad] AS float)																AS SellingExpectedQty,
									CAST(MQD.[precio] AS decimal(17,5))															AS ListPrice,
									ISNULL(CAST(MQD.[descuento] AS float),0)													AS DiscountPercent  

				FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		MQD		WITH(NoLock)


/************************************************************************************

Se verifica que el pedido de venta Tenga Encabezado
************************************************************************************/

INNER JOIN			(
									SELECT		compania,nroCotizacion 
									FROM		[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones]		WITH(NoLock)
									WHERE		nroCotizacion		IS NOT NULL
									)	MQH

				ON					MQH.compania			=			MQD.compania
				AND					MQH.nroCotizacion		=			MQD.nroCotizacion


/************************************************************************************

Se controla que el pedido no haya sido insertado previamente en la RVF_TBL_IMP_QUOTE_DETAIL

************************************************************************************/

LEFT OUTER JOIN		[CORPEPISSRS01].[RVF_Local].[DBO].RVF_TBL_IMP_QUOTE_DETAIL										DTL			WITH (NoLock)
	ON				MQD.compania			=				DTL.Company	
	AND				MQD.nroCotizacion		=				DTL.Cotizacion	
	AND				MQD.[nroLinea]			=				DTL.QuoteLine


/************************************************************************************

Se controla que el pedido no haya sido previamente integrado en la UD10

************************************************************************************/

LEFT OUTER JOIN		[CORPEPISSRS01].[RVF_Local].[DBO].RVF_TBL_IMP_QUOTE_LOG										L			WITH (NoLock)
	ON				MQD.compania			=				L.Company	
	AND				MQD.nroCotizacion		=				L.Cotizacion	

WHERE				MQD.nroCotizacion		IS NOT NULL
--AND					MQH.nroCotizacion	Not in	(Select QuoteNum from RVF_TBL_IMP_QUOTE_DETAIL)		--Excluyo los pedidos ya insertado en la tabla de integracion


------------------------------------------------------------------------------------------------------------------
select * from RVF_TBL_IMP_QUOTE_DETAIL
END


--Inserto informacion de la cabezera del pedido
/*
BEGIN
		--/*

		INSERT INTO		[CORPEPISSRS01].[RVF_Local].[DBO].[RVF_TBL_IMP_QUOTE_HEADER]	
						(	
						[Company] ,
						[QuoteNum] ,
						[EntryDate] ,
						[CustNum],
						[ShipToNum],
						[PONum],
						[MktgCampaignID],
						[TermsCode],
						[RequestDate],
						[CustID]
						)

		--*/				
				
				
				
				
				
				SELECT
									MQH.[compania]																			AS Company,
									MQH.[nroCotizacion]																		AS QuoteNum,
									convert (date,MQH.[fecha])																AS EntryDate,
									MQH.[codInternoCliente]																	AS CustNum,
									ISNULL(MQH.[codDomicilioEntrega],'')													AS ShipToNum,
									ISNULL(SUBSTRING (MQH.[ordenDeCompra],1,50),'')											AS PONum,
									MQH.[codCampana]																		AS MktgCampaignID,
									ISNULL(MQH.[codCondicionDePago],'')														AS TermsCode,
									ISNULL(convert (date,MQH.[fechaEntrega]),'')											AS RequestDate,
									MQH.[codCliente]																		AS CustID
					
				FROM				[CORPSQLMULT01].[moviventas].[dbo].[vw_cotizaciones] MQH		WITH(NoLock)
				INNER JOIN			(
										SELECT		compania,nroCotizacion FROM [CORPSQLMULT01].[moviventas].[dbo].[vw_detalle_cotizacion]		WITH(NoLock)
										WHERE		nroCotizacion		IS NOT NULL
										--AND			codProducto			NOT LIKE			'%-SK'
										GROUP BY	compania,nroCotizacion
									) MQD
				ON					MQH.compania		=		MQD.compania
				AND					MQH.nroCotizacion	=		MQD.nroCotizacion

				WHERE			
									MQH.nroCotizacion	IS NOT NULL
				AND					MQH.nroCotizacion	Not in	(Select QuoteNum from RVF_TBL_IMP_QUOTE_HEADER)		--Excluyo los pedidos ya insertado en la tabla de integracion
END
*/
GO