DROP PROCEDURE IF EXISTS SingleOrdersProcedure;
DELIMITER !
CREATE PROCEDURE SingleOrdersProcedure(FoodPar VARCHAR(20), Quantity INT, OUT Error BOOLEAN)
BEGIN

SET Error = TRUE;
SET @FoodId = (SELECT Id FROM Food WHERE FoodName = FoodPar);
-- SET @CurrentSessionName = (SELECT SessionName FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd); -- dinner and refreshment
SET @TypeId = (SELECT TypeId FROM FoodToTypeMap WHERE FoodId = @FoodId AND TypeId IN (SELECT Id FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd));-- Coffee and Tea maped to morning and evening

SET @SessionName = (SELECT SessionName FROM TypeOfFood WHERE Id = @TypeId);
SET @SessionStart = (SELECT SessionStart FROM TypeOfFood WHERE @TypeId = TypeOfFood.Id);
SET @SessionEnd = (SELECT SessionEnd FROM TypeOfFood WHERE @TypeId = TypeOfFood.Id);
SET @NoOfSeats = (SELECT NumberOfSeats FROM Configuration);
SET @SessionLimit = (SELECT Qty FROM TypeOfFood WHERE Id = @TypeId);
SET @CurrentSessionSales = (SELECT SUM(Qty) FROM SubOrders WHERE FoodId = @FoodId AND OrdersId IN (SELECT Id FROM Orders WHERE DATEDIFF(CURRENT_DATE(), TimeAndDate) = 0/*Todays Orders*/ AND OrdersStatus = 1/*Ordered food*/)); -- Amount of sales of that particular item


IF EXISTS (SELECT FoodName FROM Food WHERE FoodName = FoodPar) -- Wheather we provide the asked Food or not
THEN

	IF EXISTS(SELECT TypeId FROM FoodToTypeMap WHERE FoodId = @FoodId AND TypeId IN (SELECT Id FROM TypeOfFood WHERE CURRENT_TIME()
 BETWEEN SessionStart AND SessionEnd))
 THEN
		IF Quantity > 0
		THEN
			IF @SessionLimit >= @CurrentSessionSales OR @CurrentSessionSales IS NULL
			THEN
				IF EXISTS(SELECT SessionName FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd)-- CurrentSession
				THEN
					IF CURRENT_TIME() BETWEEN @SessionStart AND @SessionEnd
					THEN
							/*START TRANSACTION;
							SET autocommit=0;*/
								SET Error = FALSE;
							/*COMMIT;*/
					ELSE
						/*if (SELECT count(SessionName) FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd) = 1
						then*/
							SELECT CONCAT(FoodPar, " is not served during this hour!!!!");
						-- SELECT CONCAT(FoodPar, " is only severed during ", @SessionName," which starts at ", @SessionStart, " & ends at ", @SessionEnd," !!!!", "But you can order any Food from ", (SELECT SessionName FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd)/*@CurrentSessionName*/, " NOW!!!!"); -- Need change here
						/*else
							SELECT CONCAT(FoodPar, " is only severed during ", @SessionName," which starts at ", @SessionStart, " & ends at ", @SessionEnd," !!!!");
						end if;*/
					
					END IF;		
				ELSE
					SELECT CONCAT("Please Do wait for us to Prepare For the next Session!!!!");
				END IF;
			ELSE
				SELECT "Maavu Theendhudichu!!!!";
			END IF;
		ELSE
			SELECT "Enter a valid quantity U dont have the authority to add stock!!!!";
		END IF;
	ELSE
		SELECT CONCAT(FoodPar, ' is not served during this hour!!!!');
	END IF;
ELSE
	SELECT CONCAT("We  dont serve ", FoodPar, " here");
END IF;
END !
DELIMITER ;

/*CALL SingleOrdersProcedure('Variety Rice', 3, @Error);
select @Error;
-- CALL OrdersProcedure('Coffee', 3, 1);*/