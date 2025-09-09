
USE		RVF_Local

GO

-- /*

CREATE PROCEDURE		RVF_PRC_DETALLE_SERIES_FABRICADAS_ENTRE_FECHAS
									@Company			VARCHAR(15)		=			'CO01', 
									@FechaDesde			DATE, 
									@FechasHasta		DATE, 
									@ProdCode			VARCHAR(15), 
									@UnNeg				VARCHAR(15), 
									@FabricadoComprado	VARCHAR(5)	

AS

-- */

/*****************************************************************
Detalle de series fabricadas
*****************************************************************/

SET DATEFORMAT DMY

 /*
 
DECLARE				@Company			VARCHAR(15)		=			'CO01', 
					@FechaDesde			DATE			=			'01/01/2020', 
					@FechasHasta		DATE			=			'31/07/2021', 
					@ProdCode			VARCHAR(15)		=			'CEL', 
					@UnNeg				VARCHAR(15)		=			'TCL', 
					@FabricadoComprado	VARCHAR(5)		=			'C' 
 */

-----------------------------------------------------------------------------

DECLARE				@TranType			VARCHAR(15)		=			'MFG-STK' 

-----------------------------------------------------------------------------

IF					@FabricadoComprado	=	'F'

-----------------------------------------------------------------------------

		BEGIN

					SELECT				SNT.Company, SNT.PartNum, SNT.SerialNumber, SNT.TranType, SNT.TranDate, SNT.JobNum, SNT.PrevSNStatus, 
										P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode, 
										PU.Character02					AS		UnNeg 

					FROM				[CORPEPIDB].EpicorErp.Erp.SNTRan				SNT				With(NoLock)
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P				With(NoLock)
						ON				SNT.Company				=				P.Company
						AND				SNT.PartNum				=				P.PartNum	
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD				PU				With(NoLock)
						ON				P.SysRowID				=				PU.ForeignSysRowID

					WHERE				SNT.Company				=				@Company 
						AND				SNT.TranDate			BETWEEN			@FechaDesde		AND		@FechasHasta
						AND				P.ProdCode				=				@ProdCode	
						AND				PU.Character02			=				@UnNeg	
						AND				SNT.TranType			=				@TranType 
						
					ORDER BY			SNT.Company, SNT.PartNum, SNT.SerialNumber 

		END

-----------------------------------------------------------------------------

ELSE 

-----------------------------------------------------------------------------

		BEGIN 

					SELECT				SNT.Company, SNT.PartNum, SNT.SerialNumber, SNT.TranType, SNT.TranDate, SNT.JobNum, SNT.PrevSNStatus, 
										P.SearchWord, P.PartDescription, P.ClassID, P.ProdCode, 
										PU.Character02					AS		UnNeg 

					FROM				[CORPEPIDB].EpicorErp.Erp.SNTRan				SNT				With(NoLock)
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part					P				With(NoLock)
						ON				SNT.Company				=				P.Company
						AND				SNT.PartNum				=				P.PartNum	
					INNER JOIN			[CORPEPIDB].EpicorErp.Erp.Part_UD				PU				With(NoLock)
						ON				P.SysRowID				=				PU.ForeignSysRowID

					WHERE				SNT.Company				=				@Company 
						AND				SNT.TranDate			BETWEEN			@FechaDesde		AND		@FechasHasta
						AND				P.ProdCode				=				@ProdCode	
						AND				PU.Character02			=				@UnNeg	
						AND				(
										SNT.PrevSNStatus		=				''
										AND
										SNT.TranType			=				'MAINT'
										)
					
					ORDER BY			SNT.Company, SNT.PartNum, SNT.SerialNumber 
		END

-----------------------------------------------------------------------------



