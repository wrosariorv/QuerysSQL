SELECT
       A.[Compania]
      ,A.[CodigoCliente]
      ,A.[CodVendedor]
      ,A.[CodigoDomicilio]
      ,B.Direccion
      ,B.Ciudad
      ,A.[CodListaPrecio]
      ,A.[UnidadNeg]
  FROM          [RVF_Local].[dbo].[RVF_VW_MOVI_CLIENTES_DOMICILIOS_VENDEDORES] A
  INNER JOIN    RVF_VW_MOVI_DOMICILIO_DE_CLIENTE B
    ON          A.Compania          =       B.Compania
    AND         A.CodigoCliente     =       B.CodigoCliente
    AND         A.CodigoDomicilio   =       B.CodigoDomicilio

  WHERE
            A.CodigoCliente='49944'
    AND     A.CodVendedor in ('RCA09')

     AND     A.CodVendedor in ('RCA08','RCA09')


    select * from RVF_VW_MOVI_DOMICILIO_DE_CLIENTE
    where CodigoCliente='49944'
    AND     CodigoDomicilio in ('RCA-99')