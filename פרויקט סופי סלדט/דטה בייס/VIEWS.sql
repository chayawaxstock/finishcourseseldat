/*REPORT PROJECT*/
DELIMITER $$
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `reportproject` AS
    SELECT 
        `p`.`projectId` AS `projectId`,
        `p`.`numHour` AS `numHour`,
        `p`.`name` AS `name`,
        `p`.`dateBegin` AS `dateBegin`,
        `p`.`dateEnd` AS `dateEnd`,
        `p`.`isFinish` AS `isFinish`,
        `p`.`customerName` AS `customerName`,
        `p`.`managerId` AS `managerId`,
        `u`.`userName` AS `userName`,
        (SELECT 
                SUM(`presentday`.`sumHours`) AS `sumHourWork`
            FROM
                `presentday`
            WHERE
                (`presentday`.`projectId` = `p`.`projectId`)
            GROUP BY `presentday`.`projectId`) AS `sumHourDo`,
        (TO_DAYS(`p`.`dateEnd`) - TO_DAYS(CURDATE())) AS `numDaysStay`,
        (((SELECT 
                SUM(`presentday`.`sumHours`) AS `sumHourWork`
            FROM
                `presentday`
            WHERE
                (`presentday`.`projectId` = `p`.`projectId`)
            GROUP BY `presentday`.`projectId`) / `p`.`numHour`) * 100) AS `presentDoing`
    FROM
        ((`presentday` `pd`
        LEFT JOIN (`projectworker` `pw`
        LEFT JOIN `project` `p` ON ((`pw`.`projectId` = `p`.`projectId`))) ON ((`pw`.`id` = `pd`.`id`)))
        JOIN `user` `u` ON ((`u`.`id` = `p`.`managerId`)))
    GROUP BY `p`.`projectId`
    ORDER BY `p`.`isFinish`;
    
 DELIMITER $$   
  CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `reportworker` AS
    SELECT 
        `user`.`id` AS `id`,
        `user`.`userName` AS `userName`,
        `user`.`numHourWork` AS `numHourWork`,
        ((`user`.`numHourWork` * 5) * 4) AS `numHourWork*5*4`
    FROM
        `user`
    ORDER BY `user`.`userName`;
    
    
    
    sumhoursforuserproject
   DELIMITER $$ 
    CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sumhoursforuserproject` AS
    SELECT 
        SUM(`p`.`sumHours`) AS `sumHours`,
        (SELECT 
                ((SUM(`p`.`sumHours`) / `pw`.`hoursForProject`) * 100)
            FROM
                `projectworker` `pw`
            WHERE
                ((`p`.`id` = `pw`.`id`)
                    AND (`p`.`projectId` = `pw`.`projectId`))) AS `precentDone`,
        (SELECT 
                `pw`.`hoursForProject`
            FROM
                `projectworker` `pw`
            WHERE
                ((`p`.`id` = `pw`.`id`)
                    AND (`p`.`projectId` = `pw`.`projectId`))) AS `TotalHours`,
        `pr`.`name` AS `name`,
        `p`.`id` AS `id`,
        `u`.`userName` AS `userName`,
        `u`.`departmentUserId` AS `departmentUserId`,
        `p`.`projectId` AS `projectId`
    FROM
        ((`presentday` `p`
        JOIN `project` `pr` ON ((`p`.`projectId` = `pr`.`projectId`)))
        JOIN `user` `u` ON ((`u`.`id` = `p`.`id`)))
    GROUP BY `p`.`id` , `p`.`projectId` , `pr`.`name`
    
    
    
    
    