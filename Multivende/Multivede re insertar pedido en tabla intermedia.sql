USE [RadioVictoria]
GO

--/****** Object:  StoredProcedure [dbo].[MV_RV_PasarVentas]    Script Date: 14/12/2023 13:11:21 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[MV_RV_PasarVentas]
--as
declare @ID varchar(100)
declare @Json varchar(max)
declare V cursor local static for 
	select ID, Datos from MV_Ventas where id='aa7f48f8-fc4f-4910-b89f-2dbac237a80d' --InformadoRV is null and estado <> 'INEXISTENTE' order by updatedAt 
open V
fetch next from V into @ID, @Json
while @@FETCH_STATUS=0 BEGIN
	if coalesce(@Json ,'')<>'' begin
		begin try
			--lo paso a RV
			insert into [CORPSQLMULT01].[Multivende].[dbo].[RVF_TBL_API_VENTAS_WEB](CanalEntrada, NumeroOC, NumeroDocumento, Nombre, Domicilio, Ciudad, Provincia, CodigoPostal, CodigoProvincia, Entrega_Nombre, Entrega_domicilio1, Entrega_domicilio2, Entrega_domicilio3, Entrega_Ciudad, Entrega_Provincia, Entrega_CP, Entrega_Documento, Comentario, FechaVenta, Linea, CodigoProducto, Cantidad, PrecioUnitario, RequiereFactura, CostoEnvio, UltimaLinea, shippingMode, DeliveryOrderId, Chekout_id, ClientID)
			select * from dbo.MV_FormatoRV(@Json) RV
			--actualizo el dato
			--update MV_Ventas set informadoRV = GETDATE() where ID = @ID
		end try 
		begin catch
			print error_message()
		end catch
	end
	fetch next from V into @ID, @Json
END

GO


