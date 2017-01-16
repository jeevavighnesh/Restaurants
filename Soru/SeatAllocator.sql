DROP FUNCTION IF EXISTS SeatAllocater;
DELIMITER !
CREATE FUNCTION SeatAllocater()
RETURNS INT
BEGIN
DECLARE seatnumber TINYINT;
DECLARE totalseats TINYINT;
DECLARE flag BOOLEAN;
SET totalseats = (SELECT NumberOfSeats FROM configuration);
SET seatnumber = (FLOOR(RAND()*(totalseats-1+1))+1);
SET @i = 1;
SET flag = FALSE;
seatloop: WHILE ((SELECT id FROM seat WHERE StatusId = 1 ORDER BY StatusId LIMIT 1) IS NOT NULL) -- if seat is available 1 so until its available
DO
	SET seatnumber = FLOOR(RAND()*(totalseats-1+1))+1;
	IF (SELECT StatusId FROM seat WHERE id = seatnumber) = 1
	THEN
		LEAVE seatloop;
	END IF;
END WHILE;
IF((SELECT id FROM seat WHERE StatusId = 1 ORDER BY StatusId LIMIT 1))
THEN
	RETURN seatnumber;
ELSE
	RETURN 0;
END IF;
END !
DELIMITER ;

SELECT seatallocater();