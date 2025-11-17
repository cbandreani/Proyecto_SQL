-- SCRIPT: FoodExpress (MySQL 8.0)

DROP DATABASE IF EXISTS FoodExpress;
CREATE DATABASE FoodExpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE FoodExpress;

-- Tabla ZONA
CREATE TABLE Zona (
    id_zona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Tabla METODO_PAGO
CREATE TABLE Metodo_pago (
    id_metodo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Tabla ESTADO_PEDIDO
CREATE TABLE Estado_pedido (
    id_estado INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Tabla CATEGORIA
CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Tabla CLIENTE
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    id_zona INT,
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- Tabla RESTAURANTE
CREATE TABLE Restaurante (
    id_restaurante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(200),
    id_zona INT,
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- Tabla REPARTIDOR
CREATE TABLE Repartidor (
    id_repartidor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    id_zona INT,
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- Tabla PRODUCTO
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    id_categoria INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
) ENGINE=InnoDB;

-- Tabla PEDIDO
CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_restaurante INT NOT NULL,
    id_repartidor INT NOT NULL,
    id_metodo INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor),
    FOREIGN KEY (id_metodo) REFERENCES Metodo_pago(id_metodo),
    FOREIGN KEY (id_estado) REFERENCES Estado_pedido(id_estado)
) ENGINE=InnoDB;

-- Tabla ITEM_PEDIDO
CREATE TABLE Item_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
) ENGINE=InnoDB;

-- ===================================================================
-- INSERTS: dataset
-- ===================================================================

-- ZONAS (10)
INSERT INTO Zona (nombre) VALUES
('Centro'),
('Norte'),
('Sur'),
('Este'),
('Oeste'),
('Barrio Jardín'),
('Rivera'),
('Parque Industrial'),
('Universitario'),
('Puerto');

-- METODOS DE PAGO (4)
INSERT INTO Metodo_pago (nombre) VALUES
('Efectivo'),
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('MercadoPago');

-- ESTADOS DE PEDIDO (5)
INSERT INTO Estado_pedido (descripcion) VALUES
('Pendiente'),
('Preparando'),
('En camino'),
('Entregado'),
('Cancelado');

-- CATEGORÍAS (8)
INSERT INTO Categoria (nombre) VALUES
('Pizzas'),
('Sushi'),
('Hamburguesas'),
('Bebidas'),
('Pastas'),
('Tacos'),
('Wok'),
('Postres');

-- CLIENTES (20)
INSERT INTO Cliente (nombre, apellido, email, telefono, id_zona) VALUES
('Juan','Pérez','juan.perez@gmail.com','1122334455',1),
('María','Gómez','maria.gomez@gmail.com','1133445566',2),
('Luis','Ramírez','luis.ramirez@hotmail.com','1144556677',3),
('Ana','Rojas','ana.rojas@gmail.com','1155667788',4),
('Carlos','Gutiérrez','carlos.g@gmail.com','1166778899',5),
('Sofía','Torres','sofia.t@gmail.com','1177889900',6),
('Diego','Fernández','diego.f@gmail.com','1188990011',7),
('Lucía','Martínez','lucia.m@gmail.com','1199001122',8),
('Pedro','López','pedro.l@gmail.com','1100112233',9),
('Laura','Sosa','laura.s@gmail.com','1200223344',10),
('Andrés','Delgado','andres.d@gmail.com','1300334455',1),
('Paula','Méndez','paula.m@gmail.com','1400445566',2),
('Julián','Silva','julian.s@gmail.com','1500556677',3),
('Camila','Vega','camila.v@gmail.com','1600667788',4),
('Agustín','Correa','agustin.c@gmail.com','1700778899',5),
('Valentina','Ibarra','valen.i@gmail.com','1800889900',6),
('Martín','Soria','martin.s@gmail.com','1900990011',7),
('Florencia','Gauna','flo.g@gmail.com','2000112233',8),
('Hernán','Pinto','hernan.p@gmail.com','2100223344',9),
('Daniela','Suárez','daniela.s@gmail.com','2200334455',10);

-- RESTAURANTES (10)
INSERT INTO Restaurante (nombre, direccion, id_zona) VALUES
('PizzaPlanet','Av. Siempre Viva 123',1),
('SushiGo','Calle Japón 45',2),
('BurgerHouse','Ruta 8 km 15',3),
('PastaFresca','Av. Italia 331',4),
('TacoLoco','Diagonal 77 202',5),
('VeggieMix','Av. Salud 890',6),
('WokExpress','Calle Asia 10',7),
('Empanadas Don José','Ruta 3 km 120',8),
('PolloFritoYA','Av. Libertad 455',9),
('Heladería Alaska','Bv. Hielo Azul 12',10);

-- REPARTIDORES (20)
INSERT INTO Repartidor (nombre, apellido, telefono, id_zona) VALUES
('Carlos','Suarez','1155667788',1),
('Ana','Torres','1166778899',2),
('Diego','López','1177889900',3),
('Mauro','Paz','1188990011',4),
('Carla','Soria','1199001122',5),
('Leonel','Bruno','1100112233',6),
('Bárbara','Funes','1200223344',7),
('Hugo','Ríos','1300334455',8),
('Tamara','Ledesma','1400445566',9),
('Ezequiel','Mena','1500556677',10),
('Marcos','Benítez','1555667788',1),
('Luciana','Ferreyra','1666778899',2),
('Sebastián','Arias','1777889900',3),
('Cecilia','Salas','1888990011',4),
('Rodrigo','León','1999001122',5),
('Brenda','Quiroga','2000112233',6),
('Franco','Peralta','2100223344',7),
('Milagros','Navarro','2200334455',8),
('Gastón','Campos','2300445566',9),
('Nadia','Aguirre','2400556677',10);

-- PRODUCTOS (40)
INSERT INTO Producto (id_restaurante, id_categoria, nombre, precio) VALUES
(1,1,'Pizza Muzarella',2500),
(1,1,'Pizza Napolitana',2800),
(1,4,'Gaseosa Cola 500ml',800),
(1,4,'Agua Mineral',700),

(2,2,'Roll Clásico',3200),
(2,2,'Roll Philadelphia',3500),
(2,4,'Té Verde',900),
(2,8,'Mochi Helado',1500),

(3,3,'Hamburguesa Simple',1800),
(3,3,'Hamburguesa Doble',2300),
(3,4,'Limonada',950),
(3,8,'Brownie',1200),

(4,5,'Ravioles con Salsa',2700),
(4,5,'Ñoquis 4 Quesos',2600),
(4,4,'Vino Tinto Copa',1500),
(4,8,'Tiramisú',1700),

(5,6,'Taco de Pollo',900),
(5,6,'Taco de Carne',1100),
(5,4,'Margarita',2000),
(5,8,'Churros',800),

(6,5,'Ensalada César',1900),
(6,5,'Wrap Vegano',2100),
(6,4,'Jugo Detox',1500),
(6,8,'Barrita Cereal',600),

(7,7,'Wok de Pollo',2300),
(7,7,'Wok Vegano',2200),
(7,4,'Soda',750),
(7,8,'Helado Asia',1600),

(8,3,'Empanada Carne',350),
(8,3,'Empanada JyQ',300),
(8,4,'Gaseosa 1L',1200),
(8,8,'Flan Casero',900),

(9,3,'Pollo Frito 2 piezas',1600),
(9,3,'Combo Pollo + Papas',2200),
(9,4,'Gaseosa 500ml',800),
(9,8,'Helado Vainilla',700),

(10,8,'Helado 1 bocha',900),
(10,8,'Helado 2 bochas',1300),
(10,8,'Sundae',1500),
(10,4,'Café',700);

-- PEDIDOS (30)
INSERT INTO Pedido (id_cliente, id_restaurante, id_repartidor, id_metodo, id_estado, fecha_hora, total) VALUES
(1,1,1,2,4,'2025-02-10 20:15',5300),
(2,2,2,4,3,'2025-02-11 13:40',3200),
(3,3,3,1,2,'2025-02-11 19:30',3100),
(4,4,4,3,4,'2025-02-12 12:10',4100),
(5,5,5,1,3,'2025-02-12 21:00',3800),
(6,6,6,4,4,'2025-02-13 18:45',3600),
(7,7,7,2,3,'2025-02-13 20:20',4500),
(8,8,8,1,4,'2025-02-13 22:05',2200),
(9,9,9,3,4,'2025-02-14 11:00',2400),
(10,10,10,4,4,'2025-02-14 16:30',3200),
(11,1,11,1,2,'2025-02-14 19:10',1800),
(12,2,12,4,3,'2025-02-15 12:40',4700),
(13,3,13,3,4,'2025-02-15 21:10',5100),
(14,4,14,2,4,'2025-02-16 13:05',4300),
(15,5,15,1,3,'2025-02-16 22:00',2900),
(16,6,16,4,1,'2025-02-16 23:59',3300),
(17,7,17,2,4,'2025-02-17 12:20',3500),
(18,8,18,3,4,'2025-02-17 14:10',2600),
(19,9,19,4,4,'2025-02-17 19:40',3800),
(20,10,20,2,4,'2025-02-17 21:50',2900),
(3,1,5,3,4,'2025-02-18 11:40',3900),
(5,3,8,4,2,'2025-02-18 13:00',2200),
(7,4,10,1,3,'2025-02-18 14:30',4700),
(9,2,12,3,4,'2025-02-18 16:10',1800),
(11,5,14,1,4,'2025-02-18 20:15',4100),
(13,6,16,4,4,'2025-02-18 21:00',3300),
(15,7,18,2,2,'2025-02-18 22:10',5000),
(17,8,20,3,4,'2025-02-18 23:00',2400),
(19,9,1,4,3,'2025-02-19 12:50',3100),
(20,10,2,2,4,'2025-02-19 13:20',2800);

-- ITEM_PEDIDO
INSERT INTO Item_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1,1,1,2500),(1,2,1,2800),
(2,5,1,3200),
(3,10,1,2300),(3,34,1,800),
(4,13,1,2700),(4,15,1,1500),
(5,17,2,900),(5,19,1,2000),
(6,21,1,1900),(6,23,1,1500),
(7,25,1,2300),(7,26,1,2200),
(8,29,3,350),
(9,33,1,1600),
(10,37,2,1300),(10,40,1,700),
(11,9,1,1800),
(12,6,1,3500),(12,8,1,1500),
(13,10,2,2300),
(14,14,1,2600),(14,16,1,1700),
(15,18,2,1100),
(16,22,1,2100),(16,24,1,600),
(17,28,1,2200),
(18,32,1,900),(18,33,1,1200),
(19,30,1,350),(19,31,2,300),(19,32,1,1200),
(20,38,1,1500),(20,40,1,700),
(21,2,1,2800),(21,3,1,800),
(22,10,1,2300),
(23,13,1,2700),(23,15,1,1500),
(24,5,1,3200),
(25,19,2,2000),
(26,23,1,1500),(26,24,1,600),
(27,26,1,2200),(27,28,1,2200),
(28,29,2,350),
(29,33,1,1600),
(30,37,1,1300),(30,39,1,1500);

-- FIN SCRIPT