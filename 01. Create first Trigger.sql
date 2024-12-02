-- Create the SampleDB Database
CREATE DATABASE [SampleDB]
GO
-- Switch context
USE [SampleDB]
GO
-- Create a simple table
CREATE TABLE Items (
	ItemID NVARCHAR(50) NOT NULL,
	Color NVARCHAR(50) NOT NULL,
	LastUpdate DATETIME
)
GO
-- Make the ItemId the primary key
ALTER TABLE Items
ADD CONSTRAINT PK_Items_ItemId PRIMARY KEY (ItemId)
GO
-- Insert some data
INSERT INTO Items (ItemID,Color)
SELECT 'Item_1','Green'
GO
INSERT INTO Items (ItemID,Color)
SELECT 'Item_2','Blue'
GO
-- Data is there but our LastUpdate is null
SELECT * FROM Items
GO
-- Let's define an INSERT/UPDATE DML trigger
-- This could also be done from the GUI (defined on the table level)
CREATE TRIGGER trg_SetLastUpdate
ON dbo.Items
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE dbo.Items
    SET LastUpdate = GETDATE()
    FROM inserted
    WHERE dbo.Items.ItemID = inserted.ItemID
END
GO
-- Insert more data
INSERT INTO Items (ItemID,Color)
SELECT 'Item_3','Red'
GO
-- Our trigger worked
SELECT * FROM Items
GO
-- Lets fire the trigger for the other rows
UPDATE Items set Color=Color WHERE LastUpdate IS NULL
GO
-- It worked!
SELECT * FROM Items