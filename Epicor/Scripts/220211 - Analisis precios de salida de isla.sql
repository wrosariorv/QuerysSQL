

SELECT				T1.Company, T1.PackNum, T1.ShipDate, T1.LegalNumber, 
					T2.Packline, T2.LineType, T2.PartNum, T2.LineDesc, T2.Plant, T2.Quantity,  
					T12.ForeignSysRowID, T12.ShortChar04, T12.Number12, 
					T4.BasePrice 

FROM				[CORPEPIDB].EpicorErp.Erp.MscShpHd			T1

INNER JOIN			[CORPEPIDB].EpicorErp.Erp.MscShpDt			T2
 	ON				T1.Company				=				T2.Company 
	AND				T1.PackNum				=				T2.PackNum 

INNER JOIN			[CORPEPIDB].EpicorErp.Erp.MscShpDt_UD		T12
	ON				T2.SysRowID				=				T12.ForeignSysRowID	 

LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part				T3 
	ON				T3.Company				=				T2.Company 
	AND				T3.PartNum				=				T2.PartNum 

LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.Part_UD			T13 
	ON				T3.SysRowID				=				T13.ForeignSysRowID	 
	
LEFT OUTER JOIN		[CORPEPIDB].EpicorErp.Erp.PriceLstParts		T4 
	ON				T4.Company				=				T3.Company 
	AND				T4.ListCode				=				T13.ShortChar06 
	AND				T4.PartNum				=				T3.PartNum 

WHERE				T2.Company				=				'CO01'
--	AND				T2.PackNum				IN				(755, 1039, 1014)
--	AND				T12.Number12			<>				0

ORDER BY			T2.PackNum DESC 