DROP VIEW IF EXISTS USEDSTOCK;
CREATE
    VIEW USEDSTOCK 
    AS
(
SELECT FOOD.`ID`, FOODNAME, SUM(FOODTOTYPEMAP.QTY) - SUM(SUBORDERS.QTY) AS "STOCK REMAINING"
FROM FOODTOTYPEMAP
JOIN FOOD, SUBORDERS, ORDERS WHERE FOOD.ID = SUBORDERS.`FOODID` AND FOOD.`ID` = FOODTOTYPEMAP.FOODID AND ORDERSID = ORDERS.`ID` AND DATEDIFF(CURDATE(), TIMEANDDATE) = 0 AND ORDERSSTATUS = 1 GROUP BY FOOD.ID);

-- UNION

DROP VIEW IF EXISTS UNUSEDSTOCK;
CREATE VIEW UNUSEDSTOCK
AS(
SELECT FOOD.`ID`, FOODNAME, SUM(FOODTOTYPEMAP.QTY) AS "STOCK REMAINING"
FROM FOOD
JOIN FOODTOTYPEMAP WHERE FOOD.`ID` = FOODTOTYPEMAP.FOODID AND FOOD.ID NOT IN(SELECT FOOD.`ID` FROM FOODTOTYPEMAP JOIN FOOD, SUBORDERS,  ORDERS WHERE FOOD.ID = SUBORDERS.FOODID AND FOOD.`ID` = FOODTOTYPEMAP.FOODID AND ORDERSID = ORDERS.`ID` AND DATEDIFF(CURDATE(), TIMEANDDATE) = 0 AND ORDERSSTATUS = 1 GROUP BY FOOD.ID) GROUP BY FOOD.ID) /*THE STOCKPILE REMAINS CODE*/;

SELECT * FROM USEDSTOCK
UNION
SELECT * FROM `UNUSEDSTOCK`;

