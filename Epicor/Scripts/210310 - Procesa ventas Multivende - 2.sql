USE [RV_Chile]
GO



BEGIN

--------------------------------------------

DECLARE				@GrupoReproceso				INT			=		15

--------------------------------------------

DECLARE				@MaxGroupID					INT

SELECT 				@MaxGroupID			=			MAX(Number05) + 1
FROM				[EpicorTest11100].Ice.UD10

--------------------------------------------


-- INSERT INTO		[EpicorTest11100].[ICE].[UD10]	
				(	
				Company, Key1, Key2, Key3, Key4, Key5,
				----------------------------------------------------------------
				ShortChar01, ShortChar02, ShortChar03, ShortChar04, ShortChar05, 
				ShortChar06, ShortChar07, ShortChar08, 
				ShortChar09, ShortChar10, 
				ShortChar11, ShortChar12, ShortChar13, ShortChar14, 
				ShortChar15, ShortChar16, ShortChar17, ShortChar18, ShortChar19,
				----------------------------------------------------------------
				Date01, Date02, 
				Number01, Number02, Number03, Number04, Number05, 
				CheckBox01, CheckBox02, CheckBox03 
				)

-- */


SELECT			Company, Key1, Key2, Key3, 'R-' + Key4, Key5,
				----------------------------------------------------------------
				ShortChar01, ShortChar02, ShortChar03, ShortChar04, '2020' /*ShortChar05*/, 
				ShortChar06, ShortChar07, ShortChar08, 
				ShortChar09, ShortChar10, 
				ShortChar11, ShortChar12, '2022', /*ShortChar13, */ShortChar14, 
				ShortChar15, ShortChar16, 'PDT', /*ShortChar17, */ShortChar18, ShortChar19,
				----------------------------------------------------------------
				Date01, Date02, 
				Number01, Number02, Number03, Number04, @MaxGroupID, 
				CheckBox01, 0, /*CheckBox02, */ CheckBox03 	


FROM			[EpicorTest11100].[ICE].[UD10]
WHERE			Number05			=				@GrupoReproceso

/************************************************************************************
************************************************************************************/

END

