USE RemitoCot-PROD

BEGIN TRAN
 /* --------------------------------------------------------------------------
	Consula detalle de errores COT
 --------------------------------------------------------------------------*/
 SET DATEFORMAT DMY  

SELECT    ORe.IdOperacion, ORe.IdArchivo, ORe.IdRemito, ORe.Procesado, ORe.TextoProceso, ORe.StatusRegistro,   
     ORe.UltimaActualizacionUsuario, ORe.UltimaActualizacionFecha  
FROM    [CORPSQLMULT01].[RemitoCOT-PROD].dbo.OperacionesRemitos   ORe  
INNER JOIN   (  
     SELECT    *  
     FROM    [CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones   
     WHERE    [Status]      =  'E'  
      AND    UltimaActualizacionFecha  >=  '2020-2-9 '
     )       O  
 ON    O.IdOperacion  =  ORe.IdOperacion  
ORDER BY   UltimaActualizacionFecha desc

 /* --------------------------------------------------------------------------
	Consula Cabezera de errores COT
 --------------------------------------------------------------------------*/
 SET DATEFORMAT DMY  

SELECT    IDOperacion, IDTipoOperacion, CUIT, Descripcion, DatosAdicionales2, DatosAdicionales4, [Status], TextoStatus,   
     StatusRegistro, UltimaActualizacionUsuario, UltimaActualizacionFecha  
FROM    [CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones  
WHERE    [Status]      =  'E'  
 AND    UltimaActualizacionFecha  >=  '9/2/2021' 
ORDER BY   DatosAdicionales4 DESC, UltimaActualizacionFecha DESC  

 /* --------------------------------------------------------------------------
	Consula INFORMACION Vieajes COT
 --------------------------------------------------------------------------*/

SELECT				IdOperacion, IDTipoOperacion, CUIT, Descripcion, DatosAdicionales1, DatosAdicionales2, DatosAdicionales3, DatosAdicionales4, 
					[Status], TextoStatus, StatusRegistro, UltimaActualizacionUsuario,
					REPLACE(REPLACE(Descripcion, 'Remito: 91 ', ''), 'Remito: 091', '')		AS			Descripcion2, 
					MAX(UltimaActualizacionFecha)				AS			UltimaActualizacionFecha
FROM				[CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones
-- WHERE				Status				<>				'C'
GROUP BY			IdOperacion, IDTipoOperacion, CUIT, Descripcion, DatosAdicionales1, DatosAdicionales2, DatosAdicionales3, DatosAdicionales4, 
					[Status], TextoStatus, StatusRegistro, UltimaActualizacionUsuario

GO
 /* --------------------------------------------------------------------------
	Consulta busca Cliente , empaque del remito
 --------------------------------------------------------------------------*/
SELECT					C.CUSTID, SH.SHIPTONUM, SH.*
FROM					[CORPEPIDB].EPICORERP.ERP.SHIPHEAD		SH
INNER JOIN				[CORPEPIDB].EPICORERP.ERP.CUSTOMER		c
	ON					C.COMPANY			=			SH.COMPANY
	AND					C.CUSTNUM			LIKE		SH.CUSTNUM
WHERE					SH.LEGALNUMBER		LIKE		'%229%7273%'

  /* --------------------------------------------------------------------------
	Consula busca numero de viaje por el packnum "empaque" del remito
 --------------------------------------------------------------------------*/
 SELECT					NUMBER06, SHORTCHAR07,*
 FROM					[CORPEPIDB].EPICORERP.ICE.UD110A
 WHERE					NUMBER06			=			169744


 /* --------------------------------------------------------------------------
	Consula Actualiza estado Concluido para informes de remito con error
 --------------------------------------------------------------------------*/

--begin tran
UPDATE				
[CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones 
SET					Status			=			'C',  					
TextoStatus		=			'Concluída' 
WHERE				IdOperacion		=			12500	AND				[Status]		=			'E'
  --rollback tran

 --commit tran


ROLLBACK TRAN 

--COMMIT TRAN
