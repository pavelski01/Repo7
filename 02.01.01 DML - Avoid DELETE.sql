-- Switch DB context
USE SampleDB
GO
-- Create a dummy table
CREATE TABLE Customers (
	CustomerName NVARCHAR(50) 
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
GO
-- Let's avoid deletes
CREATE TRIGGER trg_Prevent_Customer_Deletes
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting from the Customers table is not allowed.', 16, 1)
    ROLLBACK TRANSACTION
END
GO
-- Add a customer
INSERT INTO Customers VALUES ('Ben')
GO
-- Delete all customers
DELETE FROM Customers
GO 
-- Check result
SELECT * FROM Customers
GO
-- However...
TRUNCATE TABLE Customers
GO 
-- Check result
SELECT * FROM Customers