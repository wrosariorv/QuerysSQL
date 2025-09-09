----------------------- Get value
DECLARE @B VARBINARY(MAX)
SELECT @B = col
FROM OPENROWSET(
BULK N'C:\Users\wrosario.RADIOVICTORIA\Desktop\ArchivoImportar\FC -A-240-00000714.pdf', SINGLE_BLOB
) Tbl(col)
----------------------- Convert to BASE64
select col
from openjson(
    (
        select col
        from (SELECT @B as col) T
        for json auto
    )
) with(col varchar(max))
Go
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
----------------------- Get value
DECLARE @B VARBINARY(MAX)
SELECT @B = col
FROM OPENROWSET(
BULK N'C:\Users\wrosario.RADIOVICTORIA\Desktop\ArchivoImportar\FC -A-240-00000714.pdf', SINGLE_BLOB
) Tbl(col)
----------------------- Convert to BASE64
select cast('' as xml).value('xs:base64Binary(sql:variable("@B"))', 'varchar(max)')
GO

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

----------------------- Get value
DECLARE @B VARBINARY(MAX)
SELECT @B = a 
FROM OPENROWSET(
BULK N'C:\Users\wrosario.RADIOVICTORIA\Desktop\ArchivoImportar\FC -A-240-00000714.pdf', SINGLE_BLOB
) Tbl(a)
----------------------- Convert to BASE64


	select		 *
							from			(select @B as '*')  AS Tbl

							for xml path('') 

GO


