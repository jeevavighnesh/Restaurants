DROP PROCEDURE IF EXISTS ORDERSPROCEDURE;
DELIMITER !
CREATE PROCEDURE ORDERSPROCEDURE(SEATNUMBER INT, OUT COMMENTS VARCHAR(2000))
BEGIN
SET MAX_SP_RECURSION_DEPTH = 255;
SET @ITEMLIMIT = (SELECT ITEMLIMIT FROM CONFIGURATION);
SET @SUBORDERID = (SELECT ID FROM INPUTORDERS WHERE SEATID = SEATNUMBER LIMIT 1);
-- SET @SEATNUMBER = (SELECT SEATALLOCATER());
-- SET @TEMP = @NUMBEROFINPUTORDERS;
SET @ERROR = FALSE;


IF SEATNUMBER <> 0
THEN
	IF (SELECT COUNT(*) FROM INPUTORDERS) <> 0
	THEN
		
WHILELOOP:		WHILE (SELECT ID FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER) IS NOT NULL
			DO
				UPDATE INPUTORDERS SET VALID = TRUE WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER;
				SET @FOODNAME = (SELECT FOOD FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATNUMBER = SEATID);
				SET @QUANTITY = (SELECT QTY  FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATNUMBER = SEATID);
				CALL SINGLEORDERSPROCEDURE(@FOODNAME, @QUANTITY, @ERROR, @COMMENTS);
				IF @ERROR -- TAKE ON THIS LOOP BRUH TO ADD IN CORRECT ADDITIONS ADDITIONS BUT U KNOW THE PROBLEM
				THEN
					UPDATE INPUTORDERS SET VALID = FALSE WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER;
					SELECT @COMMENTS;
					SET COMMENTS = IFNULL(CONCAT(COMMENTS,' ', @COMMENTS),@COMMENTS);
				END IF;
				SET @SUBORDERID = @SUBORDERID + 1;
			END WHILE;
			-- SELECT @ERROR;
			SET @NUMBEROFINPUTORDERS = (SELECT COUNT(*) FROM INPUTORDERS WHERE SEATNUMBER = SEATID AND VALID = TRUE);
			SET @SUBORDERID = (SELECT ID FROM INPUTORDERS WHERE SEATID = SEATNUMBER LIMIT 1);
		IF (SELECT COUNT(DISTINCT FOOD) FROM INPUTORDERS WHERE SEATNUMBER = SEATID AND VALID = TRUE) <= @ITEMLIMIT
		THEN	
			IF (SELECT VALID FROM INPUTORDERS ORDER BY (VALID) DESC LIMIT 1) = 1
			THEN
				INSERT INTO ORDERS(NOOFITEMS, SEATID, ORDERSSTATUS)VALUES(@NUMBEROFINPUTORDERS, SEATNUMBER, 3);
				SET @ORDERID = (SELECT ID FROM ORDERS ORDER BY (ID) DESC LIMIT 1);
				WHILE (SELECT ID FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER) IS NOT NULL
				DO
					IF (SELECT VALID FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER) = TRUE
					THEN
						SET @NAME = (SELECT FOOD FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER);
						SET @FOODID = (SELECT ID FROM FOOD WHERE FOODNAME = @NAME);
						SET @QUANTITY = (SELECT QTY  FROM INPUTORDERS WHERE ID = @SUBORDERID AND SEATID = SEATNUMBER);
						INSERT INTO SUBORDERS(ORDERSID, FOODID, QTY)VALUES(@ORDERID, @FOODID, @QUANTITY);
					END IF;
					/*CALL SINGLEORDERSPROCEDURE(@ORDERID, @FOODNAME, @QUANTITY);*/
					SET @SUBORDERID = @SUBORDERID + 1;
					-- SET @TEMP = @TEMP - 1;
				END WHILE;
				DELETE FROM INPUTORDERS WHERE SEATID = SEATNUMBER;
				SELECT CONCAT("YOUR ORDER HAS BEEN PLACED!!!! PLEASE DO WAIT FOR IT AT SEAT NO. ", SEATNUMBER);
				SET COMMENTS = IFNULL(CONCAT(COMMENTS, ' ', "YOUR ORDER HAS BEEN PLACED!!!! PLEASE DO WAIT FOR IT AT SEAT NO. ", SEATNUMBER),CONCAT("YOUR ORDER HAS BEEN PLACED!!!! PLEASE DO WAIT FOR IT AT SEAT NO. ", SEATNUMBER));
				UPDATE ORDERS SET ORDERSSTATUS = 1 WHERE ID = @ORDERID;
			ELSE
				SELECT "NONE OF YOUR ORDERS WERE PLACED PLEASE DO PLACE A VALID ORDER SO WE CAN DO BUSINESS";
				SET COMMENTS = IFNULL(CONCAT(COMMENTS, ' ', "NONE OF YOUR ORDERS WERE PLACED PLEASE DO PLACE A VALID ORDER SO WE CAN DO BUSINESS"),"NONE OF YOUR ORDERS WERE PLACED PLEASE DO PLACE A VALID ORDER SO WE CAN DO BUSINESS");
				DELETE FROM INPUTORDERS WHERE SEATID = SEATNUMBER;
			END IF;
		ELSE
			SELECT "ITEM LIMIT EXCEEDED!!!!";
			SET COMMENTS = IFNULL(CONCAT(COMMENTS, ' ', "ITEM LIMIT EXCEEDED!!!!"),"ITEM LIMIT EXCEEDED!!!!");
		END IF;
	ELSE
		SELECT "PLEASE INSERT ORDERS INTO THE INPUT SO THAT WE COULD MAKE SOME MONEY!!!!";
		SET COMMENTS = IFNULL(CONCAT(COMMENTS, ' ', "PLEASE INSERT ORDERS INTO THE INPUT SO THAT WE COULD MAKE SOME MONEY!!!!"),"PLEASE INSERT ORDERS INTO THE INPUT SO THAT WE COULD MAKE SOME MONEY!!!!");
	END IF;
ELSE
	SELECT "ALL OUR SEATS ARE CURRENTLY OCCUPIED PLEASE DO WAIT FOR US TO ALLOCATE IT...";
	SET COMMENTS = IFNULL(CONCAT(COMMENTS, ' ', "ALL OUR SEATS ARE CURRENTLY OCCUPIED PLEASE DO WAIT FOR US TO ALLOCATE IT..."),"ALL OUR SEATS ARE CURRENTLY OCCUPIED PLEASE DO WAIT FOR US TO ALLOCATE IT...");
	DO SLEEP(5); -- STALLING HERE...
		CALL ORDERSPROCEDURE();
END IF;
END !
DELIMITER ;

/*CALL ORDERSPROCEDURE(4, @CMMT);
SELECT @CMMT*/ 
/*BEFORE RUNNING THIS LINE PLEASE DO INSERT IN THE INPUT ORDERS TABLE. OBVIOUSLY WE HANDLED THE ERROR THIS IS JUST TO SAVE YOUR TIME*/
