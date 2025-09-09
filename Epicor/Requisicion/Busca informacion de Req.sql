USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_CONSULTA_REQ_SUG_OC]    Script Date: 12/05/2022 12:20:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





 /*

ALTER PROCEDURE	[dbo].[RVF_PRC_CONSULTA_REQ_SUG_OC]				@Company		VARCHAR(15)			=		'CO01', 
															@ReqNum			BIGINT, 
															@SugNum			BIGINT, 
															@PONum			BIGINT, 
															@ReqID			VARCHAR(30), 
															@CurDispID		VARCHAR(50), 
															@Estado			VARCHAR(5), 
															@ClassID		VARCHAR(15), 
															@ReqActDesc		VARCHAR(50), 
															@BuyerID		VARCHAR(15), 
															@Plant			VARCHAR(15) 

AS

 */

DECLARE	
-----------------------------------------------------	
 --/*
					@Company		VARCHAR(15)			=		'CO01', 
					@ReqNum			BIGINT				=		'', 
					@SugNum			BIGINT				=		'', 
					@PONum			BIGINT				=		'', 
					@ReqID			VARCHAR(30)			=		'', 
					@CurDispID		VARCHAR(50)			=		'', 
					@Estado			VARCHAR(5)			=		'ZZZZZ', 
					@ClassID		VARCHAR(15)			=		'', 
					@ReqActDesc		VARCHAR(50)			=		'', 
					@BuyerID		VARCHAR(15)			=		'', 
					@Plant			VARCHAR(15)			=		'', 
 --*/
-----------------------------------------------------	
					@ReqNumIni		BIGINT, 
					@ReqNumFin		BIGINT, 
					@SugNumIni		BIGINT, 
					@SugNumFin		BIGINT, 
					@PONumIni		BIGINT, 
					@PONumFin		BIGINT, 
					@ReqIDIni		VARCHAR(30), 
					@ReqIDFin		VARCHAR(30),	
					@CurDispIni		VARCHAR(50), 
					@CurDispFin		VARCHAR(50),	
					@EstadoIni		VARCHAR(5), 
					@EstadoFin		VARCHAR(5),	
					@ClassIDIni		VARCHAR(15), 
					@ClassIDFin		VARCHAR(15), 
					@ReqActDescIni	VARCHAR(50), 
					@ReqActDescFin	VARCHAR(50), 
					@BuyerIDIni		VARCHAR(15), 
					@BuyerIDFin		VARCHAR(15),	
					@PlantIni		VARCHAR(15), 
					@PlantFin		VARCHAR(15)	

-----------------------------------------------------

IF			@ReqNum		=	''	
			BEGIN		
					SELECT		@ReqNumIni		=		'0', 
								@ReqNumFin		=		'999999999999'
			END 
		ELSE
			BEGIN		
					SELECT		@ReqNumIni		=		@ReqNum, 
								@ReqNumFin		=		@ReqNum
			END 

-----------------------------------------------------

IF			@SugNum		=	''	
			BEGIN		
					SELECT		@SugNumIni		=		'0', 
								@SugNumFin		=		'999999999999'
			END 
		ELSE
			BEGIN		
					SELECT		@SugNumIni		=		@SugNum, 
								@SugNumFin		=		@SugNum
			END 

-----------------------------------------------------

IF			@PONum		=	''	
			BEGIN		
					SELECT		@PONumIni		=		'0', 
								@PONumFin		=		'999999999999'
			END 
		ELSE
			BEGIN		
					SELECT		@PONumIni		=		@PONum, 
								@PONumFin		=		@PONum
			END 

-----------------------------------------------------

IF			@ReqID		=	'' 
			BEGIN		
					SELECT		@ReqIDIni		=		'', 
								@ReqIDFin		=		'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@ReqIDIni		=		@ReqID, 
								@ReqIDFin		=		@ReqID
			END 

-----------------------------------------------------

IF			@CurDispID		=	'' 
			BEGIN		
					SELECT		@CurDispIni		=		'', 
								@CurDispFin		=		'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@CurDispIni		=		@CurDispID, 
								@CurDispFin		=		@CurDispID
			END 

-----------------------------------------------------

IF			@Estado		=	'ZZZZZ' 
			BEGIN		
					SELECT		@EstadoIni		=		'', 
								@EstadoFin		=		'ZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@EstadoIni		=		@Estado, 
								@EstadoFin		=		@Estado
			END 

-----------------------------------------------------

IF			@ClassID		=	'' 
			BEGIN		
					SELECT		@ClassIDIni		=		'', 
								@ClassIDFin		=		'ZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@ClassIDIni		=		@ClassID, 
								@ClassIDFin		=		@ClassID
			END 

-----------------------------------------------------

IF			@ReqActDesc		=	'' 
			BEGIN		
					SELECT		@ReqActDescIni	=		'', 
								@ReqActDescFin	=		'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@ReqActDescIni	=		@ReqActDesc, 
								@ReqActDescFin	=		@ReqActDesc
			END 

-----------------------------------------------------

IF			@BuyerID		=	'' 
			BEGIN		
					SELECT		@BuyerIDIni		=		'', 
								@BuyerIDFin		=		'ZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@BuyerIDIni		=		@BuyerID, 
								@BuyerIDFin		=		@BuyerID
			END 

