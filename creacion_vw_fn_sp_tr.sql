USE FoodExpress;

-- =====================================================
-- VISTAS
-- =====================================================

-- Vista: Detalle completo de pedidos
CREATE VIEW vw_pedidos_detalle AS
SELECT 
    p.id_pedido,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    r.nombre AS restaurante,
    mp.nombre AS metodo_pago,
    ep.descripcion AS estado_pedido,
    p.fecha_hora,
    p.total
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
JOIN Restaurante r ON p.id_restaurante = r.id_restaurante
JOIN Metodo_pago mp ON p.id_metodo = mp.id_metodo
JOIN Estado_pedido ep ON p.id_estado = ep.id_estado;

-- Vista: Ventas totales por restaurante
CREATE VIEW vw_ventas_por_restaurante AS
SELECT 
    r.id_restaurante,
    r.nombre AS restaurante,
    SUM(p.total) AS total_ventas
FROM Pedido p
JOIN Restaurante r ON p.id_restaurante = r.id_restaurante
GROUP BY r.id_restaurante, r.nombre;

-- Vista: Productos más vendidos
CREATE VIEW vw_productos_mas_vendidos AS
SELECT 
    pr.id_producto,
    pr.nombre AS producto,
    SUM(ip.cantidad) AS cantidad_vendida
FROM Item_pedido ip
JOIN Producto pr ON ip.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre;


-- =====================================================
-- FUNCIONES
-- =====================================================

DELIMITER $$

-- Función: Calcula el total de un pedido
CREATE FUNCTION fn_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(cantidad * precio_unitario)
    INTO total
    FROM Item_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN IFNULL(total, 0);
END $$

-- Función: Cantidad de pedidos por cliente
CREATE FUNCTION fn_cantidad_pedidos_cliente(p_id_cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*)
    INTO cantidad
    FROM Pedido
    WHERE id_cliente = p_id_cliente;

    RETURN cantidad;
END $$

DELIMITER ;


-- =====================================================
-- STORED PROCEDURES
-- =====================================================

DELIMITER $$

-- SP: Crear un nuevo pedido
CREATE PROCEDURE sp_crear_pedido(
    IN p_id_cliente INT,
    IN p_id_restaurante INT,
    IN p_id_repartidor INT,
    IN p_id_metodo INT
)
BEGIN
    INSERT INTO Pedido (
        id_cliente,
        id_restaurante,
        id_repartidor,
        id_metodo,
        id_estado,
        fecha_hora,
        total
    )
    VALUES (
        p_id_cliente,
        p_id_restaurante,
        p_id_repartidor,
        p_id_metodo,
        1,
        NOW(),
        0
    );
END $$

-- SP: Actualizar estado de pedido
CREATE PROCEDURE sp_actualizar_estado_pedido(
    IN p_id_pedido INT,
    IN p_id_estado INT
)
BEGIN
    UPDATE Pedido
    SET id_estado = p_id_estado
    WHERE id_pedido = p_id_pedido;
END $$

DELIMITER ;


-- =====================================================
-- TRIGGERS
-- =====================================================

DELIMITER $$

-- Trigger: Actualiza el total del pedido al insertar ítems
CREATE TRIGGER tr_actualizar_total_pedido
AFTER INSERT ON Item_pedido
FOR EACH ROW
BEGIN
    UPDATE Pedido
    SET total = fn_total_pedido(NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END $$

DELIMITER ;