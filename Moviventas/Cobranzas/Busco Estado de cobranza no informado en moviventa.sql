SELECT count(*) FROM [ext_estado_cobranzas]
where [NroReciboMoviventas] not in
(SELECT [nroCobranza] FROM [vw_cobranzas])