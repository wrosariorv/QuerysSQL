

SELECT				ST.Company, ST.CustNum, ST.ShipToNum, ST.[Name], ST.SalesRepCode, 
					C.CustID, C.[Name]
FROM				[CORPEPIDB].EpicorErp.Erp.ShipTo			ST			WITH(NoLock)
INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Customer			C			WITH(NoLock)
	ON				C.Company				=				ST.Company
	AND				C.CustNum				=				ST.CustNum
WHERE				ST.SalesRepCode			LIKE			'Alc%'		COLLATE SQL_Latin1_General_CP1_CS_AS
	OR				ST.SalesRepCode			LIKE			'Rca%'		COLLATE SQL_Latin1_General_CP1_CS_AS
	OR				ST.SalesRepCode			LIKE			'Agr%'		COLLATE SQL_Latin1_General_CP1_CS_AS
	OR				ST.SalesRepCode			LIKE			'Hit%'		COLLATE SQL_Latin1_General_CP1_CS_AS
	OR				ST.SalesRepCode			LIKE			'Tcl%'		COLLATE SQL_Latin1_General_CP1_CS_AS
	OR				ST.SalesRepCode			LIKE			'Kel%'		COLLATE SQL_Latin1_General_CP1_CS_AS

/*

UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Alc%'		COLLATE SQL_Latin1_General_CP1_CS_AS


UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Rca%'		COLLATE SQL_Latin1_General_CP1_CS_AS


UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Agr%'		COLLATE SQL_Latin1_General_CP1_CS_AS


UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Hit%'		COLLATE SQL_Latin1_General_CP1_CS_AS


UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Tcl%'		COLLATE SQL_Latin1_General_CP1_CS_AS


UPDATE				[CORPEPIDB].EpicorErp.Erp.ShipTo 
	SET				SalesRepCode				=				UPPER(SalesRepCode)
WHERE				SalesRepCode				LIKE			'Kel%'		COLLATE SQL_Latin1_General_CP1_CS_AS

*/

