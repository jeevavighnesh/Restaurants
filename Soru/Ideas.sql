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
SELECT COUNT(DISTINCT(FoodId)) FROM SubOrders WHERE OrderId = 1;

SELECT * FROM SubOrders GROUP BY OrderId;