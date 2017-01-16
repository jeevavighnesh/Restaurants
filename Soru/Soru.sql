DROP TABLE IF EXISTS Configuration;
CREATE TABLE Configuration(
	Id SERIAL,
	ItemLimit TINYINT NOT NULL,
	NumberOfSeats TINYINT NOT NULL
);
INSERT INTO Configuration (ItemLimit, NumberOfSeats) VALUES (5,10);

DROP TABLE IF EXISTS SeatStatus;
CREATE TABLE SeatStatus(
	Id TINYINT AUTO_INCREMENT PRIMARY KEY,
	SeatStatus VARCHAR(10)
);
INSERT INTO SeatStatus (SeatStatus) VALUES ('Available'), ('Taken');

DROP TABLE IF EXISTS OrdersStatus;
CREATE TABLE OrdersStatus(
	Id TINYINT AUTO_INCREMENT PRIMARY KEY,
	OrdersStatus VARCHAR(10)
);
INSERT INTO OrdersStatus (OrdersStatus) VALUES ('Ordered'), ('Cancelled');

DROP TABLE IF EXISTS Seat;
CREATE TABLE Seat(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	StatusId TINYINT DEFAULT 1,
	CONSTRAINT Meshi_Seat_StatusId_fk FOREIGN KEY (StatusId) REFERENCES SeatStatus(Id)
);
INSERT INTO Seat (id) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);


DROP TABLE IF EXISTS TypeOfFood;
CREATE TABLE TypeOfFood(
	Id TINYINT PRIMARY KEY,
	SessionName VARCHAR(20) NOT NULL,
	SessionStart TIME NOT NULL,
	SessionEnd TIME NOT NULL,
	Qty INT NOT NULL, CHECK (Qty BETWEEN 75 AND 200),
	CHECK (SessionStart <= DATE_SUB(SessionEnd, INTERVAL 1 HOUR))
);
INSERT INTO TypeOfFood VALUES
(1,"Breakfast", '08:00', '11:00', 100), 
(2,"Lunch", '11:15', '15:00', 75), 
(3,'Refreshment', '15:15', '23:00', 100), 
(4,'Dinner', '07:00', '23:00', 200);

DROP TABLE IF EXISTS Food;
CREATE TABLE Food(
	Id TINYINT PRIMARY KEY,
	FoodName VARCHAR(20) NOT NULL,
	Price INT NOT NULL
);
INSERT INTO Food VALUES
(1, 'Idly', 15), 
(2, 'Vada', 5), 
(3, 'Dosa', 20), 
(4, 'Poori', 20), 
(5, 'Pongal', 15), 
(6, 'South Indian Meals', 25), 
(7, 'North Indian Thali', 40), 
(8, 'Variety Rice', 25),
(9, 'Coffee', 10), 
(10, 'Tea', 5), 
(11, 'Snacks', 20),
(12, 'Fried rice', 40), 
(13, 'Chapatti', 20), 
(14, 'Chat Items', 20);
 
DROP TABLE IF EXISTS FoodToTypeMap;
CREATE TABLE FoodToTypeMap(
	Id TINYINT PRIMARY KEY,
	FoodId TINYINT NOT NULL,
	TypeId TINYINT NOT NULL,
	CONSTRAINT k_foodtotype_typeid FOREIGN KEY (TypeId) REFERENCES TypeOfFood(Id),
	CONSTRAINT k_foodtotype_foodid FOREIGN KEY (FoodId) REFERENCES Food(Id)
); 
INSERT INTO FoodToTypeMap VALUES
(1,1,1),
(2,2,1),
(3,3,1),
(4,4,1),
(5,5,1),
(6,9,1),
(7,10,1),
(8,6,2),
(9,7,2),
(10,8,2),
(11,9,3), -- also in breakfast
(12,10,3), -- also in breakfast
(13,11,3),
(14,12,4),
(15,13,4),
(16,14,4);

 
DROP TABLE IF EXISTS InputOrders;
CREATE TABLE InputOrders(
	Id SERIAL,
	Food VARCHAR(20) NOT NULL,
	Qty TINYINT NOT NULL
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	NoOfItems TINYINT NOT NULL,
	SeatId INT NOT NULL,
	OrdersStatus TINYINT NOT NULL,
	TimeAndDate TIMESTAMP,
	CONSTRAINT k_orders_seatid FOREIGN KEY (SeatId) REFERENCES Seat(Id),
	CONSTRAINT k_orders_ordersststus FOREIGN KEY (OrdersStatus) REFERENCES OrdersStatus(Id)
);

DROP TABLE IF EXISTS SubOrders;
CREATE TABLE SubOrders(
	Id SERIAL,
	OrdersId INT NOT NULL,
	FoodId TINYINT NOT NULL,
	Qty TINYINT NOT NULL,
	CONSTRAINT k_sub_orders_order_id FOREIGN KEY (OrdersId) REFERENCES Orders(Id),
	CONSTRAINT k_sub_orders_food_id FOREIGN KEY (FoodId) REFERENCES Food(Id)
);

