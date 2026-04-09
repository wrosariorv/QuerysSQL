CREATE SCHEMA [DP]
-- Crear tabla de Encabezado
CREATE TABLE [DP].DespachoHdr (
    Company NVARCHAR(50) NOT NULL,
    TranNum BIGINT IDENTITY(1,1) NOT NULL,
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

-- Crear tabla de Detalle
CREATE TABLE DespachoDtl (
    IdDtl BIGINT IDENTITY(1,1) NOT NULL, -- Llave primaria propia para la fila de detalle
    TranNum BIGINT NOT NULL,
    Whse NVARCHAR(50) NULL,
    BinNum NVARCHAR(50) NULL,
    PackLine INT NULL,
    OrderNum INT NULL,
    OrderLine INT NULL,
    OrderRelNum INT NULL,
    DisplayInvQty DECIMAL(18,2) NULL,
    SerialNo NVARCHAR(MAX) NULL, -- MAX para soportar la cadena larga concatenada con ~
    FechaActualizacion DATETIME NULL,
    Estado NVARCHAR(MAX) NULL,
    CONSTRAINT PK_DespachoDtl PRIMARY KEY CLUSTERED (IdDtl),
    
    -- Foreign Key con borrado en cascada
    CONSTRAINT FK_DespachoDtl_Hdr FOREIGN KEY (TranNum) 
        REFERENCES DespachoHdr (TranNum) 
        ON DELETE CASCADE
);
GO

-- (Opcional) Crear un índice para mejorar las búsquedas por TranNum en el detalle
CREATE NONCLUSTERED INDEX IX_DespachoDtl_TranNum ON DespachoDtl(TranNum);
GO