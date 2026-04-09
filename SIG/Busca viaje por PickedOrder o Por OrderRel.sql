--Con PickedOrder
    SELECT          DISTINCT
                    VIAJE.Company,
                    VIAJE.Key2                  AS Plant,    
                    CAST(VIAJE.Number01 AS INT) AS  OrderNum,
                    CAST(VIAJE.Number02 AS INT) AS  OrderLine,
                    CAST(VIAJE.Number03 AS INT) AS  OrderRelNum,
                    CAST(VIAJE.key3 AS INT)     AS  Viaje 

    FROM            [CORPE11-EPIDB].EpicorErp.Ice.UD110A            VIAJE WITH (NoLock)
    INNER JOIN      [CORPE11-EPIDB].EpicorErp.Erp.PickedOrders PO WITH (NoLock)
        ON          VIAJE.Company       = PO.Company COLLATE Modern_Spanish_CI_AS
        AND         VIAJE.Key2          = PO.Plant COLLATE Modern_Spanish_CI_AS
        AND         VIAJE.Number01      = PO.OrderNum
        AND         VIAJE.Number02      = PO.OrderLine
        AND         VIAJE.Number03      = PO.OrderRelNum
    INNER JOIN [CORPE11-EPIDB].EpicorErp.Erp.Part P WITH (NoLock)
        ON          PO.Company          = P.Company
        AND         PO.PartNum          = P.PartNum
    WHERE           VIAJE.Company       = 'CO01'
        AND         VIAJE.Key2          = 'CDEE'
        AND         VIAJE.Number01      = '285147'

    


--SinPickedOrder
    SELECT          DISTINCT
                    VIAJE.Company,
                    VIAJE.Key2                  AS Plant,    
                    CAST(VIAJE.Number01 AS INT) AS  OrderNum,
                    CAST(VIAJE.Number02 AS INT) AS  OrderLine,
                    CAST(VIAJE.Number03 AS INT) AS  OrderRelNum,
                    CAST(VIAJE.key3 AS INT)     AS  Viaje 

    FROM            [CORPE11-EPIDB].EpicorErp.Ice.UD110A            VIAJE WITH (NoLock)
    INNER JOIN      [CORPE11-EPIDB].[EpicorErp].Erp.OrderRel        REL WITH (NoLock)
        ON          VIAJE.Company       = REL.Company COLLATE Modern_Spanish_CI_AS
        AND         VIAJE.Key2          = REL.Plant COLLATE Modern_Spanish_CI_AS
        AND         VIAJE.Number01      = REL.OrderNum
        AND         VIAJE.Number02      = REL.OrderLine
        AND         VIAJE.Number03      = REL.OrderRelNum
    INNER JOIN [CORPE11-EPIDB].EpicorErp.Erp.Part P WITH (NoLock)
        ON          REL.Company          = P.Company
        AND         REL.PartNum          = P.PartNum
    WHERE           VIAJE.Company       = 'CO01'
        AND         VIAJE.Key2          = 'CDEE'
        AND         VIAJE.Number01      = '285147'