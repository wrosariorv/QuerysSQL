USE [SIG-CD]
GO

/*
ALTER PROCEDURE [dbo].[PRC_VERIFICAR_DESPACHOS_PENDIENTES_INICIAL]
      @Company      NVARCHAR(8)
    , @Plant        NVARCHAR(8)
    , @OrderNum     INT
    , @OrderLine    INT
    , @OrderRelNum  INT   -- liberación que se desea tomar ahora
AS
*/
--/*
DECLARE					@Company		NVARCHAR(8)		=		'CO01',
						@Plant			NVARCHAR(8)		=		'CDEE',
						@OrderNum		INT				=		283466,--283107,
						@OrderLine		INT				=		1,
						@OrderRelNum	INT				=		1
--*/
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @Estado      NVARCHAR(10)   = N'OK';
    DECLARE @Mensaje        NVARCHAR(4000) = N'';
    DECLARE @PendientesCSV  NVARCHAR(4000) = N'';
 
    /* Caso simple: si NO es liberación 1, no hay validación adicional */
    IF (@OrderRelNum <> 1)
    BEGIN
        SET @Mensaje = N'Liberación distinta de 1; validación no requerida.';
        SELECT
              Estado		= @Estado
            , Mensaje       = @Mensaje
            , Company       = @Company
            , Plant         = @Plant
            , OrderNum      = @OrderNum
            , OrderLine     = @OrderLine
            , OrderRelNum   = @OrderRelNum
            , PendientesCSV = @PendientesCSV;
        RETURN;
    END;
 
    /* ========= Reemplazo de CTE por TABLAS VARIABLES ========= */
 
    DECLARE @OtrasRel TABLE (OrderRelNum INT PRIMARY KEY);
    DECLARE @OtrasNoTomadas TABLE (OrderRelNum INT PRIMARY KEY);
 
    /* Otras liberaciones (<>1) de ESTA misma línea */
    INSERT INTO @OtrasRel (OrderRelNum)
    SELECT DISTINCT Ore.OrderRelNum
    FROM [CORPE11-EPIDB].EpicorErp.Erp.OrderRel AS Ore WITH (NOLOCK)
    WHERE Ore.Company   = @Company
      AND Ore.Plant     = @Plant
      AND Ore.OrderNum  = @OrderNum
      AND Ore.OrderLine = @OrderLine
      AND Ore.OrderRelNum <> 1
      -- Si querés considerar solo liberaciones abiertas:
      -- AND ISNULL(Ore.OpenRelease, 0) = 1
    ;
 
    /* De esas otras liberaciones, marcar las que NO están tomadas en [Ordenes] */
    INSERT INTO @OtrasNoTomadas (OrderRelNum)
    SELECT r.OrderRelNum
    FROM @OtrasRel AS r
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[Ordenes] AS o WITH (NOLOCK)
        WHERE o.Company     = @Company
          AND o.Plant       = @Plant
          AND o.OrderNum    = @OrderNum
          -- Si tu criterio de “tomada” requiere finalización, activá esta línea:
          -- AND o.FechaFin IS NOT NULL
    );
 
    /* Armar el CSV con las pendientes */
    SELECT @PendientesCSV =
        STRING_AGG(CAST(OrderRelNum AS NVARCHAR(20)), N', ')
    FROM @OtrasNoTomadas;
 
    IF (@PendientesCSV IS NOT NULL AND LEN(@PendientesCSV) > 0)
    BEGIN
        SET @Estado = N'ERROR';
        SET @Mensaje   = N'No se debe tomar la liberación 1. Existen otras liberaciones pendientes de tomar en [Ordenes]: '
                       + @PendientesCSV;
    END
    ELSE
    BEGIN
        SET @Mensaje = N'Se permite tomar la liberación 1 (no hay otras pendientes o todas ya fueron tomadas).';
    END;
 
    /* Respuesta única por SELECT */
    SELECT
          Estado		= @Estado
        , Mensaje       = @Mensaje
        , Company       = @Company
        , Plant         = @Plant
        , OrderNum      = @OrderNum
        , OrderLine     = @OrderLine
        , OrderRelNum   = @OrderRelNum
        , PendientesCSV = ISNULL(@PendientesCSV, N'');
END