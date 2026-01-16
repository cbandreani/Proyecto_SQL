USE FoodExpress;

-- =========================
-- VISTAS
-- =========================

CREATE OR REPLACE VIEW vw_pedidos_detalle AS
SELECT 
    p.id_pedido,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    r.nombre AS restaurante,
    mp.nombre AS metodo_pago,
    ep.descripcion AS estado_pedido,
    p.fecha_hora,
    p.subtotal,
    p.descuento,
    p.total
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
JOIN Restaurante r ON p.id_restaurante = r.id_restaurante
JOIN Metodo_pago mp ON p.id_metodo = mp.id_metodo
JOIN Estado_pedido ep ON p.id_estado = ep.id_estado;

CREATE OR REPLACE VIEW vw_ventas_por_restaurante AS
SELECT 
    r.id_restaurante,
    r.nombre AS restaurante,
    SUM(p.total) AS total_ventas
FROM Pedido p
JOIN Restaurante r ON p.id_restaurante = r.id_restaurante
GROUP BY r.id_restaurante, r.nombre;

CREATE OR REPLACE VIEW vw_productos_mas_vendidos AS
SELECT 
    pr.id_producto,
    pr.nombre AS producto,
    SUM(ip.cantidad) AS cantidad_vendida
FROM Item_pedido ip
JOIN Producto pr ON ip.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre;

CREATE OR REPLACE VIEW vw_pedidos_por_estado AS
SELECT 
    ep.descripcion AS estado,
    COUNT(p.id_pedido) AS cantidad_pedidos
FROM Pedido p
JOIN Estado_pedido ep ON p.id_estado = ep.id_estado
GROUP BY ep.descripcion;

CREATE OR REPLACE VIEW vw_ventas_por_zona AS
SELECT 
    z.nombre AS zona,
    SUM(p.total) AS total_ventas
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
JOIN Zona z ON c.id_zona = z.id_zona
GROUP BY z.nombre;

-- =========================
-- FUNCIONES
-- =========================

DELIMITER $$

CREATE FUNCTION fn_subtotal_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE subtotal DECIMAL(10,2);

    SELECT SUM(cantidad * precio_unitario)
    INTO subtotal
    FROM Item_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN IFNULL(subtotal, 0);
END $$

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

-- =========================
-- STORED PROCEDURES
-- =========================

DELIMITER $$

CREATE PROCEDURE sp_crear_pedido(
    IN p_id_cliente INT,
    IN p_id_restaurante INT,
    IN p_id_repartidor INT,
    IN p_id_metodo INT
)
BEGIN
    INSERT INTO Pedido (
        id_cliente, id_restaurante, id_repartidor,
        id_metodo, id_estado, fecha_hora,
        subtotal, descuento, total
    )
    VALUES (
        p_id_cliente, p_id_restaurante, p_id_repartidor,
        p_id_metodo, 1, NOW(), 0, 0, 0
    );

    INSERT INTO Historial_estado_pedido (id_pedido, id_estado)
    VALUES (LAST_INSERT_ID(), 1);
END $$

CREATE PROCEDURE sp_actualizar_estado_pedido(
    IN p_id_pedido INT,
    IN p_id_estado INT
)
BEGIN
    UPDATE Pedido
    SET id_estado = p_id_estado
    WHERE id_pedido = p_id_pedido;

    INSERT INTO Historial_estado_pedido (id_pedido, id_estado)
    VALUES (p_id_pedido, p_id_estado);
END $$

DELIMITER ;

-- =========================
-- TRIGGERS
-- =========================

DELIMITER $$

CREATE TRIGGER tr_actualizar_totales_pedido
AFTER INSERT ON Item_pedido
FOR EACH ROW
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);

    SET v_subtotal = fn_subtotal_pedido(NEW.id_pedido);

    UPDATE Pedido
    SET subtotal = v_subtotal,
        total = v_subtotal - descuento
    WHERE id_pedido = NEW.id_pedido;
END $$

CREATE TRIGGER tr_repartidor_ocupado
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
    UPDATE Repartidor
    SET estado = 'Ocupado'
    WHERE id_repartidor = NEW.id_repartidor;
END $$

DELIMITER ;
