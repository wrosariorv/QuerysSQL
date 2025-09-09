

/*

-- Busca las transacciones de la tabla [CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB] y las inserta en la tabla [EpicorTest11100].Ice.UD10
EXECUTE				RVF_PRC_API_PEDIDOS_MULTIVENDE

*/

-- Maximo numero de grupo de transacciones
SELECT 				MAX(Number05)
FROM				[EpicorTest11100].Ice.UD10


-- Registro marcado como finalizacion de grupo de transacciones
SELECT				TOP 1 Company, Key1, Key2, Key3, Key4, CheckBox03 
FROM				[EpicorTest11100].Ice.UD10										UD			WITH (NoLock)
WHERE				Number05				=				16 
ORDER BY			Company, Key1, Key3 DESC, Key4 DESC, Key2 DESC  


-- Todos los registros del ultimo grupo de transacciones 
SELECT				*	
FROM				[EpicorTest11100].Ice.UD10 
WHERE				Number05				=				18 
ORDER BY			Company, Key3 DESC, Key4 DESC, Key2 DESC 


/*

DELETE					
FROM				[EpicorTest11100].Ice.UD10
WHERE				Number05			=			18

*/
