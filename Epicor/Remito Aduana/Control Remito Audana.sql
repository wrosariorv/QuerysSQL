
Select			MS.Company, MS.PackNum, MS.OrderNum, MS.LegalNumber, MS.ShipDate, MS.EntryPerson, MS.ShipStatus, MS.ShipToNum, MS.CustNum, C.CustID, C.Name, MS.Plant, MS.JobNum, MS.Name, MS.Address1, MS.Address2, MS.Address3, MS.City, MS.State, MS.ZIP, MS.Country
				--,* 
from			[CORPL11-EPIDB].[EpicorERPDev].Erp.[MscShpHd]	MS
INNER JOIN		[CORPL11-EPIDB].[EpicorERPDev].Erp.[Customer]	C
ON				MS.Company		=		C.Company
AND				MS.CustNum		=		C.CustNum
where	
				MS.Company			=		'CO01'
AND				MS.LegalNumber		=		''
AND				MS.ShipStatus		=		'Open'
AND				MS.PackNum			=		8

Select			Company, PackNum, PackLine, PartNum, LineDesc, IUM, CustNum, ShipToNum, EffectiveDate, Plant, Quantity
				--, * 
from			[CORPL11-EPIDB].[EpicorERPDev].Erp.[MscShpDt]
where			
				Company			=		'CO01'
AND				PackNum			=		8

Select			* 
from			[CORPL11-EPIDB].[EpicorERPDev].Ice.Ud40 UD
where			
				UD.Company		=		'CO01'
AND				UD.Key1			=		'RemitoDeAduana'
AND				UD.Key2			=		'10324'
AND				UD.Key3			=		'L75C645-F'
AND				UD.Key4			=		'RT3289360284999'
AND				UD.Key5			=		''
AND				UD.ShortChar01	=		'Aduana'