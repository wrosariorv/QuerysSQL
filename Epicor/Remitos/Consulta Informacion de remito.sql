

SELECT 
				UDA.Company,
				UDA.Key1, UDA.Key2,
				UDA.Key3																AS		NroViaje,
				UDA.Key4, UDA.Key5,
				UDA.ShortChar07															AS		NroRemito,
				UDA.ShortChar09															AS		NroFactura,
				LTRIM(RTRIM(CAST(CAST(UDA.Number06 AS INTEGER) AS VARCHAR(15))))		AS		NroInternoRemito,
				LTRIM(RTRIM(CAST(CAST(UDA.Number08 AS INTEGER) AS VARCHAR(15))))		AS		NroInternoFactura,
				SH.ShipDate																AS		FechaEmisionRemito,
				ISC.PaySeq																AS		NumeroCuota,						
				ISC.PayDueDate															AS		FechaVtoCuota,
				UDA.CheckBox02															AS		Conforme
FROM 
	(
		SELECT 
				*
		FROM	[CORPEPIDB].EpicorERP.Ice.UD110A WITH (NoLock)
		WHERE	Key1 = 'ViajeCab'
	)																					AS		UDA

LEFT OUTER JOIN [CORPEPIDB].EpicorERP.Erp.ShipHead SH WITH (NoLock)
	ON		UDA.Company				=			SH.Company
	AND		UDA.Number06			=			SH.PackNum

LEFT OUTER JOIN [CORPEPIDB].EpicorERP.Erp.InvcSched ISC WITH (NoLock)
	ON		UDA.Company				=			ISC.Company
	AND		UDA.Number08			=			ISC.InvoiceNum

--------------------

WHERE		UDA.ShortChar07			<>			''
	AND		UDA.CheckBox02			=			 0

--------------------

ORDER BY 1, 2 DESC 
