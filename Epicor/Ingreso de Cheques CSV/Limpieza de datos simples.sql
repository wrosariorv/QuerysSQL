			/*********************************************************************
							CREO TABLA TEMPORAL
			*********************************************************************/

				IF OBJECT_ID('tempdb.dbo.#DirtyTable', 'U') IS NOT NULL
							TRUNCATE TABLE #DirtyTable	
					ELSE

							CREATE TABLE #DirtyTable	(
															DirtyID INT,
															[Text]	varchar(max)
														)

				IF OBJECT_ID('tempdb.dbo.#CleanTable', 'U') IS NOT NULL
							TRUNCATE TABLE #CleanTable	
					ELSE

							CREATE TABLE #CleanTable	(
															[Name]	VARCHAR(100),
															Age		INT,
															Region	VARCHAR(100)
														)
			/*********************************************************************
							Inserto dato en tabla temporal
			*********************************************************************/

			Insert into #DirtyTable VALUES (1,'    Juan 2Garcia, 50, Barcelona')
			Insert into #DirtyTable VALUES (2,'    Carlo25s   Rodrigue1z, 80, Lecheria')
			Insert into #DirtyTable VALUES (3,'    Karla Flores, 71, Guanta')
			Insert into #DirtyTable VALUES (4,'    Luis   Gonzalez, 18, Almagro')

		

			DECLARE 
					@i		INT =0,
					@Count	INT = (SELECT COUNT(DirtyID) FROM #DirtyTable),
					@Text	VARCHAR (MAX),
					@Name	VARCHAR(100),
					@Age	VARCHAR(100),
					@Region	VARCHAR(100)
			DECLARE		
					@TableToClean Table(Id int, Field VARCHAR(2000))

			DECLARE
					@NumberPatter varchar(10) = '%[0-9]%'

			--SELECT PATINDEX(@NumberPatter, 'AA112S')

			/*********************************************************************
							CONSULTA
			*********************************************************************/

			WHILE @I <@Count
			BEGIN
					SET @Text = (	SELECT		[Text] 
									FROM		#DirtyTable
									OrDER BY DirtyID
									OFFSET @i ROWS
									FETCH NEXT 1 ROW ONLY
								)
					
					INSERT INTO @TableToClean(Id,Field)
					SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)), VALUE FROM string_split(TRIM(@Text),',')


					
					SET @Name		= (	SELECT TOP 1 FIELD FROM @TableToClean
										WHERE Id = 1)
					SET @Age		=	(	SELECT TOP 1 FIELD FROM @TableToClean
											WHERE Id = 2)
					SET @Region		= (	SELECT TOP 1 FIELD FROM @TableToClean
										WHERE Id = 3)

					--SELECT @Name

					/***************Elimino los espacios en blanco***************/
					SET @Name = (SELECT TRIM (REPLACE(REPLACE(REPLACE(@Name, ' ', '<>'),'><',''),'<>',' ')))

					--SELECT @Name

					/***************Elimino los caracteres numericos***************/
					WHILE PATINDEX(@NumberPatter, @NAME)>0
						SET @Name = STUFF(@Name, PATINDEX(@NumberPatter, @NAME), 1,'')

					--SELECT @Name

					SET @Age = TRIM(@Age)
					SET @Region = TRIM(@Region)

					INSERT INTO #CleanTable ([Name], Age, Region)
					VALUES					(@Name, @Age, @Region)

					DELETE @TableToClean

					SET @i = @i +1

					
			END

			SELECT * FROM #CleanTable

			DROP TABLE #DirtyTable

			DROP TABLE #CleanTable
