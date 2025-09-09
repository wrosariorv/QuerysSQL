
/*

Validate you have enough onhand quantity to process the transfer without leaving it in negative onhand.
Run a BAQ against ShipHead table and select the field Status
Add table ShipDtl and filter by PartNum affected, select the fields Company, PackNum, PackLine, PartNum
Run the BAQ and filter by pack num with status open.
Open those pack slips at Customer Shipment Entry and identify the line requesting that part number, 
either ship the pack slip or delete the line from the pack slip to get that quantity available. 
Process the inventory transfer again, won't get the warning.

*/

/*

Verificar que todos los remitos despachados tienen marcada en TRUE la casilla ReadyToInvoice en ShipHead y ShipDtl

*/


DECLARE			@PartNum VARCHAR(50)		=				'AAPR12K'


SELECT			SH.ShipStatus,  SH.ReadyToInvoice, SD.ReadyToInvoice, SD.Invoiced, SH.*
FROM			[CORPEPIDB].EpicorErp.Erp.ShipHead			SH				WITH (NoLock)
INNER JOIN		[CORPEPIDB].EpicorErp.Erp.ShipDtl			SD				WITH (NoLock)
	ON			SH.Company					=				SD.Company
	AND			SH.PackNum					=				SD.PackNum
WHERE			PartNum						=				@PartNum
	AND			(
				SH.ShipStatus				IN				('INVOICED', 'SHIPPED')
				AND
					(
					SH.ReadyToInvoice			=				0
					OR
					SD.ReadyToInvoice			=				0
					)
				)

/*

UPDATE			[CORPEPIDB].EpicorErp.Erp.ShipHead
SET				ReadyToInvoice				=				1
WHERE			ReadyToInvoice				=				0
	AND			PackNum						=				185595
	AND			Company						=				'CO01'
	AND			Invoiced					=				1


UPDATE			[CORPEPIDB].EpicorErp.Erp.ShipDtl
SET				ReadyToInvoice				=				1
WHERE			ReadyToInvoice				=				0
	AND			PackNum						=				185595
	AND			Company						=				'CO01'
	AND			Invoiced					=				1

*/
