-- Switch DB context
USE SampleDB
GO
-- Remove old trigger
DROP TRIGGER trg_Archive_Customer_Deletes
GO
-- Let's notify on deletes
CREATE TRIGGER trg_Notify_Customer_Deletes
ON Customers
AFTER DELETE
AS
BEGIN
	Declare @Customer nvarchar(50)
	Declare @SubjectTXT nvarchar(500)
	SELECT @Customer=CustomerName FROM deleted
	SET @SubjectTXT = 'A customer (' + @Customer + ') has been deleted'
    EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Default',
    @recipients = 'sales@company.com',
    @subject = @SubjectTXT,
    @body = 'Customer has been deleted',
    @body_format = 'TEXT'
END
GO
-- Add a Customer
INSERT INTO Customers VALUES ('Ben')
GO
-- Delete all customers
DELETE FROM Customers
GO
-- Check result
SELECT recipients,subject
FROM msdb.dbo.sysmail_allitems
WHERE sent_date >= dateadd(second,-30,getdate())