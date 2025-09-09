
--------------------------------------------


SELECT				C.Company, C.CustID, C.[Name], 
					ST.ShipToNum, ST.Address1, ST.Zip, ST.City, ST.[State], ST.ShipViaCode, 
					STU.ShortChar01							AS		Zona, 
					STU.ShortChar03							AS		SubZona, 
					SV.[Description]						AS		ShipViaDescription   
FROM				[CORPEPIDB].EpicorERP.Erp.ShipTo				ST					WITH (NoLock)
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.ShipTo_UD				STU					WITH (NoLock)
	ON				ST.SysRowID				=				STU.ForeignSysRowID
INNER JOIN			[CORPEPIDB].EpicorERP.Erp.Customer				C					WITH (NoLock)
	ON				ST.Company				=				C.Company
	AND				ST.CustNum				=				C.CustNum 
LEFT OUTER JOIN		[CORPEPIDB].EpicorERP.Erp.ShipVia				SV					WITH (NoLock)
	ON				ST.Company				=				SV.Company
	AND				ST.ShipViaCode			=				SV.ShipViaCode 

WHERE				C.Company				=				'CO01' 
	AND				ST.ShipToNum			NOT IN			('', 'OUTLET')
	AND				(
					STU.ShortChar01			=				''
					AND 
					STU.ShortChar03			=				''
					)
	AND				ST.ShipViaCode			IN				('999')

	--------------------------------------------------

	AND				ST.[State]				NOT LIKE		'T%FUEGO'

	AND				ST.[State]				NOT IN			(
															'', 'AUSTRIA', 'CÓRDOBA', 'CATAMARCA', 'CHACO', 'CHUBUT', 'CORDOBA', 'CORRIENTES', 'ENTRE RIOS', 'EXTERIOR', 'FORMOSA', 'FRANCE', 'FRANCIA', 
															'GERMANY', 'JUJUY', 'LA PAMPA', 'LA RIOJA', 'MENDOZA', 'MISIONES', 'MONTEVIDEO', 'NEUQUÉN', 'NEUQUEN', 'RÍO NEGRO', 'RIO NEGRO', 'SALTA', 
															'SAN JUAN', 'SAN LUIS', 'SANTA CRUZ', 'SANTA FE', 'SANTIAGO DE CHILE', 'SANTIAGO DEL ESTERO', 'TUCUMAN', 'TUCUMÁN', 'RIO NEGRO  ', 'SANTA FE  '
															)

	AND				ST.[State]				NOT IN			(
															'C..A.B.A.', 
															'C.A.B.A', 
															'C.A.B.A.', 
															'CAB', 
															'CABA', 
															'CAPITAL FEDERAL', 
															'CIIUDAD AUTONOMA DE BUENOS AIRES', 
															'CIUDAD  AUTONOMA DE BS AS', 
															'CIUDAD AUOTONOMA DE BS AS', 
															'CIUDAD AUTÓNOMA DE BUENOS AIRES', 
															'CIUDAD AUTNOMA DE BUENOS AIRES', 
															'CIUDAD AUTOMOMA DE BUENOS AIRES', 
															'CIUDAD AUTONIMA  DE BUENOS AIRES', 
															'CIUDAD AUTONOAM DE BUENOS AIRES', 
															'CIUDAD AUTONOMA  DE BS AS', 
															'CIUDAD AUTONOMA BS AS', 
															'CIUDAD AUTONOMA BUENOS AIRE', 
															'CIUDAD AUTONOMA BUENOS AIRES', 
															'CIUDAD AUTONOMA DE BS  AS', 
															'CIUDAD AUTONOMA DE BS AS', 
															'CIUDAD AUTONOMA DE BS S', 
															'CIUDAD AUTONOMA DE BS.AS.', 
															'CIUDAD AUTONOMA DE BSAS', 
															'CIUDAD AUTONOMA DE BUENOS', 
															'CIUDAD AUTONOMA DE BUENOS AIIRES', 
															'CIUDAD AUTONOMA DE BUENOS AIRE', 
															'CIUDAD AUTONOMA DE BUENOS AIRES', 
															'CIUDAD AUT�NOMA DE BUENOS AIRES', 
															'CIUDAD AUTONOMA DE BUENOS AIRESCABA', 
															'CIUDAD AUTONOMA DE BUENOS AIRESS', 
															'CIUDAD AUTONOMA DE BUENOS ARIES', 
															'CIUDAD AUTONOMA DE BUENOSA AIRES', 
															'CIUDAD AUTONOMA DE BUENOSAIRES', 
															'CIUDAD AUTONOMA DE BUIENOS AIRES', 
															'CIUDAD AUTONOMA DE BUNOS AIRES', 
															'CIUDAD AUTONOMA DEBBUENOS AIRES', 
															'CIUDAD AUTONOMA DEBUENOS AIRES', 
															'CIUDAD AUTONOMA DEBUENOS AIRES.', 
															'CIUDAD AUTONOMO DE BUENOS AIRES', 
															'CIUDAD DE AUTONOMA DE BUENOS AIRES', 
															'CIUDAD DE BS AS', 
															'CIUDAD DE BUENOS AIRES', 
															'CIUDAD DE BUENOS AIRES  ', 
															'CIUDADA AUTONOMA DE BUENOS AIRES', 
															'CUIDAD AUTONOMA DE BUENOS AIRES' 
															)

	--------------------------------------------------

ORDER BY			8, 1, 2


--------------------------------------------

/*
SELECT				Company, ShipViaCode, [Description], TrackingNumPlaceHolder, AGStreet, AGProvinceCode, AGLocationCode 
FROM				[CORPEPIDB].EpicorERP.Erp.ShipVia				SV					WITH (NoLock)
WHERE				Company					=				'CO01'
	AND				TrackingNumPlaceHolder	=				''
	AND				ShipViaCode				NOT IN			(
															'AER', 'AERT','CAM','COU','ENTR','JP','MAR','MARC',
															'MART','R001','R002','R003','R004','R005','R006','R007',
															'R008','R009','R011','R012','R013','RETM'
															)

ORDER BY			1, 2
*/

--------------------------------------------

