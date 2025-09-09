# Querys – Índice y guía rápida

Repositorio de consultas T‑SQL y utilidades relacionadas a **Epicor**, **Moviventas**, **Multivende**, **SIG** y **WS** (integraciones y procesos). Este README resume **qué tipo de consultas** hay en cada carpeta **sin detallar cada archivo**.

> **Nota:** Las rutas y nombres siguen el árbol original de Windows. En GitHub, cada carpeta aquí listada será un subdirectorio dentro del repo.

---

## Estructura de carpetas (resumen por tema)

### `/Epicor`

Consultas y scripts para módulos y objetos de Epicor (ventas, compras, stock, series, permisos, SSRS, etc.).

* **BPM**: búsquedas y diagnósticos sobre **Business Process Management** (directivas de métodos, localizar código/strings dentro de BPMs).
* **CAEA**: validaciones y soporte de integración **AFIP CAEA** (comprobantes no asociados, revisión de SP, pruebas y ejecución de procesos CAEA).
* **Clientes**: datos de clientes (por ej., correos, auditorías básicas).
* **CM05**: controles y reportes asociados a **CM05** (gestión fiscal/tributaria, vencimientos, consistencias).
* **Compradores**: límites y parámetros de aprobadores/compradores.
* **Condiciones de Pago**: consultas sobre condiciones de pago de clientes/proveedores.
* **Cotizacion**: análisis y seguimiento de **cotizaciones** (sincronía con OV, líneas, control de no-conversión a OV, utilidades de ordenamiento).
* **Despachos Embarques**: control e investigación de **despachos/embarques** (pendientes, errores de integración, extracción de datos para depuración).
* **Domicilio de embarque**: validaciones de direcciones de entrega/embarque y errores asociados.
* **Envio de email**: listados/condiciones para notificaciones por correo (p.ej. remitos no facturados).
* **FC**: soporte y consultas de **facturación** (cabecera/detalle, ajustadores para detalle/UD, trazabilidad).
* **Fuerza de Trabajo**: autorizaciones y asignaciones por OV/recursos.
* **Impuestos**: tipos, jurisdicciones y verificaciones fiscales.
* **Ingreso de Cheques CSV**: procesos de **importación/limpieza/validación** de CSVs de tesorería (SPs de staging, normalización, controles previos).
* **Lista de precios**: búsqueda y validación de listas por parte/producto.
* **Mplace**: validaciones y consistencias para **Marketplaces** (propiedades de idioma/atributos en partes).
* **NC ND**: **notas de crédito/débito** (aplicaciones, saldos, pre‑Epicor, consistencias).
* **OT**: consultas por **órdenes de trabajo** (filtros por período, trazas).
* **OV**: **órdenes de venta** (impuestos, estados, cobertura con fabricación, integración marketplaces).
* **PartFIFO**: ejecuciones/controles de **costeo FIFO por parte** (SPs, actualizaciones, consistencias PartFifoCost).
* **Permisos**: auditoría de **perfiles/roles** y permisos necesarios para operaciones (alta de series, etc.).
* **PRC**: procesos y controles varios (p.ej., análisis de crédito, T/C, revisiones específicas).
* **Recibos cobranzas**: trazabilidad de **recibos** (errores de aplicación, búsquedas, conciliaciones).
* **Remito Aduana**: controles y consistencias de **documentación aduanera**.
* **Remitos**: **conformidades**, pendientes, problemas de numeración/campos, SPs de corrección.
* **Requisicion**: aprobaciones, búsqueda y análisis de **requisiciones**.
* **RMA**: control de **devoluciones** (facturas asociadas y actualización de datos).
* **Scripts**: colección de **controles/diagnósticos/ajustes** por fecha (prefijo `YYMMDD - ...`). Incluye ventas, cotizaciones, series, comisiones, impuestos, márgenes, percepciones, padrones, etc.
* **Series**: **números de serie** (actualizaciones, bin/warehouse, consultas de estado/pendientes, consistencias).
* **ServiceConnect**: diagnósticos de **integraciones Service Connect** (errores de altas/actualizaciones, empaques/packouts).
* **SSRS**: **suscripciones** y **parámetros** de reportes (filtros, ejecuciones programadas).
* **Stock**: existencia por parte, habilitaciones en PartPlant, consolidación de stock interno.
* **Sueldos**: acceso a **asiento de sueldos** (tablas, vistas, SPs) y consultas de apoyo.
* **Tasa de cambio**: búsquedas/verificaciones de **tipos de cambio** cargados.
* **Usuarios**: administración de **usuarios Epicor** (deshabilitar, auditoría básica).
* **Viajes**: **viajes de despacho** (controles de datos, extracción de OV asociadas).
* **WareHouse**: relaciones **Warehouse/Plant**, validaciones de configuración.
* **Wave**: actualizaciones y controles de **Waves** de picking/expedición.

---

### `/Moviventas`

Consultas para integración/operación con **Moviventas**.

* **Cobranzas**: búsqueda de recibos, detección de repetidos, conciliaciones comparativas.
* **Cotizaciones**: trazas de ingreso, vistas de control, mapeo con OV en Epicor, SPs de guardado de pedidos.
* **Usuario**: habilitación/administración básica de usuarios.
* **Vistas**: vistas de análisis (**ventas**, **cobranzas**, órdenes‑viajes‑remitos‑facturas) para reporting e integración.

---

