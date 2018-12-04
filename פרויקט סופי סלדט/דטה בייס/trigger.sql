DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER updatePresentDay44
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

REPLACE INTO projectworker (projectId,id) 
SELECT @IDPROJECT,u.id from user u where u.managerId=new.managerId;


update projectworker pw set pw.isActive=false where  pw.id in 
(select u.id from user u where u.managerId=@oldmanagerId);

END$$
DELIMITER ;

DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `managertasks`.`project_AFTER_INSERT` AFTER INSERT ON `project` FOR EACH ROW
BEGIN

SET @IDPROJECT=0;
        SELECT MAX(projectId) FROM project INTO @IDPROJECT;
       SET @IDMANAGER=NEW.managerId;
  
REPLACE INTO  managertasks.projectworker (projectId,id) 
	  SELECT @IDPROJECT,u.id  FROM managertasks.user u WHERE u.managerId=@IDMANAGER ;
END$$
DELIMITER ;




/*USER*/
DELIMITER $$
USE `managertasks`$$
CREATE DEFINER=`root`@`localhost` TRIGGER insertProjectWorker
AFTER INSERT ON `user`
      FOR EACH ROW
      BEGIN
      SET @IDUSER=0;
        SELECT MAX(id) FROM user INTO @IDUSER;
       SET @IDMANAGER=NEW.managerId;
  
	  REPLACE INTO managertasks.projectworker (projectId,id) 
	  SELECT projectId, @IDUSER FROM managertasks.project p WHERE p.managerId=@IDMANAGER ;
 
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

	  REPLACE into managertasks.projectworker (projectId,id) 
	  select projectId, new.id from managertasks.project p where p.managerId=NEW.managerId ;
END$$
DELIMITER ;





