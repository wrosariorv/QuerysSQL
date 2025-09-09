USE [RVF_Local]
GO
--/*
ALTER FUNCTION [dbo].[RVF_FNC_Calcula_NroLinea_TEST]
								(
								@Compania		VARCHAR(15), 
								@Cotizacion		INT, 
								@Linea			INT
								)
RETURNS INT  

AS

--*/

BEGIN 

   DECLARE		@Resultado	INT


   SET  @Resultado	=	(
						SELECT			ISNULL(SUM(LineasTotales), 0) + 1
						FROM			(
										SELECT			DC.compania, DC.NroCotizacion, DC.nroLinea + 1 AS nroLinea, ART.CodigoCategoria, 
														CASE 
															WHEN ART.CodigoCategoria	=	'AA-SPLIT'		THEN		3
															ELSE														1
														END										AS LineasTotales			
										FROM			[CORPSQLMULT2019].[moviventas_test].[dbo].[vw_detalle_cotizacion]								DC
										LEFT OUTER JOIN	[CORPE11-SSRS].RVF_Local.dbo.RVF_VW_MOVI_ARTICULOS			ART
											ON			DC.codProducto			=			ART.CodigoArticulo
										WHERE			DC.compania				=			@Compania
											AND			DC.nroCotizacion		=			@Cotizacion
											AND			DC.nroLinea				<			@Linea 
										)	A
						)

RETURN @Resultado


END
GO


