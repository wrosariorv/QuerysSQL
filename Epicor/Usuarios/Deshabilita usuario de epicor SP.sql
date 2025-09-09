USE [RVF_Local]
GO







/*
CREATE PROCEDURE	[dbo].[RVF_PRC_DESHABILITA_USERFILE]		

AS
*/


SET				DATEFORMAT DMY

-------------------------------------------------------------------------

DECLARE		
 /*
				@FechaDesde				DATETIME			=			'01/01/2018',

 */
				 
				@PENIENTEDES				BIT				=			0



---------------------------------------------------------------------------------
BEGIN


		IF OBJECT_ID('tempdb.dbo.#RVF_PRC_DESHABILITA_USERFILE_TEMP1','U')IS NOT NULL
		TRUNCATE TABLE #RVF_PRC_DESHABILITA_USERFILE_TEMP1

		ELSE

		CREATE TABLE		#RVF_PRC_DESHABILITA_USERFILE_TEMP1		( 
																	[Company][nvarchar](50), 
																	[Key1][nvarchar](15),
																	[Key2][nvarchar](50),
																	[Key3][nvarchar](10),
																	[Key4][nvarchar](30),
																	[Date01][date],
																	[Date02][date],
																	[Checkbox01][bit],
																	[DcdUserID][nvarchar](30),
																	[UserDisabled][bit]
																	)
		--/*

		INSERT INTO			#RVF_PRC_DESHABILITA_USERFILE_TEMP1	

		--*/
		---------------------------------------------------------------------------------

		SELECT				UD.Company,
							UD.KEY1,
							UD.Key2,
							UD.Key3,
							'wrosarioPrueba' AS Key4,
							UD.Date01,
							UD.Date02,
							UD.Checkbox01,
							UF.DcdUserID,
							UF.UserDisabled
		FROM				[CORPEPIDB].EpicorErp.ICE.UD01		UD	WITH(NoLock)
		LEFT JOIN			[CORPEPIDB].EpicorErp.erp.UserFile	UF	WITH(NoLock)
		ON					UD.Company			=			UF.CurComp
		AND					'wrosarioPrueba'	=			UF.DcdUserID
		WHERE					
							Key1				=				'UNAdicUsu'
		AND					Key2				=				'RADIOVICTORIA\wrosarioPrueba'
		AND					GETDATE()			NOT BETWEEN		UD.Date01 AND UD.Date02
		AND					UF.UserDisabled		=			0		--Si esta activo
		-------------------------------------------------------------------------

		SELECT		@PENIENTEDES		=
												CASE
														WHEN COUNT (*)>0		THEN 1
														ELSE					0
												END
					
		FROM		#RVF_PRC_DESHABILITA_USERFILE_TEMP1
	
	--SELECT @PENIENTEDES AS Pendiente,*
	--FROM	#RVF_PRC_DESHABILITA_USERFILE_TEMP1
END
/************************************************************************************

Se actualiza la informacion de la tabla UserFile.

************************************************************************************/
--BEGIN TRAN

			IF(@PENIENTEDES>1)
			BEGIN
					UPDATE				[CORPEPIDB].EpicorErp.erp.UserFile										
					SET					SysRevID				=			CONVERT(timestamp,GETDATE()),
										UserDisabled			=			1
					--SELECT				UF.DcdUserID,
					--					UF.UserDisabled

					FROM				[CORPEPIDB].EpicorErp.erp.UserFile	UF	WITH(NoLock)
					INNER JOIN			#RVF_PRC_DESHABILITA_USERFILE_TEMP1	T1	WITH(NoLock)
					ON					UF.CurComp			=			T1.Company
					AND					'wrosarioPrueba'	=			T1.DcdUserID
					WHERE					
										UF.DcdUserID		=				T1.Key4
					AND					GETDATE()			NOT BETWEEN		T1.Date01 AND T1.Date02
					AND					UF.UserDisabled		=				0		--Si esta activo				
			END


Select		DcdUserID,
			UserDisabled,
			SysRevID--0x00000000BC754ABC
from  [CORPEPIDB].EpicorErp.erp.UserFile
where
DcdUserID='wrosarioPrueba'


COMMIT TRAN

ROLLBACK TRAN

--------------------------------------------


-------------------------------------------------------------------------


GO


