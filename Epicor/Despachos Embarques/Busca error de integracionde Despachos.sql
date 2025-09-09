SELECT		 [Company],			
			 [Key1]				AS 'TipoIntegracion', 
			 [Key2] 			AS 'FechaHora', 
			 [Key3] 			AS 'OrderNum', 
			 [Key4]				AS 'Linea',
			 [Key5]	 			AS 'Liberacion',
			 [ShortChar01]	 	AS 'Plant',
			 [ShortChar02]	 	AS 'Warehouse',
			 [ShortChar03]	 	AS 'BinNum',
			 [ShortChar04]	 	AS 'Packnum',
			 [ShortChar05]		AS 'TipoError',
			 [Date01]	 		AS 'FechaError',
			 [Character05]		AS 'ErrorMsg'

FROM [CORPEPIDB].[EpicorERP].[Ice].[UD35]
WHERE
[Key1] ='SC INGRESA DESPACHO'
ORDER BY 3 Desc

INSERT INTO [Ice].[UD35]
 ([Company], [Key1], [Key2], [Key3], [Key4], [Key5], [ShortChar01], [ShortChar02], [ShortChar03], [ShortChar04], [ShortChar05],[Date01], [Character05])
VALUES (Company,'SC INGRESA DESPACHO',FECHAHORA,ORDERNUM,LINEA, LIBERACION, PLANTA , Warehouse , BinNum, Packnum, 'Error en Inserta despacho',GETDATE(), ErrorMsg)


Select			[Key3],	[Key4],	[Key5], [ShortChar04]
FROM			[Ice].[UD35]
WHERE			[ShortChar04]	=	'198399'

Select			Count(*) Registros 
FROM			[Ice].[UD35]
WHERE			
				Key3			=	'157246'	
AND				Key4			=	'2'
AND				Key5			=	'1'
AND				[ShortChar04]	=	'198399'


Select Count(*) Registros from [CORPEPISSRS01].[RVF_LOCAL].dbo.RVF_TBL_IMP_QUOTE_LOG
where Company = Company And Cotizacion = Cotizacion
