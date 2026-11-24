Use  PCDB
SELECT *  FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
where Estado='Pendiente'

SELECT *  FROM [PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where Estado='Pendiente'

SELECT *  FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
  WHERE TipoCaso='DP'
   order by TranNum desc

  select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
  where TranNum in (SELECT TranNum  FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
  WHERE TipoCaso='DP')

  order by TranNum desc

  select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
   where TranNum in (5444)

/****************************************************************************
****************************************************************************/

SELECT TOP (1000) [Company]
      ,[Tipo]
      ,[TranNum]
      ,[TipoCaso]
      ,[id_caso]
      ,[GroupID]
      ,[SoldToCustID]
      ,[InvoiceDate]
      ,[InvoiceRef]
      ,[InvRefLegNum]
      ,[TermsCode]
      ,[TaxRegionCode]
      ,[Comentario]
      ,[Fecha]
      ,[Estado]
      ,[FechaModificacion]
      ,[Eliminado]
      ,[InvoiceNum]
      ,[GroupoAsignado]
      ,[ExchangeRate]
  FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
  WHERE id_caso=26598


  select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
  where TranNum=5498

    select * from RV.RV_TBL_SIP_TAXES
  where TranNum=5498

  
  select * from RV.RV_TBL_SIP_LOG_PC
where TranNum in (5498)
order by Fecha desc

  ---------------------------------------
  select *
    FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
  WHERE TranNum in (5472,5473)


  select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
  where TranNum in (5472,5473)

  select * from RV.RV_TBL_SIP_LOG_PC
where TranNum in (5472,5473)
order by Fecha desc


---------------------------------

--ejemplo SO
SELECT *  FROM [PCDB].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
where TranNum=5498

SELECT *  FROM [PCDB].RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where TranNum=5498


SELECT *  FROM [PCDB].RV.RV_TBL_SIP_TAXES
where TranNum=5498
-------------------------------------------------
--Ejemplo DP
select * from RV.RV_TBL_SIP_LOG_PC
where TranNum in (
5570,
5571
)
order by Fecha desc

select * from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where 
id_caso
in (
20779,

20780
)

select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where 
TranNum
in (
5570,
5571
)

---------------------------------------------------
SELECT W.*
From	(
select 
			CAST(SUBSTRING(HD.PONum COLLATE Modern_Spanish_CI_AS, PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) + 3, LEN(HD.PONum) - PATINDEX('%PC-%', HD.PONum COLLATE Modern_Spanish_CI_AS) - 2) AS int) AS TranNumEncabezado
			,* 
from [CORPE11-EPIDB].[EpicorERP].dbo.InvcHead HD

where 
		HD.InvoiceType		=		'MIS' 
AND		HD.PoNum			LIKE	'PC-%'
) AS W
Where W.TranNumEncabezado in (
select 
		DISTINCT
		A.TranNum--, A.TipoCaso, A.id_caso
from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE A
LEFT JOIN RV.RV_TBL_SIP_LOG_PC B
ON A.Company	= B.company
AND A.TranNum	=B.TranNum
where 
		/*A.Fecha>'2026-06-20 10:00:01.500'
AND		*/B.Descripcion like '%Error:  EstatusCode: 400 ErrorMessage: For Credit Memo, Reference Invoice is required.'
AND		B.Proceso='SendRequest-Erp.BO.ARInvoiceSvc/UpdateMaster'
)

select 
		DISTINCT
		A.TranNum, A.TipoCaso, A.id_caso
from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE A
LEFT JOIN RV.RV_TBL_SIP_LOG_PC B
ON A.Company	= B.company
AND A.TranNum	=B.TranNum
where 
		/*A.Fecha>'2026-06-20 10:00:01.500'
AND		*/B.Descripcion like '%Error:  EstatusCode: 400 ErrorMessage: For Credit Memo, Reference Invoice is required.'
AND		B.Proceso='SendRequest-Erp.BO.ARInvoiceSvc/UpdateMaster'