INSERT INTO	[WS].[RF].[RV_TBL_SIP_RFID_SERIE]([Company]
											  ,[OT]
											  ,[PartNum]
											  ,[ClassID]
											  ,[SerialNumber]
											  ,[ItemTag]
											  ,[PseudoLinea]
											  ,[ItemNumeroSerie]     
											  ,[JsonResponse]
											  ,[Fecha]
											  ,[Timestamp]
											  ,[ProdCode])
			
select		TOP 40
			SN.Company,
			SN.JobNum,
			SN.PartNum,
			P.ClassID,
			SN.SerialNumber,			
			'5256500052540323785545104140'	AS ItemTag,
			NULL							AS PseudoLinea,
			SN.SerialNumber					AS ItemNumeroSeri,
			'{"Prueba":"Prueba"}'			AS JsonResponse,
			1765809474						AS Fecha,	
			GETDATE()						AS Timestamp,
			P.ProdCode	
			
			

from		[CORPL11-EPIDB].[EpicorERPTest].Erp.SerialNo	AS SN
LEFT JOIN	[CORPL11-EPIDB].[EpicorERPTest].Erp.Part		AS P
	ON		P.Company		=			SN.Company
	AND		P.PartNum		=			SN.PartNum
where 
			SN.JobNum in ('RV965012')
AND			SN.SNStatus='WIP'
AND			SN.SerialNumber not in (
										SELECT	SerialNumber
										FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
										WHERE ot IN ('RV965012')

									)
			--JobNum in('RV288050', 'RV913025', 'RV965011', 'RV680011')

--Piloto
INSERT INTO	[WS].[RF].[RV_TBL_SIP_RFID_SERIE]([Company]
											  ,[OT]
											  ,[PartNum]
											  ,[ClassID]
											  ,[SerialNumber]
											  ,[ItemTag]
											  ,[PseudoLinea]
											  ,[ItemNumeroSerie]     
											  ,[JsonResponse]
											  ,[Fecha]
											  ,[Timestamp]
											  ,[ProdCode])
select		TOP 40
			SN.Company,
			SN.JobNum,
			SN.PartNum,
			P.ClassID,
			SN.SerialNumber,			
			'5256500052540323785545104140'	AS ItemTag,
			NULL							AS PseudoLinea,
			SN.SerialNumber					AS ItemNumeroSeri,
			'{"Prueba":"Prueba"}'			AS JsonResponse,
			1765809474						AS Fecha,	
			GETDATE()						AS Timestamp,
			P.ProdCode	
			
			

from		[CORPP11-EPIDB].[EpicorERP].Erp.SerialNo	AS SN
LEFT JOIN	[CORPP11-EPIDB].[EpicorERP].Erp.Part		AS P
	ON		P.Company		=			SN.Company
	AND		P.PartNum		=			SN.PartNum
where 
			SN.JobNum in ('RV680012')
AND			SN.SNStatus='WIP'
AND			SN.SerialNumber not in (
										SELECT	SerialNumber
										FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
										WHERE ot IN ('RV680012')

									)

SELECT	*
										FROM [WS].[RF].[RV_TBL_SIP_RFID_SERIE]
										WHERE ot IN ('RV965012')
select * from Erp.SerialNo where JobNum in('RV965012', 'RV680012')