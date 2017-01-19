DROP PROCEDURE IF EXISTS PR_SUBORDER_SPLITTER;
DELIMITER !
CREATE PROCEDURE PR_SUBORDER_SPLITTER(ORDERS VARCHAR(200), SEATNO INT)
BEGIN
DECLARE SUBORDER VARCHAR(50);
SET SUBORDER = SUBSTRING_INDEX(ORDERS,',',1);
/*DECLARE SEATNO INT;
SET SEATNO = (SELECT SEATALLOCATER());*/
CALL PR_IS_VALID_SEAT(SEATNO,@ERR,@COMMENTS);
IF NOT @ERR
THEN
	WHILE (SUBORDER <> ORDERS)
	DO
		SET SUBORDER = SUBSTRING_INDEX(ORDERS,',',1);
		SET ORDERS = REPLACE(ORDERS,CONCAT(SUBORDER,','),'');
		/*IF POSITION(' ' IN SUBORDER) = 1
		THEN
			SET SUBORDER = 
		END IF;*/
		CALL PR_NAME_QTY_DIVIDER (SUBORDER, SEATNO);
	END WHILE;
	START TRANSACTION;
		SET AUTOCOMMIT=0;
		UPDATE SEAT SET STATUSID = 2/*TAKEN YO BEAT IT*/ WHERE ID = SEATNO;
		CALL ORDERSPROCEDURE(SEATNO);
		UPDATE SEAT SET STATUSID = 1/*AVAILABLE*/ WHERE ID = SEATNO;
	COMMIT;
ELSE
	SELECT @COMMENTS;
END IF;
END !
DELIMITER ;

/*CALL PR_SUBORDER_SPLITTER('IDLY 3,COFFEE 4,HAI 40,SNACKS 6,TEA 3',5);*/-- THIS IS THE ROOT CALLING PROCEDURE STATEMENT

DROP PROCEDURE IF EXISTS PR_NAME_QTY_DIVIDER;
DELIMITER !
CREATE PROCEDURE PR_NAME_QTY_DIVIDER(SUBORDER VARCHAR(50), SEATNUMBER INT)
BEGIN
DECLARE FOODNAME VARCHAR(20);
DECLARE CHAR_QTY VARCHAR(10);
DECLARE QTY INT;
DECLARE FEILD VARCHAR(20);
DECLARE ERROR BOOLEAN;
SET FOODNAME = '';
SET QTY = 0;
SET FEILD = SUBSTRING_INDEX(SUBORDER,' ',1);
SET ERROR = FALSE;

WHILELOOP: WHILE (SUBORDER <> FEILD)
DO
	SET FEILD = SUBSTRING_INDEX(SUBORDER,' ',1);
	SET SUBORDER = REPLACE(SUBORDER,CONCAT(FEILD,' '),'');
	-- SELECT FEILD;
	IF FEILD <> '0'
	THEN
		IF (CONVERT(FEILD, SIGNED) <> 0)
		THEN
			SET QTY = CONVERT(FEILD, SIGNED);
			IF QTY <= 0
			THEN
				SET ERROR = TRUE;
				LEAVE WHILELOOP;
			END IF; 
		ELSE
			SET FOODNAME = CONCAT(FOODNAME,' ',FEILD);
		END IF;
	ELSE
		SET ERROR = TRUE;
		LEAVE WHILELOOP;
	END IF;
END WHILE;
SET FOODNAME = UPPER(TRIM(FOODNAME));
INSERT INTO INPUTORDERS (FOOD, QTY, SEATID) VALUES (FOODNAME, QTY, SEATNUMBER);
-- SELECT SUBORDER,FEILD,FOODNAME,QTY,ERROR;

END !
DELIMITER ;

-- CALL PR_NAME_QTY_DIVIDER('FRIED RICE 3', 5);

-- SELECT CONVERT('IDLU', SIGNED);
