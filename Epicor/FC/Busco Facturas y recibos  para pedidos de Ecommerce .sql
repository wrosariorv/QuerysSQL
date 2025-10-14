--Busco Facturas generadas por OV 
SELECT          
				DISTINCT
                IH.Company, 
                IH.InvoiceNum,
				--ID.PartNum,
				IH.LegalNumber

FROM            [CORPE11-EPIDB].[EpicorERP].Erp.InvcHead             IH      WITH(NoLock)
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.InvcDtl             ID      WITH(NoLock)
    ON          IH.Company              =       ID.Company
    AND         IH.InvoiceNum           =       ID.InvoiceNum 
INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.Part                   P       WITH(NoLock)
    ON          ID.Company              =       P.Company
    AND         ID.PartNum              =       P.PartNum
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.OrderDtl             OD      WITH(NoLock)
    ON          ID.Company              =       OD.Company
    AND         ID.OrderNum             =       OD.OrderNum 
    AND         ID.OrderLine            =       OD.OrderLine 
INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.OrderHed             OH      WITH(NoLock)
	ON          OH.Company              =       OD.Company
    AND         OH.OrderNum             =       OD.OrderNum 
 
WHERE           
				IH.Company              =       'CO01'
	--AND         ID.PartNum NOT LIKE '%-SK%'
    AND         P.ClassID IN ('PTF', 'PTCO', 'SK', 'SKCO', 'REVI', 'REVN') --Filtro por las clases de productos para la venta
	AND			OH.CustNum =12934 --Filtro por OV de Cliente 'VENTAS ECOMMERCE'


	--Busco recibos de cobranzas aplicado a Factura
SELECT          
				DISTINCT
                CD.Company, 
				
                CD.InvoiceNum,
				--ID.PartNum,
				CH.HeadNum	,
				IH.LegalNumber

FROM            [CORPE11-EPIDB].EpicorErp.Erp.CashDtl				CD		WITH(NoLock)

INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.CashHead					CH
	ON			CD.Company              =       CH.Company
    AND         CD.InvoiceNum           =       CH.InvoiceNum 
INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.InvcHead            IH      WITH(NoLock)
	ON			CH.Company              =       IH.Company
    AND         CD.InvoiceNum           =       IH.InvoiceNum 
INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.InvcDtl             ID      WITH(NoLock)
    ON          IH.Company              =       ID.Company
    AND         IH.InvoiceNum           =       ID.InvoiceNum 
INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.Part                   P       WITH(NoLock)
    ON          ID.Company              =       P.Company
    AND         ID.PartNum              =       P.PartNum
WHERE           
				IH.Company              =       'CO01'
	
    AND         P.ClassID IN ('PTF', 'PTCO', 'SK', 'SKCO', 'REVI', 'REVN')

	select * from [CORPE11-EPIDB].[EpicorERP].Erp.Orderhead


	--Busco recibos de cobranzas aplicado a Factura de Ecommerce
	SELECT		
				DISTINCT
				CH.Company,
				CH.HeadNum,
				CD.InvoiceNum
	FROM		(
					SELECT          
									--DISTINCT
									IH.Company, 
									IH.InvoiceNum,
									--ID.PartNum,
									IH.LegalNumber

					FROM            [CORPE11-EPIDB].[EpicorERP].Erp.InvcHead             IH      WITH(NoLock)
					INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.InvcDtl             ID      WITH(NoLock)
						ON          IH.Company              =       ID.Company
						AND         IH.InvoiceNum           =       ID.InvoiceNum 
					INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.Part                   P       WITH(NoLock)
						ON          ID.Company              =       P.Company
						AND         ID.PartNum              =       P.PartNum
					INNER JOIN      [CORPE11-EPIDB].[EpicorERP].Erp.OrderDtl             OD      WITH(NoLock)
						ON          ID.Company              =       OD.Company
						AND         ID.OrderNum             =       OD.OrderNum 
						AND         ID.OrderLine            =       OD.OrderLine 
					INNER JOIN		[CORPE11-EPIDB].[EpicorERP].Erp.OrderHed             OH      WITH(NoLock)
						ON          OH.Company              =       OD.Company
						AND         OH.OrderNum             =       OD.OrderNum 
 
					WHERE           
									IH.Company              =       'CO01'
						--AND         ID.PartNum NOT LIKE '%-SK%'
						AND         P.ClassID IN ('PTF', 'PTCO', 'SK', 'SKCO', 'REVI', 'REVN') --Filtro por las clases de productos para la venta
						AND			OH.CustNum =12934 --Filtro por OV de Cliente 'VENTAS ECOMMERCE'


				)	AS W

INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.CashDtl					CD		WITH(NoLock)
	ON			W.Company              =       CD.Company
    AND         W.InvoiceNum           =       CD.InvoiceNum 

INNER JOIN		[CORPE11-EPIDB].EpicorErp.Erp.CashHead					CH
	ON			CD.Company              =       CH.Company
    AND         CD.InvoiceNum           =       CH.InvoiceNum 