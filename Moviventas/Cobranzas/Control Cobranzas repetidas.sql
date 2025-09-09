SELECT					*	
 FROM					RVF_TBL_IMP_RECIBO_LOG		
where Recibo =74664
or Observaciones like '%RA-00171720%'

select * from [CORPSQLMULT2019].[moviventas].dbo.vw_cobranzas
where nroCobranza=74644

select * from [dbo].[RVF_VW_MOVI_ESTADO_COBRANZAS]
where OtherDetails =74644


SELECT			
				--REPLACE(OtherDetails, 'COBRANZA MOVIVENTAS ', '')			AS	OtherDetails,  
				--LegalNumber, TranAmt, 
				--CASE	
				--	WHEN Posted = 0		THEN	'No Posteada'  
				--	WHEN Posted = 1		THEN	'Posteada'
				--END															AS	Estado
				OtherDetails,GroupID,*
FROM			[CORPE11-EPIDB].EpicorErp.Erp.CashHead
WHERE	--		TranDate				>=				'2021-04-01'
				TranDate				>=				DATEADD(DD, -7, GETDATE())
	AND			OtherDetails			<>				''
	AND			OtherDetails			=74644


	


SELECT			REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', '')			AS	OtherDetails,
				CH.GroupID,
				CH.LegalNumber, 
				CH.TranAmt, 
				CASE	
					WHEN CH.Posted = 0		THEN	'No Posteada'  
					WHEN CH.Posted = 1		THEN	'Posteada'
				END																AS	Estado

FROM			[CORPE11-EPIDB].EpicorErp.Erp.CashHead							CH
INNER JOIN	(
				SELECT		REPLACE(OtherDetails, 'COBRANZA MOVIVENTAS ', '')	AS	OtherDetailsLimpio
				FROM		[CORPE11-EPIDB].EpicorErp.Erp.CashHead
				WHERE		TranDate				>=				DATEADD(DD, -7, GETDATE())
					AND		OtherDetails			<>				''
				GROUP BY	REPLACE(OtherDetails, 'COBRANZA MOVIVENTAS ', '')
				HAVING		COUNT(*)				>				1
			) D ON		REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', '')	=	D.OtherDetailsLimpio

WHERE			CH.TranDate				>=				DATEADD(DD, -7, GETDATE())
	AND			CH.OtherDetails		<>				''
order by OtherDetails desc


select * from [CORPE11-EPIDB].EpicorErp.Erp.CashHead							CH
where OtherDetails='74664'



SELECT		NCotizacionMovi
FROM		[RVF_Local].[dbo].[RVF_VW_MOVI_ENCABEZADO_COTIZACION]
WHERE		NCotizacionMovi		IS NOT NULL
GROUP BY	NCotizacionMovi
HAVING		COUNT(*)			>	1