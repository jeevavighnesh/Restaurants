SELECT * 
FROM table_name
ORDER BY id DESC
LIMIT 1

SELECT CURRENT_TIME(),"Hai";
SELECT SessionName FROM TypeOfFood WHERE '11:00' BETWEEN SessionStart AND SessionEnd;
SELECT SessionName FROM TypeOfFood WHERE TypeId = (SELECT TypeId FROM Food WHERE 'Idly' = Food)

SELECT (FLOOR(RAND()*(10-1+1))+1)

SELECT 11 BETWEEN 1 AND 10;

SELECT JSON_TYPE('"hello"')

CREATE TABLE t1 (jdoc JSON);

SELECT COUNT(*) FROM SubOrders;

CALL SubOrdersProcedure(1, 1, 5, 1);
CALL SubOrdersProcedure(1, 2, 5, 1);
CALL SubOrdersProcedure(1, 3, 5, 1);
CALL SubOrdersProcedure(1, 4, 5, 1);
CALL SubOrdersProcedure(1, 5, 5, 1);
CALL SubOrdersProcedure(1, 6, 5, 1);
CALL SubOrdersProcedure(1, 7, 5, 1);

SELECT COUNT(DISTINCT(FoodId)) FROM SubOrders WHERE OrderId = 1;

SELECT * FROM SubOrders GROUP BY OrderId;

SELECT id FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd AND id =

SELECT Id FROM Food WHERE Food = 'coffee';

SELECT TypeId FROM FoodToTypeMap WHERE FoodId = (SELECT Id FROM Food WHERE Food = 'idly') AND TypeId IN (SELECT Id FROM TypeOfFood WHERE CURRENT_TIME() BETWEEN SessionStart AND SessionEnd);

SELECT SUM(Qty) FROM SubOrders WHERE FoodId = 10 AND OrdersId IN (SELECT Id FROM Orders WHERE TimeAndDate >= CURRENT_DATE())
SELECT SUM(Qty) FROM SubOrders WHERE FoodId = 10 AND OrdersId IN (SELECT Id FROM Orders WHERE TimeAndDate >= CURRENT_DATE()) IS NULL

SELECT (SELECT Qty FROM TypeOfFood WHERE Id = 3) >= (SELECT SUM(Qty) FROM SubOrders WHERE FoodId = 10 AND OrdersId IN (SELECT Id FROM Orders WHERE TimeAndDate >= CURRENT_DATE()));

SELECT NULL IS NOT NULL;
SELECT 1 IS NOT NULL;

SHOW VARIABLES max_sp_recursion_depth;




SELECT Food.`Id`, FoodName, typeoffood.Qty - SUM(suborders.Qty) AS "Stock Remaining"
FROM typeoffood
JOIN food, suborders, FoodToTypeMap, orders WHERE TypeId = typeoffood.Id AND Food.Id = suborders.FoodId AND Food.`Id` = foodtotypemap.FoodId AND OrdersId = orders.`Id` AND DATEDIFF(CURDATE(), TimeAndDate) = 0 AND OrdersStatus = 1 GROUP BY food.Id

UNION

SELECT Food.`Id`, FoodName, typeoffood.Qty AS "Stock Remaining"
FROM food
JOIN typeoffood, FoodToTypeMap WHERE TypeId = typeoffood.Id AND Food.`Id` = foodtotypemap.FoodId AND Food.Id NOT IN(SELECT Food.`Id` FROM typeoffood JOIN food, suborders, FoodToTypeMap, orders WHERE TypeId = typeoffood.Id AND Food.Id = suborders.FoodId AND Food.`Id` = foodtotypemap.FoodId AND OrdersId = orders.`Id` AND DATEDIFF(CURDATE(), TimeAndDate) = 0 AND OrdersStatus = 1 GROUP BY food.Id) GROUP BY food.Id; /*The Stockpile Remains code*/

SELECT *
FROM food
JOIN typeoffood, FoodToTypeMap, SubOrders WHERE Food.Id = FoodToTypeMap.FoodId AND TypeId = typeoffood.`Id` OR Food.Id = SubOrders.FoodId