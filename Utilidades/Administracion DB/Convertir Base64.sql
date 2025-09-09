
BEGIN
	DECLARE @FileOK  INT,
			@Base64 Nvarchar(MAX),
			@UrlFile Nvarchar(100)='\\Corpdmz02ft\bk\PDF\52-2270.PDF';

--CABECERA
	--Creo Tabla temporal
	IF OBJECT_ID('tempdb.dbo.#BuscaPDF', 'U') IS NOT NULL
		TRUNCATE TABLE #BuscaPDF	
	ELSE
		CREATE TABLE #BuscaPDF (linea varchar(2000))
	
	--Inserto las lineas en tabla temporal
	EXEC xp_fileExist @UrlFile ,@FileOK OUTPUT	

	IF (@FileOK = 1)
	begin 
		-- Encode the string "TestData" in Base64 to get "VGVzdERhdGE="
				SELECT @Base64=W.Base64Encoding
				FROM (
							SELECT 
								CAST(N'' AS XML).value(
									  'xs:base64Binary(xs:hexBinary(sql:column("bin")))'
									, 'VARCHAR(MAX)'
								)  AS Base64Encoding
							FROM (
								SELECT CAST(@UrlFile AS VARBINARY(MAX)) AS bin
							) AS bin_sql_server_temp
					) AS W

					SELECT @Base64 AS Base64Encoding
--/*
			-- Decode the Base64-encoded string "VGVzdERhdGE=" to get back "TestData"
			SELECT 
				CAST(
					CAST(N'' AS XML).value(
						'xs:base64Binary("XABcAEMAbwByAHAAZABtAHoAMAAyAGYAdABcAGIAawBcAFAARABGAFwANQAyAC0AMgAyADcAMAAuAFAARABGAA==")'
					  , 'VARBINARY(MAX)'
					) 
					AS VARCHAR(MAX)
				)   ASCIIEncoding
--*/
			;
	END

END
-- Encode the string "TestData" in Base64 to get "VGVzdERhdGE="
SELECT
    CAST(N'' AS XML).value(
          'xs:base64Binary(xs:hexBinary(sql:column("bin")))'
        , 'VARCHAR(MAX)'
    )   Base64Encoding
FROM (
    SELECT CAST('TestData' AS VARBINARY(MAX)) AS bin
) AS bin_sql_server_temp;

-- Decode the Base64-encoded string "VGVzdERhdGE=" to get back "TestData"
SELECT 
    CAST(
        CAST(N'' AS XML).value(
            'xs:base64Binary("VGVzdERhdGE=")'
          , 'VARBINARY(MAX)'
        ) 
        AS VARCHAR(MAX)
    )   ASCIIEncoding
;