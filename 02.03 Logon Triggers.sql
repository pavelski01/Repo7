-- Switch DB context - this can happen in ANY database as we're acting on Instance Level
USE master
GO
-- Create a login
CREATE LOGIN testuser WITH PASSWORD = 'P@ssw0rd'
GO
-- Connect to the Instance using that user
-- Let's deny all logons for this user after 9AM
-- This happens on the Instance level (Server objects)
CREATE TRIGGER trg_DenyLogin_testuser_After9AM
ON ALL SERVER
FOR LOGON
AS
BEGIN
    IF (ORIGINAL_LOGIN()= 'testuser' AND DATEPART(HOUR, GETDATE()) >= 9)
    BEGIN
        RAISERROR ('Login denied for user testuser after 9 AM.', 16, 1)
        ROLLBACK
    END
END
GO
-- Check the time
SELECT DATEPART(HOUR, GETDATE()) 
GO
-- Disconnect with that user and try to re-connect
-- Disable the trigger
DISABLE TRIGGER trg_DenyLogin_testuser_After9AM ON ALL SERVER
-- Try to reconnect again