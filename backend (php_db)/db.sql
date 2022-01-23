-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 23, 2022 at 04:41 PM
-- Server version: 5.7.24
-- PHP Version: 7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

-- --------------------------------------------------------

--
-- Table structure for table `add`
--

DROP TABLE IF EXISTS `add`;
CREATE TABLE IF NOT EXISTS `add` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) NOT NULL,
  `price` double NOT NULL,
  `time` datetime NOT NULL,
  `img` varchar(120) NOT NULL,
  `isTop` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `add`
--

INSERT INTO `add` (`id`, `title`, `price`, `time`, `img`, `isTop`) VALUES
(1, 'Samsung S20', 200000, '2022-01-23 00:00:00', 'samsung.jpg', 0),
(2, 'Samsung S8', 70000, '2022-01-22 00:00:00', 's8.jpg', 1),
(3, 'Samsung S9', 70000, '2022-01-12 00:00:00', 's9.jpg', 1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
