# Proyecto_SQL
## 1. Introducción
FoodExpress es una plataforma digital de pedidos de comida a domicilio que conecta clientes, restaurantes y repartidores. El sistema permite gestionar el catálogo de productos, registrar pedidos, asignar repartidores y almacenar información relevante para análisis comerciales, logísticos y operativos. El objetivo principal es centralizar esta información de manera estructurada para facilitar consultas, reportes y procesos analíticos.

## 2. Objetivo del sistema
El proyecto tiene como objetivo diseñar e implementar una base de datos relacional que permita:
- Registrar clientes, restaurantes y repartidores.
- Gestionar productos, categorías y precios.
- Procesar pedidos y sus detalles.
- Administrar métodos de pago y estados de pedido.
- Facilitar análisis de negocio: ventas por restaurante, ticket promedio, desempeño logístico, tiempos de entrega.
- Proveer información consistente para áreas cross-funcionales: contabilidad (pagos, ingresos), logística (tareas de reparto), análisis (métricas operativas).

## 3. Situación problemática
Sin una base de datos centralizada, los procesos del negocio presentan múltiples dificultades:
- Falta de trazabilidad de pedidos y entregas.
- Información dispersa entre restaurantes, clientes y repartidores.
- Imposibilidad de analizar ventas, zonas críticas o desempeño de delivery.
- Problemas para gestionar múltiples estados de pedido (pendiente, en preparación, enviado, entregado).
- Limitaciones para estandarizar métodos de pago y promociones.
La implementación de una base de datos bien diseñada resuelve estas brechas, unificando datos y permitiendo reportes confiables.

## 4. Modelo de negocio
FoodExpress funciona como intermediario entre restaurantes y clientes. La empresa gestiona:
- Restaurantes: ofrecen productos y configuran sus menús.
- Clientes: realizan pedidos mediante la aplicación.
- Repartidores: entregan los pedidos a domicilio.
- Plataforma: registra transacciones, cobra comisiones y administra el flujo del proceso.
El modelo combina logística, marketplace y procesamiento de pagos.

## 5. DER

## 6. Listado de tablas y diccionario de datos

### Tabla: Zona
Contiene las zonas geográficas donde operan clientes, restaurantes y repartidores.
| Campo     | Nombre completo       | Tipo         | Clave | Descripción                 |
| --------- | --------------------- | ------------ | ----- | --------------------------- |
| `id_zona` | Identificador de zona | INT          | PK    | Identificador único de zona |
| `nombre`  | Nombre de zona        | VARCHAR(100) | -     | Nombre de la zona           |

### Tabla: Cliente
Almacena los clientes registrados que realizan pedidos.
| Campo        | Nombre completo          | Tipo         | Clave | Descripción                     |
| ------------ | ------------------------ | ------------ | ----- | ------------------------------- |
| `id_cliente` | Identificador de cliente | INT          | PK    | Identificador único del cliente |
| `nombre`     | Nombre del cliente       | VARCHAR(50)  | -     | Nombre                          |
| `apellido`   | Apellido del cliente     | VARCHAR(50)  | -     | Apellido                        |
| `email`      | Email del cliente        | VARCHAR(100) | -     | Correo electrónico              |
| `telefono`   | Teléfono del cliente     | VARCHAR(20)  | -     | Teléfono                        |
| `id_zona`    | Zona del cliente         | INT          | FK    | Relación a `Zona`               |

### Tabla: Restaurante
Restaurantes que ofrecen productos en la plataforma.
| Campo            | Nombre completo           | Tipo         | Clave | Descripción        |
| ---------------- | ------------------------- | ------------ | ----- | ------------------ |
| `id_restaurante` | Identificador restaurante | INT          | PK    | ID del restaurante |
| `nombre`         | Nombre del restaurante    | VARCHAR(100) | -     | Nombre comercial   |
| `direccion`      | Dirección física          | VARCHAR(150) | -     | Ubicación          |
| `id_zona`        | Zona del restaurante      | INT          | FK    | Relación a `Zona`  |

