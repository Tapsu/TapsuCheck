CREATE TABLE `whitelist` (
  `identifier` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`identifier`)
);

CREATE TABLE `poikkeusluvat` (
  `identifier` varchar(60) COLLATE utf8mb4_bin NOT NULL, PRIMARY KEY (`identifier`)
);
