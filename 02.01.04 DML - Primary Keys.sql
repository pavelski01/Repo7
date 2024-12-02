-- Switch context
USE [SampleDB]
GO
-- Create a simple table
CREATE TABLE UniqueItems (
	ItemID NVARCHAR(50) NOT NULL
)
GO
-- Insert a record
INSERT INTO UniqueItems (ItemID)
SELECT 'Item_1'
GO
-- Insert it again
INSERT INTO UniqueItems (ItemID)
SELECT 'Item_1'
GO
-- We have a duplicate
SELECT * FROM UniqueItems
GO
-- Cleanup
TRUNCATE TABLE UniqueItems
GO
-- Prevent this through a trigger
CREATE TRIGGER PreventDuplicateInsert
ON UniqueItems
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT i.ItemID FROM inserted AS i INNER JOIN UniqueItems AS t ON i.ItemID = t.ItemID GROUP BY i.ItemID having Count(*) > 1)
    BEGIN
        RAISERROR ('Cannot insert duplicate record.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO
-- Insert a record
INSERT INTO UniqueItems (ItemID)
SELECT 'Item_1'
GO
-- Try to insert it again
INSERT INTO UniqueItems (ItemID)
SELECT 'Item_1'
GO
-- Remove the trigger
DROP TRIGGER PreventDuplicateInsert
GO
-- Make the ItemId the primary key
ALTER TABLE UniqueItems
ADD CONSTRAINT PK_UniqueItems_ItemId PRIMARY KEY (ItemId)
GO
-- Try to insert the item again
INSERT INTO UniqueItems (ItemID)
SELECT 'Item_1'
