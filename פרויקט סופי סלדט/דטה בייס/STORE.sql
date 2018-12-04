DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `reportWorker`(in idWorker int)
BEGIN
select year(pd.timeBegin), month(pd.timeBegin),(select name from project where projectId=pd.projectId)
,(select hoursForProject from projectworker where id=pd.id
 and projectId=pd.projectId) as totalHours,
(select sum(sumHours) from presentday where projectId=pd.projectId and id=pd.id) as hourDo
 ,sum(pd.sumHours) as doingMonth from presentday pd  where pd.id=idWorker
group by year(pd.timeBegin), month(pd.timeBegin),pd.projectId order by year(pd.timeBegin) ;
END


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `report`(IN viewName VARCHAR(40))
BEGIN
SET @sql =CONCAT("SELECT * FROM ",viewName);
 PREPARE stmt3 FROM @sql;
 EXECUTE stmt3;
 DEALLOCATE PREPARE stmt3;
END

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `departmensProject`(in Id nvarchar(5))
BEGIN
select d.id, d.department,pd.sumHours,(select sum(sumHours) from sumhoursforuserproject where projectId=projectId and departmentUserId=d.id )
,(select (select sum(sumHours) from sumhoursforuserproject where projectId=Id and departmentUserId=pd.departmentId )/
 pd.sumHours*100) as precentsDone from department d join hourfordepartment pd on
pd.departmentId=d.id where pd.projectId=Id;
END


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateReport`(in fillter NVARCHAR(20),in fillter2 NVARCHAR(20))
BEGIN
set @sql='SELECT
                    * 
                   FROM report';
if(fillter>'')  then        				
 set @sql = CONCAT(@sql,' where ',fillter,'=',fillter2);
end if;

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_date`(IN dateBegin date, IN dateEnd date)
BEGIN
    IF DATEDIFF(dateEnd,dateBegin)<=0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'check constraint on project.dateEnd failed';
    END IF;
 
END