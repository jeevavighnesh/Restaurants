DROP PROCEDURE IF EXISTS OrdersProcedure;
DELIMITER !
CREATE PROCEDURE OrdersProcedure(FoodPar VARCHAR(20), Quantity INT, SeatNumber INT)
BEGIN
SET @TypeId = (SELECT TypeId FROM Food WHERE FoodPar = Food);
SET @FoodId = (SELECT FoodId FROM Food WHERE FoodPar = Food);
SET @CurrentSessionName = (SELECT SessionName FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd);
SET @SessionName = (SELECT SessionName FROM TypeOfFood WHERE TypeId=@TypeId);
SET @SessionStart = (SELECT SessionStart FROM TypeOfFood WHERE @TypeId = TypeOfFood.TypeId);
SET @SessionEnd = (SELECT SessionEnd FROM TypeOfFood WHERE @TypeId = TypeOfFood.TypeId);
SET @OrderLimit = (SELECT ItemLimit FROM Configuration);
SET @NoOfSeats = (SELECT NumberOfSeats FROM Configuration);
SET @SessionLimit = (SELECT Qty FROM TypeOfFood WHERE TypeId = @TypeId);
SET @CurrentSessionSales = (SELECT COUNT(*) FROM Orders WHERE FoodId = @FoodId);
IF SeatNumber BETWEEN 1 AND 10
THEN
	IF EXISTS (SELECT TypeId FROM Food WHERE FoodPar = Food) -- TypeId
	THEN
		IF @SessionLimit >= @CurrentSessionSales
		THEN
			IF EXISTS(SELECT SessionName FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd)-- CurrentSession
			THEN
				IF CURRENT_TIME() BETWEEN @SessionStart AND @SessionEnd
				THEN
					IF SeatNumber NOT IN (SELECT Seat FROM orders)
					THEN
						START TRANSACTION;
						SET autocommit=0;
							INSERT INTO Orders(FoodId, Qty, Seat)VALUES(@FoodId, Quantity, SeatNumber);
						COMMIT;
						SELECT CONCAT("Your Order has been placed!!!! Please do wait for it at Seat No. ", SeatNumber);
					ELSE
						CALL SubOrdersProcedure((SELECT Id FROM Orders WHERE Seat = SeatNumber), @FoodId, Quantity, SeatNumber);
					END IF;
				ELSE
					SELECT CONCAT(FoodPar, " is only severed during ", @SessionName," which starts at ", @SessionStart, " & ends at ", @SessionEnd," !!!!", "But you can order any Food from ", @CurrentSessionName);
					
				END IF;		
			ELSE
				SELECT CONCAT("Please Do wait for us to Prepare For the next Session!!!!");
			END IF;
		ELSE
			SELECT "Maavu Theendhudichu!!!!";
		END IF;
	ELSE
		SELECT CONCAT("We  dont serve ", FoodPar, " here");
	END IF;
ELSE
	SELECT CONCAT("I Think we dont have a seat numbered ", SeatNumber);
END IF;
END !
DELIMITER ;

CALL OrdersProcedure('Idly', 3, 1);
-- CALL OrdersProcedure('Coffee', 3, 1);

