DROP PROCEDURE IF EXISTS SubOrdersProcedure;
DELIMITER !
CREATE PROCEDURE SubOrdersProcedure(OrderIdPara INT, FoodId INT, Quantity INT, SeatNumber INT)
BEGIN

IF (SELECT DISTINCT COUNT(FoodId) FROM SubOrders WHERE OrderId = OrderIdPara) > 4
THEN
	SELECT "We are Sorry to Say you that our Item Limit Has Reached";	
ELSE
	START TRANSACTION;
	SET autocommit=0;
		INSERT INTO SubOrders(OrderId, FoodId, Qty)VALUES(OrderIdPara, FoodId, Quantity);
	COMMIT;
	SELECT CONCAT("Your Order has been placed!!!! Please do wait for it at the Seat No. ", SeatNumber);
END IF;
	
END !
DELIMITER ;

CALL SubOrdersProcedure(1, 7, 5, 1);