-----------------------------------------------------

IF			@Plant		=	'' 
			BEGIN		
					SELECT		@PlantIni		=		'', 
								@PlantFin		=		'ZZZZZZZZZZZZZZZ'
			END 
		ELSE
			BEGIN		
					SELECT		@PlantIni		=		@Plant, 
								@PlantFin		=		@Plant
			END 

-----------------------------------------------------
SET DATEFORMAT dmy;

SELECT				RH.Company, RH.ReqNum, RH.OpenReq, RH.RequestorID, RH.RequestDate, RH.CommentText, RH.ReqActionID, 
					RH.CurrDispatcherID, 
					CASE	RH.StatusType 
							WHEN	'O'		THEN	'Compras' 
							WHEN	'A'		THEN	'Aprobada'
							WHEN	'P'		THEN	'Pendiente' 
							WHEN	'R'		THEN	'Rechazado'
							ELSE					'Sin Status'
					END								AS Estado, 
					ISNULL(RD.ReqLine, '')			AS ReqLine, 
					ISNULL(RD.PartNum, '')			AS PartNum, 
					ISNULL(RD.LineDesc, '')			AS LineDesc, 
					ISNULL(RD.Class, '')			AS Class, 
					ISNULL(RD.PONum, 0)				AS PONum, 
					ISNULL(RD.POLine, 0)			AS POLine, 
					ISNULL(RD.PORelNum, 0)			AS PORelNum, 
					ISNULL(RD.CurrencyCode, '')		AS CurrencyCode, 
					ISNULL(RD.RUM, '')				AS RUM, 
					ISNULL(RD.OrderQty, 0)			AS OrderQty, 
					ISNULL(RA.ReqActionDesc, '')	AS ReqActionDesc, 
------------------------------------

					ISNULL(SD.SugNum, 0)							AS SugNum, 
					ISNULL(ISNULL(SD.BuyerID, PH.BuyerID), '')		AS BuyerID, 
					ISNULL(SD.JobNum, 0)							AS JobNum, 
					ISNULL(ISNULL(SD.VendorID, V.VendorID), '')		AS VendorID, 
					ISNULL(ISNULL(SD.Name, V.Name), '')				AS VendorName, 
					ISNULL(SD.Plant, '')							AS Plant, 
					ISNULL(Pl.Name, '')								As PlantName

------------------------------------

----------------------------------------------------------------------------------

FROM				[CORPEPIDB].EpicorERP.Erp.ReqHead		RH			WITH (NoLock)
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ReqDetail	RD			WITH (NoLock)
	ON				RH.Company		=		RD.Company
	AND				RH.ReqNum		=		RD.ReqNum
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.POHeader		PH			WITH (NoLock)
	ON				RD.Company		=		PH.Company
	AND				RD.PONum		=		PH.PONum
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ReqActs		RA			WITH (NoLock)
	ON				RH.Company		=		RA.Company
	AND				RH.ReqActionID	=		RA.ReqActionID
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.SugPoDtl		SD			WITH (NoLock)
	ON				RD.Company		=		SD.Company
	AND				RD.ReqNum 		=		SD.ReqNum
	AND				RD.ReqLine 		=		SD.ReqLine
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Plant 		Pl			WITH (NoLock)
	ON				SD.Company		=		Pl.Company
	AND				SD.Plant 		=		Pl.Plant
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.Vendor		V			WITH (NoLock)
	ON				PH.Company		=		V.Company
	AND				PH.VendorNum 	=		V.VendorNum

-----------------------------------------------------

WHERE				
					RH.RequestorID ='cgallar'
	AND				RH.RequestDate  Between '12-11-2021' and '12-05-2022'
ORDER by 5
	AND				RH.ReqNum='12956'
					RH.Company						=			@Company
	AND				RH.ReqNum						BETWEEN		@ReqNumIni		AND		@ReqNumFin
	AND				ISNULL(SD.SugNum, 0)			BETWEEN		@SugNumIni		AND		@SugNumFin
	AND				ISNULL(RD.PONum, 0)				BETWEEN		@PONumIni		AND		@PONumFin
	AND				RH.RequestorID					BETWEEN		@ReqIDIni		AND		@ReqIDFin
	AND				RH.CurrDispatcherID				BETWEEN		@CurDispIni		AND		@CurDispFin
	AND				RH.StatusType					BETWEEN		@EstadoIni		AND		@EstadoFin
	AND				ISNULL(RD.Class, '')			BETWEEN		@ClassIDIni		AND		@ClassIDFin
	AND				ISNULL(RA.ReqActionDesc, '')	BETWEEN		@ReqActDescIni	AND		@ReqActDescFin
	AND				ISNULL(SD.BuyerID, '')			BETWEEN		@BuyerIDIni		AND		@BuyerIDFin
	AND				ISNULL(SD.Plant, '')			BETWEEN		@PlantIni		AND		@PlantFin

----------------------------------------------------------------------------------



GO


select top 100 * FROM				[CORPEPIDB].EpicorERP.Erp.ReqHead		RH