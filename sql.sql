CREATE TABLE `turfs` (
	`name` VARCHAR(20) NOT NULL,
	`gang` VARCHAR(20) NOT NULL DEFAULT 'neutral',
	`reputations` LONGTEXT NOT NULL DEFAULT '{\"neutral\":0}',

	PRIMARY KEY (`name`)
);

INSERT INTO `turfs` (`name`, `gang`, `reputations`) VALUES
('DEL_PERRO', 'neutral', '{\"neutral\":0}'),
('VINEWOOD', 'neutral', '{\"neutral\":0}'),
('MIRROR', 'neutral', '{\"neutral\":0}'),
('VESPUCCI', 'neutral', '{\"neutral\":0}'),
('LITTLE_SEOUL', 'neutral', '{\"neutral\":0}'),
('CYPRESS_FLATS', 'neutral', '{\"neutral\":0}');