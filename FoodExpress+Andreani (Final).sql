-- =====================================================
-- SCRIPT FINAL: FoodExpress (MySQL 8.0)
-- Proyecto corregido según devolución docente
-- =====================================================

DROP DATABASE IF EXISTS FoodExpress;
CREATE DATABASE FoodExpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE FoodExpress;

-- =====================================================
-- TABLAS MAESTRAS
-- =====================================================

CREATE TABLE Zona (
    id_zona INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Metodo_pago (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Estado_pedido (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- CLIENTE
-- =====================================================

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    id_zona INT,
    calle VARCHAR(150),
    numero VARCHAR(10),
    departamento VARCHAR(10),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- =====================================================
-- RESTAURANTE
-- =====================================================

CREATE TABLE Restaurante (
    id_restaurante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(200),
    id_zona INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- =====================================================
-- REPARTIDOR
-- =====================================================

CREATE TABLE Repartidor (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    id_zona INT,
    estado ENUM('Disponible','Ocupado','Fuera de servicio') DEFAULT 'Disponible',
    FOREIGN KEY (id_zona) REFERENCES Zona(id_zona)
) ENGINE=InnoDB;

-- =====================================================
-- PRODUCTO
-- =====================================================

CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_restaurante INT NOT NULL,
    id_categoria INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
) ENGINE=InnoDB;

-- =====================================================
-- PEDIDO
-- =====================================================

CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_restaurante INT NOT NULL,
    id_repartidor INT NOT NULL,
    id_metodo INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor),
    FOREIGN KEY (id_metodo) REFERENCES Metodo_pago(id_metodo),
    FOREIGN KEY (id_estado) REFERENCES Estado_pedido(id_estado)
) ENGINE=InnoDB;

-- =====================================================
-- ITEM PEDIDO
-- =====================================================

CREATE TABLE Item_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
) ENGINE=InnoDB;

-- =====================================================
-- HISTORIAL DE ESTADOS DEL PEDIDO
-- =====================================================

CREATE TABLE Historial_estado_pedido (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_estado DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_estado) REFERENCES Estado_pedido(id_estado)
) ENGINE=InnoDB;

-- =====================================================
-- TABLA CUPON
-- =====================================================

CREATE TABLE Cupon (
    id_cupon INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(150),
    porcentaje_descuento DECIMAL(5,2),
    activo BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- TABLA PEDIDO CUPON
-- =====================================================
CREATE TABLE Pedido_cupon (
    id_pedido INT,
    id_cupon INT,
    PRIMARY KEY (id_pedido, id_cupon),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_cupon) REFERENCES Cupon(id_cupon)
);

-- =====================================================
-- TABLA CALIFICACION
-- =====================================================
CREATE TABLE Calificacion (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    puntuacion INT CHECK (puntuacion BETWEEN 1 AND 5),
    comentario VARCHAR(255),
    fecha DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- =====================================================
-- TABLA TURNO REPARTIDOR
-- =====================================================
CREATE TABLE Turno_repartidor (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    id_repartidor INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor)
);

-- =====================================================
-- INSERTS
-- =====================================================

-- ZONAS
INSERT INTO Zona (nombre) VALUES
('Centro'),('Norte'),('Sur'),('Este'),('Oeste'),
('Barrio Jardín'),('Rivera'),('Parque Industrial'),
('Universitario'),('Puerto');

-- METODOS DE PAGO
INSERT INTO Metodo_pago (nombre) VALUES
('Efectivo'),('Tarjeta de Crédito'),
('Tarjeta de Débito'),('MercadoPago');

-- ESTADOS DE PEDIDO
INSERT INTO Estado_pedido (descripcion) VALUES
('Pendiente'),('Preparando'),
('En camino'),('Entregado'),('Cancelado');

-- CATEGORIAS
INSERT INTO Categoria (nombre) VALUES
('Pizzas'),('Sushi'),('Hamburguesas'),
('Bebidas'),('Pastas'),('Tacos'),
('Wok'),('Postres');

