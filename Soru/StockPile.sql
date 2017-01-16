DROP VIEW usedstock;
CREATE
    VIEW usedstock 
    AS
(
SELECT Food.`Id`, FoodName, typeoffood.Qty - SUM(suborders.Qty) AS "Stock Remaining"
FROM typeoffood
JOIN food, suborders, FoodToTypeMap, orders WHERE TypeId = typeoffood.Id AND Food.Id = suborders.FoodId AND Food.`Id` = foodtotypemap.FoodId AND OrdersId = orders.`Id` AND DATEDIFF(CURDATE(), TimeAndDate) = 0 AND OrdersStatus = 1 GROUP BY food.Id)

UNION

CREATE VIEW unusedstock
AS(
SELECT Food.`Id`, FoodName, typeoffood.Qty AS "Stock Remaining"
FROM food
JOIN typeoffood, FoodToTypeMap WHERE TypeId = typeoffood.Id AND Food.`Id` = foodtotypemap.FoodId AND Food.Id NOT IN(SELECT Food.`Id` FROM typeoffood JOIN food, suborders, FoodToTypeMap, orders WHERE TypeId = typeoffood.Id AND Food.Id = suborders.FoodId AND Food.`Id` = foodtotypemap.FoodId AND OrdersId = orders.`Id` AND DATEDIFF(CURDATE(), TimeAndDate) = 0 AND OrdersStatus = 1 GROUP BY food.Id) GROUP BY food.Id
)/*Dosen't  Work Whatever I do see to it future Bruh!!!!*/

SELECT * FROM usedstock
UNION
SELECT * FROM `unusedstock`;