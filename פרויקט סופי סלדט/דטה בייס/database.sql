CREATE DATABASE managerTasks;

USE managerTasks;


 CREATE TABLE `department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `department` varchar(15) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;


CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(20) CHARACTER SET utf8 NOT NULL,
  `userComputer` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `password` varchar(64) CHARACTER SET utf8 NOT NULL,
  `departmentUserId` int(11) NOT NULL,
  `email` varchar(40) CHARACTER SET utf8 NOT NULL,
  `numHourWork` decimal(10,0) NOT NULL COMMENT 'num hour that worker work',
  `managerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fkIdx_133` (`departmentUserId`),
  KEY `fkIdx_182` (`managerId`),
  CONSTRAINT `FK_133` FOREIGN KEY (`departmentUserId`) REFERENCES `department` (`id`),
  CONSTRAINT `FK_182` FOREIGN KEY (`managerId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;


CREATE TABLE `project` (
  `projectId` int(11) NOT NULL AUTO_INCREMENT,
  `numHour` decimal(10,0) NOT NULL,
  `name` varchar(15) CHARACTER SET utf8 NOT NULL,
  `dateBegin` date NOT NULL,
  `dateEnd` date NOT NULL,
  `isFinish` bit(1) NOT NULL DEFAULT b'0',
  `customerName` varchar(15) CHARACTER SET utf8 NOT NULL,
  `managerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`projectId`),
  KEY `fkIdx_157` (`managerId`),
  CONSTRAINT `FK_157` FOREIGN KEY (`managerId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;




CREATE TABLE `hourfordepartment` (
  `projectId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL,
  `sumHours` decimal(10,0) NOT NULL,
  PRIMARY KEY (`projectId`,`departmentId`),
  KEY `fkIdx_160` (`projectId`),
  KEY `fkIdx_172` (`departmentId`),
  CONSTRAINT `FK_160` FOREIGN KEY (`projectId`) REFERENCES `project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_172` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `presentday` (
  `timeBegin` datetime NOT NULL,
  `presentDayId` int(11) NOT NULL AUTO_INCREMENT,
  `timeEnd` datetime DEFAULT NULL,
  `sumHours` decimal(10,4) DEFAULT '0.0000',
  `id` int(11) NOT NULL,
  `projectId` int(11) NOT NULL,
  PRIMARY KEY (`presentDayId`),
  KEY `fkIdx_210` (`id`),
  KEY `fkIdx_213` (`projectId`),
  CONSTRAINT `FK_210` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_213` FOREIGN KEY (`projectId`) REFERENCES `project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;



CREATE TABLE `projectworker` (
  `projectId` int(11) NOT NULL,
  `hoursForProject` decimal(10,0) DEFAULT '0',
  `id` int(11) NOT NULL,
  `isActive` bit(1) DEFAULT b'1',
  PRIMARY KEY (`projectId`,`id`),
  KEY `fkIdx_151` (`projectId`),
  KEY `fkIdx_185` (`id`),
  CONSTRAINT `FK_151` FOREIGN KEY (`projectId`) REFERENCES `project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_185` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `requestpassword` (
  `idRequest` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(20) DEFAULT NULL,
  `dateCreate` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateExpirence` datetime DEFAULT CURRENT_TIMESTAMP,
  `isUse` bit(1) DEFAULT b'0',
  PRIMARY KEY (`idRequest`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;






