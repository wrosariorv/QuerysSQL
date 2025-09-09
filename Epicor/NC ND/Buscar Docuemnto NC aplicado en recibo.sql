--Buscar NC
SELECT            LegalNumber, *
FROM            [CORPEPIDB].EpicorErp.Erp.InvcHead
WHERE            InvoiceNUm                IN                (280173)



--Buscar cabezera de Recibo
SELECT            LegalNumber, *
FROM            [CORPEPIDB].EpicorErp.Erp.CashDtl
WHERE            InvoiceNUm                IN                (280173)




--Buscar detalle de Recibo
SELECT            LegalNumber, *
FROM            [CORPEPIDB].EpicorErp.Erp.CashHead
WHERE            HeadNum                 IN                (197274)