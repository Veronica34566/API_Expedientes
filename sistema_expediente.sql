-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-11-2026 a las 19:54:50
-- Versión del servidor: 10.11.19-MariaDB
-- Versión de PHP: 8.3.37

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_expediente`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aseguradoras`
--

CREATE TABLE `aseguradoras` (
  `id_aseguradoras` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `aseguradoras`
--

INSERT INTO `aseguradoras` (`id_aseguradoras`, `nombre`) VALUES
(1, 'ASSA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_cita`
--

CREATE TABLE `estado_cita` (
  `id_estado` int(11) NOT NULL,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado_cita`
--

INSERT INTO `estado_cita` (`id_estado`, `nombre_estado`, `descripcion`) VALUES
(1, 'Pendiente', 'Cita pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `expedientes`
--

CREATE TABLE `expedientes` (
  `id_expediente` int(11) NOT NULL,
  `numero_expediente` varchar(50) NOT NULL,
  `fecha_servicio` date NOT NULL,
  `hora_servicio` time NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_aseguradora` int(11) NOT NULL,
  `id_juzgado` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `expedientes`
--

INSERT INTO `expedientes` (`id_expediente`, `numero_expediente`, `fecha_servicio`, `hora_servicio`, `id_usuario`, `id_aseguradora`, `id_juzgado`, `id_estado`, `observaciones`) VALUES
(2, 'EXP-2026-002', '2026-11-20', '11:30:00', 1, 1, 1, 1, 'Registro para evidencia de consulta GET');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juzgados`
--

CREATE TABLE `juzgados` (
  `id_juzgados` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `ubicacion` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `juzgados`
--

INSERT INTO `juzgados` (`id_juzgados`, `nombre`, `ubicacion`) VALUES
(1, 'Juzgado Primero', 'Panamá');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `usuario`, `password_hash`) VALUES
(1, 'Administrador', 'admin', 'hash_demo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aseguradoras`
--
ALTER TABLE `aseguradoras`
  ADD PRIMARY KEY (`id_aseguradoras`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `estado_cita`
--
ALTER TABLE `estado_cita`
  ADD PRIMARY KEY (`id_estado`),
  ADD UNIQUE KEY `nombre_estado` (`nombre_estado`);

--
-- Indices de la tabla `expedientes`
--
ALTER TABLE `expedientes`
  ADD PRIMARY KEY (`id_expediente`),
  ADD UNIQUE KEY `numero_expediente` (`numero_expediente`),
  ADD KEY `fk_expedientes_usuario` (`id_usuario`),
  ADD KEY `fk_expedientes_aseguradora` (`id_aseguradora`),
  ADD KEY `fk_expedientes_juzgado` (`id_juzgado`),
  ADD KEY `fk_expedientes_estado` (`id_estado`);

--
-- Indices de la tabla `juzgados`
--
ALTER TABLE `juzgados`
  ADD PRIMARY KEY (`id_juzgados`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aseguradoras`
--
ALTER TABLE `aseguradoras`
  MODIFY `id_aseguradoras` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `estado_cita`
--
ALTER TABLE `estado_cita`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `expedientes`
--
ALTER TABLE `expedientes`
  MODIFY `id_expediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `juzgados`
--
ALTER TABLE `juzgados`
  MODIFY `id_juzgados` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `expedientes`
--
ALTER TABLE `expedientes`
  ADD CONSTRAINT `fk_expedientes_aseguradora` FOREIGN KEY (`id_aseguradora`) REFERENCES `aseguradoras` (`id_aseguradoras`),
  ADD CONSTRAINT `fk_expedientes_estado` FOREIGN KEY (`id_estado`) REFERENCES `estado_cita` (`id_estado`),
  ADD CONSTRAINT `fk_expedientes_juzgado` FOREIGN KEY (`id_juzgado`) REFERENCES `juzgados` (`id_juzgados`),
  ADD CONSTRAINT `fk_expedientes_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
