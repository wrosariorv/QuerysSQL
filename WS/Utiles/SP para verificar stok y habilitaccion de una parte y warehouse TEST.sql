

--/*
 
DECLARE				@Company					VARCHAR(15)			=		'CO01', 

					@PartNum					VARCHAR(150)		=		'T613P1-FAAVAR11', 

					@WarehouseCodeSalida		VARCHAR(15)			=		'STG',  

					@BinNumSalida 				VARCHAR(15)			=		'STGDESP', 

					@WarehouseCodeDestino		VARCHAR(15)			=		'OUT-C', 

					@BinNumDestino 				VARCHAR(15)			=		'99-99-99'  
 
--*/

/* 

DECLARE				@Company					VARCHAR(15)			=		'CO01', 

					@PartNum					VARCHAR(150)		=		'L43S5400-F', 

					@WarehouseCodeSalida		VARCHAR(15)			=		'GR-FRA',--'SJDESV',  

					@BinNumSalida 				VARCHAR(15)			=		'99-99-99', 

					@WarehouseCodeDestino		VARCHAR(15)			=		'OUT-C'

--*/

/*
 
DECLARE				@Company					VARCHAR(15)			=		'CO01', 

					@PartNum					VARCHAR(150)		=		'L43S5400-F', 

					@WarehouseCodeSalida		VARCHAR(15)			=		'SJDESV',  

					@BinNumSalida 				VARCHAR(15)			=		'99-99-99', 

					@WarehouseCodeDestino		VARCHAR(15)			=		'OUT-C'
 
--*/
 
-------------------------------------------------------------------------------------------------
 
DECLARE				@ControlWhseSalida	TABLE				(

															Company						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															PartNum						VARCHAR(150)			COLLATE		SQL_Latin1_General_CP1_CI_AS,

															WarehouseCodeSalida			VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															Plant						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS

															)

INSERT INTO			@ControlWhseSalida

SELECT				PW.Company, 

										PW.PartNum, 

										PW.WarehouseCode										AS	WarehouseCodeSalida,  

										W.Plant  

					FROM				[CORPL11-EPIDB].EpicorErpTest.Erp.PartWhse			PW

					LEFT OUTER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.WareHse			W

						ON				PW.Company				=				W.Company

						AND				PW.WarehouseCode		=				W.WarehouseCode

					WHERE				PW.Company				=				@Company

						AND				PW.PartNum				=				@PartNum

						AND				PW.WarehouseCode		=				@WarehouseCodeSalida
 
-------------------------------------------------------------------------------------------------
 
DECLARE				@ControlWhseDestino	TABLE				(

															Company						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															Plant						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															PartNum						VARCHAR(150)			COLLATE		SQL_Latin1_General_CP1_CI_AS,

															WarehouseCodeDestino		VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															StockWhseDestino			DECIMAL(23,5)

															)

INSERT INTO			@ControlWhseDestino

SELECT				W.Company, W.Plant, 

					PW.PartNum, PW.WarehouseCode, PW.OnhandQty											AS	StockWhseDestino 

FROM				[CORPL11-EPIDB].EpicorErpTest.Erp.PartWhse			PW

LEFT OUTER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.WareHse			W

	ON				PW.Company				=				W.Company

	AND				PW.WarehouseCode		=				W.WarehouseCode

WHERE				PW.Company				=				@Company

	AND				PW.PartNum				=				@PartNum

	AND				PW.WarehouseCode		=				@WarehouseCodeDestino 

-------------------------------------------------------------------------------------------------
 
DECLARE				@ControlBinDestino	TABLE				(

															Company						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															Plant						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															PartNum						VARCHAR(150)			COLLATE		SQL_Latin1_General_CP1_CI_AS,

															WarehouseCodeDestino		VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															BinNumDestino				VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															StockBinDestino				DECIMAL(23,5)

															)

INSERT INTO			@ControlBinDestino

SELECT				W.Company, W.Plant, 

					PB.PartNum, PB.WarehouseCode, PB.BinNum, 

					PB.OnhandQty											AS	StockWhseDestino 

FROM				[CORPL11-EPIDB].EpicorErpTest.Erp.PartBin			PB

LEFT OUTER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.WareHse			W

	ON				PB.Company				=				W.Company

	AND				PB.WarehouseCode		=				W.WarehouseCode

WHERE				PB.Company				=				@Company

	AND				PB.PartNum				=				@PartNum

	AND				PB.WarehouseCode		=				@WarehouseCodeDestino 

	AND				PB.BinNum				=				@BinNumDestino 

-------------------------------------------------------------------------------------------------
 
DECLARE				@ControlBinSalida	TABLE				(

															Company						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															Plant						VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															PartNum						VARCHAR(150)			COLLATE		SQL_Latin1_General_CP1_CI_AS,

															WarehouseCode				VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															BinNumSalida				VARCHAR(15)				COLLATE		SQL_Latin1_General_CP1_CI_AS, 

															StockBinSalida				DECIMAL(23,5)

															)

INSERT INTO			@ControlBinSalida

SELECT				W.Company, W.Plant, 

					PB.PartNum, PB.WarehouseCode, 

					PB.BinNum												AS	BinNumSalida, 

					PB.OnhandQty											AS	StockBinSalida 

FROM				[CORPL11-EPIDB].EpicorErpTest.Erp.PartBin				PB

LEFT OUTER JOIN		[CORPL11-EPIDB].EpicorErpTest.Erp.WareHse				W

	ON				PB.Company				=				W.Company

	AND				PB.WarehouseCode		=				W.WarehouseCode

WHERE				PB.Company				=				@Company

	AND				PB.PartNum				=				@PartNum

	AND				PB.WarehouseCode		=				@WarehouseCodeSalida

	AND				PB.BinNum				=				@BinNumSalida

-------------------------------------------------------------------------------------------------
 
IF					(

					SELECT				COUNT(*)

					FROM				@ControlWhseSalida

					)	=	0

	BEGIN

					INSERT INTO			@ControlWhseSalida

					SELECT				@Company, @PartNum, NULL, NULL

	END
 
-------------------------------------------------------------------------------------------------
 
SELECT				A.Company, A.PartNum, A.Plant, A.WarehouseCodeSalida, 

					ISNULL(C.BinNumSalida, @BinNumSalida)				AS BinNumSalida, 

					ISNULL(C.StockBinSalida, 0)							AS StockBinSalida, 

					B.WarehouseCodeDestino, 

					B.StockWhseDestino, 

					D.BinNumDestino, 

					D.StockBinDestino

FROM				@ControlWhseSalida		A

LEFT OUTER JOIN		@ControlWhseDestino		B

	ON				A.Company			=			B.Company

	AND				A.PartNum			=			B.PartNum

LEFT OUTER JOIN		@ControlBinSalida		C

	ON				A.Company					=			C.Company

	AND				A.PartNum					=			C.PartNum

	AND				A.Plant						=			C.Plant

	AND				A.WarehouseCodeSalida		=			C.WarehouseCode

LEFT OUTER JOIN		@ControlBinDestino		D

	ON				B.Company					=			D.Company

	AND				B.PartNum					=			D.PartNum

	AND				B.Plant						=			D.Plant

	AND				B.WarehouseCodeDestino		=			D.WarehouseCodeDestino
 
 
 