-- Switch DB context
USE SampleDB
GO
-- Create another small table
CREATE TABLE PerfTest (
	Dummy NVARCHAR(50) 
)
GO
-- Insert some data
INSERT INTO PerfTest VALUES ('Test')
GO
-- INSERT was fast and worked:
SELECT * FROM PerfTest
GO
-- Now we'll add a DML trigger for INSERT operations that just waits for 3 seconds to simulate a workload
CREATE TRIGGER trg_PerfTest
ON dbo.PerfTest
AFTER INSERT
AS
BEGIN
	DECLARE @EndTime DATETIME = DATEADD(SECOND, 3, GETDATE())
	WHILE GETDATE() < @EndTime
	BEGIN
		SET @EndTime = @EndTime
	END
END
GO
-- Check the execution plan!
-- INSERT works but takes 3 seconds
INSERT INTO PerfTest VALUES ('Test')
GO
-- Other operations are not affected though
UPDATE PerfTest SET Dummy = Dummy