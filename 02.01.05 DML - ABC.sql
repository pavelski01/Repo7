-- Switch DB context
USE SampleDB
GO
-- Create a Customer and an Order table
CREATE TABLE Sales_Customers (
	Customer NVARCHAR(50),
	TotalRevenue FLOAT,
	ABC NVARCHAR(1)
)
GO
CREATE TABLE Sales_Orders (
	Customer NVARCHAR(50),
	Revenue FLOAT
)
GO
-- Create a customer
INSERT INTO Sales_Customers VALUES ('Customer_1','0','C')
GO
-- It has no revenue
SELECT * FROM Sales_Customers
GO
-- Create a trigger on the order table
CREATE TRIGGER trg_UpdateABC
ON dbo.Sales_Orders
AFTER INSERT
AS
BEGIN
	DECLARE @TotalRevenue float
	SELECT @TotalRevenue=SUM(Revenue) FROM Sales_Orders WHERE Customer in (Select Customer from inserted)
    UPDATE dbo.Sales_Customers SET TotalRevenue = @TotalRevenue WHERE Customer in (Select Customer from inserted)
    UPDATE dbo.Sales_Customers SET ABC = 
		CASE WHEN TotalRevenue > 10000 THEN 'A' 
			 WHEN TotalRevenue > 5000 THEN 'B' 
			 ELSE 'C' END
		WHERE Customer in (Select Customer from inserted)
END
GO
-- Nothing has happened
SELECT * FROM Sales_Customers
GO
-- Add an order
INSERT INTO Sales_Orders VALUES ('Customer_1',500)
GO
-- Revenue is showing
SELECT * FROM Sales_Customers
GO
-- Let's make this less noisy
ALTER TRIGGER trg_UpdateABC
ON dbo.Sales_Orders
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @TotalRevenue float
	SELECT @TotalRevenue=SUM(Revenue) FROM Sales_Orders WHERE Customer in (Select Customer from inserted)
    UPDATE dbo.Sales_Customers SET TotalRevenue = @TotalRevenue WHERE Customer in (Select Customer from inserted)
    UPDATE dbo.Sales_Customers SET ABC = 
		CASE WHEN TotalRevenue > 10000 THEN 'A' 
			 WHEN TotalRevenue > 5000 THEN 'B' 
			 ELSE 'C' END
		WHERE Customer in (Select Customer from inserted)
END
GO
-- Add another order
INSERT INTO Sales_Orders VALUES ('Customer_1',1500)
GO
-- Revenue gets updated, so does the ABC class
SELECT * FROM Sales_Customers
GO
-- This could be two triggers!
ALTER TRIGGER trg_UpdateABC
ON dbo.Sales_Orders
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @TotalRevenue float
	SELECT @TotalRevenue=SUM(Revenue) FROM Sales_Orders WHERE Customer in (Select Customer from inserted)
    UPDATE dbo.Sales_Customers SET TotalRevenue = @TotalRevenue WHERE Customer in (Select Customer from inserted)
END
GO
CREATE TRIGGER trg_UpdateCustABC
ON dbo.Sales_Customers
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON
    UPDATE dbo.Sales_Customers SET ABC = 
		CASE WHEN TotalRevenue > 10000 THEN 'A' 
			 WHEN TotalRevenue > 5000 THEN 'B' 
			 ELSE 'C' END
		WHERE Customer in (Select Customer from inserted)
END
GO
-- Add another order
INSERT INTO Sales_Orders VALUES ('Customer_1',10000)
GO
-- Revenue gets updated, so does the ABC class
-- This requires nested triggers - enabled by default
SELECT * FROM Sales_Customers
GO
-- But we can also just update the Customer
UPDATE Sales_Customers SET TotalRevenue = 0
GO
-- Revenue gets updated, so does the ABC class
SELECT * FROM Sales_Customers