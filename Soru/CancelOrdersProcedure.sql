DROP PROCEDURE IF EXISTS CancelOrdersProcedure;
DELIMITER !
CREATE PROCEDURE CancelOrdersProcedure(OrdersId INT)
BEGIN

IF OrdersId IN (SELECT Id FROM Orders WHERE DATEDIFF(CURRENT_DATE(), TimeAndDate) = 0)
THEN
	IF (SELECT OrdersStatus FROM Orders WHERE Id = OrdersId) <> 2/*Not Already Canceled*/
	THEN
		UPDATE Orders SET OrdersStatus = 2 WHERE Id = OrdersId/*Making Status as Cancelled*/;
	ELSE
		SELECT CONCAT("Order Id ", OrdersId," has alreary been Cancelled!!!!!");
	END IF;

ELSE
	SELECT CONCAT("Order Id ", OrdersId," is not available in our database or it is from an old record, other than today!!!!");
END IF;

END !
DELIMITER ;

CALL CancelOrdersProcedure(3);