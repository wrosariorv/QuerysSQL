
USE [RemitoCot-PROD]
GO


SELECT				IDOperacion, IDTipoOperacion, CUIT, Descripcion, DatosAdicionales2, DatosAdicionales4, [Status], TextoStatus, 
					StatusRegistro, UltimaActualizacionUsuario, UltimaActualizacionFecha
FROM				[CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones
WHERE				[Status]						=		'E'

/*

UPDATE				[CORPSQLMULT01].[RemitoCOT-PROD].dbo.Operaciones
SET					[Status]						=		'C', 
					TextoStatus						=		'Concluída'
WHERE				[Status]						=		'E'
	AND				TextoStatus						=		'Error'
	AND				DatosAdicionales4				LIKE	'2022%'

*/