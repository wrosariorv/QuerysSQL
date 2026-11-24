CREATE SCHEMA [DP]

IF OBJECT_ID('[DP].[DespachoDtl]', 'U') IS NOT NULL DROP TABLE [DP].[DespachoDtl];
IF OBJECT_ID('[DP].[DespachoHdr]', 'U') IS NOT NULL DROP TABLE [DP].[DespachoHdr];
GO

CREATE TABLE [DP].DespachoHdr (
    Company NVARCHAR(50) NOT NULL,
    TranNum INT IDENTITY(1,1) NOT NULL,
    Plant NVARCHAR(50) NOT NULL,
    ShipDate DATETIME NOT NULL,    
    OrderNum INT NOT NULL,
    FechaDespacho DATETIME NOT NULL,
    FechaActualizacion DATETIME NULL,
    Estado NVARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_DespachoHdr PRIMARY KEY CLUSTERED (TranNum)
);
GO
ALTER TABLE [DP].[DespachoHdr] ADD  DEFAULT (getdate()) FOR [FechaDespacho]
ALTER TABLE [DP].[DespachoHdr] ADD  DEFAULT ('Pendiente') FOR [Estado]


-- 3. Crear tabla de Detalle con Llave Compuesta
CREATE TABLE [DP].DespachoDtl (
    TranNum INT NOT NULL,
    OrderLine INT NOT NULL,
    OrderRelNum INT NOT NULL,
    SerialNo NVARCHAR(50) NOT NULL, -- Longitud definida para permitir PK
    Whse NVARCHAR(50) NOT NULL,
    BinNum NVARCHAR(50) NOT NULL,
    DisplayInvQty DECIMAL(18,2) NOT NULL,
    FechaActualizacion DATETIME NULL,
    Estado NVARCHAR(100) NOT NULL DEFAULT ('Pendiente'),

    -- Llave Primaria Compuesta (Garantiza no duplicidad de Serie por Linea/Rel/Tran)
    CONSTRAINT PK_DespachoDtl PRIMARY KEY CLUSTERED (TranNum, OrderLine, OrderRelNum, SerialNo),
    
    -- Relación con el encabezado y borrado en cascada
    CONSTRAINT FK_DespachoDtl_Hdr FOREIGN KEY (TranNum) 
        REFERENCES [DP].DespachoHdr (TranNum) 
        ON DELETE CASCADE
);
GO
-- (Opcional) Crear un índice para mejorar las búsquedas por TranNum en el detalle
CREATE NONCLUSTERED INDEX IX_DespachoDtl_TranNum ON [DP].DespachoDtl(TranNum);
GO