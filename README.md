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

# Tabla: Zona
Contiene las zonas geográficas donde operan clientes, restaurantes y repartidores.
| Campo     | Nombre completo       | Tipo         | Clave | Descripción                 |
| --------- | --------------------- | ------------ | ----- | --------------------------- |
| `id_zona` | Identificador de zona | INT          | PK    | Identificador único de zona |
| `nombre`  | Nombre de zona        | VARCHAR(100) | -     | Nombre de la zona           |

# Tabla: Cliente
Almacena los clientes registrados que realizan pedidos.
| Campo        | Nombre completo          | Tipo         | Clave | Descripción                     |
| ------------ | ------------------------ | ------------ | ----- | ------------------------------- |
| `id_cliente` | Identificador de cliente | INT          | PK    | Identificador único del cliente |
| `nombre`     | Nombre del cliente       | VARCHAR(50)  | -     | Nombre                          |
| `apellido`   | Apellido del cliente     | VARCHAR(50)  | -     | Apellido                        |
| `email`      | Email del cliente        | VARCHAR(100) | -     | Correo electrónico              |
| `telefono`   | Teléfono del cliente     | VARCHAR(20)  | -     | Teléfono                        |
| `id_zona`    | Zona del cliente         | INT          | FK    | Relación a `Zona`               |

## 7. Script SQL (.sql) de creación de la BD
