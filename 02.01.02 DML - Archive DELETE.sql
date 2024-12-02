-- Switch DB context
USE SampleDB
GO
-- Create an archive table
CREATE TABLE Customers_Archive (
	CustomerName NVARCHAR(50),
	DeleteDate Datetime
)
GO
-- Add a customer
INSERT INTO Customers VALUES ('Ben')
GO
-- Delete all customers
DELETE FROM Customers
GO 
-- Check result
SELECT * FROM Customers
SELECT * FROM Customers_Archive
GO
-- Remove old trigger
-- Also notice that the trigger object/name isn't linked to the table!
DROP TRIGGER trg_Prevent_Customer_Deletes
GO
-- Let's avoid deletes
CREATE TRIGGER trg_Archive_Customer_Deletes
ON Customers
AFTER DELETE
AS
BEGIN
    INSERT INTO Customers_Archive
	SELECT CustomerName,GetDate() FROM deleted
END
GO
-- Check result
SELECT * FROM Customers
SELECT * FROM Customers_Archive
GO
-- Delete all customers
DELETE FROM Customers
GO
-- Check result
SELECT * FROM Customers
SELECT * FROM Customers_Archive
GO
-- However...
INSERT INTO Customers VALUES ('Ben 2')
GO
TRUNCATE TABLE Customers
GO 
-- Check result
SELECT * FROM Customers
SELECT * FROM Customers_Archive