### `/Multivende`

Consultas y SPs de soporte a la integración con **Multivende**/**Shopify**: autenticación (**tokens**), backfill/reprocesos de pedidos, detección de registros duplicados, comentarios en facturas, UD/propiedades, validaciones de fechas/zonas/UTC, vistas de estado, **tablas de stock y precios**, requests a APIs y trazas de notificaciones.

---

### `/SIG`

Soporte a procesos de **SIG** (despachos/series), detección de pendientes y vínculos entre despachos y números de serie.

---

### `/WS`

Consultas/funciones/SPs asociados a **servicios** e **integraciones** (producción, licencias, despachos API, e‑commerce, PCDB, transferencias, etc.).

* **Actualiza Series DMT**: validaciones/colas para **DMT** de series (inserciones a tablas intermedias, medición de tiempos, borradores de reglas).
* **CIMEI**: búsquedas y controles sobre **IMEI/CIMEI** (validación por fecha, consistencias).
* **Declaracion de Produccion**: control y trazabilidad de **transferencias de producción** (creación de encabezados, inserción de series, labels, notificaciones por email, reinicio de tablas, SPs de pendientes/estado, vistas de reporte). Subcarpetas con **Imeis** y utilidades.
* **Despachos API**: diagnóstico/monitoreo de **integración de despachos** vía API.
* **Facturas Ecommerce**: control de **entrega de facturas** a canales e‑commerce.
* **Licencias**: generación/gestión de **licencias**, concurrencia, limpieza de duplicados, vistas operativas.
* **PCDB**: consultas para **Portal Comercial/PC** (actualizaciones de estado, invoice, control de comprobantes, tablas soporte).
* **Transferecia de Stock / Transferencias entre planta**: consultas y SPs para **movimientos y transferencias** (incluye **multi‑parte**, ambientes *Producción/Test*, validaciones por partes/servicio/outlet).
* **Transferencias Inventario o Entre Planta**: scripts generales de transferencia.
* **Utiles**: snippets y SPs de utilidad (sequences, inserts con identity, búsquedas de facturado por años, verificación de stock/warehouse por ambiente).

---

### `/Utilidades`

Utilidades genéricas de **SQL Server**.

* **Administracion DB**: búsqueda de texto en **SP/Vistas**, análisis de **bloqueos**, habilitar/deshabilitar bases, insertar archivos, **reiniciar IDENTITY**, fechas de última restauración, etc.
* **Base64**: conversión de binarios/PDF ↔ **Base64/Hex**.
* **Envio de email**: ejemplo para enviar correos desde T‑SQL.
* **Job**: utilidades para **SQL Agent** (ajustar schedule fin de mes, deshabilitar jobs, cálculo de días especiales).

---

### `/Notas`

Notas operativas y **apuntes técnicos** (p.ej., cambios de servidor de base de datos).

---

## Convenciones de nombres (observadas y sugeridas)

* **Prefijo de fecha** en muchos scripts: `YYMMDD - Descripción.sql` (ej.: `210625 - Control PrimBin por parte.sql`).
* **Sugerencia**: estandarizar a `YYYY‑MM‑DD_Area_Tema.sql` (ej.: `2021-06-25_Epicor_Stock_ControlPrimBin.sql`).
* **Áreas**: `Epicor`, `Moviventas`, `Multivende`, `WS`, `SIG`, `Utilidades`.
* **Tipos** (opcional en el nombre): `SELECT`, `FIX`, `SP`, `VW`, `JOB`, `ETL`.

### Encabezado recomendado dentro de cada `.sql`

```sql
/*
  Título: <breve>
  Área: <Epicor|Moviventas|Multivende|WS|SIG|Utilidades>
  Propósito: <qué problema responde>
  Tipo: <SELECT|DML|DDL|SP|VW|JOB>
  Entorno: <DEV|TEST|PILOTO|PROD>
  Impacto: <solo lectura|modifica datos|estructural>
  Tablas clave: <schema.tabla, ...>
  Autor: <iniciales>  Fecha: <YYYY‑MM‑DD>
  Tags: <cotizacion, remito, series, ...>
*/
```

---

## Buenas prácticas de ejecución

* **Leer primero**: revisar encabezado, entorno y tablas afectadas.
* **Separar SELECT vs DML**: si hay fixes, envolver en `BEGIN TRAN` y **probar con `ROLLBACK`** antes de `COMMIT`.
* **Usar filtros por rango/empresa** para evitar escaneos completos en PROD.
* **Guardar evidencia** (resultado o `ROWCOUNT`) al aplicar correcciones.

---

## Búsqueda rápida

* **En GitHub**: usar *Code Search* con filtros: `repo:<org>/<repo> extension:sql "OV"`, `path:/Epicor/OV`, `org:<org> "PartFifo"`.
* **Local (clonado)**: usar el buscador del editor o `Select-String`/`rg` sobre la carpeta del repo.

---

## Mantenimiento

* Mantener **consistencia de nombres** y **encabezados**.
* Registrar cambios relevantes en un `CHANGELOG.md` (alta de carpetas, scripts sensibles, procedimientos nuevos).
* Preferir **carpetas por tema** (como las actuales) y evitar duplicados entre áreas.

---

> ¿Querés que agreguemos un `CHANGELOG.md`, `.gitignore` y una plantilla de script (`template.sql`) con el encabezado anterior? Puedo incorporarlos en este repo.
