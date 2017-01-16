DROP VIEW StockPile;
CREATE
    VIEW StockPile 
    AS
(SELECT Food.Id, FoodName, typeoffood.Qty - SUM(suborders.Qty)
FROM food
JOIN typeoffood, suborders, FoodToTypeMap, orders WHERE TypeId = typeoffood.Id AND foodtotypemap.FoodId = suborders.FoodId AND Food.`Id` = foodtotypemap.FoodId AND OrdersId = orders.`Id` AND DATEDIFF(CURDATE(), TimeAndDate) = 0 AND OrdersStatus = 1 GROUP BY Id)