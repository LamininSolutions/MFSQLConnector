PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + 'tMFProcessBatch_UserMessage';
GO


SET NOCOUNT ON;
EXEC setup.spMFSQLObjectsControl @SchemaName = N'dbo',
                                 @ObjectName = N'tMFProcessBatch_UserMessage', -- nvarchar(100)
                                 @Object_Release = '4.1.5.42',                 -- varchar(50)
                                 @UpdateFlag = 2                               -- smallint
;
GO


/*
CHANGE HISTORY
--------------
2017-06-26	ACilliers	-	Expand the scope of when the trigger fires; adding Status and LogText
						-	Remove query that retrieves @ClassTable, as it is already taken care of in spMFInsertUserMessage
						-	Update call to spMFResultMessageForUI to read the message with carriage return instead of \n
2018-4-30	LC			add paramater for MFUserMessage enabled
2018
*/

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE type = 'TR'
          AND name = 'tMFProcessBatch_UserMessage'
)
BEGIN

    DROP TRIGGER dbo.tMFProcessBatch_UserMessage;
    PRINT SPACE(10) + '...Trigger dropped and recreated';
END;

GO


CREATE TRIGGER dbo.tMFProcessBatch_UserMessage
ON dbo.MFProcessBatch
FOR UPDATE, INSERT
--FOR UPDATE	
AS
/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2017-03
	Database: 
	Description: Create User Message in MFUserMessages table where LogType = Message
						
				 Executed when ever [LogType] is updated in [MFProcessBatch]
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  update MFProcessBatch set LogType = 'Message' where ProcessBatch_ID = 2
  select * from mfusermessages where processbatch_ID = 2
  
-----------------------------------------------------------------------------------------------*/
DECLARE @result INT,
        @LogType NVARCHAR(100),
        @LogStatus NVARCHAR(50),
        @LogText NVARCHAR(4000),
        @ProcessBatch_ID INT,
        @ClassTable NVARCHAR(100),
        @UserMessageEnabled INT,
		@TranCount int

		BEGIN TRY
        

--IF (UPDATE(LogType) OR UPDATE(Status) OR UPDATE(LogText))

--SELECT @TranCount = @@TranCount


--IF @TranCount > 0
--COMMIT;

IF (UPDATE(LogType) OR UPDATE([Status]))
BEGIN

    SELECT @LogType = Inserted.LogType,
           @LogStatus = Inserted.[Status],
           @ProcessBatch_ID = Inserted.ProcessBatch_ID
    FROM inserted;

    SELECT @UserMessageEnabled = CAST(Value AS INT)
    FROM dbo.MFSettings
    WHERE source_key = 'MF_Default'
          AND Name = 'MFUserMessagesEnabled';

    IF @UserMessageEnabled = 1 AND @LogType = 'Message' AND (@logstatus LIKE 'Complete%' OR @LogStatus LIKE 'Error%' OR @LogStatus LIKE 'Fail%')

    BEGIN
--        IF (
--               @LogType = 'Message'
--               AND
--               (
--                   @LogStatus LIKE 'Complete%'
--                   OR @LogStatus LIKE '%Error%'
--                   OR @LogStatus LIKE '%Fail%'
--               )
--           )
--*/


	--	SELECT ''

            EXEC @result = dbo.spMFInsertUserMessage @ProcessBatch_ID, @UserMessageEnabled;

    END;

	END

	END TRY
    BEGIN CATCH
    ROLLBACK TRAN	
	END CATCH
    

GO
