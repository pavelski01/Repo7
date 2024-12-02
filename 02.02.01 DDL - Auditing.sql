-- Switch DB context
USE SampleDB
GO
-- Create a table to audit our DDL events to
CREATE TABLE DDL_Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(100),
    EventDDL NVARCHAR(MAX),
    EventDate DATETIME DEFAULT GETDATE()
)
GO
-- Create a dummy table
CREATE TABLE Dummy (
	Dummy NVARCHAR(50) 
)
GO
-- Drop it again
DROP TABLE Dummy
GO
-- Did this get logged?
SELECT * FROM DDL_Log
GO
-- Create a trigger - this sits on database level (programmability - database triggers)
CREATE TRIGGER trg_DDL_Log
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA()

    INSERT INTO DDL_Log (EventType, EventDDL)
    VALUES (@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
            @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'))
END
GO
-- Create a dummy table
CREATE TABLE Dummy (
	Dummy NVARCHAR(50) 
)
GO
-- Drop it again
DROP TABLE Dummy
GO
-- Did this get logged?
SELECT * FROM DDL_Log
GO