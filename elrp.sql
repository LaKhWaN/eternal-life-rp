-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 02, 2020 at 10:56 AM
-- Server version: 10.1.44-MariaDB-1~jessie
-- PHP Version: 7.0.33-1~dotdeb+8.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `server_4118_sql`
--

-- --------------------------------------------------------

--
-- Table structure for table `bizdata`
--

CREATE TABLE `bizdata` (
  `SQLID` int(11) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `Name` varchar(256) NOT NULL,
  `Type` int(11) NOT NULL,
  `bX` float NOT NULL,
  `bbY` float NOT NULL,
  `bZ` float NOT NULL,
  `bInt` int(11) NOT NULL,
  `bVW` int(11) NOT NULL,
  `bMoney` int(11) NOT NULL,
  `bInteriorPack` int(11) NOT NULL,
  `bLocked` int(11) NOT NULL,
  `bSell` int(11) NOT NULL,
  `bFee` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bizdata`
--

INSERT INTO `bizdata` (`SQLID`, `Owner`, `Name`, `Type`, `bX`, `bbY`, `bZ`, `bInt`, `bVW`, `bMoney`, `bInteriorPack`, `bLocked`, `bSell`, `bFee`) VALUES
(6, 'Steve_Veratti', 'M Biz', 2, 1948.47, 1363.7, 9.10938, 0, 0, 0, 2, 0, 0, 0),
(5, 'None', 'ULALALA', 1, 1941.43, 1364.19, 9.25781, 0, 0, 0, 1, 0, 0, 0),
(1, 'Jo_Varela', 'Royal Casino', 2, 2089.24, 1451.03, 10.8203, 0, 0, 0, 2, 1, 1000000000, 0),
(0, 'Upender_Lakhwan', 'Lakhwan\'s Cloth Store', 7, 1947.27, 1402.11, 9.2501, 0, 0, 0, 7, 0, 0, 0),
(2, 'Steve_Veratti', 'NO Name', 1, 1964.69, 1402.13, 9.25781, 0, 0, 0, 1, 0, 0, 0),
(3, 'None', 'NO Name', 0, 1972, 1402.13, 9.25781, 0, 0, 0, 0, 0, 0, 0),
(4, 'Veronica_Kosovna', 'NO Name', 7, 1931.6, 1338.61, 9.96875, 0, 0, 0, 7, 0, 0, 0),
(7, 'None', 'NO Name', 1, 2188.2, 2469.64, 11.2422, 0, 0, 0, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `factiondata`
--

CREATE TABLE `factiondata` (
  `SQLID` int(11) NOT NULL,
  `Name` varchar(40) NOT NULL,
  `Type` int(11) NOT NULL,
  `Colour` int(11) NOT NULL DEFAULT '1',
  `Chat` int(11) NOT NULL DEFAULT '1',
  `Points` int(11) NOT NULL DEFAULT '0',
  `MaxCars` int(11) NOT NULL DEFAULT '10',
  `MaxBoys` int(11) NOT NULL DEFAULT '10',
  `StartPay` int(11) NOT NULL DEFAULT '1000',
  `Leader` varchar(24) NOT NULL DEFAULT 'None',
  `Bank` int(11) NOT NULL DEFAULT '0',
  `Freq` int(11) NOT NULL DEFAULT '0',
  `fX` float NOT NULL DEFAULT '0',
  `fY` float NOT NULL DEFAULT '0',
  `fZ` float NOT NULL DEFAULT '0',
  `fA` float NOT NULL DEFAULT '0',
  `fInt` int(11) NOT NULL DEFAULT '0',
  `fVW` int(11) NOT NULL DEFAULT '0',
  `fOpen` int(11) NOT NULL DEFAULT '0',
  `fInteriorPack` int(11) NOT NULL,
  `fFX` float NOT NULL DEFAULT '0',
  `fFY` float NOT NULL DEFAULT '0',
  `fFZ` float NOT NULL DEFAULT '0',
  `fFA` float NOT NULL DEFAULT '0',
  `fFVW` int(11) NOT NULL DEFAULT '0',
  `fFInt` int(11) NOT NULL DEFAULT '0',
  `fFOpen` int(11) NOT NULL DEFAULT '0',
  `fFGunParts` int(11) NOT NULL DEFAULT '0',
  `fFSellables` int(11) NOT NULL DEFAULT '0',
  `fFMoney` int(11) NOT NULL DEFAULT '0',
  `fInX` float NOT NULL,
  `fInY` float NOT NULL,
  `fInZ` float NOT NULL,
  `fInA` float NOT NULL,
  `fInInt` int(11) NOT NULL,
  `fInVW` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `factiondata`
--

INSERT INTO `factiondata` (`SQLID`, `Name`, `Type`, `Colour`, `Chat`, `Points`, `MaxCars`, `MaxBoys`, `StartPay`, `Leader`, `Bank`, `Freq`, `fX`, `fY`, `fZ`, `fA`, `fInt`, `fVW`, `fOpen`, `fInteriorPack`, `fFX`, `fFY`, `fFZ`, `fFA`, `fFVW`, `fFInt`, `fFOpen`, `fFGunParts`, `fFSellables`, `fFMoney`, `fInX`, `fInY`, `fInZ`, `fInA`, `fInInt`, `fInVW`) VALUES
(0, 'LaKhWaN', 3, 1, 1, 0, 10, 10, 1000, 'None', 20000, 0, 2147.36, -100.178, 2.7203, 110.137, 0, 0, 1, 2, 2353.16, -667.15, 130.547, 358.995, 0, 0, 1, 1100, 1998, 0, 2146.17, -99.491, 2.71866, 121.166, 0, 0),
(1, 'Palomino Creek Police Department', 2, 1, 1, 10, 10, 10, 1000, 'None', 20000, 0, 2263.42, -77.9454, 26.5391, 1.90464, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 246.23, 108.081, 1003.22, 3.14573, 10, 101);

-- --------------------------------------------------------

--
-- Table structure for table `gatesdata`
--

CREATE TABLE `gatesdata` (
  `ID` int(11) NOT NULL,
  `ModelID` int(11) NOT NULL,
  `Password` varchar(256) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `rX` float NOT NULL,
  `rY` float NOT NULL,
  `rZ` float NOT NULL,
  `OpenX` float NOT NULL,
  `OpenY` float NOT NULL,
  `OpenZ` float NOT NULL,
  `OpenrX` float NOT NULL,
  `OpenrY` float NOT NULL,
  `OpenrZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gatesdata`
--

INSERT INTO `gatesdata` (`ID`, `ModelID`, `Password`, `X`, `Y`, `Z`, `rX`, `rY`, `rZ`, `OpenX`, `OpenY`, `OpenZ`, `OpenrX`, `OpenrY`, `OpenrZ`) VALUES
(0, 968, '', 2251.11, -89.4977, 26.4844, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `housedata`
--

CREATE TABLE `housedata` (
  `SQLID` int(11) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `hX` float NOT NULL,
  `hY` float NOT NULL,
  `hZ` float NOT NULL,
  `hInt` int(11) NOT NULL,
  `hVW` int(11) NOT NULL,
  `hAlarm` int(11) NOT NULL DEFAULT '0',
  `hMoney` int(11) NOT NULL DEFAULT '0',
  `hInteriorPack` int(11) NOT NULL DEFAULT '0',
  `hLocked` int(11) NOT NULL DEFAULT '0',
  `hSell` int(11) NOT NULL DEFAULT '0',
  `hSafe` int(11) NOT NULL DEFAULT '0',
  `hGuns` text NOT NULL,
  `hDrugs` text NOT NULL,
  `hAmmo` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `housedata`
--

INSERT INTO `housedata` (`SQLID`, `Owner`, `hX`, `hY`, `hZ`, `hInt`, `hVW`, `hAlarm`, `hMoney`, `hInteriorPack`, `hLocked`, `hSell`, `hSafe`, `hGuns`, `hDrugs`, `hAmmo`) VALUES
(0, 'Upender_Lakhwan', 1932.9, 1353.48, 9.96875, 0, 0, 0, 0, 6, 0, 0, 1, '0,0', '0,0,0', '0,0'),
(1, 'Veronica_Kosovna', 1680.24, 2069.24, 11.3594, 0, 0, 1, 0, 13, 0, 0, 0, '0,0', '0,0,0', '0,0');

-- --------------------------------------------------------

--
-- Table structure for table `importcars`
--

CREATE TABLE `importcars` (
  `ID` int(11) NOT NULL,
  `ModelID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `playerdata`
--

CREATE TABLE `playerdata` (
  `ID` int(11) NOT NULL,
  `Username` varchar(24) COLLATE utf8_bin NOT NULL,
  `Password` varchar(129) COLLATE utf8_bin NOT NULL,
  `IPAddress` varchar(20) COLLATE utf8_bin NOT NULL,
  `Admin` int(11) NOT NULL DEFAULT '0',
  `Banned` int(11) NOT NULL DEFAULT '0',
  `IPBanned` int(11) NOT NULL DEFAULT '0',
  `BanReason` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT 'NoAny',
  `Kicks` int(11) NOT NULL DEFAULT '0',
  `Warns` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '0',
  `Money` int(11) NOT NULL DEFAULT '0',
  `pDrugs` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0,0,0',
  `hasPhone` int(11) NOT NULL DEFAULT '0',
  `hasSIM` int(11) NOT NULL DEFAULT '0',
  `hasGPS` int(11) NOT NULL DEFAULT '0',
  `hasRadio` int(11) NOT NULL DEFAULT '0',
  `Skin` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT '-1',
  `Tier` int(11) NOT NULL DEFAULT '-1',
  `Rank` varchar(10) COLLATE utf8_bin NOT NULL DEFAULT 'None',
  `Sellables` int(11) NOT NULL DEFAULT '0',
  `Jail` int(11) NOT NULL DEFAULT '0',
  `JailTime` int(11) NOT NULL DEFAULT '0',
  `JailReason` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT 'None',
  `TradePut` int(11) NOT NULL DEFAULT '0',
  `TradePoint` float NOT NULL DEFAULT '0',
  `TradeType` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `vehicledata`
--

CREATE TABLE `vehicledata` (
  `SQLID` int(11) NOT NULL,
  `Model` int(11) NOT NULL,
  `Owner` text COLLATE utf8_bin NOT NULL,
  `vX` float NOT NULL,
  `vY` float NOT NULL,
  `vZ` float NOT NULL,
  `vA` float NOT NULL,
  `vVW` int(11) NOT NULL,
  `vInt` int(11) NOT NULL,
  `vColour1` int(11) NOT NULL DEFAULT '0',
  `vColour2` int(11) NOT NULL DEFAULT '0',
  `vPaintJob` int(11) NOT NULL DEFAULT '0',
  `vSell` int(11) NOT NULL DEFAULT '0',
  `vLocked` int(11) NOT NULL DEFAULT '0',
  `vLockedBy` int(11) NOT NULL DEFAULT '0',
  `vFuel` int(11) NOT NULL DEFAULT '100',
  `vMileage` float NOT NULL DEFAULT '0',
  `vAlarm` int(11) NOT NULL DEFAULT '0',
  `vPlate` text COLLATE utf8_bin NOT NULL,
  `vRegistered` int(11) NOT NULL DEFAULT '0',
  `vFaction` int(11) NOT NULL DEFAULT '-1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `vehicledata`
--

INSERT INTO `vehicledata` (`SQLID`, `Model`, `Owner`, `vX`, `vY`, `vZ`, `vA`, `vVW`, `vInt`, `vColour1`, `vColour2`, `vPaintJob`, `vSell`, `vLocked`, `vLockedBy`, `vFuel`, `vMileage`, `vAlarm`, `vPlate`, `vRegistered`, `vFaction`) VALUES
(15, 522, 'None', 2028.68, 1344.11, 11.1203, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(0, 598, 'Veronica_Kosovna', 1680.76, 2062.56, 11.1095, 269.407, 0, 0, 129, 1, 0, 0, 1, -1, 100, 0, 0, 'Alphalon', 0, -1),
(2, 2, 'None', 2687.68, 731.898, 10.9719, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(9, 468, 'None', 2025.77, 1347.39, 10.4845, 273.022, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(7, 581, 'None', 2023.22, 1346.15, 10.4122, 274.04, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(8, 471, 'None', 2026, 1338.43, 10.3006, 267.918, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(3, 461, 'None', 2020.5, 1345.05, 10.4029, 271.072, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(4, 586, 'None', 2020.62, 1340.84, 10.3388, 268.127, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(5, 463, 'None', 2023.37, 1339.65, 10.3586, 273.326, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(6, 521, 'None', 2021.41, 1342.92, 10.3784, 270.529, 0, 0, 45, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(10, 411, 'Ashton_Adam', 2687.27, 731.792, 10.402, 8.90747, 0, 0, 1, 1, 0, 90000, 0, -1, 100, 0, 0, 'Ashton', 0, -1),
(11, 522, 'Upender_Lakhwan', 2684.52, 730.478, 10.9719, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(12, 522, 'None', 1947.68, 1339.59, 9.40938, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(13, 522, 'None', 1252.05, 827.37, 8.69984, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(14, 522, 'None', 2027.28, -613.484, 65.7033, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(0, 598, 'Veronica_Kosovna', 1680.76, 2062.56, 11.1095, 269.407, 0, 0, 129, 1, 0, 0, 1, -1, 100, 0, 0, 'Alphalon', 0, -1),
(1, 598, 'None', 1714.24, 2062.53, 11.1203, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(16, 482, 'None', -521.762, -65.3686, 62.6248, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(17, 487, 'None', 2043.65, 1306.82, 10.9719, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(18, 482, 'None', 886.723, -28.4649, 63.4953, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(19, 487, 'None', 2038.06, -517.593, 78.2018, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(20, 560, 'Tony_Patterson', 2148.24, -73.6512, 2.99929, 69.2771, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0.316667, 0, 'NONE00', 0, 0),
(21, 579, 'Steve_Veratti', 2155.12, -90.3964, 2.53372, 114.693, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 19.5166, 0, 'NONE00', 0, -1),
(22, 560, 'Tony_Patterson', 2106.25, -20.5157, 1.1994, 179.937, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(24, 522, 'None', 2046.42, 1060.57, 10.9719, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(25, 522, 'None', 516.886, -2201.77, 7.598, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(26, 488, 'None', 474.01, -2563.48, 7.51712, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(23, 522, 'None', 2240.11, -98.8319, 26.6359, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 23.9665, 0, 'NONE00', 0, -1),
(29, 560, 'Steve_Veratti', 2157, -81.5047, 3.31602, 109.311, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 9.74999, 0, 'NONE00', 0, -1),
(30, 560, 'None', 573.812, -2346.39, 7.44956, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(31, 522, 'None', 569.253, -2344.21, 7.44956, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(32, 562, 'None', 734.795, -2343.46, 7.45967, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(33, 562, 'None', 728.021, -2345, 7.47737, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(34, 562, 'None', 584.898, -2203.99, 7.44948, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(35, 562, 'None', 296.067, 2507.35, 16.7844, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 0, 0, 'NONE00', 0, -1),
(27, 522, 'None', 2135.71, -56.7605, 3.18009, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 2.3, 0, 'NONE00', 0, -1),
(28, 522, 'None', 2283.22, -99.2868, 26.6376, 0, 0, 0, 0, 0, 0, 0, 0, 65535, 100, 4.43333, 0, 'NONE00', 0, -1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `playerdata`
--
ALTER TABLE `playerdata`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `playerdata`
--
ALTER TABLE `playerdata`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
