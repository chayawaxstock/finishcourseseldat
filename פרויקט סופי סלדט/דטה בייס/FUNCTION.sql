CREATE DEFINER=`root`@`localhost` FUNCTION `NullDate`(_Input DATETIME) RETURNS tinyint(1)
BEGIN 
IF (_Input = '0000-00-00') OR 
(_Input = '0000-00-00 00:00:00') THEN 
RETURN TRUE; 
ELSE 
RETURN FALSE; 
END IF; 
END