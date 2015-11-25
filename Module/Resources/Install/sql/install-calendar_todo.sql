CREATE TABLE IF NOT EXISTS `#__calendar_todo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userFrom` int(11) NOT NULL,
  `userFor` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `priority` tinyint(4) NOT NULL,
  `done` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `type` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `ordering` tinyint(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userFor` (`userFor`),
  KEY `userFrom` (`userFrom`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;
