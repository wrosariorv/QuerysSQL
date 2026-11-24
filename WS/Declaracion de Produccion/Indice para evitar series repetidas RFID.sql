-- ============================================================
-- ⭐ CREAR ÍNDICE ÚNICO
-- Ejecuta SOLO si la query anterior retornó 0 filas
-- ============================================================

IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'IX_UniqueRfidSerieConcurrency' 
    AND object_id = OBJECT_ID('[WS].[RF].[RV_TBL_SIP_RFID_SERIE]')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_UniqueRfidSerieConcurrency
    ON [WS].[RF].[RV_TBL_SIP_RFID_SERIE] 
    (
        Company,
        OT,
        PartNum,
        SerialNumber
    )
    WHERE Estado != 'ERROR'
    WITH (FILLFACTOR = 90);

    PRINT '✅ Índice creado exitosamente';
END
ELSE
BEGIN
    PRINT '⚠️  Índice ya existe';
END;