-- ══════════════════════════════════════════════════════════════
-- RetailPro — M5: Consultas con JOINs y UNION ALL
-- Base de datos: Ventas_Tech_DB
-- Autor: [Tu nombre]
-- Fecha: 2026-11-22
-- ══════════════════════════════════════════════════════════════

USE Ventas_Tech_DB;
GO

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: construir la vista enriquecida de ventas cruzando clientes, productos y categorías para el análisis comercial y posterior carga en Power BI.
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_cliente;
-- Hallazgo: [Completar según tu salida, ej.: Se consolidan los registros de venta con cliente, ciudad, producto y categoría listos para filtrar y agrupar en Power BI.]


-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron, para que CRM los contacte.
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;
-- Hallazgo: [Indicar cuántos clientes aparecieron sin compras y qué acción implica para CRM, ej.: activar campaña de bienvenida o recontacto.]


-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar artículos del catálogo sin ventas registradas para que el área de Producto evalúe su rotación o promoción.
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;
-- Hallazgo: [Indicar cuántos productos aparecieron sin ventas y qué implica para el área de Producto, ej.: revisar precio, visibilidad o stock.]


-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar el total facturado entre dos criterios definidos como canal literal sin perder filas repetidas.
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Primera quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) <= 15
    UNION ALL
    SELECT
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Segunda quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) > 15
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;
-- Hallazgo: El 100% de la facturación registrada (6444.00) se concentró en 'Primera quincena', sin ventas en la segunda quincena del período analizado.