-- CLIENTES (20)
INSERT INTO Cliente (nombre, apellido, email, telefono, id_zona, calle, numero) VALUES
('Juan','Pérez','juan.perez@gmail.com','1122334455',1,'Av. Central','123'),
('María','Gómez','maria.gomez@gmail.com','1133445566',2,'Calle Norte','456'),
('Luis','Ramírez','luis.ramirez@hotmail.com','1144556677',3,'Ruta Sur','789'),
('Ana','Rojas','ana.rojas@gmail.com','1155667788',4,'Av. Este','321'),
('Carlos','Gutiérrez','carlos.g@gmail.com','1166778899',5,'Calle Oeste','654'),
('Sofía','Torres','sofia.t@gmail.com','1177889900',6,'Av. Jardín','111'),
('Diego','Fernández','diego.f@gmail.com','1188990011',7,'Calle Rivera','222'),
('Lucía','Martínez','lucia.m@gmail.com','1199001122',8,'Parque Ind.','333'),
('Pedro','López','pedro.l@gmail.com','1100112233',9,'Av. Uni','444'),
('Laura','Sosa','laura.s@gmail.com','1200223344',10,'Bv. Puerto','555'),
('Andrés','Delgado','andres.d@gmail.com','1300334455',1,'Av. Central','777'),
('Paula','Méndez','paula.m@gmail.com','1400445566',2,'Calle Norte','888'),
('Julián','Silva','julian.s@gmail.com','1500556677',3,'Ruta Sur','999'),
('Camila','Vega','camila.v@gmail.com','1600667788',4,'Av. Este','112'),
('Agustín','Correa','agustin.c@gmail.com','1700778899',5,'Calle Oeste','113'),
('Valentina','Ibarra','valen.i@gmail.com','1800889900',6,'Av. Jardín','114'),
('Martín','Soria','martin.s@gmail.com','1900990011',7,'Calle Rivera','115'),
('Florencia','Gauna','flo.g@gmail.com','2000112233',8,'Parque Ind.','116'),
('Hernán','Pinto','hernan.p@gmail.com','2100223344',9,'Av. Uni','117'),
('Daniela','Suárez','daniela.s@gmail.com','2200334455',10,'Bv. Puerto','118');

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
INSERT INTO Pedido
(id_cliente, id_restaurante, id_repartidor, id_metodo, id_estado, fecha_hora, subtotal, descuento, total)
VALUES
(1,1,1,2,4,'2025-02-10 20:15',5300,0,5300),
(2,2,2,4,3,'2025-02-11 13:40',3200,0,3200),
(3,3,3,1,2,'2025-02-11 19:30',3100,0,3100),
(4,4,4,3,4,'2025-02-12 12:10',4100,0,4100),
(5,5,5,1,3,'2025-02-12 21:00',3800,0,3800),
(6,6,6,4,4,'2025-02-13 18:45',3600,0,3600),
(7,7,7,2,3,'2025-02-13 20:20',4500,0,4500),
(8,8,8,1,4,'2025-02-13 22:05',2200,0,2200),
(9,9,9,3,4,'2025-02-14 11:00',2400,0,2400),
(10,10,10,4,4,'2025-02-14 16:30',3200,0,3200),
(11,1,11,1,2,'2025-02-14 19:10',1800,0,1800),
(12,2,12,4,3,'2025-02-15 12:40',4700,0,4700),
(13,3,13,3,4,'2025-02-15 21:10',5100,0,5100),
(14,4,14,2,4,'2025-02-16 13:05',4300,0,4300),
(15,5,15,1,3,'2025-02-16 22:00',2900,0,2900),
(16,6,16,4,1,'2025-02-16 23:59',3300,0,3300),
(17,7,17,2,4,'2025-02-17 12:20',3500,0,3500),
(18,8,18,3,4,'2025-02-17 14:10',2600,0,2600),
(19,9,19,4,4,'2025-02-17 19:40',3800,0,3800),
(20,10,20,2,4,'2025-02-17 21:50',2900,0,2900),
(3,1,5,3,4,'2025-02-18 11:40',3900,0,3900),
(5,3,8,4,2,'2025-02-18 13:00',2200,0,2200),
(7,4,10,1,3,'2025-02-18 14:30',4700,0,4700),
(9,2,12,3,4,'2025-02-18 16:10',1800,0,1800),
(11,5,14,1,4,'2025-02-18 20:15',4100,0,4100),
(13,6,16,4,4,'2025-02-18 21:00',3300,0,3300),
(15,7,18,2,2,'2025-02-18 22:10',5000,0,5000),
(17,8,20,3,4,'2025-02-18 23:00',2400,0,2400),
(19,9,1,4,3,'2025-02-19 12:50',3100,0,3100),
(20,10,2,2,4,'2025-02-19 13:20',2800,0,2800);

-- HISTORIAL INICIAL
INSERT INTO Historial_estado_pedido (id_pedido, id_estado, fecha_estado)
SELECT id_pedido, id_estado, fecha_hora FROM Pedido;

INSERT INTO Cupon (codigo, descripcion, porcentaje_descuento) VALUES
('DESC10','Descuento 10%',10),
('DESC20','Descuento 20%',20);

INSERT INTO Pedido_cupon (id_pedido, id_cupon) VALUES
(1,1),
(2,2);

INSERT INTO Calificacion (id_pedido, puntuacion, comentario) VALUES
(1,5,'Excelente servicio'),
(2,4,'Buen servicio');

INSERT INTO Turno_repartidor (id_repartidor, fecha, hora_inicio, hora_fin) VALUES
(1,'2025-02-10','18:00','23:00'),
(2,'2025-02-10','12:00','18:00');

-- FIN SCRIPT