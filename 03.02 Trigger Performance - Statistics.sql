-- Switch DB context
USE SampleDB
GO
-- Enable Statistics IO
SET STATISTICS IO ON
GO
-- Disable the trigger
DISABLE TRIGGER [trg_UpdateABC] ON Sales_Orders
GO
-- Insert another row into Sales_Orders
INSERT INTO Sales_Orders VALUES ('Customer_1',10000)
GO
-- Enable the trigger
ENABLE TRIGGER [trg_UpdateABC] ON Sales_Orders
GO
-- Insert another row into Sales_Orders
INSERT INTO Sales_Orders VALUES ('Customer_1',10000)