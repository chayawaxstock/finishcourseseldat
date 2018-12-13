DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER updatePresentDay
BEFORE UPDATE
   ON presentday FOR EACH ROW
/*presentday -update sumHours work every day */
BEGIN
   SET NEW.`sumHours` = TIME_TO_SEC(  timediff(NEW.timeEnd, NEW.timeBegin ))/3600;
END;


/*project*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `project_before_insert` BEFORE INSERT ON `project`
FOR EACH ROW
BEGIN
IF new.dateEnd IS NOT NULL THEN
    CALL check_date(new.dateBegin,new.dateEnd);
    END IF;
END


/*Adding employees under the teamLeader to a project team associated with it*/
DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `managertasks`.`project_BEFORE_UPDATE` BEFORE UPDATE ON `project` FOR EACH ROW
BEGIN

IF new.dateEnd IS NOT NULL THEN
    CALL check_date(new.dateBegin,new.dateEnd);
END IF;

SET SQL_SAFE_UPDATES = 0;
SET @IDPROJECT=OLD.projectId;
set @oldmanagerId=OLD.managerId;

update projectworker pw set pw.isActive=false where  pw.id in 
(select u.id from user u where u.managerId=@oldmanagerId);

REPLACE INTO projectworker (projectId,id,isActive) 
SELECT @IDPROJECT,u.id,b'1' from user u where u.managerId=new.managerId;
END$$
DELIMITER ;


/*Adding employees under the teamLeader to a project team associated with it*/
DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `managertasks`.`project_AFTER_INSERT` AFTER INSERT ON `project` FOR EACH ROW
BEGIN

SET @IDPROJECT=LAST_INSERT_ID();
SET @IDMANAGER=NEW.managerId;
  
REPLACE INTO  managertasks.projectworker (projectId,id,isActive) 
	  SELECT @IDPROJECT,u.id,b'1' FROM managertasks.user u WHERE u.managerId=@IDMANAGER ;
END$$
DELIMITER ;




/*Adding employees under the teamLeader to a project team associated with it*/
DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER insertProjectWorker
AFTER INSERT ON `user`
      FOR EACH ROW
      BEGIN
      SET @IDUSER=LAST_INSERT_ID();
	  SET @IDMANAGER=NEW.managerId;
  
	  REPLACE INTO managertasks.projectworker (projectId,id,isActive) 
	  SELECT projectId,b'1', @IDUSER FROM managertasks.project p WHERE p.managerId=@IDMANAGER ;
END$$
DELIMITER ;


DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER UpdateProjectWorker
   AFTER UPDATE  ON `user`
    FOR EACH ROW
BEGIN
SET SQL_SAFE_UPDATES = 0;

set @oldmanagerId=OLD.managerId;
set @id=OLD.id;

	  update projectworker pw set pw.isActive=false where pw.id=@id and  pw.projectId in 
      (select p.projectId from managertasks.project p where p.managerId=@oldmanagerId);

       REPLACE into managertasks.projectworker (projectId,id,isActive) 
	   select projectId, new.id,b'1' from managertasks.project p where p.managerId=NEW.managerId ;
END$$
DELIMITER ;





