

select	CAST (ROUND((QD.OrdBasedPrice*QD.OrderQty) + QD.Tax, 2)AS DECIMAL(30,2) )							AS TotalLinea,
		CAST (ROUND(QD.DocExtPriceDtl - QD.DocDiscount +  ISNULL(Tax.DocTaxAmt, 0), 2)AS DECIMAL(30,2) )	AS NuevoTotalLinea,
		QD.OrdBasedPrice,
		QD.OrderQty,
		QD.Tax,
				* from [CORPEPIDB].EpicorERP.Erp.QuoteDtl									QD
LEFT OUTER JOIN		(
						SELECT			TXQD.Company, TXQD.QuoteNum, TXQD.QuoteLine, SUM(TXQD.DocTaxAmt) AS DocTaxAmt 					-- Monto de Impuestos en moneda del documento 
						FROM			[CORPEPIDB].EpicorErp.Erp.QuoteDtlTax							TXQD				WITH(NoLock)
						INNER JOIN		[CORPEPIDB].EpicorErp.Erp.SalesTax								STax			WITH(NoLock)
							ON			TXQD.Company				=					STax.Company
							AND			TXQD.TaxCode				=					STax.TaxCode
									/******************************************************************************
									Se excluyen los impuestos clasificados como Retenciones y Percepciones
									******************************************************************************/
						WHERE			STax.RPTCatCode				NOT IN			('PIIBB', 'PIVA', 'PIV', 'RIV', 'RIVA', 'RFFSS', 'RIIBB', 'RGAN', 'RSUSS')
						GROUP BY		TXQD.Company, TXQD.QuoteNum, TXQD.QuoteLine
					) Tax
	ON				QD.Company			=			Tax.Company
	AND				QD.QuoteNum			=			Tax.QuoteNum
	AND				QD.QuoteLine		=			Tax.QuoteLine

where
QD.QuoteNum	='119188'



select	CAST (ROUND(OD.DocExtPriceDtl - OD.DocDiscount +  ISNULL(Tax.DocTaxAmt, 0), 2)AS DECIMAL(30,2) )	AS TotalLinea,
		A.QuoteNum																					AS NumeroCotizacion,
		OD.DocExtPriceDtl,
		OD.DocDiscount,
		Tax.DocTaxAmt
				,* from [CORPEPIDB].EpicorERP.Erp.OrderDtl									OD			With (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.OrderHed									OH			With (NoLock)
	ON				OD.Company			=			OH.Company
	AND				OD.OrderNum			=			OH.OrderNum 
INNER JOIN 
			(
				SELECT OD.Company,OD.OrderNum,OD.QuoteNum  FROM [CORPEPIDB].EpicorERP.Erp.OrderDtl	OD	WITH (NoLock)
				GROUP BY OD.Company,OD.OrderNum,OD.QuoteNum
			)		A
	on				OH.Company			=			A.Company
	AND				OH.OrderNum			=			A.OrderNum
LEFT OUTER JOIN		(
					/*
					SELECT					Company, OrderNum, OrderLine, SUM(DocTaxAmt) AS DocTaxAmt  
					FROM					[CORPEPIDB].EpicorERP.Erp.OrderRelTax		WITH (NoLock)
					GROUP BY				Company, OrderNum, OrderLine
					*/
					SELECT			ORT.Company, ORT.OrderNum, ORT.OrderLine, SUM(DocTaxAmt) AS DocTaxAmt  
					FROM			[CORPEPIDB].EpicorERP.Erp.OrderRelTax	ORT		WITH (NoLock)
					/******************************************************************************
					Se busca la clasificacion de cada impuesto
					******************************************************************************/
					INNER JOIN		[CORPEPIDB].EpicorErp.Erp.SalesTax								STax			WITH(NoLock)
						ON			ORT.Company				=					STax.Company
						AND			ORT.TaxCode				=					STax.TaxCode
									/******************************************************************************
									Se excluyen los impuestos clasificados como Retenciones y Percepciones
									******************************************************************************/
					WHERE			STax.RPTCatCode				NOT IN			('PIIBB', 'PIVA', 'PIV', 'RIV', 'RIVA', 'RFFSS', 'RIIBB', 'RGAN', 'RSUSS')
					GROUP BY		ORT.Company, ORT.OrderNum, ORT.OrderLine
					) Tax
	ON				OD.Company			=			Tax.Company
	AND				OD.OrderNum			=			Tax.OrderNum
	AND				OD.OrderLine		=			Tax.OrderLine
where
OD.OrderNum	='144937'



Select * from RVF_VW_MOVI_ENCABEZADO_PEDIDOS
where
NOrden='144937'

Select * from RVF_VW_MOVI_DETALLE_PEDIDOS
where
NOrden='144937'