### Tabla: Repartidor
Repartidores disponibles para asignar pedidos.
| Campo           | Nombre completo          | Tipo        | Clave | Descripción       |
| --------------- | ------------------------ | ----------- | ----- | ----------------- |
| `id_repartidor` | Identificador repartidor | INT         | PK    | ID único          |
| `nombre`        | Nombre del repartidor    | VARCHAR(50) | -     | Nombre            |
| `apellido`      | Apellido del repartidor  | VARCHAR(50) | -     | Apellido          |
| `telefono`      | Teléfono                 | VARCHAR(20) | -     | Teléfono          |
| `id_zona`       | Zona asignada            | INT         | FK    | Relación a `Zona` |

### Tabla: Categoría
Categorias o tipos de productos ofrecidos.
| Campo          | Nombre completo         | Tipo         | Clave | Descripción      |
| -------------- | ----------------------- | ------------ | ----- | ---------------- |
| `id_categoria` | Identificador categoría | INT          | PK    | ID único         |
| `nombre`       | Nombre categoría        | VARCHAR(100) | -     | Tipo de producto |

### Tabla: Producto
Productos vendidos por cada restaurante.
| Campo            | Nombre completo        | Tipo          | Clave | Descripción              |
| ---------------- | ---------------------- | ------------- | ----- | ------------------------ |
| `id_producto`    | Identificador producto | INT           | PK    | ID único                 |
| `id_restaurante` | Restaurante dueño      | INT           | FK    | Relación a `Restaurante` |
| `id_categoria`   | Categoría              | INT           | FK    | Relación a `Categoria`   |
| `nombre`         | Nombre del producto    | VARCHAR(150)  | -     | Nombre                   |
| `precio`         | Precio unitario        | DECIMAL(10,2) | -     | Precio                   |

### Tabla: Metodo_pago
Métodos de pago disponibles en la plataforma.
| Campo       | Nombre completo           | Tipo        | Clave | Descripción             |
| ----------- | ------------------------- | ----------- | ----- | ----------------------- |
| `id_metodo` | Identificador método pago | INT         | PK    | ID único                |
| `nombre`    | Nombre método             | VARCHAR(50) | -     | Efectivo, Tarjeta, etc. |

### Tabla: Estado_pedido
Estados en los que puede encontrarse un pedido.
| Campo         | Nombre completo      | Tipo        | Clave | Descripción                |
| ------------- | -------------------- | ----------- | ----- | -------------------------- |
| `id_estado`   | Identificador estado | INT         | PK    | ID único                   |
| `descripcion` | Estado del pedido    | VARCHAR(50) | -     | Pendiente, En camino, etc. |

### Tabla: Pedido
Encabezado del pedido realizado por un cliente.
| Campo            | Nombre completo         | Tipo          | Clave | Descripción                |
| ---------------- | ----------------------- | ------------- | ----- | -------------------------- |
| `id_pedido`      | Identificador de pedido | INT           | PK    | ID único                   |
| `id_cliente`     | Cliente del pedido      | INT           | FK    | Relación a `Cliente`       |
| `id_restaurante` | Restaurante productor   | INT           | FK    | Relación a `Restaurante`   |
| `id_repartidor`  | Repartidor asignado     | INT           | FK    | Relación a `Repartidor`    |
| `id_metodo`      | Método de pago          | INT           | FK    | Relación a `Metodo_pago`   |
| `id_estado`      | Estado actual           | INT           | FK    | Relación a `Estado_pedido` |
| `fecha_hora`     | Fecha y hora            | DATETIME      | -     | Timestamp                  |
| `total`          | Total del pedido        | DECIMAL(10,2) | -     | Monto total                |

### Tabla: Item_pedido
Detalle de productos incluidos en cada pedido.
| Campo             | Nombre completo     | Tipo          | Clave | Descripción           |
| ----------------- | ------------------- | ------------- | ----- | --------------------- |
| `id_item`         | Identificador ítem  | INT           | PK    | ID único              |
| `id_pedido`       | Pedido asociado     | INT           | FK    | Relación a `Pedido`   |
| `id_producto`     | Producto asociado   | INT           | FK    | Relación a `Producto` |
| `cantidad`        | Cantidad solicitada | INT           | -     | Unidades              |
| `precio_unitario` | Precio al momento   | DECIMAL(10,2) | -     | Precio histórico      |

## 7. Script SQL (.sql) de creación de la BD
