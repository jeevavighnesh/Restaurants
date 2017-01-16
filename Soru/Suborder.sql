DROP PROCEDURE IF EXISTS OrdersProcedure;
DELIMITER !
CREATE PROCEDURE OrdersProcedure()
BEGIN
SET max_sp_recursion_depth = 255;
SET @ItemLimit = (SELECT ItemLimit FROM Configuration);
SET @suborderid = (SELECT Id FROM InputOrders LIMIT 1);
SET @SeatNumber = (SELECT seatallocater());
SET @NumberOfInputOrders = (SELECT COUNT(*) FROM InputOrders);
-- SET @temp = @NumberOfInputOrders;
SET @Error = FALSE;


IF @SeatNumber <> 0
THEN
	IF (SELECT COUNT(*) FROM InputOrders) <> 0
	THEN
		IF (SELECT COUNT(DISTINCT Food) FROM InputOrders) <= @ItemLimit
		THEN
WhileLoop:	WHILE (SELECT Id FROM InputOrders WHERE Id = @suborderid) IS NOT NULL
		DO
			SET @FoodName = (SELECT Food FROM InputOrders WHERE Id = @suborderid);
			SET @Quantity = (SELECT Qty  FROM InputOrders WHERE Id = @suborderid);
			CALL SingleOrdersProcedure(@FoodName, @Quantity, @Error);
			SET @suborderid = @suborderid + 1;
			IF @Error -- Take on this loop bruh to add in correct additions additions but u know the problem
			THEN
				LEAVE WhileLoop;
			END IF;
		END WHILE;
		SELECT @Error;
		SET @suborderid = (SELECT Id FROM InputOrders LIMIT 1);
		
			IF NOT @Error				
			THEN
				START TRANSACTION;
				SET autocommit=0;
					UPDATE Seat SET StatusId = 2/*Taken yo Beat it*/ WHERE Id = @SeatNumber;
					INSERT INTO Orders(NoOfItems, SeatId, OrdersStatus)VALUES(@NumberOfInputOrders, @SeatNumber, 1);
					SET @OrderId = (SELECT Id FROM Orders ORDER BY (Id) DESC LIMIT 1);
						WHILE (SELECT Id FROM InputOrders WHERE Id = @suborderid) IS NOT NULL
						DO
							SET @FoodName = (SELECT Food FROM InputOrders WHERE Id = @suborderid);
							SET @Quantity = (SELECT Qty  FROM InputOrders WHERE Id = @suborderid);
							INSERT INTO SubOrders(OrdersId, FoodId, Qty)VALUES(@OrderId, @FoodId, @Quantity);
							/*call SingleOrdersProcedure(@OrderId, @FoodName, @Quantity);*/
							SET @suborderid = @suborderid + 1;
							-- SET @temp = @temp - 1;
						END WHILE;
					TRUNCATE InputOrders;
					SELECT CONCAT("Your Order has been placed!!!! Please do wait for it at Seat No. ", @SeatNumber);
					UPDATE Seat SET StatusId = 1/*Available*/ WHERE Id = @SeatNumber;
				COMMIT;
			END IF;
		ELSE
			SELECT "Item Limit Exceeded!!!!";
		END IF;
	ELSE
		SELECT "Please Insert orders into the InputOrders Table So that we could make some money!!!!";	
	END IF;
ELSE
	SELECT "All our Seats are currently occupied please do wait for us to allocate it...";
	/*if !(select sleep(5))
	then
		call OrdersProcedure();
	end if;*/
END IF;
END !
DELIMITER ;

/*CALL OrdersProcedure();*/ /*Before Running this line Please DO INSERT IN THE INPUT ORDERS TABLE. Obviously We Handled the error This is just to save your time*/