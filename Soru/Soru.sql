DROP TABLE IF EXISTS TypeOfFood;
CREATE TABLE TypeOfFood(
	TypeId TINYINT PRIMARY KEY,
	SessionName VARCHAR(20) NOT NULL,
	SessionStart TIME NOT NULL,
	SessionEnd TIME NOT NULL,
	Qty INT NOT NULL, CHECK (Qty BETWEEN 75 AND 200),
	CHECK (SessionStart <= DATE_SUB(SessionEnd, INTERVAL 1 HOUR))
);
INSERT INTO TypeOfFood VALUES(1,"Breakfast", '08:00', '11:00', 100), (2,"Lunch", '11:15', '15:00', 75), (3,'Refreshment', '15:15', '23:00', 100), (4,'Dinner', '07:00', '23:00', 200);


DROP TABLE IF EXISTS Food;
CREATE TABLE Food(
	FoodId TINYINT PRIMARY KEY,
	TypeId TINYINT NOT NULL,
	Food VARCHAR(20) NOT NULL,
	Price INT NOT NULL,
	CONSTRAINT k_type FOREIGN KEY (TypeId) REFERENCES TypeOfFood(TypeId)
);
INSERT INTO Food VALUES(1, 1, 'Idly', 15), (2, 1, 'Vada', 5), (3, 1, 'Dosa', 20), (4, 1, 'Poori', 20), (5, 1, 'Pongal', 15), (6, 3, 'Coffee', 10),
 (7, 3, 'Tea', 5), (8, 2, 'South Indian Meals', 25), (9, 2, 'North Indian Thali', 40), (10, 2, 'Variety Rice', 25), (11, 3, 'Snacks', 20),
 (12, 4, 'Fried rice', 40), (13, 4, 'Chapatti', 20), (14, 4, 'Chat Items', 20), (15, 1, 'Coffee', 10), (16, 1, 'Tea', 5);
 
INSERT INTO Food VALUES (15, 1, 'Coffee', 10), (16, 1, 'Tea', 5);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	FoodId TINYINT NOT NULL,
	Qty TINYINT NOT NULL,
	Seat INT NOT NULL,
	Time_Stamp TIMESTAMP,
	CONSTRAINT k_order FOREIGN KEY (FoodId) REFERENCES Food(FoodId)
);

DROP TABLE IF EXISTS SubOrders;
CREATE TABLE SubOrders(
	Id SERIAL,
	OrderId INT,
	FoodId TINYINT NOT NULL,
	Qty TINYINT NOT NULL,
	CONSTRAINT Meshi_SubOrder_fk FOREIGN KEY (OrderId) REFERENCES Orders(Id)
);


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
DROP TABLE IF EXISTS Seat;
CREATE TABLE Seat(
	id SERIAL,
	StatusId TINYINT DEFAULT 1,
	CONSTRAINT Meshi_Seat_StatusId_fk FOREIGN KEY (StatusId) REFERENCES SeatStatus(Id)
);
INSERT INTO Seat (id) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);