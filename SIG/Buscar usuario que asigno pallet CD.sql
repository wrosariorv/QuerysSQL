SELECT p.NumPallet, concat(u.Apellido, ' ', u.Nombre) as Operario
    FROM dbo.PalletAsignados p
	INNER JOIN  [SIGSeguridad].dbo.Usuario u
	ON p.IdUsuario = u.IdUsuarioCD
	WHERE p.NumPallet in ( 'PL175618A','PL193328A')