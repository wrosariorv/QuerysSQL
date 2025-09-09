USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_MFG_TOTALES_PRODUCCION_OT]    Script Date: 12/05/2022 16:00:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*

ALTER PROCEDURE	[dbo].[RVF_PRC_MFG_TOTALES_PRODUCCION_OT]		@Company	VARCHAR(15), 
															@FechaDesde	DATETIME, 
															@FechaHasta	DATETIME
AS

 */

SET DATEFORMAT DMY

 --/*

DECLARE				@Company	VARCHAR(15)			=			'CO01', 
					@FechaDesde	DATETIME			=			'04/01/2017', 
					@FechaHasta	DATETIME			=			'31/12/2022' 

 --*/
 Select * from (

SELECT				PT.Company, PT.Plant, 
					JH.PartNum, JH.ProdCode, 
					UPPER(PT.JobNum)						AS		JobNum, 
					SUM(PT.TranQty)						AS		TranQty 
FROM				[CORPEPIDB].EpicorERP.Erp.PartTran							PT		WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.JobHead							JH		WITH (NoLock)
	ON				PT.Company					=				JH.Company
	AND				PT.JobNum					=				JH.JobNum
WHERE				PT.Company					IN				('CO01','CO02','CO03')
	AND				PT.TranDate					BETWEEN			@FechaDesde		AND			@FechaHasta
	AND				PT.TranType					=				'MFG-STK'
GROUP BY			PT.Company, PT.JobNum, PT.Plant, JH.PartNum, JH.ProdCode 
--ORDER BY			PT.Company, PT.JobNum 
)W
where
W.JobNum in ('RV922010','RV922015','RV922025','RV923010','RV923015')
GO

SET DATEFORMAT DMY
select  Company, TranNum, PartNum, WareHouseCode, BinNum, trandate, UPPER(PT.JobNum)						AS		JobNum  FROM				[CORPEPIDB].EpicorERP.Erp.PartTran							PT
where 
PT.JobNum <> ''
AND PT.TranDate					BETWEEN			'04/01/2021'		AND			'31/12/2022'
--AND PT.JobNum in ('RV922010','RV922015','RV922025','RV923010','RV923015','RV139001')
AND PT.Company ='CO01'
order by 1,7

PT.JobNum in ('RV922010','RV922015','RV922025','RV923010','RV923015','RV139001')




