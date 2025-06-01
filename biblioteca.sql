-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 01-06-2025 a las 22:58:20
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libros`
--

CREATE TABLE `libros` (
  `codigo` int(11) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `autor` varchar(100) DEFAULT NULL,
  `editorial` varchar(100) DEFAULT NULL,
  `publicacion` year(4) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libros`
--

INSERT INTO `libros` (`codigo`, `titulo`, `autor`, `editorial`, `publicacion`, `categoria`) VALUES
(1, 'Cien años de soledad', 'Gabriel García Márquez', 'Sudamericana', '1967', 'Novela'),
(2, 'Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Salamandra', '1997', 'Infantil'),
(3, 'Clean Code', 'Robert C. Martin', 'Prentice Hall', '2008', 'Técnica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `multas`
--

CREATE TABLE `multas` (
  `id` int(11) NOT NULL,
  `total` decimal(8,2) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `f_emision` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `multas`
--

INSERT INTO `multas` (`id`, `total`, `descripcion`, `f_emision`) VALUES
(1, 5.00, 'Retraso de 3 días', '2025-05-20'),
(2, 10.00, 'Retraso de una semana', '2025-05-28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamos`
--

CREATE TABLE `prestamos` (
  `id` int(11) NOT NULL,
  `numero_socio` int(11) DEFAULT NULL,
  `codigo_libro` int(11) DEFAULT NULL,
  `f_prestamo` date DEFAULT NULL,
  `f_limite` date DEFAULT NULL,
  `f_devolucion` date DEFAULT NULL,
  `id_multa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamos`
--

INSERT INTO `prestamos` (`id`, `numero_socio`, `codigo_libro`, `f_prestamo`, `f_limite`, `f_devolucion`, `id_multa`) VALUES
(1, 101, 1, '2025-05-01', '2025-05-10', '2025-05-13', 1),
(2, 101, 2, '2025-05-01', '2025-05-10', '2025-05-09', NULL),
(3, 102, 3, '2025-05-15', '2025-05-25', '2025-05-29', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socios`
--

CREATE TABLE `socios` (
  `numero` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `f_inscripcion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socios`
--

INSERT INTO `socios` (`numero`, `nombre`, `direccion`, `email`, `f_inscripcion`) VALUES
(101, 'Laura Sánchez', 'Calle Luna 3', 'laura@email.com', '2022-03-15'),
(102, 'Pedro García', 'Av. del Sol 21', 'pedro@email.com', '2023-01-10');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_libros_por_socio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_libros_por_socio` (
`nombre` varchar(100)
,`cantidad_libros_prestados` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_prestamos_con_multas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_prestamos_con_multas` (
`socio` varchar(100)
,`libro` varchar(100)
,`f_devolucion` date
,`multa_total` decimal(8,2)
,`descripcion` text
,`f_emision` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_prestamos_detallados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_prestamos_detallados` (
`id_prestamo` int(11)
,`socio` varchar(100)
,`libro` varchar(100)
,`f_prestamo` date
,`f_limite` date
,`f_devolucion` date
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_libros_por_socio`
--
DROP TABLE IF EXISTS `vista_libros_por_socio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_libros_por_socio`  AS SELECT `s`.`nombre` AS `nombre`, count(`p`.`codigo_libro`) AS `cantidad_libros_prestados` FROM (`prestamos` `p` join `socios` `s` on(`p`.`numero_socio` = `s`.`numero`)) GROUP BY `s`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_prestamos_con_multas`
--
DROP TABLE IF EXISTS `vista_prestamos_con_multas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prestamos_con_multas`  AS SELECT `s`.`nombre` AS `socio`, `l`.`titulo` AS `libro`, `p`.`f_devolucion` AS `f_devolucion`, `m`.`total` AS `multa_total`, `m`.`descripcion` AS `descripcion`, `m`.`f_emision` AS `f_emision` FROM (((`prestamos` `p` join `socios` `s` on(`p`.`numero_socio` = `s`.`numero`)) join `libros` `l` on(`p`.`codigo_libro` = `l`.`codigo`)) join `multas` `m` on(`p`.`id_multa` = `m`.`id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_prestamos_detallados`
--
DROP TABLE IF EXISTS `vista_prestamos_detallados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prestamos_detallados`  AS SELECT `p`.`id` AS `id_prestamo`, `s`.`nombre` AS `socio`, `l`.`titulo` AS `libro`, `p`.`f_prestamo` AS `f_prestamo`, `p`.`f_limite` AS `f_limite`, `p`.`f_devolucion` AS `f_devolucion` FROM ((`prestamos` `p` join `socios` `s` on(`p`.`numero_socio` = `s`.`numero`)) join `libros` `l` on(`p`.`codigo_libro` = `l`.`codigo`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `libros`
--
ALTER TABLE `libros`
  ADD PRIMARY KEY (`codigo`);

--
-- Indices de la tabla `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `numero_socio` (`numero_socio`),
  ADD KEY `codigo_libro` (`codigo_libro`),
  ADD KEY `id_multa` (`id_multa`);

--
-- Indices de la tabla `socios`
--
ALTER TABLE `socios`
  ADD PRIMARY KEY (`numero`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `multas`
--
ALTER TABLE `multas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamos`
--
ALTER TABLE `prestamos`
  ADD CONSTRAINT `prestamos_ibfk_1` FOREIGN KEY (`numero_socio`) REFERENCES `socios` (`numero`),
  ADD CONSTRAINT `prestamos_ibfk_2` FOREIGN KEY (`codigo_libro`) REFERENCES `libros` (`codigo`),
  ADD CONSTRAINT `prestamos_ibfk_3` FOREIGN KEY (`id_multa`) REFERENCES `multas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
