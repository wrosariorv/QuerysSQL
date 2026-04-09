select * delete from RV.RV_TBL_SIP_ENCABEZADO_COMPROBANTE
where TranNum = 4231

select * delete from RV.RV_TBL_SIP_DETALLE_COMPROBANTE
where TranNum = 4231



select * from dbo.casos
where id in (24793)

update dbo.casos
set id_estado=13
where id in (24793)

	/***** Actualizar la tabla [dbo].[casos]*****/
					UPDATE C
					SET				C.id_estado							=		T.New_ID_Estado, 
									--Actualizo numero legal de Epicor solo cuando el id de estado sea 12
									C.nota_credito_debito				=		CASE
																						WHEN		T.New_ID_Estado	=	12 
																						THEN		T.LegalNumber 
																						ELSE		C.nota_credito_debito
																				END,								
									C.NC_INTERNO						=		CASE
																						WHEN		T.New_ID_Estado	=	12 
																						THEN		T.InvoiceNum 
																						ELSE		C.NC_INTERNO
																				END						
					FROM			dbo.casos							AS C
					JOIN			@TablaTemporal						AS T 
					ON				C.ID								=		T.id_caso 
					AND				T.TipoCaso							=		'SO'
					WHERE			C.id_estado							>=		4