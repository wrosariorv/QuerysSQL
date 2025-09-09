/*------------------------
Number01 es el numero de la orden de venta
Number02 es el numero de linea de la orden de venta
Number03 es el numero de liberacion de la linea de la orden de venta
Number06 es el numero interno del remito
Number08 es el numero interno de la factura
ShortChar07 es el numero legal del remito
ShortChar09 es el numero legal de la factura
*/

SELECT Company, Key1, Key2, Key3, -- Key4, Key5,
ChildKey1, ChildKey2, -- ChildKey3, ChildKey4, ChildKey5,
Number01, Number02, Number03, Number04, Number05, Number06, Number07, Number08, -- Number09, Number10,
ShortChar06, ShortChar07, ShortChar09
FROM [CORPEPIDB].EpicorERP.Ice.UD110A A WITH(NoLock)
WHERE Key1 = 'ViajeCab'
--AND Key3 = '00031766'
 AND ShortChar09 <> ''
 AND ShortChar07 = ''
ORDER BY Key3 DESC, Number01 DESC, Number02 DESC, Number03 DESC



 set dateformat DMY
SELECT					a.Company, Key1, Key2, Key3, -- Key4, Key5,
						ChildKey1, ChildKey2, -- ChildKey3, ChildKey4, ChildKey5,
						Number01, Number02, Number03, Number04, Number05, convert (int,a.Number06) AS Number06, Number07, Number08, -- Number09, Number10,
						ShortChar06, ShortChar07, ShortChar09, b.*
FROM					[CORPEPIDB].EpicorERP.Ice.UD110A		A WITH(NoLock)
inner join				[CORPEPIDB].EpicorERP.erp.ShipHead		B
On						a.Company						=			b.Company
and						convert (int,a.Number06)		=			b.PackNum 
WHERE					Key1							=			 'ViajeCab'
--AND Key3 = '00031766'
 AND					A.ShortChar09					<>			 ''
 AND					A.ShortChar07					=			 ''
-- AND Number06 = 0
 AND b.ShipDate  between '09-11-2021' and '10-11-2021'
ORDER BY 4 DESC, 6 DESC, 7 DESC, 8 DESC,b.ShipDate


-----------------------
--Con esta consulta recupero el numero de empaque de una orden/linea/liberacion


SELECT SH.Company, SH.PackNum, SH.LegalNumber, SD.OrderNum, SD.OrderLine, SD.OrderRelNum
FROM [CORPEPIDB].EpicorERP.Erp.ShipDtl SD WITH(NoLock)
INNER JOIN [CORPEPIDB].EpicorERP.Erp.ShipHead SH WITH(NoLock)
ON SD.Company = SH.Company
AND SD.PackNum = SH.PackNum
WHERE (
SD.OrderNum = 163050.000000000
AND SD.OrderLine = 1
AND SD.OrderRelNum = 1
)
OR
(
SD.OrderNum = 163050.000000000
AND SD.OrderLine = 2
AND SD.OrderRelNum = 1
)