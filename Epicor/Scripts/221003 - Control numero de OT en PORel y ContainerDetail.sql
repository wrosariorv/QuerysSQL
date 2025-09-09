
--------------------------------------------------------------------------------------------------------------

DECLARE				@POList TABLE (PO int)

INSERT INTO			@POlist
					SELECT			DISTINCT TOP 10 PO.PONum
					FROM			CORPEPIDB.EpicorErp.Erp.POHeader		PO			WITH(NoLock)
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.POHeader_UD		POU			WITH(NoLock)
						ON			PO.SysRowID			=				POU.ForeignSysRowID
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.PORel			PORel		WITH(NoLock)
						ON			PO.Company			=				PORel.Company
						AND			PO.PONum			=				PORel.PONum
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.PORel_UD		PORelU		WITH(NoLock)
						ON			PORel.SysRowID		=				PORelU.ForeignSysRowID
					WHERE			POU.ShortChar04		<>			''
						AND			PORelU.ShortChar04	=			''


SELECT				PO.Company, PO.PONum , POU.ShortChar04, 
					PORel.POLine, PORel.PORelNum, 
					PORelU.ForeignSysRowID, PORelU.ShortChar04, PORelU.*
FROM				CORPEPIDB.EpicorErp.Erp.POHeader		PO			WITH(NoLock)
INNER JOIN			CORPEPIDB.EpicorErp.Erp.POHeader_UD		POU			WITH(NoLock)
	ON				PO.SysRowID			=				POU.ForeignSysRowID
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel			PORel		WITH(NoLock)
	ON				PO.Company			=				PORel.Company
	AND				PO.PONum			=				PORel.PONum
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel_UD		PORelU		WITH(NoLock)
	ON				PORel.SysRowID		=				PORelU.ForeignSysRowID
WHERE				PO.OpenOrder		=			1
	AND				POU.ShortChar04		<>			''
ORDER BY			PO.Company, PO.PONum


--------------------------------------------------------------------------------------------------------------

DECLARE				@POList TABLE (PO int)

INSERT INTO			@POlist
					SELECT			DISTINCT TOP 10 PORel.PONum
					FROM				CORPEPIDB.EpicorErp.Erp.ContainerDetail			CD			WITH(NoLock)
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.ContainerDetail_UD		CDU			WITH(NoLock)
						ON				CD.SysRowID		=				CDU.ForeignSysRowID
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel
						ON				CD.Company							=				PORel.Company
						AND				CD.PONum							=				PORel.PONum
						AND				CD.POLine							=				PORel.POLine
						AND				CD.PORelNum							=				PORel.PORelNum
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel_UD				PORelU		WITH(NoLock)
						ON				PORel.SysRowID									=				PORelU.ForeignSysRowID
					WHERE			PORelU.ShortChar04	<>			''
						AND			CDU.PAC_RVJobNum_c	=			''


SELECT				CD.Company, CD.ContainerID, CD.PONum, CD.POLine, CD.PORelNum, 
					CDU.PAC_RVJobNum_c 
FROM				CORPEPIDB.EpicorErp.Erp.ContainerDetail			CD			WITH(NoLock)
INNER JOIN			CORPEPIDB.EpicorErp.Erp.ContainerDetail_UD		CDU			WITH(NoLock)
	ON				CD.SysRowID		=				CDU.ForeignSysRowID
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel
	ON				CD.Company							=				PORel.Company
	AND				CD.PONum							=				PORel.PONum
	AND				CD.POLine							=				PORel.POLine
	AND				CD.PORelNum							=				PORel.PORelNum
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel_UD
	ON				PORel.SysRowID									=				PORel_UD.ForeignSysRowID
WHERE				PORel.Company									=				'CO01'
	AND				PORel.PONum 									IN				(
																					SELECT			*
																					FROM			@POList
																					)




/*

--------------------------------------------------------------------------------------------------------------

/*

DECLARE				@POList TABLE (PO int)

INSERT INTO			@POlist
					SELECT			DISTINCT PO.PONum
					FROM			CORPEPIDB.EpicorErp.Erp.POHeader		PO			WITH(NoLock)
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.POHeader_UD		POU			WITH(NoLock)
						ON			PO.SysRowID			=				POU.ForeignSysRowID
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.PORel			PORel		WITH(NoLock)
						ON			PO.Company			=				PORel.Company
						AND			PO.PONum			=				PORel.PONum
					INNER JOIN		CORPEPIDB.EpicorErp.Erp.PORel_UD		PORelU		WITH(NoLock)
						ON			PORel.SysRowID		=				PORelU.ForeignSysRowID
					WHERE			POU.ShortChar04		<>			''
						AND			PORelU.ShortChar04	=			''
*/
--------------------------------------------------------------------------------------------------------------

UPDATE				CORPEPIDB.EpicorErp.Erp.PORel_UD
SET					PORel_UD.ShortChar04							=				POHeader_UD.ShortChar04
FROM				CORPEPIDB.EpicorErp.Erp.PORel_UD
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel
	ON				PORel.SysRowID									=				PORel_UD.ForeignSysRowID
INNER JOIN			CORPEPIDB.EpicorErp.Erp.POHeader 
	ON				POHeader.Company								=				PORel.Company
	AND				POHeader.PONum									=				PORel.PONum
INNER JOIN			CORPEPIDB.EpicorErp.Erp.POHeader_UD		
	ON				POHeader.SysRowID								=				POHeader_UD.ForeignSysRowID
WHERE				POHeader.PONum 									IN				(
																					SELECT			*
*/																				FROM			@POList

/*

DECLARE				@POList TABLE (PO int)

INSERT INTO			@POlist
					SELECT			DISTINCT PORel.PONum
					FROM				CORPEPIDB.EpicorErp.Erp.ContainerDetail			CD			WITH(NoLock)
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.ContainerDetail_UD		CDU			WITH(NoLock)
						ON				CD.SysRowID		=				CDU.ForeignSysRowID
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel
						ON				CD.Company							=				PORel.Company
						AND				CD.PONum							=				PORel.PONum
						AND				CD.POLine							=				PORel.POLine
						AND				CD.PORelNum							=				PORel.PORelNum
					INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel_UD				PORelU		WITH(NoLock)
						ON				PORel.SysRowID									=				PORelU.ForeignSysRowID
					WHERE			PORelU.ShortChar04	<>			''
						AND			CDU.PAC_RVJobNum_c	=			''				

--------------------------------------------------------------------------------------------------------------

UPDATE				CORPEPIDB.EpicorErp.Erp.ContainerDetail_UD
SET					ContainerDetail_UD.PAC_RVJobNum_c				=				PORel_UD.ShortChar04
FROM				CORPEPIDB.EpicorErp.Erp.ContainerDetail_UD
INNER JOIN			CORPEPIDB.EpicorErp.Erp.ContainerDetail		
	ON				ContainerDetail.SysRowID						=				ContainerDetail_UD.ForeignSysRowID
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel
	ON				ContainerDetail.Company							=				PORel.Company
	AND				ContainerDetail.PONum							=				PORel.PONum
	AND				ContainerDetail.POLine							=				PORel.POLine
	AND				ContainerDetail.PORelNum						=				PORel.PORelNum
INNER JOIN			CORPEPIDB.EpicorErp.Erp.PORel_UD
	ON				PORel.SysRowID									=				PORel_UD.ForeignSysRowID
WHERE				PORel.PONum 									IN				(
																					SELECT			*
																					FROM			@POList
																					)

--------------------------------------------------------------------------------------------------------------

*/