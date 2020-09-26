CREATE TABLE `whitelist` (
  `identifier` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`)
);

CREATE TABLE `poikkeusluvat` (
  `identifier` varchar(60) COLLATE utf8mb4_bin NOT NULL, PRIMARY KEY (`identifier`)
);

INSERT INTO `poikkeusluvat` (`identifier`) VALUES
	('steam:1100001155db950'),
	('steam:11000013de6363f');