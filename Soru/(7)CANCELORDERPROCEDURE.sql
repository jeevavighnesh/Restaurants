DROP PROCEDURE IF EXISTS CANCELORDERSPROCEDURE;
DELIMITER !
CREATE PROCEDURE CANCELORDERSPROCEDURE(ORDERSID INT)
BEGIN

IF ORDERSID IN (SELECT ID FROM ORDERS WHERE DATEDIFF(CURRENT_DATE(), TIMEANDDATE) = 0)
THEN
	IF (SELECT ORDERSSTATUS FROM ORDERS WHERE ID = ORDERSID) <> 2/*NOT ALREADY CANCELED*/
	THEN
		IF (SELECT ORDERSSTATUS FROM ORDERS WHERE ID = ORDERSID)<>1
		THEN
			START TRANSACTION;
			SET AUTOCOMMIT = 0;
				UPDATE ORDERS SET ORDERSSTATUS = 2 WHERE ID = ORDERSID/*MAKING STATUS AS CANCELLED*/;
			COMMIT;
		ELSE
			SELECT CONCAT("ORDER ID ", ORDERSID," HAS BEEN ", (SELECT ORDERSSTATUS FROM ORDERSSTATUS WHERE ID = 1)," TO YOU  WHICH COULD NOT BE TAKEN BACK. ITS NOT COOL!!!!!");
		END IF;
	ELSE
		SELECT CONCAT("ORDER ID ", ORDERSID," HAS ALREARY BEEN CANCELLED!!!!!");
	END IF;

ELSE
	SELECT CONCAT("ORDER ID ", ORDERSID," IS NOT AVAILABLE IN OUR DATABASE OR IT IS FROM AN OLD RECORD, OTHER THAN TODAY!!!!");
END IF;

END !
DELIMITER ;

/*CALL CANCELORDERSPROCEDURE(35);*//*SUPER INSANELY PERFECT CHECK FOR THE CONDITONS IN ORDERSFUNCTION AGAIN AND AGAIN AND AGAIN!!!!!*/
