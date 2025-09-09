USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_TCRED_ANALISISCRED_RES_COMPLETO]    Script Date: 20/01/2023 08:32:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**********************************************

Autor: Eduardo Salva
Detalle: Se toma como origen los datos usados para armar el tablero de credito resumido.
Se quita el filtro por cliente y los subconjuntos que no deben considerarse en el control de limite de credito

**********************************************/

-- /*

ALTER PROCEDURE		[dbo].[RVF_PRC_TCRED_ANALISISCRED_RES_COMPLETO]			@Company		VARCHAR(15)	=	'CO01', 
																			@CustID			VARCHAR(15)	=	'', 
																			@UN				VARCHAR(15)	=	'', 
																			@UserID			VARCHAR(50)	=	'', 
																			@TipoCliente	VARCHAR(15)	=	''

AS

-- */

BEGIN

		DECLARE

 /*
		------------------------------------
			@Company		VARCHAR(15)		=		'CO01', 
			@CustID			VARCHAR(15)		=		'', 
			@UN				VARCHAR(15)		=		'', 
			@UserID			VARCHAR(50)		=		'RADIOVICTORIA\esalva',
			@TipoCliente	VARCHAR(15)	=	'',  
		------------------------------------
 */
			@ClienteIni		VARCHAR(15), 
			@ClienteFin		VARCHAR(15), 
			@TipoClienteIni	VARCHAR(15), 
			@TipoClienteFin	VARCHAR(15) 
		------------------------------------

		------------------------------------------------------------------------------------------------------------------

		IF		@CustID		=	''	
				BEGIN		
						SELECT		@ClienteIni		=		'0', 
									@ClienteFin		=		'ZZZZZZZZZZZZZZZ'
				END 
			ELSE
				BEGIN		
						SELECT		@ClienteIni		=		@CustID	, 
									@ClienteFin		=		@CustID	
				END 

		------------------------------------------------------------------------------------------------------------------

		IF		@TipoCliente		=	'Todos'	
				BEGIN		
						SELECT		@TipoClienteIni		=		'0', 
									@TipoClienteFin		=		'ZZZZZZZZZZZZZZZ'
				END 
			ELSE
				BEGIN		
						SELECT		@TipoClienteIni		=		@TipoCliente, 
									@TipoClienteFin		=		@TipoCliente	
				END 

		------------------------------------------------------------------------------------------------------------------


		BEGIN

				---------------------------------------
				-- Cuenta corriente de clientes
				---------------------------------------

				BEGIN

					EXECUTE				RVF_PRC_TCRED_CTACTE 	@Company		=		@Company, 
																@CustID			=		@CustID, 
																@UN				=		@UN, 
																@UserID			=		@UserID

					DELETE FROM			RVF_TBL_TCRED_CTACTE_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_CTACTE_RES	(
																	Company, UN, CustID, Balance, UserID
																	)

					SELECT				Company, Character07, CustID, SUM(InvoiceBal) AS InvoiceBal, @UserID
					FROM				RVF_TBL_TCRED_CTACTE_TEMP 	WITH (NoLock)
					WHERE				UserID		=		@UserID	
					GROUP BY			Company, Character07, CustID 

				END

				---------------------------------------
				-- Cheques pendientes de clientes
				---------------------------------------

				BEGIN

					DELETE FROM			RVF_TBL_TCRED_CHEQUESCARTERA_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_CHEQUESCARTERA_RES

					EXECUTE				RVF_PRC_TCRED_CHEQUESCARTERA_RES
																@Company, 
																@CustID, 
																@UN, 
																@UserID

				END
		/*
				---------------------------------------
				-- NC20 de clientes
				---------------------------------------

				BEGIN

					DELETE FROM			RVF_TBL_TCRED_NC20_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_NC20_RES

					EXECUTE				RVF_PRC_TCRED_NC20_RES
																@Company, 
																@CustID, 
																@UN, 
																@UserID

				END

				---------------------------------------
				-- Facturas observadas
				---------------------------------------

				BEGIN

					DELETE FROM			RVF_TBL_TCRED_FACTURASDISP_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_FACTURASDISP_RES

					EXECUTE				RVF_PRC_TCRED_FACTURASDISP_RES
																@Company, 
																@CustID, 
																@UN, 
																@UserID

				END

				---------------------------------------
				-- Ordenes de venta
				---------------------------------------

				BEGIN

					DELETE FROM			RVF_TBL_TCRED_PEDIDOSCAB_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_PEDIDOSCAB_RES

					EXECUTE				RVF_PRC_TCRED_PEDIDOSCAB_RES
																@Company, 
																@CustID, 
																@UN, 
																@UserID

				END

				---------------------------------------
				-- Cotizaciones de venta
				---------------------------------------

				BEGIN

					DELETE FROM			RVF_TBL_TCRED_COTIZCAB_RES
					WHERE				UserID		=		@UserID	

					INSERT INTO			RVF_TBL_TCRED_COTIZCAB_RES

					EXECUTE				RVF_PRC_TCRED_COTIZCAB_RES 
																@Company, 
																@CustID, 
																@UN, 
																@UserID

				END
		*/
				---------------------------------------

				SELECT					X.Company, X.UN, X.CustID, 
										ISNULL(CC.Balance, 0)			AS CtaCte, 
										ISNULL(CH.Balance, 0)			AS Cheques, 
		/*								ISNULL(NC.Balance, 0)			AS NC20, 
 										ISNULL(FC.Balance, 0)			AS FCDisp, 
  										ISNULL(SO.Balance, 0)			AS Pedcab,
  										ISNULL(SQ.Balance, 0)			AS CotCab, 
		*/ 								CU.Name, CU.ResaleID, CU.CreditReviewDate, CU.CreditLimit, CU.ReminderCode

				FROM					-- Resumen de unidades de negocio con informacion para el cliente
										(
										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_CTACTE_RES			WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	

										UNION

										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_CHEQUESCARTERA_RES	WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	

		/*								UNION

										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_NC20_RES				WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	

										UNION

										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_FACTURASDISP_RES		WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	

										UNION

										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_PEDIDOSCAB_RES		WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	

										UNION

										SELECT				Company, UN, CustID, UserID		
										FROM				RVF_TBL_TCRED_COTIZCAB_RES		WITH (NoLock)
										WHERE				CustID		BETWEEN		@ClienteIni		AND		@ClienteFin
											AND				UserID		=			@UserID	
		*/								) X
				LEFT OUTER JOIN			RVF_TBL_TCRED_CTACTE_RES			CC	WITH (NoLock)
					ON					X.Company			=		CC.Company
					AND					X.UN				=		CC.UN
					AND					X.CustID			=		CC.CustID
					AND					X.UserID			=		CC.UserID

				LEFT OUTER JOIN			RVF_TBL_TCRED_CHEQUESCARTERA_RES	CH 	WITH (NoLock)
					ON					X.Company			=		CH.Company
					AND					X.UN				=		CH.UN
					AND					X.CustID			=		CH.CustID
					AND					X.UserID			=		CH.UserID

		/*		LEFT OUTER JOIN			RVF_TBL_TCRED_NC20_RES				NC 	WITH (NoLock)
					ON					X.Company			=		NC.Company
					AND					X.UN				=		NC.UN
					AND					X.CustID			=		NC.CustID
					AND					X.UserID			=		NC.UserID

				LEFT OUTER JOIN			RVF_TBL_TCRED_FACTURASDISP_RES		FC 	WITH (NoLock)
					ON					X.Company			=		FC.Company
					AND					X.UN				=		FC.UN
					AND					X.CustID			=		FC.CustID
					AND					X.UserID			=		FC.UserID

				LEFT OUTER JOIN			RVF_TBL_TCRED_PEDIDOSCAB_RES		SO 	WITH (NoLock)
					ON					X.Company			=		SO.Company
					AND					X.UN				=		SO.UN
					AND					X.CustID			=		SO.CustID
					AND					X.UserID			=		SO.UserID

				LEFT OUTER JOIN			RVF_TBL_TCRED_COTIZCAB_RES			SQ 	WITH (NoLock)
					ON					X.Company			=		SQ.Company
					AND					X.UN				=		SQ.UN
					AND					X.CustID			=		SQ.CustID
					AND					X.UserID			=		SQ.UserID

		*/				LEFT OUTER JOIN			[CORPEPIDB].EpicorERP.Erp.Customer		CU 	WITH (NoLock)
					ON					X.Company			=		CU.Company
					AND					X.CustID			=		CU.CustID
				WHERE					CU.ReminderCode		BETWEEN		@TipoClienteIni		AND		@TipoClienteFin
		END

END





GO


