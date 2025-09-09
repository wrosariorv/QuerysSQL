USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_FIN_CONSULTA_CLIENTE_SHIPTO]    Script Date: 25/08/2022 10:35:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--/*
ALTER PROCEDURE [dbo].[RVF_PRC_FIN_CONSULTA_CLIENTE_SHIPTO]	
						@Company	VARCHAR(15), 
						@CustID		VARCHAR(30), 
						@UN			VARCHAR(15), 
						@UNDef		VARCHAR(15)

AS
--*/
DECLARE		
/*
---------------------------------------------
@Company	VARCHAR(15) = 'CO01', 
@CustID		VARCHAR(30) = '', 
@UN			VARCHAR(15) = '', 
@UNDef		VARCHAR(15) = ' Todas',
---------------------------------------------
*/
		@UNIni			VARCHAR(15), 
		@UNFin			VARCHAR(15),
		@UNDefIni		VARCHAR(15), 
		@UNDefFin		VARCHAR(15),
		@CustIDIni	VARCHAR(30),
		@CustIDFin	VARCHAR(30)

---------------------------------------------

IF		@CustID	=	''	
		BEGIN		
				SELECT		@CustIDIni	=		'', 
							@CustIDFin	=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@CustIDIni	=		@CustID	, 
							@CustIDFin	=		@CustID	
		END 

---------------------------------------------

------------------------------------------------------------------------------------------------------------------

IF		@UN		=	''	
		BEGIN		
				SELECT		@UNIni			=		'', 
							@UNFin			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@UNIni			=		@UN	, 
							@UNFin			=		@UN	
		END 

------------------------------------------------------------------------------------------------------------------

IF		@UNDef		=	' Todas'	
		BEGIN		
				SELECT		@UNDefIni			=		'', 
							@UNDefFin			=		'ZZZZZZZZZZZZZZZ'
		END 
	ELSE
		BEGIN		
				SELECT		@UNDefIni			=		@UNDef	, 
							@UNDefFin			=		@UNDef	
		END 

------------------------------------------------------------------------------------------------------------------

SELECT			ST.Company,C.CustID,  ST.ShipToNum, ST.Name, ST.Address1, ST.City, ST.[State], ST.SalesRepCode, ST.TerritoryID, ST.ShipViaCode, 
				STUD.ShortChar01, STUD.ShortChar03, STUD.ShortChar04, STUD.Character02, 
				STe.TerritoryDesc, 
				SRe.Name			AS		SalesRep_Name
FROM			[CORPEPIDB].EpicorERP.Erp.ShipTo		ST	WITH (NoLock)
INNER JOIN		[CORPEPIDB].EpicorERP.Erp.ShipTo_UD		STUD	WITH (NoLock)
	ON			ST.SysRowID		=			STUD.ForeignSysRowID
INNER JOIN		(
				SELECT			*
				FROM			[CORPEPIDB].EpicorERP.Erp.Customer			WITH (NoLock)
				WHERE			Company				=			@Company
					AND			CustID				BETWEEN		@CustIDIni	AND		@CustIDFin
				) C
	ON			C.Company		=		ST.Company
	AND			C.CustNum		=		ST.CustNum
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.SalesTer		STe	WITH (NoLock)
	ON			ST.Company		=		STe.Company
	AND			ST.TerritoryID	=		STe.TerritoryID
LEFT OUTER JOIN	[CORPEPIDB].EpicorERP.Erp.SalesRep		SRe	WITH (NoLock)
	ON			ST.Company		=		SRe.Company
	AND			ST.SalesRepCode	=		SRe.SalesRepCode	

WHERE			ST.ShipToNum		<>			''
	AND 		ST.Company			=			@Company
	AND			STUD.Character02		BETWEEN		@UNIni		AND		@UNFin
	AND			STUD.Character02		BETWEEN		@UNDefIni	AND		@UNDefFin

GO


