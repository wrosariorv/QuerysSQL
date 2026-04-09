
/* Vistas a tocar para habilitar lineas
[dbo].[RV_VW_SIP_OT_SERIES_PENDIENTES]
[RF].[RV_VW_SIP_RFID_SERIES_PENDIENTE]
*/
select * from RV_TBL_SIP_ENCABEZADO_TRANSFERENCIA_P
where 
		--[TranNum] Between 53512 and 53516
		--[TranNum] > 53511
		Estado <>'Integrado'

select * from RV_TBL_SIP_ITEM_TP
where 
		--[TranNum] Between 53512 and 53516
		--[TranNum] > 53511
		Estado <>'Integrado'

SELECT	
		*
FROM	[WS].[RF].[RV_TBL_SIP_RFID_SERIE]
where 
			--OT in ('RV322040')
			SerialNumber in (
						select Serie from RV_TBL_SIP_ITEM_TP
						where 
								--[TranNum] Between 53512 and 53516
								[TranNum] > 53511
								--Estado <>'Integrado'
					
						)

SELECT		
			*
FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas]
where 
			/*OT in ('RV322040')
AND			*/Serie IN (
						SELECT Serie
                    
						FROM RV_TBL_SIP_ITEM_TP

						WHERE 
								--[TranNum] Between 53512 and 53516
								--OT in ('RV322040')
								[TranNum] > 53511
					)
SELECT *
                    
FROM RV_TBL_SIP_ITEM_TP

WHERE 
        --[TranNum] Between 53512 and 53516
        OT in ('RV322040')

SELECT		
			Serie,
			COUNT(*)
FROM		[PLANSQLMULT2019].[SIP].[dbo].[SeriesFabricadas]
where 
			OT in ('RV322040')
Group by Serie
Having COUNT(*) >1


SELECT	
		*
FROM	[WS].[RF].[RV_TBL_SIP_RFID_SERIE]
WHERE	
				PseudoLinea in ('TV4')
AND				Estado ='Pendiente'	
AND				FechaAlta  between '2026-03-17 06:00:00' and GETDATE()
--AND				OT in ('RV969010')

BEGIN TRAN
UPDATE [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
SET Estado='Cancelado', HoraActualizacion=GETDATE()
WHERE	
				PseudoLinea in ('TV4')
AND				Estado ='Pendiente'	
AND				FechaAlta NOT between '2026-03-17 06:00:00' and GETDATE()


Commit tran

---------------------------------------------------------------

SELECT	
		*
FROM	[WS].[RF].[RV_TBL_SIP_RFID_SERIE]
WHERE	
				PseudoLinea in ('TV3')
AND				Estado ='Pendiente'	
AND				FechaAlta between '2026-03-17 06:00:00' and GETDATE()
--AND				OT in ('RV969010')

BEGIN TRAN
UPDATE [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
SET Estado='Cancelado', HoraActualizacion=GETDATE()
WHERE	
				PseudoLinea in ('TV3')
AND				Estado ='Pendiente'	
AND				FechaAlta NOT between '2026-03-17 06:00:00' and GETDATE()


Commit tran