CREATE TABLE IF NOT EXISTS `item` (
    `itemid` INT(11) AUTO_INCREMENT PRIMARY KEY,
    `display_name` VARCHAR(32) NOT NULL,
    `display_name_plural` VARCHAR(32),
    `code_name` VARCHAR(32) NOT NULL UNIQUE,
    `description` TEXT,
    `image` VARCHAR(32) NOT NULL,
    `weight` FLOAT UNSIGNED DEFAULT 1.0 NOT NULL,
    `stacksize` INT(11) UNSIGNED DEFAULT 99 NOT NULL
);

CREATE TABLE IF NOT EXISTS `inventory` (
    `uiid` VARCHAR(256) NOT NULL PRIMARY KEY,
    `owner` VARCHAR(64), 
    `theme` TINYINT(11) UNSIGNED NOT NULL DEFAULT 0,
    `style` TINYINT(11) UNSIGNED NOT NULL DEFAULT 0,
    `width` TINYINT(11) UNSIGNED NOT NULL DEFAULT 8,
    `height` TINYINT(11) UNSIGNED NOT NULL DEFAULT 8,
    INDEX idx_uiid_owner (uiid, owner)
);

CREATE TABLE IF NOT EXISTS `inventory_item` ( 
    `id` INT NOT NULL AUTO_INCREMENT, 
    `uiid` VARCHAR(256) NOT NULL, 
    `x` TINYINT(11) UNSIGNED NOT NULL DEFAULT 0, 
    `y` TINYINT(11) UNSIGNED NOT NULL DEFAULT 0, 
    `itemid` INT(11) NOT NULL DEFAULT -1, 
    PRIMARY KEY (`id`),
    FOREIGN KEY (`uiid`) REFERENCES inventory(`uiid`),
    FOREIGN KEY (`itemid`) REFERENCES item(`itemid`)
);