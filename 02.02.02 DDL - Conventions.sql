-- Switch DB context
USE SampleDB
GO
-- Create a dummy table
CREATE TABLE Dummy_varchar_1 (
	Dummy VARCHAR(50) 
)
GO
-- we want to avoid varchar columns
-- let's define another trigger
CREATE TRIGGER trg_Prevent_Varchar_Columns
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @TableName NVARCHAR(128) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)')
	DECLARE @ColumnName NVARCHAR(128)
    DECLARE ColumnCursor CURSOR FOR
    SELECT c.name FROM sys.columns c
    INNER JOIN sys.types t ON c.system_type_id = t.system_type_id
    WHERE object_id = OBJECT_ID(@TableName) AND t.name = 'varchar'

    OPEN ColumnCursor;
    FETCH NEXT FROM ColumnCursor INTO @ColumnName

    IF @@FETCH_STATUS = 0
    BEGIN
        RAISERROR ('Creation of VARCHAR columns not allowed.', 16, 1)
        ROLLBACK
    END;

    CLOSE ColumnCursor
    DEALLOCATE ColumnCursor
END
GO
-- try to create another dummy table
CREATE TABLE Dummy_varchar_2 (
	Dummy VARCHAR(50) 
)
GO
-- try to create another datatype
CREATE TABLE Dummy_nvarchar_1 (
	Dummy NVARCHAR(50) 
)
GO
-- Our original table still exists unchanged though:
SELECT c.name FROM sys.columns c
    INNER JOIN sys.types t ON c.system_type_id = t.system_type_id
    WHERE object_id = OBJECT_ID('Dummy_varchar_1') AND t.name = 'varchar'
GO
-- We can't alter it anymore though:
ALTER TABLE Dummy_varchar_1
	ADD Dummy_2 NVARCHAR(50)