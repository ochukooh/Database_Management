CREATE DATABASE Lucky_Shrub
USE Lucky_Shrub;
CREATE TABLE Products (ProductID VARCHAR(10), ProductName VARCHAR(100),BuyPrice DECIMAL(6,2), SellPrice DECIMAL(6,2), NumberOfItems INT);
INSERT INTO Products (ProductID, ProductName, BuyPrice, SellPrice, NumberOfITems)

VALUES ("P1", "Artificial grass bags ", 40, 50, 100),  
("P2", "Wood panels", 15, 20, 250),  
("P3", "Patio slates",35, 40, 60),  
("P4", "Sycamore trees ", 7, 10, 50),  
("P5", "Trees and Shrubs", 35, 50, 75),  
("P6", "Water fountain", 65, 80, 15);
CREATE TABLE Notifications (NotificationID INT AUTO_INCREMENT, Notification VARCHAR(255), DateTime TIMESTAMP NOT NULL, PRIMARY KEY(NotificationID));

--an insert trigger to check the sellprice when a new product is added to the product table and then insert into a notification table
DELIMITER //

CREATE TRIGGER ProductSellPriceInsertCheck 
    AFTER INSERT  
    ON Products FOR EACH ROW  
	BEGIN
	IF NEW.SellPrice <= NEW.BuyPrice THEN
		INSERT INTO Notifications(Notification,DateTime) 
		VALUES(CONCAT('A SellPrice same or less than the BuyPrice was inserted for ProductID ', NEW.ProductID), NOW()); 
    END IF;
	END //

DELIMITER ;

--an update trigger to check if the product sellprice is not less than buyprice for accuracy
DELIMITER //

CREATE TRIGGER ProductSellPriceUpdateCheck 
    AFTER UPDATE  
    ON Products FOR EACH ROW  
	BEGIN
	IF NEW.SellPrice <= NEW.BuyPrice THEN
		INSERT INTO Notifications(Notification,DateTime) 
		VALUES(CONCAT(NEW.ProductID,' was updated with a SellPrice of ', NEW.SellPrice,' which is the same or less than the BuyPrice'), NOW()); 
    END IF;
	END //

DELIMITER ;

--a delete trigger after a product has been deleted from the product table as indicated in the notification table
DELIMITER //

CREATE TRIGGER NotifyProductDelete 
    AFTER DELETE   
    ON Products FOR EACH ROW   
	INSERT INTO Notifications(Notification, DateTime) 
    VALUES(CONCAT('The product with a ProductID ', OLD.ProductID,' was deleted'), NOW()); 
END //
DELIMITER ;
