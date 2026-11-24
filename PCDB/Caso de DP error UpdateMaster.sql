SELECT  [Company]
      ,[Tipo]
      ,[TranNum]
      ,[TipoCaso]
      ,[id_caso]
      ,[GroupID]
      ,[SoldToCustID]
      ,[InvoiceDate]
      ,[InvoiceRef]
      ,[InvRefLegNum]
      ,[TermsCode]
      ,[TaxRegionCode]
      ,[Comentario]
      ,[Fecha]
      ,[Estado]
      ,[FechaModificacion]
      ,[Eliminado]
      ,[InvoiceNum]
      ,[GroupoAsignado]
      ,[ExchangeRate]
  FROM [PCDB_Test].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
  where-- Estado ='Pendiente'
            InvoiceRef=415304
  AND TranNum=4504

  select * from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
    where TranNum=4504


    begin tran

    update [PCDB_Test].[RV].[RV_TBL_SIP_ENCABEZADO_COMPROBANTE]
    set Estado='Integrado'
    where TranNum in (6,5721)


    
    update [PCDB_Test].RV.RV_TBL_SIP_DETALLE_COMPROBANTE
    set Estado='Integrado'
    where TranNum in (6,5721)

    commit tran


    