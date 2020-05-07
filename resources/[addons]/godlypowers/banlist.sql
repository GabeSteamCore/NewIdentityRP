CREATE TABLE `Alexis3572fivem`.`banlist` ( 
  `fivemID` VARCHAR(25) NOT NULL , 
  `steamID` VARCHAR(25) NOT NULL , 
  `date` DATE NOT NULL,
  `duration` INT UNSIGNED NOT NULL DEFAULT '0',
  `reason` VARCHAR(255) NOT NULL ,  
) ENGINE = InnoDB COMMENT = 'list of players banned'; 