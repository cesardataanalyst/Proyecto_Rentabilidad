-- ============================================================
-- PROYECTO DE RENTABILIDAD
-- Análisis de ventas y utilidad
-- ============================================================
--
-- Base de datos: SQLite
-- Tabla principal: sales
-- Registros analizados: 9,994
--
-- Objetivo:
-- Analizar ventas, utilidad, margen, productos,
-- descuentos, regiones y segmentos.
-- ============================================================


-- ============================================================
-- 1. KPIs GENERALES
-- ============================================================

SELECT
    COUNT(*) AS total_registros,
    COUNT(DISTINCT "Order ID") AS total_ordenes,
    COUNT(DISTINCT "Customer ID") AS total_clientes,
    SUM("Sales") AS ventas_totales,
    SUM("Profit") AS utilidad_total,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales; 
-- ============================================================
-- 2. RENTABILIDAD POR CATEGORÍA
-- ============================================================

SELECT
    "Category" AS categoria,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY "Category"
ORDER BY utilidad DESC;
-- ============================================================
-- 3. RENTABILIDAD POR SUBCATEGORÍA
-- ============================================================

SELECT
    "Sub-Category" AS subcategoria,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY "Sub-Category"
ORDER BY utilidad DESC;
-- ============================================================
-- 4. RENTABILIDAD POR NIVEL DE DESCUENTO
-- ============================================================

SELECT
    "Discount" AS descuento,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY "Discount"
ORDER BY descuento;
-- ============================================================
-- 5. RENTABILIDAD POR REGIÓN
-- ============================================================

SELECT
    "Region" AS region,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY "Region"
ORDER BY utilidad DESC;
-- ============================================================
-- 6. RENTABILIDAD POR SEGMENTO
-- ============================================================

SELECT
    "Segment" AS segmento,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY "Segment"
ORDER BY utilidad DESC;
-- ============================================================
-- 7. PRODUCTOS CON PÉRDIDA NETA
-- ============================================================

SELECT
    "Product ID" AS product_id,
    "Product Name" AS product_name,
    SUM("Sales") AS ventas,
    SUM("Profit") AS utilidad,
    SUM("Quantity") AS cantidad,
    SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100 AS margen_utilidad
FROM sales
GROUP BY
    "Product ID",
    "Product Name"
HAVING SUM("Profit") < 0
ORDER BY utilidad ASC
LIMIT 10;
-- ============================================================
-- 8. OPERACIONES INDIVIDUALES CON PÉRDIDA
-- ============================================================

SELECT
    COUNT(*) AS operaciones_con_perdida,
    SUM("Sales") AS ventas_asociadas,
    SUM("Profit") AS perdida_acumulada,
    SUM("Quantity") AS unidades
FROM sales
WHERE "Profit" < -1e-9;
-- ============================================================
-- 9. PÉRDIDAS POR CATEGORÍA Y SUBCATEGORÍA
-- ============================================================

SELECT
    "Category" AS categoria,
    "Sub-Category" AS subcategoria,
    COUNT(*) AS operaciones_con_perdida,
    SUM("Sales") AS ventas_con_perdida,
    SUM("Profit") AS perdida_acumulada,
    SUM("Quantity") AS unidades
FROM sales
WHERE "Profit" < -1e-9
GROUP BY
    "Category",
    "Sub-Category"
ORDER BY perdida_acumulada ASC;
-- ============================================================
-- 10. CLASIFICACIÓN DE PRODUCTOS POR RENTABILIDAD
-- ============================================================

SELECT
    COUNT(*) AS total_productos,
    SUM(CASE WHEN utilidad > 1e-9 THEN 1 ELSE 0 END) AS productos_rentables,
    SUM(CASE WHEN utilidad < -1e-9 THEN 1 ELSE 0 END) AS productos_con_perdida,
    SUM(CASE WHEN ABS(utilidad) <= 1e-9 THEN 1 ELSE 0 END) AS productos_sin_utilidad
FROM (
    SELECT
        "Product ID",
        "Product Name",
        SUM("Profit") AS utilidad
    FROM sales
    GROUP BY
        "Product ID",
        "Product Name"
) AS productos;
-- ============================================================
-- 11. PRINCIPALES OPERACIONES INDIVIDUALES CON PERDIDA
-- ============================================================

SELECT
    "Order ID" AS order_id,
    "Order Date" AS order_date,
    "Product ID" AS product_id,
    "Product Name" AS product_name,
    "Category" AS category,
    "Sub-Category" AS subcategory,
    "Sales" AS sales,
    "Discount" AS discount,
    "Profit" AS profit
FROM sales
WHERE "Profit" < -1e-9
ORDER BY "Profit" ASC
LIMIT 10;