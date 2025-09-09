USE [RVF_Local]
GO


---------------------------------------------------------------

SELECT			VD.Company, VD.Key1, VD.Key2, VD.Key3, VD.Key4, VD.Key5, VD.ChildKey1, VD.ChildKey3, VD.ChildKey4, VD.ChildKey5,
				VD.NroEmpaque, VD.NroRemito, VD.NroInterno, VD.NroFactura, VD.NroRemito2, 
				MIN(VD.ChildKey2)							AS		ChildKey2, 
				ISNULL(C.[Status], 'N')						AS		[Status], 
				ISNULL(C.TextoStatus, 'No Presentado')		AS		TextoStatus, 
				C.UltimaActualizacionFecha
FROM			(
				SELECT			U.Company, U.Key1, U.Key2, U.Key3, U.Key4, U.Key5, ChildKey1, ChildKey2, ChildKey3, ChildKey4, ChildKey5, 
								Number06						AS		NroEmpaque, 
								Number08						AS		NroInterno, 
								ShortChar07						AS		NroRemito, 
								ShortChar09						AS		NroFactura, 
								RIGHT('00000' + REPLACE(REPLACE(ShortChar07, '-', ''), 'R', ''), 13)	AS		NroRemito2 
				FROM 			[CORPEPIDB].EpicorERP.Ice.UD110A		U					WITH (NoLock)
				WHERE			U.Key1					=			'ViajeCab'
			--		AND			U.Company				=			@Empresa		
			--		AND			U.Key3					=			@Viaje
				)		VD
LEFT OUTER JOIN	RVF_VW_COT_RESULTADOS_INFORME		C					WITH (NoLock)
	ON			VD.NroRemito2			=			C.Descripcion2		COLLATE		SQL_Latin1_General_CP1_CI_AS

WHERE 			C.[Status]				=			'E'

GROUP BY		VD.Company, VD.Key1, VD.Key2, VD.Key3, VD.Key4, VD.Key5, VD.ChildKey1, VD.ChildKey3, VD.ChildKey4, VD.ChildKey5,
				VD.NroEmpaque, VD.NroRemito, VD.NroInterno, VD.NroFactura, VD.NroRemito2, 
				C.[Status], C.TextoStatus, C.UltimaActualizacionFecha

