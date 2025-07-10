-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-07-2025 a las 16:21:18
-- Versión del servidor: 8.0.31
-- Versión de PHP: 8.1.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_online`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `imagen`, `activo`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'Electrónicos', 'Dispositivos electrónicos y tecnología', 'electronicos.jpg', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(2, 'Ropa', 'Ropa y accesorios de moda', 'ropa.jpg', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(3, 'Hogar', 'Artículos para el hogar y decoración', 'hogar.jpg', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(4, 'Deportes', 'Equipamiento deportivo y fitness', 'deportes.jpg', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(5, 'Libros', 'Libros y material educativo', 'libros.jpg', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  `precio_unitario` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','procesando','enviado','entregado','cancelado') DEFAULT 'pendiente',
  `fecha_pedido` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id`, `usuario_id`, `producto_id`, `cantidad`, `precio_unitario`, `total`, `estado`, `fecha_pedido`, `fecha_actualizacion`) VALUES
(1, 3, 1, 1, 1199.99, 1199.99, 'entregado', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(2, 3, 4, 2, 249.99, 499.98, 'entregado', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(3, 4, 5, 3, 29.99, 89.97, 'enviado', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(4, 4, 8, 1, 65.99, 65.99, 'procesando', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(5, 5, 16, 2, 24.99, 49.98, 'pendiente', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(6, 5, 19, 1, 19.99, 19.99, 'pendiente', '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(7, 3, 11, 1, 599.99, 599.99, 'procesando', '2025-07-09 14:13:48', '2025-07-09 14:13:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `categoria_id` int NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `codigo_barras` varchar(50) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `stock`, `categoria_id`, `imagen`, `codigo_barras`, `activo`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'iPhone 15 Pro', 'Smartphone Apple iPhone 15 Pro 256GB', 1199.99, 50, 1, NULL, '1234567890123', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(2, 'Samsung Galaxy S24', 'Smartphone Samsung Galaxy S24 128GB', 899.99, 30, 1, NULL, '1234567890124', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(3, 'MacBook Air M2', 'Laptop Apple MacBook Air con chip M2', 1299.99, 20, 1, NULL, '1234567890125', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(4, 'AirPods Pro', 'Auriculares inalámbricos Apple AirPods Pro', 249.99, 100, 1, NULL, '1234567890126', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(5, 'Camiseta Nike', 'Camiseta deportiva Nike algodón 100%', 29.99, 200, 2, NULL, '1234567890127', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(6, 'Jeans Levis 501', 'Jeans clásicos Levis 501 Original', 79.99, 150, 2, NULL, '1234567890128', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(7, 'Sudadera Adidas', 'Sudadera con capucha Adidas Originals', 59.99, 80, 2, NULL, '1234567890129', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(8, 'Zapatillas Converse', 'Zapatillas Converse All Star clásicas', 65.99, 120, 2, NULL, '1234567890130', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(9, 'Sofá 3 Plazas', 'Sofá cómodo de 3 plazas color gris', 599.99, 15, 3, NULL, '1234567890131', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(10, 'Mesa de Comedor', 'Mesa de comedor de madera para 6 personas', 399.99, 25, 3, NULL, '1234567890132', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(11, 'Lámpara LED', 'Lámpara de mesa LED regulable', 45.99, 60, 3, NULL, '1234567890133', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(12, 'Espejo Decorativo', 'Espejo decorativo redondo 60cm', 89.99, 40, 3, NULL, '1234567890134', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(13, 'Bicicleta Montaña', 'Bicicleta de montaña 21 velocidades', 299.99, 35, 4, NULL, '1234567890135', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(14, 'Pelota Fútbol', 'Pelota de fútbol profesional FIFA', 24.99, 150, 4, NULL, '1234567890136', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(15, 'Raqueta Tenis', 'Raqueta de tenis profesional Wilson', 129.99, 45, 4, NULL, '1234567890137', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(16, 'Pesas Ajustables', 'Set de pesas ajustables 20kg', 89.99, 30, 4, NULL, '1234567890138', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(17, 'El Quijote', 'Don Quijote de la Mancha - Edición especial', 19.99, 100, 5, NULL, '1234567890139', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(18, 'Cien Años de Soledad', 'Novela de Gabriel García Márquez', 16.99, 80, 5, NULL, '1234567890140', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(19, 'Manual PHP', 'Manual completo de programación PHP', 39.99, 60, 5, NULL, '1234567890141', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(20, 'Cookbook JavaScript', 'Recetas y técnicas de JavaScript', 34.99, 70, 5, NULL, '1234567890142', 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `activo`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'admin', 'Administrador del sistema con todos los permisos', 1, '2025-07-09 14:13:47', '2025-07-09 14:13:47'),
(2, 'vendedor', 'Vendedor con permisos para gestionar productos y pedidos', 1, '2025-07-09 14:13:47', '2025-07-09 14:13:47'),
(3, 'cliente', 'Cliente con permisos básicos para realizar compras', 1, '2025-07-09 14:13:47', '2025-07-09 14:13:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `rol_id` int NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `apellido`, `email`, `password`, `telefono`, `fecha_nacimiento`, `rol_id`, `activo`, `fecha_registro`, `fecha_actualizacion`) VALUES
(1, 'Juan', 'Pérez', 'admin@tienda.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '555-0001', '1985-06-15', 1, 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(2, 'María', 'González', 'vendedor@tienda.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '555-0002', '1990-03-22', 2, 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(3, 'Carlos', 'Rodríguez', 'carlos@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '555-0003', '1992-11-08', 3, 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(4, 'Ana', 'Martínez', 'ana@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '555-0004', '1988-07-30', 3, 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48'),
(5, 'Luis', 'Hernández', 'luis@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '555-0005', '1995-12-12', 3, 1, '2025-07-09 14:13:48', '2025-07-09 14:13:48');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_producto` (`producto_id`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_fecha` (`fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_barras` (`codigo_barras`),
  ADD KEY `idx_categoria` (`categoria_id`),
  ADD KEY `idx_precio` (`precio`),
  ADD KEY `idx_stock` (`stock`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_rol` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
