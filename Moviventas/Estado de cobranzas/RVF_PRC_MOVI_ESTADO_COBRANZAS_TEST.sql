USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_MOVI_ESTADO_COBRANZAS_TEST]    Script Date: 11/9/2025 10:35:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/*
ALTER PROCEDURE [dbo].[RVF_PRC_MOVI_ESTADO_COBRANZAS_TEST]
AS

--*/

BEGIN
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;

    BEGIN TRY
        --BEGIN TRAN;

        /* ================================================================
           1) Tabla variable de staging (sin #temp)
           ================================================================ */
        DECLARE @TablaTemporal TABLE
        (
            OtherDetails  varchar(50)   NOT NULL,
            LegalNumber   varchar(30)   NULL,
            TranAmt       numeric(17,3) NULL,
            Estado        varchar(11)   NOT NULL
        );

        /* Cobranzas registradas en Epicor (últimos 30 días) */
        INSERT INTO @TablaTemporal (OtherDetails, LegalNumber, TranAmt, Estado)
        SELECT
					LEFT(LTRIM(RTRIM(REPLACE(OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)   AS OtherDetails,
					NULLIF(LEFT(LTRIM(RTRIM(LegalNumber)), 30), '')                             AS LegalNumber,
					CAST(TranAmt AS numeric(17,3))                                              AS TranAmt,
					CASE 
							WHEN Posted = 0 THEN 'No Posteada'
							WHEN Posted = 1 THEN 'Posteada'
					END                                                                         AS Estado
        FROM		[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead
        WHERE 
					TranDate				>=		DATEADD(DAY, -30, GETDATE())
			AND		
					ISNULL(OtherDetails, '') <>		''

			AND NOT EXISTS
							(
							    SELECT		1
							    FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T
							    WHERE		T.NroReciboMoviventas		=		LEFT(LTRIM(RTRIM(REPLACE(CashHead.OtherDetails, 'COBRANZA MOVIVENTAS ', ''))), 50)
							      AND		ISNULL(T.LegalNumber,'')	=		ISNULL(LEFT(LTRIM(RTRIM(CashHead.LegalNumber)), 30), '')
							      AND		(
													(T.TranAmt = CAST(CashHead.TranAmt AS numeric(17,3)))
												OR		
													(T.TranAmt IS NULL AND CAST(CashHead.TranAmt AS numeric(17,3)) IS NULL)
											)
							      AND		ISNULL(T.Estado,'')			=		CASE	WHEN CashHead.Posted = 0 THEN 'No Posteada'
																						WHEN CashHead.Posted = 1 THEN 'Posteada' 
																				END
							)

        /* Cobranzas integradas y luego eliminadas desde Epicor (últimos 30 días) */
        INSERT INTO @TablaTemporal (OtherDetails, LegalNumber, TranAmt, Estado)
        SELECT
						LEFT(LTRIM(RTRIM(L.Recibo)), 50)										AS OtherDetails,
						NULL																	AS LegalNumber,
						CAST(0 AS numeric(17,3))												AS TranAmt,
						'Eliminada'																AS Estado
        FROM			RVF_Local.dbo.RVF_TBL_IMP_RECIBO_LOG L WITH (NOLOCK)
        WHERE			L.FechaProceso		>=		DATEADD(DAY, -30, GETDATE())--DATEADD(YEAR/*DAY*/, -2, GETDATE()) || DATEADD(DAY, -30, GETDATE())
			AND NOT EXISTS
							(
							  SELECT		1
							  FROM			[CORPL11-EPIDB].EpicorErpTest.Erp.CashHead CH WITH (NOLOCK)
							  WHERE			ISNULL(CH.OtherDetails, '')		<>		''
							    AND		L.Recibo							=		REPLACE(CH.OtherDetails, 'COBRANZA MOVIVENTAS ', '')
							)
          AND NOT EXISTS
							(
								SELECT		1
								FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T
								WHERE		T.NroReciboMoviventas		=		LEFT(LTRIM(RTRIM(L.Recibo)), 50)
								  AND		(T.LegalNumber IS NULL OR T.LegalNumber = '')
								  AND		T.TranAmt = CAST(0 AS numeric(17,3))
								  AND		ISNULL(T.Estado,'') = 'Eliminada'
							)
        /* ================================================================
           2) Manejos los datos obtenidos en @TablaTemporal:
              - UPDATE de existentes
              - INSERT de nuevos
           ================================================================ */

        /* --- UPDATE: registros existentes en destino --- */
        UPDATE		T
        SET			T.LegalNumber	=	S.LegalNumber,
					T.TranAmt		=	S.TranAmt,
					T.Estado		=	S.Estado,
					T.Fecha			=	GETDATE(),
					T.Actualizada	=	1
        FROM		[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas		T
        INNER JOIN	@TablaTemporal														S
					ON	T.NroReciboMoviventas = S.OtherDetails
        WHERE       NOT (
                            ( (T.LegalNumber = S.LegalNumber) OR (T.LegalNumber IS NULL AND S.LegalNumber IS NULL) )
                        AND ( (T.TranAmt     = S.TranAmt)     OR (T.TranAmt     IS NULL AND S.TranAmt     IS NULL) )
                        AND ( (T.Estado      = S.Estado)      OR (T.Estado      IS NULL AND S.Estado      IS NULL) )
                        )

        /* --- INSERT: sólo los que no existen en destino por NroRecibo --- */
        INSERT INTO	[CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas
					(NroReciboMoviventas, LegalNumber, TranAmt, Estado, Fecha, Actualizada)
        SELECT		S.OtherDetails, S.LegalNumber, S.TranAmt, S.Estado, GETDATE(), 0
        FROM		@TablaTemporal														S
        WHERE		NOT EXISTS
					(
						SELECT 1
						FROM [CORPSQLMULT2019].[moviventas_test].dbo.ext_estado_cobranzas T2
						WHERE T2.NroReciboMoviventas = S.OtherDetails
					)

        --COMMIT TRAN
    END TRY
    BEGIN CATCH

        --IF @@TRANCOUNT > 0 ROLLBACK TRAN

        DECLARE @ErrMsg nvarchar(4000) = ERROR_MESSAGE(),
                @ErrNum int = ERROR_NUMBER(),
                @ErrSev int = ERROR_SEVERITY(),
                @ErrSt  int = ERROR_STATE(),
                @ErrLine int = ERROR_LINE(),
                @ErrProc sysname = ERROR_PROCEDURE()

        RAISERROR(N'usp_Sync_Estado_Cobranzas falló. Nº:%d, Sev:%d, Estado:%d, Proc:%s, Línea:%d, Mensaje:%s',
                  @ErrSev, 1, @ErrNum, @ErrSev, @ErrSt, @ErrProc, @ErrLine, @ErrMsg);
    END CATCH
END
GO


