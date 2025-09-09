
/*
En algún momento me podrás tirar un reporte con todos los clientes (ventas) de Alcatel 
donde figure total ventas, 
margen bruto, 
total NC, 
no se si se puede sacar el margen final (o sea Margen bruto - Notas de crédito por volumen o sellout) 
y cantidades de celus o tableta por cliente,
durante el año 2021.
*/

SET DATEFORMAT DMY


SELECT			IH.Company, IH.CreditMemo, IH.Posted, IH.InvoiceNum, IH.InvoiceDate, IH.CurrencyCode, IH.ExchangeRate, IH.LegalNumber,			
				ID.InvoiceLine, ID.PartNum, ID.ProdCode, ID.SellingShipQty, 
				C.CustID, C.[Name], C.GroupCode, C.ReminderCode, 
				IHU.PAC_InvoiceRef_c									AS		DocVinculado, 
				LEFT(IHU.Character07, 5)								AS		UnNeg, 
				IDU.Number09											AS		MargenBruto, 
				IDU.Number11											AS		VentaLinea, 
				IDU.Number10											AS		IngresoTotal, 
				IDU.Number08											AS		MargenTotal, 
				CASE 
					WHEN	ID.ProdCode			IN						('CEL', 'TAB')
					THEN												ID.SellingShipQty
					ELSE												0
				END														AS		'Unidades', 
				CASE 
					WHEN	ID.ProdCode			IN						('CEL', 'TAB', 'SELL', 'ACUSUP')
					THEN												'Si'
					ELSE												'No'
				END														AS		'Vta_Sell' 

FROM			[CORPEPIDB].EpicorErp.Erp.InvcDtl			ID				WITH (NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcDtl_UD		IDU				WITH (NoLock)
	ON			ID.SysRowID				=				IDU.ForeignSysRowID
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead			IH				WITH (NoLock)
	ON			ID.Company				=				IH.Company
	AND			ID.InvoiceNum			=				IH.InvoiceNum
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.InvcHead_UD		IHU				WITH (NoLock)
	ON			IH.SysRowID				=				IHU.ForeignSysRowID
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.Customer			C				WITH (NoLock)
	ON			C.Company				=				IH.Company
	AND			C.CustNum				=				IH.CustNum

WHERE			IH.Company				=				'CO02'
	AND			IH.InvoiceSuffix		NOT IN			('UR')
	AND			IH.Posted				=				1
	AND			IH.InvoiceDate			BETWEEN			'01/01/2021'		AND			'31/12/2021'
	AND			IHU.Character07			=				'ALC'

ORDER BY		IH.Company, IH.InvoiceDate, IH.LegalNumber