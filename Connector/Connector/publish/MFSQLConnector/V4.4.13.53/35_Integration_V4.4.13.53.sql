USE {varAppDB}

GO




/*
THIS SCRIPT HAS BEEN PREPARE TO ALLOW FOR THE AUTOMATION OF ALL THE INSTALLATION VARIABLES

2018-2-14

{varAppDB}
*/



GO
/*rST**************************************************************************

==================
MFEventLog_OpenXML
==================

Columns
=======

Id int (primarykey, not null)
  SQL primary key
XMLData xml
  Event log data
LoadedDateTime datetime
  Time of saving event log

Additional Info
===============

The event log is XML format in the MFEventLog_OpenXML table by executing the spMFGetMFilesLog procedure.

Used By
=======

- spMFGetMfilesLog


Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-07  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[MFEventLog_OpenXML]';

GO


SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFEventLog_OpenXML', -- nvarchar(100)
    @Object_Release = '2.0.2.0', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO
/*------------------------------------------------------------------------------------------------
	Author: DEvTeam2, Laminin Solutions
	Create date: 2017-01
	Database: 
	Description: MFiles Event Log
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	YYYY-MM-DD		{Author}	{Comment}
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  Select * from MFEventLog_OpenXML
  
-----------------------------------------------------------------------------------------------*/


GO


IF NOT EXISTS ( SELECT  name
                FROM    sys.tables
                WHERE   name = 'MFEventLog_OpenXML'
                        AND SCHEMA_NAME(schema_id) = 'dbo' )
    BEGIN
        CREATE TABLE MFEventLog_OpenXML
		(
		Id INT IDENTITY PRIMARY KEY,
		XMLData XML,
		LoadedDateTime DATETIME
		)

--	DROP TABLE MFilesEvents
CREATE table MFilesEvents ( ID           INT
,                         [Type]       NVARCHAR(100)
,                         [Category]   NVARCHAR(100)
,                         [TimeStamp]  NVARCHAR(100)
,                         CausedByUser NVARCHAR(100)
,                         loaddate     DATETIME
,                         Events       xml )

        PRINT SPACE(10) + '... Table: created';
    END;
ELSE
    PRINT SPACE(10) + '... Table: exists';

/*rST**************************************************************************

==============
MFUserMessages
==============

Columns
=======

ID int (primarykey, not null)
  SQL Primary Key
GUID nvarchar(100)
  fixme description
MX\_User\_ID uniqueidentifier
  fixme description
Class nvarchar(100)
  fixme description
Class\_ID int (not null)
  fixme description
Created datetime
  fixme description
Created\_by nvarchar(100)
  fixme description
Created\_by\_ID int
  fixme description
MF\_Last\_Modified datetime
  fixme description
MF\_Last\_Modified\_by nvarchar(100)
  fixme description
MF\_Last\_Modified\_by\_ID int
  fixme description
Mfsql\_Class\_Table nvarchar(100)
  fixme description
Mfsql\_Count int
  fixme description
Mfsql\_Message nvarchar(4000)
  fixme description
Mfsql\_Process\_Batch int
  fixme description
Mfsql\_User nvarchar(100)
  fixme description
Mfsql\_User\_ID int
  fixme description
Name\_Or\_Title nvarchar(100)
  fixme description
Single\_File bit (not null)
  fixme description
Workflow nvarchar(100)
  fixme description
Workflow\_ID int
  fixme description
State nvarchar(100)
  fixme description
State\_ID int
  fixme description
LastModified datetime
  fixme description
Process\_ID int
  fixme description
ObjID int
  fixme description
ExternalID nvarchar(100)
  fixme description
MFVersion int
  fixme description
FileCount int
  fixme description
Deleted bit
  fixme description
Update\_ID int
  fixme description

Additional Info
===============

Contains messages emanating from the MFProcessBatch Table intended for user consumption.

Used By
=======

- spMFInsertUserMessage


Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-07  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[MFUserMessages]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFUserMessages', -- nvarchar(100)
    @Object_Release = '3.1.2.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO
/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2017-03
	Database: 
	Description: Table for user messages 
	Used to set store the user messages generated by the MFProcessBatch Table
	

 
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	2017-06-26		Arnie		-	Change field size for Message to NVARCHAR(4000)
		
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  Select * from [dbo].[MFUserMessages]

   DROP TABLE MFUserMessages 
-----------------------------------------------------------------------------------------------*/
GO
IF NOT EXISTS (	  SELECT [name]
				  FROM	 [sys].[tables]
				  WHERE	 [name] = 'MFUserMessages'
						 AND SCHEMA_NAME([schema_id]) = 'dbo'
			  )
	BEGIN


		CREATE TABLE [dbo].[MFUserMessages]
			(
				[ID] [INT] IDENTITY(1, 1) NOT NULL
			  , [ProcessBatch_ID] INT NULL
			  , [ClassTable] NVARCHAR(100)
			  , [OriginatingUser_ID] INT NULL
			  , [ItemCount] INT NULL
			  , [Created_on] DATETIME
					DEFAULT GETDATE() NOT NULL
			  , [Message] [NVARCHAR](4000) NULL
			)

        PRINT SPACE(10) + '... Table: created';
    END;
ELSE
    PRINT SPACE(10) + '... Table: exists';

GO
IF EXISTS(SELECT 1 FROM [INFORMATION_SCHEMA].[COLUMNS] 
		WHERE [TABLE_NAME] = 'MFUserMessages'
		AND [COLUMN_NAME] = 'Message'
		AND [CHARACTER_MAXIMUM_LENGTH] <> 4000
		)
BEGIN
	ALTER TABLE [dbo].[MFUserMessages] ALTER COLUMN [Message] NVARCHAR(4000)
	PRINT SPACE(10) + '... Column Message: updated column length to NVARCHAR(4000)';
END

GO
/*rST**************************************************************************

============
MFPublicLink
============

Columns
=======

Id int (primarykey, not null)
  SQL Primary Key
ObjectID int
  - ObjID column of the Record
  - Use the combination of objid and class_ID to join this record to the class table
ClassID int
  Class_ID of the Record
ExpiryDate datetime
  Expiredate used in Access Key
AccessKey nvarchar(4000)
  Unique key generated by M-Files using the Assembly
Link nvarchar(4000)
  Constructed link
HtmlLink nvarchar(4000)
  HTML constructed link to be used in emails. The name of the document is used as the friendly name of the link
DateCreated datetime
  Date item was created
DateModified datetime
  Date item was last udated

Used By
=======

- spMFCreatePublicSharedLink


Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-07  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

go


PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[MFPublicLink]';

GO


SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFPublicLink', -- nvarchar(100)
    @Object_Release = '3.1.1.34', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO
/*------------------------------------------------------------------------------------------------
	Author: DevTeam2, Laminin Solutions
	Create date: 2016-02
	Database: 
	Description: MFiles Public Share Link
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	YYYY-MM-DD		{Author}	{Comment}
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  Select * from MFPublicLink
  
-----------------------------------------------------------------------------------------------*/


GO


IF NOT EXISTS ( SELECT  name
                FROM    sys.tables
                WHERE   name = 'MFPublicLink'
                        AND SCHEMA_NAME(schema_id) = 'dbo' )
    BEGIN
        
		CREATE TABLE [dbo].[MFPublicLink]
		(
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[ObjectID] [int] NULL,
			[ClassID] [int] NULL,
			[ExpiryDate] [datetime] NULL,
			[AccessKey] [nvarchar](4000) NULL,
			[Link] [nvarchar](4000) NULL,
			[HtmlLink] [nvarchar](4000) NULL,
			[DateCreated] [datetime] NULL,
			[DateModified] [datetime] NULL,
		PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]



        PRINT SPACE(10) + '... Table: created';
    END;
ELSE
    PRINT SPACE(10) + '... Table: exists';
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
SET NOCOUNT ON;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[fnMFObjectHyperlink]';
PRINT SPACE(10) + '...Function: Create'
GO

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'fnMFObjectHyperlink', -- nvarchar(100)
    @Object_Release = '4.3.09.48', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

/*
MODIFICATIONS

*/

IF EXISTS ( SELECT  1
            FROM    information_schema.[ROUTINES]
            WHERE   [ROUTINES].[ROUTINE_NAME] = 'fnMFObjectHyperlink'--name of procedire
                    AND [ROUTINES].[ROUTINE_TYPE] = 'FUNCTION'
                    AND [ROUTINES].[ROUTINE_SCHEMA] = 'dbo' )
BEGIN					
	DROP FUNCTION [dbo].[fnMFObjectHyperlink]
END	
GO

CREATE FUNCTION fnMFObjectHyperlink (
    --Add the parameters for the function here
	@MFTableName NVARCHAR(100)
	,@MFObject_MFID INT	
	,@ObjectGUID	   NVARCHAR(50)
	,@HyperLinkType INT = 1 --1 = Desktop show, 2 = Web App  ,  3 = mobile, 4 = desktop open
	)
RETURNS NVARCHAR(250)
AS
/*rST**************************************************************************

===================
fnMFObjectHyperlink
===================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(100)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @MFObject\_MFID int
    fixme description
  @ObjectGUID nvarchar(50)
    fixme description
  @HyperLinkType int
    fixme description


Purpose
=======

M-Files Object Hyperlink

Examples
========

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-05-15  LC         Update options available
2017-09-05  LC         UPDATE BUG IN URL
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
	/*-------------------------------
    Declare the return variable here
    -------------------------------*/
	DECLARE @VaultGUID	   NVARCHAR(50)
		,@ServerURL	   NVARCHAR(200)
		,@ObjectType	   INT			
		,@Hyperlink	   NVARCHAR(250)
		,@SelectQuery	   NVARCHAR(200)
		,@ParmDefinition  NVARCHAR(500);
    
     --SELECT VAULT GUID
	SELECT @VaultGUID = CAST(value AS NVARCHAR(50))
	FROM [MFSettings] AS [s]
	WHERE NAME = 'VaultGUID' AND [s].[source_key] = 'MF_Default'

	 DECLARE @expres AS VARCHAR(50) = '%[{,}]%'

      WHILE Patindex(@expres, @VaultGUID) > 0
        SET @VaultGUID = Replace(@VaultGUID, Substring(@VaultGUID, Patindex(@expres, @VaultGUID), 1), '')

	--SELECT SERVER URL
	SELECT @ServerURL = CAST(value AS NVARCHAR(250))
	FROM [MFSettings] AS [s]
	WHERE NAME = 'ServerURL' AND [s].[source_key] = 'MF_Default'

	--SELECT OBJECT GUID
	--SELECT @ParmDefinition = N'@retvalOUT NVARCHAR(100) OUTPUT';
	--SELECT @SelectQuery = 'SELECT @retvalOUT = GUID FROM ['+@MFTableName+'] WHERE ObjID = '+CAST(@MFObject_MFID AS NVARCHAR(20))+''
	--EXEC Sp_executesql
	--     @SelectQuery
     --     ,@ParmDefinition
	--     ,@retvalOUT = @ObjectGUID OUTPUT;

	/*------------------------------------------------------------------------------------------------------------
    m-files://show/9C2A4835-6C05-4503-8B46-0BCFD78A021E/287-411?object=BE1C9AB2-0BCE-46A0-987F-A0CB03185F17
    https://mfiles.com/Default.aspx?#CE7643CB-C9BB-4536-8187-707DB78EAF2A/object/0/513/latest
    ------------------------------------------------------------------------------------------------------------*/
	/*
	public link
	https://cloud.lamininsolutions.com/SharedLinks.aspx?accesskey=d13c4b71ebd80911ce09310d2cfd429456c420993f8d5289d4da1c5f2fd61e9b&VaultGUID=312E44F6-AE4B-4F5E-8784-9527260A5743
	https://cloud.lamininsolutions.com/SharedLinks.aspx?accesskey=ec02f6e0be6b00b4a4180a736472324042811bb852d312815940a600a23d2240&VaultGUID=312E44F6-AE4B-4F5E-8784-9527260A5743


	*/

	--SELECTING OBJECTTYPE ID
	SELECT @ObjectType = mot.mfid
	FROM [MFClass] AS [mc]
	INNER JOIN [MFObjectType] AS [mot] ON [mot].[ID] = [mc].[MFObjectType_ID]
	WHERE [mc].[TableName] = @MFTableName;

      WHILE Patindex(@expres, @ObjectGUID) > 0
        SET @ObjectGUID = Replace(@ObjectGUID, Substring(@ObjectGUID, Patindex(@expres, @ObjectGUID), 1), '')

	--CREATING HYPERLINK 
	SELECT @Hyperlink = CASE 
			WHEN @HyperLinkType = 1
				THEN 'm-files://show/' + @VaultGUID + '/' + CAST(@ObjectType AS VARCHAR(5)) + '-' + CAST(@MFObject_MFID AS VARCHAR(20)) + '?object=' + @ObjectGUID
			WHEN @HyperLinkType = 2
				THEN @ServerURL + '/Default.aspx?#' + @VaultGUID + '/object/' + CAST(@ObjectType AS VARCHAR(5)) + '/' + CAST(@MFObject_MFID AS VARCHAR(20)) + '/latest'
			WHEN @HyperLinkType = 3
				THEN 'm-files://view/' + @VaultGUID + '/' + CAST(@ObjectType AS VARCHAR(5)) + '-' + CAST(@MFObject_MFID AS VARCHAR(20)) + '?object=' + @ObjectGUID
			WHEN @HyperLinkType = 4
				THEN 'm-files://open/' + @VaultGUID + '/' + CAST(@ObjectType AS VARCHAR(5)) + '-' + CAST(@MFObject_MFID AS VARCHAR(20)) + '?object=' + @ObjectGUID
			WHEN @HyperLinkType = 5
				THEN 'm-files://showmetadata/' + @VaultGUID + '/' + CAST(@ObjectType AS VARCHAR(5)) + '-' + CAST(@MFObject_MFID AS VARCHAR(20)) + '?object=' + @ObjectGUID
			WHEN @HyperLinkType = 6
				THEN 'm-files://edit/' + @VaultGUID + '/' + CAST(@ObjectType AS VARCHAR(5)) + '-' + CAST(@MFObject_MFID AS VARCHAR(20)) + '?object=' + @ObjectGUID
			END;
	
	RETURN @Hyperlink;
END;
go



GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[MFvwVaultSettings]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwVaultSettings', -- nvarchar(100)
    @Object_Release = '3.1.2.37', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwVaultSettings'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW dbo.MFvwVaultSettings
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
/*
-- ============================================= 
-- Author: leRoux Cilliers, Laminin Solutions
-- Create date: 2016-5

-- Description:	Summary of AuditHistory by Flag and Class
-- Revision History:  
-- YYYYMMDD Author - Description 
-- =============================================
MODIFICATIONS
2017-06-21	LC	Change Name
*/		
ALTER VIEW dbo.MFvwVaultSettings
AS

/*************************************************************************
STEP view all vault settings
NOTES
*/

SELECT [mvs].[ID] ,
       [mvs].[Username] ,
       [mvs].[Password] ,
       [mvs].[NetworkAddress] ,
       [mvs].[VaultName] ,
   [mat].[AuthenticationType] ,
 mat.ID AS Authentication_ID,
       [mpt].[ProtocolType] ,
	 mpt.id AS ProtocolType_ID,
       [mvs].[Endpoint] 

  FROM [dbo].[MFVaultSettings] AS [mvs]
INNER JOIN [dbo].[MFAuthenticationType] AS [mat]
ON [mat].[ID] = [mvs].[MFAuthenticationType_ID]
INNER JOIN [dbo].[MFProtocolType] AS [mpt]
ON [mpt].[ID] = [mvs].[MFProtocolType_ID]

--SELECT * FROM [dbo].[MFAuthenticationType] AS [mat]

--SELECT * FROM [dbo].[MFProtocolType] AS [mpt]
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[MFvwAuditSummary]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwAuditSummary', -- nvarchar(100)
    @Object_Release = '4.3.10.49', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwAuditSummary'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW [dbo].[MFvwAuditSummary]
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
/*
-- ============================================= 
-- Author: leRoux Cilliers, Laminin Solutions
-- Create date: 2016-5

-- Description:	Summary of AuditHistory by Flag and Class
-- Revision History:  
-- YYYYMMDD Author - Description 
-- =============================================

Modifications

2019-06-17	LC		Add class name to as column, remove session id
*/		
ALTER VIEW [dbo].[MFvwAuditSummary]
AS


SELECT TOP 500 mc.name AS Class,  [mc].[TableName], mah.[StatusName], mah.[StatusFlag], COUNT(*) AS [Count]

FROM [dbo].[MFAuditHistory] AS [mah]
INNER JOIN [dbo].[MFClass] AS [mc]
ON mc.mfid = mah.[Class] 

GROUP BY mc.name,  mah.[StatusName], [mc].[TableName], mah.[StatusFlag]
ORDER BY mc.name DESC


GO


GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[MFvwLogTableStats]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwLogTableStats', -- nvarchar(100)
    @Object_Release = '3.1.2.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwLogTableStats'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW dbo.MFvwLogTableStats
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
/*
-- ============================================= 
-- Author: leRoux Cilliers, Laminin Solutions
-- Create date: 2016-5

-- Description:	Summary of AuditHistory by Flag and Class
-- Revision History:  
-- YYYYMMDD Author - Description 
-- =============================================
*/		
ALTER VIEW dbo.MFvwLogTableStats
AS


/*
View to report log counts
*/


SELECT  'MFAuditHistory' AS TableName, COUNT(*) AS RecordCount, EarliestDate = MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah]
UNION ALL 
SELECT  'MFUpdateHistory' AS TableName, COUNT(*) AS RecordCount, EarliestDate = MIN([mah].[CreatedAt]) FROM [dbo].[MFUpdateHistory] AS [mah]
UNION ALL
SELECT  'MFLog' AS TableName, COUNT(*) AS RecordCount, EarliestDate = MIN([mah].[CreateDate]) FROM [dbo].[MFLog] AS [mah]
UNION ALL
SELECT  'MFProcessBatch' AS TableName, COUNT(*) AS RecordCount, EarliestDate = MIN([mah].[CreatedOn]) FROM [dbo].[MFProcessBatch] AS [mah]
UNION ALL
SELECT  'MFProcessBatchDetail' AS TableName, COUNT(*) AS RecordCount, EarliestDate = MIN([mah].[CreatedOn]) FROM [dbo].[MFProcessBatchDetail] AS [mah]
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[MFvwMetadataStructure]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwMetadataStructure', -- nvarchar(100)
    @Object_Release = '4.3.09.48', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwMetadataStructure'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW [dbo].[MFvwMetadataStructure]
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
/*
-- ============================================= 
-- Author: leRoux Cilliers, Laminin Solutions
-- Create date: 2016-5

-- Description:	View of metadata structure
-- Revision History:  
-- 2017-8-22	lc	fix property_alias spelling error
--2019-4-10		lc	add RealObjectType
-- =============================================
*/		
ALTER VIEW MFvwMetadataStructure
AS
    SELECT  [mp].[Name] AS Property ,
            [mp].[Alias] AS Property_alias ,
            [mp].[MFID] AS Property_MFID ,
			mp.[ID] AS Property_ID,
            [mp].[ColumnName] ,
            [mp].[PredefinedOrAutomatic] ,
            [mcp].[Required] ,
            [mvl].[Name] AS Valuelist ,
            [mvl].[Alias] AS Valuelist_Alias ,
			mvl.id AS Valuelist_ID,
            [mvl].[MFID] AS Valuelist_MFID ,
			mvl.[RealObjectType] AS IsObjectType,
            [ValuelistOwner].[Name] AS Valuelist_Owner ,
            [mvl].[OwnerID] AS Valuelist_Owner_MFID ,
            [ValuelistOwner].[Alias] AS Valuelist_OwnerAlias ,
            [mc].[Name] AS Class ,
            [mc].[Alias] AS Class_Alias ,
            [mc].[MFID] AS class_MFID ,
            [mc].[IncludeInApp] ,
            [mc].[TableName] ,
            [mw].[Name] AS Workflow ,
            [mw].[Alias] AS Workflow_Alias ,
            [mw].[MFID] AS Workflow_MFID ,
            [mot].[Name] AS ObjectType ,
            [mot].[Alias] AS ObjectType_Alias ,
            [mot].[MFID] AS ObjectType_MFID ,
            [mdt].[SQLDataType] ,
            [mdt].[Name] AS MFDataType
    FROM    [dbo].[MFProperty] AS [mp]
            LEFT JOIN [dbo].[MFClassProperty] AS [mcp] ON [mcp].[MFProperty_ID] = mp.[ID]
            LEFT JOIN [dbo].[MFClass] AS [mc] ON mc.[ID] = [mcp].[MFClass_ID]
            LEFT JOIN [dbo].[MFObjectType] AS [mot] ON mc.[MFObjectType_ID] = [mot].[ID]
            LEFT JOIN [dbo].[MFDataType] AS [mdt] ON mp.[MFDataType_ID] = [mdt].[ID]
            LEFT JOIN [dbo].[MFWorkflow] AS [mw] ON mw.[ID] = [mc].[MFWorkflow_ID]
            LEFT JOIN [dbo].[MFValueList] AS [mvl] ON mp.[MFValueList_ID] = mvl.[ID]
            LEFT JOIN ( SELECT  [MFValueList].[Name] ,
                                [MFValueList].[Alias] ,
                                [MFValueList].[MFID]
                        FROM    MFValueList
                        UNION 
                        SELECT  [mot].[Name] ,
                                [mot].[Alias] ,
                                [mot].[MFID]
                        FROM    [dbo].[MFObjectType] AS [mot]
                      ) AS ValuelistOwner ON [mvl].[OwnerID] = [ValuelistOwner].MFID
    WHERE   mp.[Deleted] = 0;



	GO


GO

PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[MFvwObjectTypeSummary]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'MFvwObjectTypeSummary' -- nvarchar(100)
                                    ,@Object_Release = '4.2.8.47'           -- varchar(50)
                                    ,@UpdateFlag = 2;                       -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[VIEWS]
    WHERE [TABLE_NAME] = 'MFvwObjectTypeSummary'
          AND [TABLE_SCHEMA] = 'dbo'
)
BEGIN
    SET NOEXEC ON;
END;
GO

CREATE VIEW [dbo].[MFvwObjectTypeSummary]
AS
SELECT [Column1] = 'UNDER CONSTRUCTION';
GO

SET NOEXEC OFF;
GO

/*
-- ============================================= 
-- Author: leRoux Cilliers, Laminin Solutions
-- Create date: 2018-12

-- Description:	Summary of Records by object type and class
-- Revision History:  
-- YYYYMMDD Author - Description 

2019-1-18 LC	Fix bug on document collections
-- =============================================
*/
ALTER VIEW [dbo].[MFvwObjectTypeSummary]
AS
WITH [cte]
AS (
   SELECT [mottco].[ObjectType_ID]
         ,[mottco].[Class_ID]
         ,COUNT(*)                    [RecordCount]
         ,MAX([mottco].[Object_MFID]) [MaximumObjid]
   FROM [dbo].[MFObjectTypeToClassObject] AS [mottco]
   GROUP BY [mottco].[ObjectType_ID]
           ,[mottco].[Class_ID])
SELECT [mc].[Name]  AS [Class]
      ,[mot].[Name] AS [ObjectType]
      ,[cte].[RecordCount]
      ,[cte].[MaximumObjid]
      ,[mc].[IncludeInApp]
FROM [cte]
    INNER JOIN [dbo].[MFClass]      AS [mc]
        ON [cte].[Class_ID] = [mc].[MFID]
    INNER JOIN [dbo].[MFObjectType] AS [mot]
        ON [cte].[ObjectType_ID] = [mot].MFID
GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + 'dbo.spMFGetObjectvers';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFGetObjectvers' -- nvarchar(100)
                                    ,@Object_Release = '4.4.12.53'      -- varchar(50)
                                    ,@UpdateFlag = 2;                   -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFGetObjectvers' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFGetObjectvers]
AS
SELECT 'created, but not implemented yet.'; --just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFGetObjectvers]
(
    @TableName NVARCHAR(100)
   ,@dtModifiedDate DATETIME
   ,@MFIDs NVARCHAR(4000)
   ,@outPutXML NVARCHAR(MAX) OUTPUT
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0
)
AS
/*rST**************************************************************************

=================
spMFGetObjectvers
=================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @TableName nvarchar(100)
    fixme description
  @dtModifiedDate datetime
    fixme description
  @MFIDs nvarchar(4000)
    fixme description
  @outPutXML nvarchar(max) (output)
    fixme description
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

To get all the object versions of the class table as XML.

Additional Info
===============

Prerequisites
=============

Warnings
========

Examples
========

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-04  LC         Add connection test
2019-08-30  JC         Added documentation
2019-08-05  LC         Improve logging
2019-07-10  LC         Add debugging and messaging
2018-04-04  DEV2       Added License module validation code
2016-08-22  LC         Update settings index
2016 08-22  LC         Change objids to NVARCHAR(4000)
2015 09-21  DEV2       Removed old style vaultsettings, replace with @VaultSettings
2015-06-16  Kishore    Create procedure
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------------
    -- CONSTANTS: MFSQL Class Table Specific
    -------------------------------------------------------------
    DECLARE @MFTableName AS NVARCHAR(128) = '';
    DECLARE @ProcessType AS NVARCHAR(50);

    SET @ProcessType = ISNULL(@ProcessType, 'Get Objver');

    -------------------------------------------------------------
    -- CONSTATNS: MFSQL Global 
    -------------------------------------------------------------
    DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
    DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
    DECLARE @Process_ID_1_Update TINYINT = 1;
    DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
    DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
    DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
    DECLARE @Process_ID_2_SyncError TINYINT = 2;
    DECLARE @ProcessBatchSize INT = 250;

    -------------------------------------------------------------
    -- VARIABLES: MFSQL Processing
    -------------------------------------------------------------
    DECLARE @Update_ID INT;
    DECLARE @Update_IDOut INT;
    DECLARE @MFLastModified DATETIME;
    DECLARE @MFLastUpdateDate DATETIME;
    DECLARE @Validation_ID INT;

    -------------------------------------------------------------
    -- VARIABLES: T-SQL Processing
    -------------------------------------------------------------
    DECLARE @rowcount AS INT = 0;
    DECLARE @return_value AS INT = 0;
    DECLARE @error AS INT = 0;

    -------------------------------------------------------------
    -- VARIABLES: DEBUGGING
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFGetObjectvers';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @DebugText AS NVARCHAR(256) = '';
    DECLARE @Msg AS NVARCHAR(256) = '';
    DECLARE @MsgSeverityInfo AS TINYINT = 10;
    DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
    DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

    -------------------------------------------------------------
    -- VARIABLES: LOGGING
    -------------------------------------------------------------
    DECLARE @LogType AS NVARCHAR(50) = 'Status';
    DECLARE @LogText AS NVARCHAR(4000) = '';
    DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
    DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
    DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
    DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
    DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
    DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
    DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
    DECLARE @count INT = 0;
    DECLARE @Now AS DATETIME = GETDATE();
    DECLARE @StartTime AS DATETIME = GETUTCDATE();
    DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
    DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

    -------------------------------------------------------------
    -- VARIABLES: DYNAMIC SQL
    -------------------------------------------------------------
    DECLARE @sql NVARCHAR(MAX) = N'';
    DECLARE @sqlParam NVARCHAR(MAX) = N'';

    -------------------------------------------------------------
    -- INTIALIZE PROCESS BATCH
    -------------------------------------------------------------
    SET @ProcedureStep = 'Start Logging';
    SET @LogText = 'Processing ' + @ProcedureName;

    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Status'
                                        ,@LogText = @LogText
                                        ,@LogStatus = N'In Progress'
                                        ,@debug = @Debug;

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Debug'
                                              ,@LogText = @ProcessType
                                              ,@LogStatus = N'Started'
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT
                                              ,@debug = 0;

    BEGIN TRY
        -------------------------------------------------------------
        -- BEGIN PROCESS
        -------------------------------------------------------------
        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        DECLARE @VaultSettings NVARCHAR(4000);
        DECLARE @ClassId INT;
        DECLARE @Idoc INT;

        SELECT @ClassId = [MFID]
        FROM [dbo].[MFClass]
        WHERE [TableName] = @TableName;

        IF ISNULL(@ClassId, -1) = -1
        BEGIN
            SET @DebugText = ' Unable to find class table - check name: ' + @TableName;
            SET @DebugText = @DefaultDebugText + @DebugText;
            SET @ProcedureStep = 'Get class id';

            RAISERROR(@DebugText, 16, 1, @ProcedureName, @ProcedureStep);
        END;

        SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

		        -------------------------------------------------------------
        -- Check connection to vault
        -------------------------------------------------------------
        --DECLARE @IsUpToDate INT;

        --SET @ProcedureStep = 'Connection test: ';

        --EXEC @return_value = [dbo].[spMFGetMetadataStructureVersionID] @IsUpToDate = @IsUpToDate OUTPUT; -- bit

        --IF @return_value < 0
        --BEGIN
        --    SET @DebugText = 'Connection failed %i';
        --    SET @DebugText = @DefaultDebugText + @DebugText;

        --    RAISERROR(@DebugText, 16, 1, @ProcedureName, @ProcedureStep, @return_value);
        --END;

        ---------------------------------------------------------------
        -- Checking module access for CLR procdure  spMFGetObjectType
        ------------------------------------------------------------------
        SET @ProcedureStep = 'Check license';

        EXEC [dbo].[spMFCheckLicenseStatus] 'spMFGetObjectVersInternal'
                                           ,@ProcedureName
                                           ,@ProcedureStep;

        SET @DebugText = 'Filters: Class %i , ;Date ' + CAST(@dtModifiedDate AS VARCHAR(30)) + ' ;Count objids %s ';
        SET @DebugText = @DefaultDebugText + @DebugText;
        SET @ProcedureStep = 'Wrapper - spMFGetObjectVersInternal';

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ClassId, @MFIDs);
        END;

        EXECUTE @return_value = [dbo].[spMFGetObjectVersInternal] @VaultSettings
                                                                 ,@ClassId
                                                                 ,@dtModifiedDate
                                                                 ,@MFIDs
                                                                 ,@outPutXML OUTPUT;

        IF @Debug > 0
            SELECT CAST(@outPutXML AS XML) AS [ObjVerOutput];

        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @outPutXML;

		Set @DebugText = ' wrapper return value: %i'
		Set @DebugText = @DefaultDebugText + @DebugText
		Set @Procedurestep = ''
		
		IF @debug > 0
			Begin
				RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep, @return_value );
			END
		

        SELECT @rowcount = COUNT([xmlfile].[objId])
        FROM
            OPENXML(@Idoc, '/form/objVers', 1)
            WITH
            (
                [objId] INT './@objectID'
            ) [xmlfile];

        SET @StartTime = GETUTCDATE();
        SET @ProcedureStep = 'Result of Getobjver';
        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'In Progress';
        SET @LogTextDetail
            = 'Objver with filters: Date: ' + CAST(ISNULL(@dtModifiedDate, '2000-01-01') AS NVARCHAR(30)) + ' Objids: '
              + ISNULL(@MFIDs, '');
        SET @LogColumnName = 'Get Objectvers';
        SET @LogColumnValue = CAST(@rowcount AS NVARCHAR(10));

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

        EXEC [sys].[sp_xml_removedocument] @Idoc;

        -------------------------------------------------------------
        --END PROCESS
        -------------------------------------------------------------
        END_RUN:
        SET @ProcedureStep = 'End';
        SET @LogStatus = 'Completed';
		SET @LogText = 'Object versions updated'

        -------------------------------------------------------------
        -- Log End of Process
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Debug'
                                            ,@LogText = @LogText
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Debug'
                                                  ,@LogText = @LogText
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN 1;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;
GO

GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFChangeClass]';
GO

SET NOCOUNT ON;

EXEC [Setup].[spMFSQLObjectsControl]
    @SchemaName = N'dbo'
  , @ObjectName = N'spMFChangeClass'
  ,-- nvarchar(100)
    @Object_Release = '2.1.0.0'
  ,-- varchar(50)
    @UpdateFlag = 2;
	-- smallint
GO

IF EXISTS ( SELECT  1
            FROM    [INFORMATION_SCHEMA].[ROUTINES]
            WHERE   [ROUTINES].[ROUTINE_NAME] = 'spMFChangeClass' --name of procedure
                    AND [ROUTINES].[ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
                    AND [ROUTINES].[ROUTINE_SCHEMA] = 'dbo' )
   BEGIN
         PRINT SPACE(10) + '...Stored Procedure: update';

         SET NOEXEC ON;
   END;
ELSE
   PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFChangeClass]
AS
       SELECT   'created, but not implemented yet.';
	--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

--spMFChangeClass 'MFCustomer'
alter Procedure spMFChangeClass
(
		@MFTableName NVARCHAR(128)
)
AS /*******************************************************************************
   ** Desc:  The purpose of this procedure is to move the records from one class 
          table to another class table and synxhronize records into M-Files.
   ** Calls: spMFUpdateTable

   ** Date:  06-01-2017

   ******************************************************************************/
      Begin
	   
			  BEGIN TRY
					
				CREATE TABLE #TempChangeClass
				( 
				  ObjID int,
				  Class_ID int
				)

				DECLARE @SqlQuery nvarchar(max)
					   ,@Total_Rows int
					   ,@Counter int
					   ,@DestiClass_ID int
					   ,@DestClass_Name NVARCHAR(128)
					   ,@ProcedureStep sysname = 'Start'
					   ,@ObjID NVARCHAR(4000)
					 

                SET @ProcedureStep = 'Inserting Source table ObjID with Class_ID into Temp table';

				SET @SqlQuery='insert into #TempChangeClass(ObjID,Class_ID)
							   Select ObjID ,Class_ID from '+@MFTableName+' where Process_ID=1 and Deleted=0'

				EXEC [sys].[sp_executesql] 
				           @SqlQuery

				----------Update source table from  Sql to M-files to change class -----------

				SET @ProcedureStep = 'Moving record from Source table to destination table by Synch from sql to M-files';
				
				EXEC spMFUpdateTable @MFTableName,0

				Create table #TempDestinationClass
				(
				 RowID int identity(1,1)
				,Class_ID int
				)
				insert into #TempDestinationClass
				(
				 Class_ID
				)
				select distinct
				(
				 Class_ID
				) 
				from 
				 #TempChangeClass

				select @Total_Rows=max(RowID) from #TempDestinationClass

				Set @Counter =1

				while @Counter<= @Total_Rows
				 BEGIN
						Select @DestiClass_ID=Class_ID from #TempDestinationClass where RowID=@Counter
						select @DestClass_Name=TableName from MFClass where MFID=@DestiClass_ID

						----------Update Destination table from M-files to Sql-----------
						SET @ProcedureStep = 'Synch records from M_files to sql in destination table'+@DestClass_Name+' ;'
						EXEC spMFUpdateTable @DestClass_Name,1 
						SET @Counter=@Counter+1
					
				 END
                 
				

				--SET @SqlQuery= 'Update '+ @MFTableName +' set Process_ID=1 where ObjID in (
				--               select ObjID from #TempChangeClass) and Process_ID=0'



				

                EXEC [sys].[sp_executesql] 
				           @SqlQuery

				SET @SqlQuery ='Select @ObjID= COALESCE(@ObjID + '', '', '''') + cast(ObjID as nvarchar(20))from '
				                + @MFTableName +
							   ' where Process_ID=1 and deleted=0'

				EXEC [sys].[sp_executesql] 
				            @SqlQuery
						   , N'@ObjID Nvarchar(4000) OUTPUT'
						   ,@ObjID  OutPut


				
				SET @ProcedureStep = 'Marking moved records as Deleted=1 from in Souce table'+@MFTableName+' ;'

				Declare @ObjIDs Nvarchar(4000)
				select @ObjIDs=@ObjID

				
				Exec spMFUpdateTable @MFTableName,1,null,null,@objIDs,null,null,null
				


				
				DROP TABLE #TempChangeClass
				DROP TABLE #TempDestinationClass

			  End try
			  BEGIN CATCH
			     INSERT    INTO [dbo].[MFLog]
                            ( [SPName]
                            , [ErrorNumber]
                            , [ErrorMessage]
                            , [ErrorProcedure]
                            , [ProcedureStep]
                            , [ErrorState]
                            , [ErrorSeverity]
                            , [Update_ID]
                            , [ErrorLine]
			                )
                  VALUES    ( 'spMFUpdateTable'
                            , ERROR_NUMBER()
                            , ERROR_MESSAGE()
                            , ERROR_PROCEDURE()
                            , @ProcedureStep
                            , ERROR_STATE()
                            , ERROR_SEVERITY()
                            , 0
                            , ERROR_LINE()
                            );

			  End CATCH
End
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFCreateValueListLookupView]';
GO
SET NOCOUNT ON;
EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo',
                                     @ObjectName = N'spMFCreateValueListLookupView', -- nvarchar(100)
                                     @Object_Release = '3.1.5.41',                   -- varchar(50)
                                     @UpdateFlag = 2;                                -- smallint

GO

/*
 ********************************************************************************
  ** Change History
  ********************************************************************************
  ** Date        Author     Description
  ** ----------  ---------  -----------------------------------------------------
  ** 20-07-2015  DEV 2	   New Logic implemented
  ** 12-5-2017		LC			add deleted = 0 as filter
  ** 2017-7-25		AC			update the join statement to fix error with ownership relationship
  ** 2017-12-10		lc			Add Schema
  ** 2018 - 5- 20	lc			Add error check that Valuelist exist
*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFCreateValueListLookupView' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    DROP PROC [dbo].[spMFCreateValueListLookupView];
    PRINT SPACE(10) + '...Stored Procedure: dropped and recreated';
    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO


-- the following section will be always executed
SET NOEXEC OFF;
GO

CREATE PROCEDURE [dbo].[spMFCreateValueListLookupView]
(
    @ValueListName NVARCHAR(128),
    @ViewName NVARCHAR(128),
    @Schema NVARCHAR(20) = 'dbo',
    @Debug SMALLINT = 0
)
AS
/*******************************************************************************
  ** Desc:  The purpose of this procedure is to easily create one or more SQL Views to be used as lookup sources
  **  
  ** Version: 1.0.0.6
  **
  ** 
  ** Author:          Thejus T V
  ** Date:            15/07/2015 
 
  ******************************************************************************/
BEGIN
    BEGIN TRY
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -------------------------------------------------------------
        -- Validate that valuelist exist
        -------------------------------------------------------------

        IF
        (
            SELECT COUNT(*) FROM [dbo].[MFValueList] WHERE [Name] = @ValueListName
        ) = 1
        BEGIN

            DECLARE @Query NVARCHAR(2500),
                    @OwnerTableJoin NVARCHAR(250),
                    @ProcedureStep sysname = 'Start';

            -----------------------------------------
            --DROP THE EXISTSING VIEW
            -----------------------------------------
            DECLARE @object NVARCHAR(100);
            SET @object = DB_NAME() + '.' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ViewName);
            IF
            (
                SELECT OBJECT_ID(@object, 'V')
            ) IS NOT NULL
            BEGIN

                -----------------------------------------
                --DEFINE DYNAMIC QUERY
                -----------------------------------------


                DECLARE @DropQuery NVARCHAR(100) = 'DROP VIEW ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ViewName) + '';

                SELECT @ProcedureStep = 'DROP EXISTING VIEW';

                IF @Debug > 0
                    SELECT 'view dropped';
                -----------------------------------------
                --EXECUTE DYNAMIC QUERY
                -----------------------------------------
                EXECUTE (@DropQuery);


            END;

            SELECT @ProcedureStep = 'Set Dynamic query';


            ------------------------------------------------------
            --DEFINE DYNAMIC QUERY TO CREATE VIEW
            ------------------------------------------------------

            SELECT @Query
                = 'CREATE VIEW ' + @Schema + '.' + QUOTENAME(@ViewName)
                  + '
 AS
				   
            SELECT 
            Name_ValueListItems = mvli.Name ,
			MFID_ValueListItems = mvli.MFID ,
			DisplayID_ValueListItems = mvli.DisplayID,
            AppRef_ValueListItems = mvli.AppRef ,
			GUID_ValueListItems = mvli.ItemGUID,
			OwnerName_ValueListItems = mvli2.Name ,
			OwnerMFID_ValueListItems = mvli.OwnerID ,
            OwnerAppRef_ValueListItems = mvli2.AppRef ,
			Name_ValueList = mvl.Name ,
            MFID_ValueList = mvl.MFID ,
            ID_ValueList = mvl.ID ,
            OwnerMFID_ValueList = mvl.OwnerID,
			Deleted = mvli.Deleted,
			Process_ID = mvli.Process_ID
    FROM    [dbo].[MFValueListItems] AS [mvli]
            INNER JOIN [dbo].[MFValueList] AS [mvl] ON mvl.ID = mvli.[MFValueListID]
            LEFT OUTER JOIN ( [MFValueListItems] [mvli2]
                  LEFT OUTER JOIN MFValueList mvl2 ON mvl2.id = [mvli2].MFValueListId
                ) ON mvli.ownerid = mvli2.mfid
                     AND [mvl].[OwnerID] = [mvl2].[MFID]
    WHERE    mvl.Name = ''' + @ValueListName + '''';

            IF @Debug > 0
                SELECT @ProcedureStep AS [ProcedureStep],
                       @Query AS [QUERY];

            SELECT @ProcedureStep = 'EXECUTE DYNAMIC QUERY';

            --------------------------------
            --EXECUTE DYNAMIC QUERY
            --------------------------------
            EXECUTE (@Query);
            IF EXISTS (SELECT * FROM [sys].[views] WHERE [name] = @ViewName)
            BEGIN
                RETURN 1; --SUCESS
            END;
        END;
        ELSE
            DECLARE @DebugMessage NVARCHAR(100);
        SET @DebugMessage = 'Valuelist name: ' + @ValueListName + ' Does not exist or is a duplicate';
        RAISERROR(@DebugMessage, 16, 1);
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET NOCOUNT ON;

        IF @Debug > 0
            SELECT 'spMFCreateValueListLookupView',
                   ERROR_NUMBER(),
                   ERROR_MESSAGE(),
                   ERROR_PROCEDURE(),
                   ERROR_STATE(),
                   ERROR_SEVERITY(),
                   ERROR_LINE(),
                   @ProcedureStep;

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName],
            [ErrorNumber],
            [ErrorMessage],
            [ErrorProcedure],
            [ErrorState],
            [ErrorSeverity],
            [ErrorLine],
            [ProcedureStep]
        )
        VALUES
        ('spMFCreateLookupView', ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(),
         ERROR_LINE(), @ProcedureStep);

        RETURN 2; --FAILURE
    END CATCH;
END;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFCreateWorkflowStateLookupView]';
GO

SET NOCOUNT ON;
EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo',
                                     @ObjectName = N'spMFCreateWorkflowStateLookupView', -- nvarchar(100)
                                     @Object_Release = '3.1.5.41',                       -- varchar(50)
                                     @UpdateFlag = 2;                                    -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFCreateWorkflowStateLookupView' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    DROP PROC [dbo].[spMFCreateWorkflowStateLookupView];
    PRINT SPACE(10) + '...Stored Procedure: dropped and recreated';
    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO


-- the following section will be always executed
SET NOEXEC OFF;
GO

CREATE PROCEDURE [dbo].[spMFCreateWorkflowStateLookupView]
(
    @WorkflowName NVARCHAR(128),
    @ViewName NVARCHAR(128),
    @Schema NVARCHAR(20) = 'dbo',
    @Debug SMALLINT = 0
)
AS
/*******************************************************************************
  ** Desc:  The purpose of this procedure is to easily create one or more SQL Views to be used as lookup sources
  **  
  ** Version: 1.0.0.6
  **
  ** Processing Steps:
  **      
  
  **
  ** Author:          Thejus T V
  ** Date:            15/07/2015 
  ********************************************************************************
  ** Change History
  ********************************************************************************
  ** Date        Author     Description
  ** ----------  ---------  -----------------------------------------------------
  ** 20-07-2015  DEV 2	   New Logic implemented
   ** 12-5-2017		LC			add deleted = 0 as filter
   ** 1-6-2017		LC		add ID columns, change naming of columns to align with valuelist views, remove
    deleted as filter
  ** 2017-12-10		lc			Add Schema
  ** 2018-05-20		LC			add error check if workflow does not exist
  ******************************************************************************/
BEGIN
    BEGIN TRY
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -------------------------------------------------------------
        -- Validate that workflow exist
        -------------------------------------------------------------

        IF
        (
            SELECT COUNT(*)
            FROM [dbo].[MFWorkflow] AS [mw]
            WHERE [mw].[Name] = @WorkflowName
        ) = 1
        BEGIN

            DECLARE @Query NVARCHAR(2500),
                    @OwnerTableJoin NVARCHAR(250),
                    @ProcedureStep sysname = 'Start';
            -----------------------------------------
            --DROP THE EXISTSING VIEW
            -----------------------------------------
            DECLARE @object NVARCHAR(100);
            SET @object = DB_NAME() + '.' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ViewName);

            IF
            (
                SELECT OBJECT_ID(@object, 'V')
            ) IS NOT NULL
            BEGIN

                -----------------------------------------
                --DEFINE DYNAMIC QUERY
                -----------------------------------------


                DECLARE @DropQuery NVARCHAR(100) = 'DROP VIEW ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ViewName) + '';

                SELECT @ProcedureStep = 'DROP EXISTING VIEW';

                IF @Debug > 0
                    SELECT 'view dropped';
                -----------------------------------------
                --EXECUTE DYNAMIC QUERY
                -----------------------------------------
                EXECUTE (@DropQuery);


            END;

            SELECT @ProcedureStep = 'Set Dynamic query';


            ------------------------------------------------------
            --DEFINE DYNAMIC QUERY TO CREATE VIEW
            ------------------------------------------------------

            SELECT @Query
                = 'CREATE VIEW ' + @Schema + '.' + QUOTENAME(@ViewName)
                  + '
 AS
					    SELECT  
                            [mwf].[Name] AS Name_Workflow ,
                            [mwf].[Alias] AS Alias_Workflow ,
                            [mwf].[MFID] AS MFID_Workflow,  
							[mwf].[ID] AS ID_Workflow,                       
                            [mwfs].[Name] AS Name_State ,
                            [mwfs].[Alias] AS Alias_State,
                            [mwfs].[MFID] AS MFID_State,
							[mwfs].[ID] AS ID_State,
							[mwfs].[Deleted] AS Deleted_State
                         
    FROM    [dbo].[MFWorkflow] AS [mwf]
            INNER JOIN [dbo].[MFWorkflowState] AS [mwfs] ON [mwfs].[MFWorkflowID] = [mwf].[ID]
 
  WHERE    mwf.Name = '''   + @WorkflowName + '''';



            IF @Debug > 0
                SELECT @ProcedureStep AS [ProcedureStep],
                       @Query AS [QUERY];

            SELECT @ProcedureStep = 'EXECUTE DYNAMIC QUERY';

            --------------------------------
            --EXECUTE DYNAMIC QUERY
            --------------------------------
            EXECUTE (@Query);
            IF EXISTS (SELECT * FROM [sys].[views] WHERE [name] = @ViewName)
            BEGIN
                RETURN 1; --SUCESS
            END;
        END;
        ELSE
            DECLARE @DebugMessage NVARCHAR(100);
        SET @DebugMessage = 'Workflowname: ' + @WorkflowName + ' Does not exist or is a duplicate';
        RAISERROR(@DebugMessage, 16, 1);
        RETURN 0;

    END TRY
    BEGIN CATCH
        SET NOCOUNT ON;

        IF @Debug > 0
            SELECT 'spMFCreateValueListLookupView',
                   ERROR_NUMBER(),
                   ERROR_MESSAGE(),
                   ERROR_PROCEDURE(),
                   ERROR_STATE(),
                   ERROR_SEVERITY(),
                   ERROR_LINE(),
                   @ProcedureStep;

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName],
            [ErrorNumber],
            [ErrorMessage],
            [ErrorProcedure],
            [ErrorState],
            [ErrorSeverity],
            [ErrorLine],
            [ProcedureStep]
        )
        VALUES
        ('spMFCreateLookupView', ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(),
         ERROR_LINE(), @ProcedureStep);

        RETURN 2; --FAILURE
    END CATCH;
END;
GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFDeleteAdhocProperty]';
GO

SET NOCOUNT ON;

EXEC [Setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFDeleteAdhocProperty'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.3.09.48'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;
                                    -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFDeleteAdhocProperty' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFDeleteAdhocProperty]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFDeleteAdhocProperty]
(
    @MFTableName NVARCHAR(128)
                                --,@ObjId			    INT			-- ObjId the record
   ,@columnNames NVARCHAR(4000) --Property names separated by comma to delete the value 
   ,@process_ID SMALLINT        -- do not use 0
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0
)
AS
/*rST**************************************************************************

=======================
spMFDeleteAdhocProperty
=======================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(128)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @columnNames nvarchar(4000)
    Name of the column to be removed
  @process\_ID smallint
    Use any flag that is not 0 = 4 to indicate the records that should be included. Set the flag on all records if the adhoc property should be removed from all
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

This procedure is specially useful when the metadata design in the vault has changed over time and properties that is not used any longer is still remaining on the metadata card.  Instead of manually deleted these properties from the metadata card, they can be deleted in bulk using the Connector.

Additional Info
===============

When a class table is refreshed in SQL and the properties are not defined on the metadata card, but are still on the object then it will be added as a separate column towards the end of the Class Table list of columns.

Using this procedure can delete these columns and delete it from the metadata.

Prerequisites
=============

There is a few requirements or steps to be taken to use this procedure:

- Identify the adhoc columns towards the end of the Class Table column list.
- Any column that is not a default column can be specified.
- The property will only be removed from the metadata card if there are no objects with values for that property any longer.
- If the property is set on the metadata card it, the value will be set to Null but it will not be removed.

Examples
========

.. code:: sql

    DECLARE @return_value int
    EXEC    @return_value = [dbo].[spMFDeleteAdhocProperty]
                                  @MFTableName =  N'MFCustomer',
                                  @columnNames =  N'Address',
                                  @process_ID = 5,
                                  @Debug =  NULL
    SELECT  'Return Value' = @return_value
    GO

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-04-25  LC         Fix bug to pick up both ID column and label column when deleting columns
2019-03-10  LC         Fix bug on not deleting the data in column
==========  =========  ========================================================

**rST*************************************************************************/
 /*******************************************************************************
  ** Desc:  The purpose of this procedure is used to delete Adhoc property value of objects
  **  
 */
BEGIN
    BEGIN TRY
        --BEGIN TRANSACTION
        SET NOCOUNT ON;

        -------------------------------------------------------------
        -- CONSTANTS: MFSQL Class Table Specific
        -------------------------------------------------------------
        DECLARE @ProcessType AS NVARCHAR(50);

        SET @ProcessType = 'Delete Properties';

        -------------------------------------------------------------
        -- CONSTATNS: MFSQL Global 
        -------------------------------------------------------------
        DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
        DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
        DECLARE @Process_ID_1_Update TINYINT = 1;
        DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
        DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
        DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
        DECLARE @Process_ID_2_SyncError TINYINT = 2;
        DECLARE @ProcessBatchSize INT = 250;

        -------------------------------------------------------------
        -- VARIABLES: MFSQL Processing
        -------------------------------------------------------------
        DECLARE @Update_ID INT;
        DECLARE @MFLastModified DATETIME;
        DECLARE @Validation_ID INT;
        -------------------------------------------------------------
        -- VARIABLES: T-SQL Processing
        -------------------------------------------------------------
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT = 0;
        DECLARE @error AS INT = 0;

        -------------------------------------------------------------
        -- VARIABLES: DEBUGGING
        -------------------------------------------------------------
        DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFDeleteAdhocProperty';
        DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @Msg AS NVARCHAR(256) = '';
        DECLARE @MsgSeverityInfo AS TINYINT = 10;
        DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
        DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

        -------------------------------------------------------------
        -- VARIABLES: LOGGING
        -------------------------------------------------------------
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = '';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
        DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
        DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @count INT = 0;
        DECLARE @Now AS DATETIME = GETDATE();
        DECLARE @StartTime AS DATETIME = GETUTCDATE();
        DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
        DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

        -------------------------------------------------------------
        -- VARIABLES: DYNAMIC SQL
        -------------------------------------------------------------
        DECLARE @sql NVARCHAR(MAX) = N'';
        DECLARE @sqlParam NVARCHAR(MAX) = N'';

        -------------------------------------------------------------
        -- INTIALIZE PROCESS BATCH
        -------------------------------------------------------------
        SET @ProcedureStep = 'Start Logging';
        SET @LogText = 'Processing ' + @ProcedureName;

        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Status'
                                            ,@LogText = @LogText
                                            ,@LogStatus = N'In Progress'
                                            ,@debug = @Debug;

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Debug'
                                                  ,@LogText = @ProcessType
                                                  ,@LogStatus = N'Started'
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                                  ,@debug = 0;

        -----------------------------------------------------
        --DECLARE LOCAL VARIABLE
        -----------------------------------------------------
        DECLARE @VaultSettings    NVARCHAR(4000)
               ,@ObjectId         INT
               ,@ClassId          INT
               ,@MFLastUpdateDate SMALLDATETIME;

        --check if table exists
        IF EXISTS
        (
            SELECT *
            FROM [sys].[objects]
            WHERE [object_id] = OBJECT_ID(N'[dbo].[' + @MFTableName + ']')
                  AND [type] IN ( N'U' )
        )
        BEGIN
            -----------------------------------------------------
            --GET LOGIN CREDENTIALS
            -----------------------------------------------------
            SET @ProcedureStep = 'Get Security Variables';

            SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

            IF @Debug > 0
            BEGIN
                SELECT @VaultSettings;
            END;

            -----------------------------------------------------
            --Set Object Type Id, class id
            -----------------------------------------------------
            SET @ProcedureStep = 'Get Object Type and Class';

            SELECT @ObjectId = [mot].[MFID]
                  ,@ClassId  = [mc].[MFID]
            FROM [dbo].[MFClass]                AS [mc]
                INNER JOIN [dbo].[MFObjectType] AS [mot]
                    ON [mc].[MFObjectType_ID] = [mot].[ID]
            WHERE [mc].[TableName] = @MFTableName; --SUBSTRING(@TableName, 3, LEN(@TableName))

            IF @Debug > 0
            BEGIN
                SELECT @ClassId  AS [classid]
                      ,@ObjectId AS [ObjectID];
            END;

            -----------------------------------------------------
            --SELECT THE ROW DETAILS DEPENDS ON USER INPUT
            -----------------------------------------------------
            SET @ProcedureStep = 'Count records to update';

            DECLARE @ColumnCount    INT
                   ,@SelectQuery    NVARCHAR(200)
                   ,@ParmDefinition NVARCHAR(500);

            SET @SelectQuery
                = 'SELECT @retvalOUT  = COUNT(ID) FROM [' + @MFTableName + '] WHERE Process_ID = '
                  + CAST(@process_ID AS NVARCHAR(20)) + ' AND Deleted = 0';
            SET @ParmDefinition = N'@retvalOUT int OUTPUT';

            IF @Debug > 0
            BEGIN
                SELECT @SelectQuery AS [SELECT QUERY];
            END;

            EXEC [sys].[sp_executesql] @SelectQuery
                                      ,@ParmDefinition
                                      ,@retvalOUT = @count OUTPUT;

            SET @DebugText = 'Count of items to update %i';
            SET @DebugText = @DefaultDebugText + @DebugText;

            IF @Debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @count);
            END;

            SELECT @ColumnCount = COUNT(*)
            FROM [INFORMATION_SCHEMA].[COLUMNS] AS [c]
                LEFT JOIN
                (
                    SELECT [ListItem] AS [columnname]
                    FROM [dbo].[fnMFParseDelimitedString](@columnNames, ',')
                )                               AS [list]
                    ON [list].[columnname] = [c].[COLUMN_NAME]
            WHERE [c].[TABLE_NAME] = @MFTableName;

            ----------------------------------------------------------------------------------------------------------
            --If Any record Updated/Insert in SQL and @UpdateMethod = 0(0=Update from SQL to MF only)
            ----------------------------------------------------------------------------------------------------------
            IF (@count + @ColumnCount > 0)
            BEGIN

                --Update table
                --EXEC [dbo].[spMFUpdateMFilesToMFSQL] @MFTableName = @MFTableName                  -- nvarchar(128)
                --                                    ,@MFLastUpdateDate = @MFLastUpdateDate OUTPUT -- smalldatetime
                --                                    ,@UpdateTypeID = 1                            -- tinyint
                --                                    ,@Update_IDOut = @Update_ID OUTPUT            -- int
                --                                    ,@ProcessBatch_ID = @ProcessBatch_ID          -- int
                --                                    ,@debug = 0;

                                                                                                  -- tinyint

                --- set values of select columns and objects to null
                DECLARE @ColumnName NVARCHAR(100);

                DECLARE @ColumnList AS TABLE
                (
                    [ColumnName] NVARCHAR(100)
                );

                INSERT INTO @ColumnList
                (
                    [ColumnName]
                )
                SELECT [list].[Item]
                FROM [dbo].[fnMFSplitString](@columnNames, ',') [list]
                    INNER JOIN [dbo].[MFProperty]               AS [mp]
                        ON REPLACE([mp].[ColumnName], '_ID', '') = [list].[Item]
                UNION ALL
                SELECT [mp].[ColumnName]
                FROM [dbo].[fnMFSplitString](@columnNames, ',') [list]
                    INNER JOIN [dbo].[MFProperty]               AS [mp]
                        ON REPLACE([mp].[ColumnName], '_ID', '') = [list].[Item]
                WHERE [list].[Item] <> [mp].[ColumnName];

				Set @DebugText = ''
				Set @DebugText = @DefaultDebugText + @DebugText
				Set @Procedurestep = 'Get columns'
				
				IF @debug > 0
				SELECT * FROM @ColumnList AS [cl];
					Begin
						RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep );
					END
				

                DECLARE @UpdateQuery NVARCHAR(MAX);

                WHILE EXISTS (SELECT [cl].[ColumnName] FROM @ColumnList AS [cl])
                BEGIN
                    SELECT TOP 1
                           @ColumnName = [cl].[ColumnName]
                    FROM @ColumnList AS [cl];

                    SET @UpdateQuery = N'
					UPDATE tbl
					SET ' + @ColumnName + ' = null
					FROM ' + @MFTableName + ' tbl WHERE Process_ID = ' + CAST(@process_ID AS VARCHAR(10));
                    SET @DebugText = 'Items deleted in column ' + @ColumnName;
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    SET @ProcedureStep = 'Delete column values';

								Set @DebugText = ''
				Set @DebugText = @DefaultDebugText + @DebugText


                    IF @Debug > 0
                    BEGIN
					Select @UpdateQuery AS 'UpdateQuery'
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    EXEC (@UpdateQuery);

                    DELETE FROM @ColumnList
                    WHERE [ColumnName] = @ColumnName;
                END;

				SET @sqlParam = N'@Process_ID int'

				SET @UpdateQuery = N'UPDATE Tbl 
				SET Process_id = 1 
				FROM ' + QUOTENAME(@MFtableName) + ' Tbl
				WHERE process_ID = @process_id'

				EXEC sp_executeSQL @smtp = @UpdateQuery, @Param = @sqlParam, @Process_ID = @Process_ID

                ---update using mfupdatetable method 0
                EXEC [dbo].[spMFUpdateTable] @MFTableName = @MFTableName
                                            ,@UpdateMethod = 0                   -- in		 	
                                            ,@Update_IDOut = @Update_ID OUTPUT   -- int
                                            ,@ProcessBatch_ID = @ProcessBatch_ID -- int
                                            ,@Debug = 0;

                                                                                 -- smallint

                ---if all values for column is null then delete column

                /*
Drop redundant columns
*/
                DECLARE @SQLquery NVARCHAR(MAX);

                INSERT INTO @ColumnList
                (
                    [ColumnName]
                )
                SELECT [Item]
                FROM [dbo].[fnMFSplitString](@columnNames, ',');

                WHILE EXISTS (SELECT TOP 1 [c].[ColumnName] FROM @ColumnList AS [c])
                BEGIN
                    SELECT TOP 1
                           @ColumnName = [c].[ColumnName]
                    FROM @ColumnList AS [c];

                    SET @SQLquery
                        = N'

								IF (SELECT COUNT(*) FROM ' + QUOTENAME(@MFTableName) + ' t WHERE t.' + @ColumnName
                          + ' IS NOT NULL) = 0
								BEGIN
								ALTER TABLE ' + QUOTENAME(@MFTableName) + '
								DROP COLUMN ' + QUOTENAME(@ColumnName) + '
								END;';

                    EXEC [sys].[sp_executesql] @SQLquery;

                    DELETE FROM @ColumnList
                    WHERE [ColumnName] = @ColumnName;
                END; -- while - column exist
            END; -- if count of records to update > 0
        END; -- if MFtableExist
        ELSE
        BEGIN
            SELECT 'Check the table Name Entered';
        END;

        SET NOCOUNT OFF;

        -------------------------------------------------------------
        --END PROCESS
        -------------------------------------------------------------
        END_RUN:
        SET @ProcedureStep = 'End';
        SET @LogStatus = 'Completed';

        -------------------------------------------------------------
        -- Log End of Process
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Message'
                                            ,@LogText = @LogText
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Debug'
                                                  ,@LogText = @ProcessType
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN 1;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFDeleteHistory]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMFDeleteHistory', -- nvarchar(100)
    @Object_Release = '2.1.1.13', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM   information_schema.Routines
            WHERE   ROUTINE_NAME = 'spMFDeleteHistory'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
BEGIN
	PRINT SPACE(10) + '...Stored Procedure: update'
    SET NOEXEC ON
END
ELSE
	PRINT SPACE(10) + '...Stored Procedure: create'
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFDeleteHistory]
AS
       SELECT   'created, but not implemented yet.'--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF
GO
Alter procedure [dbo].[spMFDeleteHistory](
@DeleteBeforeDate DATETIME 
)
as
/*******************************************************************************
  ** Desc:  The purpose of this procedure is to delete all records in MFlog,MFUpdateHistory,MFAuditHistory till the given date  
  **  
  ** Version: 2.0.2.5
  **
  ** Processing Steps:
  **					1.delete the records in MFLog
                         2.delete the records in MFUpdateHistory
					3.delete the records in MFAuditHistory
  **
  ** Parameters and acceptable values: 					
  **					@DeleteBeforeDate        DATETIME
  **			       
  ** Restart:
  **					Restart at the beginning.  No code modifications required.
  ** 
  ** Tables Used:                 					  
  **					
  **
  ** Return values:		
  **					
  **
  ** Called By:			
  **
  ** Calls:           
  **					NONE
  **														
  **
  ** Author:			Kishore
  ** Date:				28-07-2016

  Change history

  2016-11-10 LC Add ProcessBatch and ProcessBatchDetail to delete

  ******************************************************************************/
  SET NOCOUNT on
BEGIN

delete from MFLog where CreateDate < = @DeleteBeforeDate 
delete from MFUpdateHistory where CreatedAt < = @DeleteBeforeDate
delete from MFAuditHistory where [TranDate] < = @DeleteBeforeDate
DELETE FROM [dbo].[MFProcessBatchDetail] WHERE [MFProcessBatchDetail].[CreatedOn] < = @DeleteBeforeDate
DELETE FROM [dbo].[MFProcessBatch] WHERE [MFProcessBatch].[CreatedOn] < = @DeleteBeforeDate

END
RETURN 1
GO


PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFDeleteObject]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFDeleteObject' -- nvarchar(100)
                                    ,@Object_Release = '4.4.12.52'     -- varchar(50)
                                    ,@UpdateFlag = 2;                  -- smallint
GO
IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFDeleteObject' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFDeleteObject]
AS
SELECT 'created, but not implemented yet.'; --just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFDeleteObject]
    @ObjectTypeId INT
   ,@objectId INT
   ,@Output NVARCHAR(2000) OUTPUT
   ,@ObjectVersion INT = 0
   ,@DeleteWithDestroy BIT = 0
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0
AS
/*rST**************************************************************************

================
spMFDeleteObject
================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ObjectTypeId int
    OBJECT Type MFID from MFObjectType
  @objectId int
    Objid of record
  @Output nvarchar(2000) (output)
    Output message
  @DeleteWithDestroy bit (optional)
    - Default = 0
    - 1 = Destroy

Purpose
=======

An object can be deleted from M-Files using the ClassTable by using the spMFDeleteObject procedure. Is it optional to delete or destroy the object in M-Files.

Warnings
========

Note that when a object is deleted it will not show in M-Files but it will still show in the class table. However, in the class table the deleted flag will be set to 1.

Examples
========

.. code:: sql

    DECLARE @return_value int, @Output nvarchar(2000)
    SELECT @Output =N'0'
    EXEC @return_value = [dbo].[spMFDeleteObject]
         @ObjectTypeId =128,-- OBJECT MFID
         @objectId =4700,-- Objid of record
         @Output = @Output OUTPUT,
         @DeleteWithDestroy = 0
    SELECT @Output as N'@Output'
    SELECT'Return Value'= @return_value
    SELECT @Output =N'0'
    GO

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-08-20  LC         Expand routine to respond to output and remove object from change history
2019-08-13  DEV2       Added objversion to delete particular version.
2018-08-03  LC         Suppress SQL error when no object in MF found
2016-09-26  DEV2       Removed vault settings parameters and pass them as comma separated string in @VaultSettings parameter.
2016-08-22  LC         Update settings index
2016-08-14  LC         Add objid to output message
==========  =========  ========================================================

**rST*************************************************************************/

/*******************************************************************************
1	Success object deleted
2	Success object version destroyed
3	Success object  destroyed
4	Failure object does not exist
5	Failure object version does not exist
6	Failure destroy latest object version not allowed
*/


BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------------
    -- CONSTANTS: MFSQL Class Table Specific
    -------------------------------------------------------------
    DECLARE @MFTableName AS NVARCHAR(128);
    DECLARE @ProcessType AS NVARCHAR(50);

    SET @ProcessType = ISNULL(@ProcessType, 'Delete Object');

    -------------------------------------------------------------
    -- CONSTATNS: MFSQL Global 
    -------------------------------------------------------------
    DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
    DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
    DECLARE @Process_ID_1_Update TINYINT = 1;
    DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
    DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
    DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
    DECLARE @Process_ID_2_SyncError TINYINT = 2;
    DECLARE @ProcessBatchSize INT = 250;

    -------------------------------------------------------------
    -- VARIABLES: MFSQL Processing
    -------------------------------------------------------------
    DECLARE @Update_ID INT;
    DECLARE @Update_IDOut INT;
    DECLARE @MFLastModified DATETIME;
    DECLARE @MFLastUpdateDate DATETIME;
    DECLARE @Validation_ID INT;

    -------------------------------------------------------------
    -- VARIABLES: T-SQL Processing
    -------------------------------------------------------------
    DECLARE @rowcount AS INT = 0;
    DECLARE @return_value AS INT = 0;
    DECLARE @error AS INT = 0;

    -------------------------------------------------------------
    -- VARIABLES: DEBUGGING
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = 'spMFDeleteObject';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @DebugText AS NVARCHAR(256) = '';
    DECLARE @Msg AS NVARCHAR(256) = '';
    DECLARE @MsgSeverityInfo AS TINYINT = 10;
    DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
    DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

    -------------------------------------------------------------
    -- VARIABLES: LOGGING
    -------------------------------------------------------------
    DECLARE @LogType AS NVARCHAR(50) = 'Status';
    DECLARE @LogText AS NVARCHAR(4000) = '';
    DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
    DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
    DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
    DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
    DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
    DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
    DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
    DECLARE @count INT = 0;
    DECLARE @Now AS DATETIME = GETDATE();
    DECLARE @StartTime AS DATETIME = GETUTCDATE();
    DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
    DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

    -------------------------------------------------------------
    -- VARIABLES: DYNAMIC SQL
    -------------------------------------------------------------
    DECLARE @sql NVARCHAR(MAX) = N'';
    DECLARE @sqlParam NVARCHAR(MAX) = N'';

    -------------------------------------------------------------
    -- INTIALIZE PROCESS BATCH
    -------------------------------------------------------------
    SET @ProcedureStep = 'Start Logging';

    DECLARE @ObjectType NVARCHAR(100);

    SELECT @ObjectType = [mot].[Name]
    FROM [dbo].[MFObjectType] AS [mot]
    WHERE [mot].[MFID] = @ObjectTypeId;

    SET @LogText
        = CASE
              WHEN @DeleteWithDestroy = 1 THEN
                  'Destroy objid ' + CAST(@objectId AS VARCHAR(10)) + ' for Object Type ' + @ObjectType + ' Version '
                  + CAST(@ObjectVersion AS NVARCHAR(10))
              ELSE
                  'Delete objid ' + CAST(@objectId AS VARCHAR(10)) + ' for Object Type ' + @ObjectType + ' Version '
                  + CAST(@ObjectVersion AS NVARCHAR(10))
          END;

    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Status'
                                        ,@LogText = @LogText
                                        ,@LogStatus = N'In Progress'
                                        ,@debug = @Debug;

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Debug'
                                              ,@LogText = @LogText
                                              ,@LogStatus = N'Started'
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = NULL
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT
                                              ,@debug = 0;

    BEGIN TRY
        -------------------------------------------------------------
        -- BEGIN PROCESS
        -------------------------------------------------------------
        SET @DebugText = 'Object Type %i; Objid %i; Version %i';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjectTypeId, @objectId, @ObjectVersion);
        END;

        -----------------------------------------------------
        -- LOCAL VARIABLE DECLARARTION
        -----------------------------------------------------
        DECLARE @VaultSettings NVARCHAR(4000);
        DECLARE @Idoc INT;
        DECLARE @StatusCode INT;
        DECLARE @Message NVARCHAR(100);

        -----------------------------------------------------
        -- SELECT CREDENTIAL DETAILS
        -----------------------------------------------------
        SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

        ------------------------------------------------------
        --Validating Module for calling CLR Procedure
        ------------------------------------------------------
        EXEC [dbo].[spMFCheckLicenseStatus] 'spMFDeleteObjectInternal'
                                           ,'spMFDeleteObject'
                                           ,'Deleting object';

        -----------------------------------------------------
        -- CALLS PROCEDURE spMFDeleteObjectInternal
        -----------------------------------------------------
        -- nvarchar(2000)
        SET @ProcedureStep = 'Wrapper result';

        EXEC [dbo].[spMFDeleteObjectInternal] @VaultSettings
                                             ,@ObjectTypeId
                                             ,@objectId
                                             ,@DeleteWithDestroy
                                             ,@ObjectVersion
                                             ,@Output OUTPUT;

        --      PRINT @Output + ' ' + CAST(@objectId AS VARCHAR(100))
        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @Output;

        SELECT @StatusCode = [xmlfile].[StatusCode]
              ,@Message    = [xmlfile].[Message]
        FROM
            OPENXML(@Idoc, '/form/objVers', 1)
            WITH
            (
                [objId] INT './@objId'
               ,[MFVersion] INT './@ObjVers'
               ,[StatusCode] INT './@statusCode'
               ,[Message] NVARCHAR(100) './@Message'
            ) [xmlfile];

        EXEC [sys].[sp_xml_removedocument] @Idoc;

        SET @DebugText = 'Statuscode %i; Message %s';
        SET @DebugText = @DefaultDebugText + @DebugText;


        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @StatusCode, @Message);
        END;

IF @StatusCode = 2
BEGIN 


      DELETE 
        FROM [dbo].[MFObjectChangeHistory] 
        WHERE [ObjectType_ID] = @ObjectTypeId
              AND [ObjID] = @objectId
              AND [MFVersion] = @ObjectVersion;
END

IF @StatusCode IN (1,3)
BEGIN

 DELETE 
        FROM [dbo].[MFObjectChangeHistory] 
        WHERE [ObjectType_ID] = @ObjectTypeId
              AND [ObjID] = @objectId;
END

        -------------------------------------------------------------
        --END PROCESS
        -------------------------------------------------------------
        END_RUN:
        SET @ProcedureStep = 'End';
        SET @LogStatus = CASE WHEN @StatusCode IN (1,2,3) THEN 'Completed' ELSE 'Failed' end
		
		SET @logtext = @Message

        -------------------------------------------------------------
        -- Log End of Process
        -------------------------------------------------------------   
    
	    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Debug'
                                            ,@LogText = @LogText
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Debug'
                                                  ,@LogText = @LogText
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN @StatusCode;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;
GO
GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFLogTableStats]';
GO
SET NOCOUNT ON; 
EXEC Setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',
    @ObjectName = N'spMFLogTableStats', -- nvarchar(100)
    @Object_Release = '3.1.1.36', -- varchar(50)
    @UpdateFlag = 2;
 -- smallint
GO

/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-02
	Database: 
	Description: Listing of log Table stats
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====

  EXEC [spMFLogTableStats]  


  
-----------------------------------------------------------------------------------------------*/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFLogTableStats'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE spMFLogTableStats
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO



ALTER  PROC spMFLogTableStats
AS


Begin

create table #TableSize (
Name varchar(255),
[rows] int,
reserved varchar(255),
data varchar(255),
index_size varchar(255),
unused varchar(255))

create table #ConvertedSizes (
Name varchar(255),
[rows] int,
reservedKb int,
dataKb int,
reservedIndexSize int,
reservedUnused int,
earliestDate datetime)


insert into #TableSize
EXEC sp_spaceused 'MFAuditHistory'
insert into #TableSize
EXEC sp_spaceused 'MFUpdateHistory'
insert into #TableSize
EXEC sp_spaceused 'MFLog'
insert into #TableSize
EXEC sp_spaceused  'MFProcessBatch'
insert into #TableSize
EXEC sp_spaceused 'MFProcessBatchDetail' 

insert into #ConvertedSizes (Name, [rows], reservedKb, dataKb, reservedIndexSize, reservedUnused)
select name, [rows],
SUBSTRING(reserved, 0, LEN(reserved)-2),
SUBSTRING(data, 0, LEN(data)-2),
SUBSTRING(index_size, 0, LEN(index_size)-2),
SUBSTRING(unused, 0, LEN(unused)-2)
from #TableSize


UPDATE #ConvertedSizes
SET earliestDate = (
SELECT  MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah])
WHERE NAME = 'MFAuditHistory'

UPDATE #ConvertedSizes
SET earliestDate = (
SELECT  MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah])
WHERE NAME = 'MFUpdateHistory'

UPDATE #ConvertedSizes
SET earliestDate = (
SELECT  MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah])
WHERE NAME = 'MFLog'

UPDATE #ConvertedSizes
SET earliestDate = (
SELECT  MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah])
WHERE NAME = 'MFProcessBatch' 

UPDATE #ConvertedSizes
SET earliestDate = (
SELECT  MIN([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah])
WHERE NAME = 'MFProcessBatchDetail' 

select * from #ConvertedSizes
order by reservedKb desc

drop table #TableSize
drop table #ConvertedSizes

END

GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFCreateAllMFTables]';
GO

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'spMFCreateAllMFTables', -- nvarchar(100)
    @Object_Release = '2.0.2.4', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFCreateAllMFTables'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFCreateAllMFTables]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFCreateAllMFTables] @Debug SMALLINT = 0
AS
/*rST**************************************************************************

=====================
spMFCreateAllMFTables
=====================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

Create all Class Tables where Included in App is 1 or 2

Examples
========

.. code:: sql

    EXEC [spMFCreateAllMFTables] 1

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

    BEGIN
        IF @Debug > 0
            SELECT  Name
            FROM    MFClass
            WHERE   IncludeInApp IN ( 1, 2 );

        DECLARE @tableName VARCHAR(MAX);
        DECLARE tbCursor CURSOR
        FOR
            SELECT  TableName
            FROM    MFClass
            WHERE   IncludeInApp IN ( 1, 2 );
        OPEN tbCursor;
        FETCH NEXT FROM tbCursor INTO @tableName;

        WHILE ( @@FETCH_STATUS = 0 )
            BEGIN

                IF @Debug > 0
                    SELECT  @tableName;

                DECLARE @ActualMFTable VARCHAR(MAX);  
                SET @ActualMFTable = @tableName;

                IF NOT EXISTS ( SELECT  *
                                FROM    INFORMATION_SCHEMA.TABLES
                                WHERE   TABLE_NAME = @ActualMFTable )
                    BEGIN
                        IF @Debug > 0
                            SELECT  @tableName AS 'Table created';
                        DECLARE @ClassTableName VARCHAR(100);

                        SELECT  @ClassTableName = Name
                        FROM    MFClass
                        WHERE   [MFClass].[TableName] = @tableName;

                        EXEC spMFCreateTable @ClassTableName;

                    END;


                FETCH NEXT FROM tbCursor INTO @tableName;

            END;
        CLOSE tbCursor;
        DEALLOCATE tbCursor;

		RETURN 1
    END;


GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.dbo.spMFDeleteObjectList';
SET NOCOUNT ON;
GO
EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo',
                                     @ObjectName = N'spMFDeleteObjectList', -- nvarchar(100)
                                     @Object_Release = '4.1.5.43',          -- varchar(50)
                                     @UpdateFlag = 2;                       -- smallint

GO

/*
2018-04-9		lc			Delete object from class table after deletion.
2018-6-26		LC			Imrpove return value
2018-8-2		LC			Suppress SQL error when nothing deleted
*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFDeleteObjectList' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';
    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFDeleteObjectList]
AS
SELECT 'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROC [dbo].[spMFDeleteObjectList]
(
    @TableName NVARCHAR(100),
    @Process_id INT,
    @DeleteWithDestroy BIT = 0,
    @ProcessBatch_ID INT = NULL OUTPUT,
    @Debug INT = 0
)
AS /*
Procedure to delete a series of objects

USAGE:
Before running this procedure, set the process_id for the target objects for deletion 
Select * from MFTest
update t
set process_id = 10
from MFTest t where id in(10,11,12)

exec spMFDeleteObjectList @tableName = 'MFTest', @process_ID = 10, @Debug = 1

*/

-------------------------------------------------------------
-- CONSTANTS: MFSQL Class Table Specific
-------------------------------------------------------------
DECLARE @MFTableName AS NVARCHAR(128) = @TableName;
DECLARE @ProcessType AS NVARCHAR(50);

SET @ProcessType = ISNULL(@ProcessType, 'Delete Objects');

-------------------------------------------------------------
-- CONSTATNS: MFSQL Global 
-------------------------------------------------------------
DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
DECLARE @Process_ID_1_Update TINYINT = 1;
DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
DECLARE @Process_ID_2_SyncError TINYINT = 2;
DECLARE @ProcessBatchSize INT = 250;

-------------------------------------------------------------
-- VARIABLES: MFSQL Processing
-------------------------------------------------------------
DECLARE @Update_ID INT;
DECLARE @MFLastModified DATETIME;
DECLARE @Validation_ID INT;

-------------------------------------------------------------
-- VARIABLES: T-SQL Processing
-------------------------------------------------------------
DECLARE @rowcount AS INT = 0;
DECLARE @return_value AS INT = 0;
DECLARE @error AS INT = 0;

-------------------------------------------------------------
-- VARIABLES: DEBUGGING
-------------------------------------------------------------
DECLARE @ProcedureName AS NVARCHAR(128) = 'spMFDeleteObjectList';
DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
DECLARE @DebugText AS NVARCHAR(256) = '';
DECLARE @Msg AS NVARCHAR(256) = '';
DECLARE @MsgSeverityInfo AS TINYINT = 10;
DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

-------------------------------------------------------------
-- VARIABLES: LOGGING
-------------------------------------------------------------
DECLARE @LogType AS NVARCHAR(50) = 'Status';
DECLARE @LogText AS NVARCHAR(4000) = '';
DECLARE @LogStatus AS NVARCHAR(50) = 'Started';

DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;

DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;

DECLARE @count INT = 0;
DECLARE @Now AS DATETIME = GETDATE();
DECLARE @StartTime AS DATETIME = GETUTCDATE();
DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

-------------------------------------------------------------
-- VARIABLES: DYNAMIC SQL
-------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @sqlParam NVARCHAR(MAX) = N'';


-------------------------------------------------------------
-- INTIALIZE PROCESS BATCH
-------------------------------------------------------------
SET @ProcedureStep = 'Start Logging';

SET @LogText = 'Processing ' + @ProcedureName;

EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
                                     @ProcessType = @ProcessType,
                                     @LogType = N'Status',
                                     @LogText = @LogText,
                                     @LogStatus = N'In Progress',
                                     @debug = @Debug;


EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                           @LogType = N'Debug',
                                           @LogText = @ProcessType,
                                           @LogStatus = N'Started',
                                           @StartTime = @StartTime,
                                           @MFTableName = @MFTableName,
                                           @Validation_ID = @Validation_ID,
                                           @ColumnName = NULL,
                                           @ColumnValue = NULL,
                                           @Update_ID = @Update_ID,
                                           @LogProcedureName = @ProcedureName,
                                           @LogProcedureStep = @ProcedureStep,
                                           @ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT,
                                           @debug = 0;


BEGIN TRY
    -------------------------------------------------------------
    -- BEGIN PROCESS
    -------------------------------------------------------------
    SET @DebugText = '';
    SET @DefaultDebugText = @DefaultDebugText + @DebugText;
    SET @ProcedureStep = '';

    IF @Debug > 0
    BEGIN
        RAISERROR(@DefaultDebugText, 10, 1, @ProcedureName, @ProcedureStep);
    END;


    DECLARE @Objid INT,
            @ObjectTypeID INT,
            @output NVARCHAR(100),
            @itemID INT,
            @Query NVARCHAR(MAX),
            @Params NVARCHAR(MAX);

    SET NOCOUNT ON;

    SELECT @ObjectTypeID = [mot].[MFID]
    FROM [dbo].[MFClass] AS [mc]
        INNER JOIN [dbo].[MFObjectType] AS [mot]
            ON [mot].[ID] = [mc].[MFObjectType_ID]
    WHERE [mc].[TableName] = @TableName;


    IF ISNULL(@ObjectTypeID, -1) = -1
        RAISERROR('ObjectID not found', 16, 1);

    IF @Debug = 1
        SELECT @ObjectTypeID AS [ObjectTypeid];

    CREATE TABLE [#ObjectList]
    (
        [Objid] INT
    );

    SET @Params = N'@Process_id INT';
    SET @Query = N'

		INSERT INTO #ObjectList
		        ( [Objid] )

SELECT  t.[ObjID] 
FROM ' + QUOTENAME(@TableName) + ' as t
WHERE  t.[Process_ID] = @Process_id
ORDER BY objid ASC;';

    EXEC [sys].[sp_executesql] @Stmt = @Query,
                               @Param = @Params,
                               @Process_id = @Process_id;

    -------------------------------------------------------------
    -- Count records to be deleted
    -------------------------------------------------------------
    SET @Params = N'@Count Int Output, @Process_id INT';
    SET @sql = N'SELECT @Count = COUNT(*) FROM ' + QUOTENAME(@TableName) + 'Where Process_ID = @Process_ID';

    EXEC [sys].[sp_executesql] @Stmt = @sql,
                               @Param = @Params,
                               @Count = @count OUTPUT,
                               @Process_id = @Process_id;


    SET @ProcedureStep = 'Total objects to delete';
    SET @LogTypeDetail = 'Status';
    SET @LogStatusDetail = 'In Progress';
    SET @LogTextDetail = 'Total objects: ' + CAST(@count AS NVARCHAR(10));
    SET @LogColumnName = '';
    SET @LogColumnValue = '';

    EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                                                  @LogType = @LogTypeDetail,
                                                                  @LogText = @LogTextDetail,
                                                                  @LogStatus = @LogStatusDetail,
                                                                  @StartTime = @StartTime,
                                                                  @MFTableName = @MFTableName,
                                                                  @Validation_ID = @Validation_ID,
                                                                  @ColumnName = @LogColumnName,
                                                                  @ColumnValue = @LogColumnValue,
                                                                  @Update_ID = @Update_ID,
                                                                  @LogProcedureName = @ProcedureName,
                                                                  @LogProcedureStep = @ProcedureStep,
                                                                  @debug = @Debug;

    -------------------------------------------------------------
    -- Process deletions
    -------------------------------------------------------------
    IF @Debug = 1
        SELECT *
        FROM [#ObjectList] AS [ol];

    DECLARE @getObjidID CURSOR;
    SET @getObjidID = CURSOR FOR
    SELECT [ol].[Objid]
    FROM [#ObjectList] AS [ol]
    ORDER BY [ol].[Objid] ASC;

    OPEN @getObjidID;
    FETCH NEXT FROM @getObjidID
    INTO @Objid;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ProcedureStep = 'SPMFDeleteObject';

        SET @return_value = NULL;
        EXEC @return_value = [dbo].[spMFDeleteObject] @ObjectTypeId = @ObjectTypeID,           -- int
                                                      @objectId = @Objid,                      -- int
                                                      @Output = @output OUTPUT,
                                                      @DeleteWithDestroy = @DeleteWithDestroy; -- nvarchar(2000)

													  SET @output = CASE WHEN @Output IS NULL THEN '0' ELSE @Output END
                                                      
        SET @DebugText = ' Delete Output %s ReturnValue %i';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @output, @return_value);
        END;

        -------------------------------------------------------------
        -- Record deletion
        -------------------------------------------------------------


        SET @ProcedureStep = 'Delete Record';
        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'In Progress';
        SET @LogTextDetail = @output + ': ' + CAST(@Objid AS VARCHAR(10));
        SET @LogColumnName = '';
        SET @LogColumnValue = '';

        EXECUTE [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                                      @LogType = @LogTypeDetail,
                                                      @LogText = @LogTextDetail,
                                                      @LogStatus = @LogStatusDetail,
                                                      @StartTime = @StartTime,
                                                      @MFTableName = @MFTableName,
                                                      @Validation_ID = @Validation_ID,
                                                      @ColumnName = @LogColumnName,
                                                      @ColumnValue = @LogColumnValue,
                                                      @Update_ID = @Update_ID,
                                                      @LogProcedureName = @ProcedureName,
                                                      @LogProcedureStep = @ProcedureStep,
                                                      @debug = @Debug;


        -------------------------------------------------------------
        -- Delete object from class table of deletion in MF
        -------------------------------------------------------------		
        IF @return_value = 1 
        BEGIN
            SET @Query = '
			DELETE FROM ' + QUOTENAME(@TableName) + 'WHERE Objid = ' + CAST(@Objid AS VARCHAR(10));
            EXEC (@Query);
        END;


        FETCH NEXT FROM @getObjidID
        INTO @Objid;
    END;
    CLOSE @getObjidID;
    DEALLOCATE @getObjidID;

    -------------------------------------------------------------
    --END PROCESS
    -------------------------------------------------------------
    END_RUN:
    SET @ProcedureStep = 'End';
    SET @LogStatus = 'Completed';
    -------------------------------------------------------------
    -- Log End of Process
    -------------------------------------------------------------   

    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID,
                                         @ProcessType = @ProcessType,
                                         @LogType = N'Message',
                                         @LogText = @LogText,
                                         @LogStatus = @LogStatus,
                                         @debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                               @LogType = N'Debug',
                                               @LogText = @ProcessType,
                                               @LogStatus = @LogStatus,
                                               @StartTime = @StartTime,
                                               @MFTableName = @MFTableName,
                                               @Validation_ID = @Validation_ID,
                                               @ColumnName = NULL,
                                               @ColumnValue = NULL,
                                               @Update_ID = @Update_ID,
                                               @LogProcedureName = @ProcedureName,
                                               @LogProcedureStep = @ProcedureStep,
                                               @debug = 0;

    RETURN 1;

END TRY
BEGIN CATCH
    SET @StartTime = GETUTCDATE();
    SET @LogStatus = 'Failed w/SQL Error';
    SET @LogTextDetail = ERROR_MESSAGE();

    --------------------------------------------------
    -- INSERTING ERROR DETAILS INTO LOG TABLE
    --------------------------------------------------
    INSERT INTO [dbo].[MFLog]
    (
        [SPName],
        [ErrorNumber],
        [ErrorMessage],
        [ErrorProcedure],
        [ErrorState],
        [ErrorSeverity],
        [ErrorLine],
        [ProcedureStep]
    )
    VALUES
    (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(),
     @ProcedureStep);

    SET @ProcedureStep = 'Catch Error';
    -------------------------------------------------------------
    -- Log Error
    -------------------------------------------------------------   
    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
                                         @ProcessType = @ProcessType,
                                         @LogType = N'Error',
                                         @LogText = @LogTextDetail,
                                         @LogStatus = @LogStatus,
                                         @debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                               @LogType = N'Error',
                                               @LogText = @LogTextDetail,
                                               @LogStatus = @LogStatus,
                                               @StartTime = @StartTime,
                                               @MFTableName = @MFTableName,
                                               @Validation_ID = @Validation_ID,
                                               @ColumnName = NULL,
                                               @ColumnValue = NULL,
                                               @Update_ID = @Update_ID,
                                               @LogProcedureName = @ProcedureName,
                                               @LogProcedureStep = @ProcedureStep,
                                               @debug = 0;

    RETURN 0;
END CATCH;



GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFDropAllClassTables]';
GO

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'spMFDropAllClassTables', -- nvarchar(100)
    @Object_Release = '2.0.2.4', -- varchar(50)
    @UpdateFlag = 2 -- smallint
go
/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-06
	Database: 
	Description: Drop all Class Tables where Included in App is specified
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	YYYY-MM-DD		{Author}	{Comment}
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  debug mode
  
-----------------------------------------------------------------------------------------------*/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFDropAllClassTables'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFDropAllClassTables]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFDropAllClassTables] @IncludeInApp int, @Debug SMALLINT = 0
AS
/*rST**************************************************************************

======================
spMFDropAllClassTables
======================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @IncludeInApp int
    - Drop only tables with IncludeInApp value
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

Drop all class tables.

Examples
========

.. code:: sql

    EXEC [spMFDropAllClassTables] 1, 0

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

    BEGIN
	SET NOCOUNT ON 
        IF @Debug = 1
            SELECT  Name
            FROM    MFClass
            WHERE   IncludeInApp = @IncludeInApp;

        DECLARE @tableName VARCHAR(MAX);
        DECLARE tbCursor CURSOR
        FOR
            SELECT  TableName
            FROM    MFClass
            WHERE   IncludeInApp = @IncludeInApp;
        OPEN tbCursor;
        FETCH NEXT FROM tbCursor INTO @tableName;

        WHILE ( @@FETCH_STATUS = 0 )
            BEGIN

                IF @Debug = 1
                    SELECT  @tableName;

                DECLARE @ActualMFTable VARCHAR(MAX);  
                SET @ActualMFTable = @tableName;

                IF EXISTS ( SELECT  *
                                FROM    INFORMATION_SCHEMA.TABLES
                                WHERE   TABLE_NAME = @ActualMFTable )
                    BEGIN
								IF @debug = 1
                            PRINT   'Table dropped:' +  @tableName ;

                        DECLARE @ClassTableName VARCHAR(100), @Query NVARCHAR(100);

                        SET @Query = N'Drop Table ' + @TableName;
						EXEC sp_executeSQL @Query

                    END;


                FETCH NEXT FROM tbCursor INTO @tableName;

            END;
        CLOSE tbCursor;
        DEALLOCATE tbCursor;


    END;

	RETURN 1

GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFGetDataExport]';
GO
 

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'spMFGetDataExport', -- nvarchar(100)
    @Object_Release = '3.1.5.41', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

IF EXISTS ( SELECT  1
            FROM   information_schema.Routines
            WHERE   ROUTINE_NAME = 'spMFGetDataExport'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
BEGIN
	PRINT SPACE(10) + '...Stored Procedure: update'
    SET NOEXEC ON
END
ELSE
	PRINT SPACE(10) + '...Stored Procedure: create'
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFGetDataExport]
AS
       SELECT   'created, but not implemented yet.'--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF
GO

ALTER PROCEDURE [dbo].[spMFGetDataExport] (@ExportDatasetName [NVARCHAR](2000)
                                            ,@Debug            INT = 0)
AS
/*rST**************************************************************************

=================
spMFGetDataExport
=================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ExportDatasetName nvarchar(2000)
    fixme description
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

To export the dataset.

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-04-04  DEV2       Added License module validation code
2016-10-11  LC         Change of Settings Tablename
2016-09-26  DEV2       Removed vault settings parameters and pass them as comma separated string in @VaultSettings parameter
==========  =========  ========================================================

**rST*************************************************************************/

/*******************************************************************************
**
** Processing Steps:
** 1. Insert data from XML into temperory data
** 2. Update M-Files ID with primary key values from MFWorkflow,MFValueList,MFObjectType
** 3. Update the Class details into MFClass
** 4. INsert the new class details
** 5. If fullUpdate
** Delete the class details deleted from M-Files
**
******************************************************************************/
  BEGIN
      ------------------------------------------------------
      -- SET SESSION STATE
      -------------------------------------------------------
      SET NOCOUNT ON

      ------------------------------------------------------
      -- DEFINE CONSTANTS
      ------------------------------------------------------
      DECLARE @ProcedureName  SYSNAME = 'spMFGetDataExport'
              ,@ProcedureStep SYSNAME = 'Start'
              ,@ErrStep       VARCHAR(255)
              ,@Output        NVARCHAR(max)

      --BEGIN TRY
      ------------------------------------------------------
      -- GET M-FILES AUTHENTICATION
      -------------------------------------------------------		
      SET @ProcedureStep = 'M-Files Authentication'

      DECLARE @VaultSettings   NVARCHAR(4000)
              
     
     SELECT @VaultSettings=dbo.FnMFVaultSettings()

     DECLARE @Username nvarchar(2000)
     DECLARE @VaultName nvarchar(2000)

	 SELECT TOP 1  @Username = username, @VaultName = vaultname
                    FROM    dbo.MFVaultSettings                   

      IF @debug > 0
        RAISERROR ( '%s: VaultName: %s; UserName: %s',10,1,@ProcedureStep,@VaultName,@Username );

      ------------------------------------------------------
      -- MAIN CODE
      -------------------------------------------------------	
      DECLARE @IsExported BIT

      SET @ProcedureStep = 'EXEC spMFSearchForObjectInternal'

      IF @debug > 0
        RAISERROR ( '   %s',10,1,@ProcedureStep );

		------------------------------------------------------
      -- Validating module for CLR Procedure
      -------------------------------------------------------	
	   EXEC [dbo].[spMFCheckLicenseStatus] 'spMFGetDataExportInternal',@ProcedureName,@ProcedureStep

      --SELECT @ExportDatasetName
      ------------------------------------------------------
      --Executing CLR procedure
      ------------------------------------------------------
      EXEC spMFGetDataExportInternal
        @VaultSettings
        ,@ExportDatasetName
        ,@IsExported OUTPUT

      IF( @IsExported = 1 )
        BEGIN
            SELECT 'YES' AS 'EXPORTING STATUS'
        END
      ELSE
        BEGIN
            SELECT 'NO' AS 'EXPORTING STATUS'
        END

      --SELECT @IsExported		
      RETURN 0
  --END TRY
  --BEGIN CATCH
  --	DECLARE @ErrorMessage NVARCHAR(4000)
  --	DECLARE @ErrorSeverity INT
  --	DECLARE @ErrorState INT
  --	DECLARE @ErrorNumber INT
  --	DECLARE @ErrorLine INT
  --	DECLARE @ErrorProcedure NVARCHAR(128)
  --	DECLARE @OptionalMessage VARCHAR(max)
  --	SELECT @ErrorMessage = ERROR_MESSAGE()
  --		,@ErrorSeverity = ERROR_SEVERITY()
  --		,@ErrorState = ERROR_STATE()
  --		,@ErrorNumber = ERROR_NUMBER()
  --		,@ErrorLine = ERROR_LINE()
  --		,@ErrorProcedure = ERROR_PROCEDURE()
  --	IF @debug > 0
  --		RAISERROR (
  --				'FAILED: In %s:%s with Error: %s'
  --				,16
  --				,1
  --				,@ProcedureName
  --				,@ProcedureStep
  --				,@ErrorMessage
  --				)
  --		WITH NOWAIT;
  --	RAISERROR (
  --			 @ErrorMessage	-- Message text.
  --			,@ErrorSeverity -- Severity.
  --			,@ErrorState	-- State.
  --			);
  --	RETURN - 1
  --END CATCH
  END

SET NOCOUNT OFF

GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFGetMfilesLog]';
go
 
SET NOCOUNT ON; 
EXEC [Setup].[spMFSQLObjectsControl]
    @SchemaName = N'dbo'
  , @ObjectName = N'spMFGetMfilesLog'
  , -- nvarchar(100)
    @Object_Release = '3.1.5.41'
  , -- varchar(50)
    @UpdateFlag = 2;
 -- smallint
 go

 /*
 CHANGE HISTORY
  
 */
IF EXISTS ( SELECT  1
            FROM    [INFORMATION_SCHEMA].[ROUTINES]
            WHERE   [ROUTINES].[ROUTINE_NAME] = 'spMFGetMfilesLog'--name of procedure
                    AND [ROUTINES].[ROUTINE_TYPE] = 'PROCEDURE'--for a function --'FUNCTION'
                    AND [ROUTINES].[ROUTINE_SCHEMA] = 'dbo' )
   BEGIN
         PRINT SPACE(10) + '...Stored Procedure: update';
         SET NOEXEC ON;
   END;
ELSE
   PRINT SPACE(10) + '...Stored Procedure: create';
go
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFGetMfilesLog]
AS
       SELECT   'created, but not implemented yet.';
--just anything will do

go
-- the following section will be always executed
SET NOEXEC OFF;
go

ALTER PROCEDURE [dbo].[spMFGetMfilesLog] ( @IsClearMfilesLog BIT = 0, @Debug smallint = 0 )
AS
/*rST**************************************************************************

================
spMFGetMfilesLog
================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @IsClearMfilesLog bit (optional)
    - Default = 0
    - 1 = Clear Mfiles log
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

The purpose of this procedure is to insert Mfiles Log details into MFEventLog_OpenXML table.

Additional Info
===============

This procedure can be used on demand. Alternatively it can be included in an Agent to schedule the export on a regular basis.  This may be particularly relevant as M-Files automatically drops events and only maintain the last 10 000 event records.


Example XML for a new object
----------------------------

.. code:: xml

    <event>
      <id>35543</id>
      <type id="NewObject">New document or other object</type>
      <category id="3">NewObject</category>
      <timestamp>2016-11-25 16:27:57.226000000</timestamp>
      <causedbyuser loginaccount="LS-CilliersL" />
      <data>
        <objectversion>
          <objver>
            <objtype id="162">Test</objtype>
            <objid>1163</objid>
            <version>1</version>
          </objver>
          <extid extidstatus="Internal">1163</extid>
          <objectguid>{84E076F0-92A1-49CD-961E-D4A293512FC3}</objectguid>
          <versionguid>{6B2E37C4-2D8F-4B33-A5BE-A117BB9EF7D3}</versionguid>
          <objectflags value="64">
            <objectflag id="64">normal</objectflag>
          </objectflags>
          <originalobjid>
            <vault>{3F4B2DFA-6D56-4D2D-AC4C-8AB3EF7DFE54}</vault>
            <objtype>162</objtype>
            <id>1163</id>
          </originalobjid>
          <title>Lakeisha222</title>
          <displayid>1163</displayid>
        </objectversion>
      </data>
    </event>

Examples
========

.. code:: sql

    EXEC [dbo].[spMFGetMfilesLog]
         @IsClearMfilesLog = 0 -- bit

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-04-04  DEV2       Added Licensing module validation code.
2017-09-24  LC         Fix bug 'unknown column'
2017-01-23  DEV2       The purpose of this procedure is to insert Mfiles Log details into MFEventLog_OpenXML table.
==========  =========  ========================================================

**rST*************************************************************************/
      BEGIN
            BEGIN TRY

                  SET NOCOUNT ON;

          -----------------------------------------------------
          --DECLARE LOCAL VARIABLE
          -----------------------------------------------------
                  DECLARE @Xml [NVARCHAR](MAX)
                        , @VaultSettings NVARCHAR(4000)
                        , @XMLDoc XML
                        , @ProcedureStep NVARCHAR(MAX)
						, @LoadDate datetime

                  SELECT    @ProcedureStep = 'Create Table #ValueList';
                  DECLARE @procedureName NVARCHAR(128) = 'spMFInsertValueList';

				
			 -----------------------------------------------------
          --ACCESS CREDENTIALS
          -----------------------------------------------------
         

                  SELECT    @VaultSettings = [dbo].[FnMFVaultSettings]()
         

		  -----------------------------------------------------
          -- Remove redundant downloads
          -----------------------------------------------------

		  DELETE FROM [dbo].[MFEventLog_OpenXML]
		  WHERE id > 0

		  -----------------------------------------------------
          -- Get M-Files Log
          -----------------------------------------------------

		  SET @Loaddate = GETDATE()

		  -----------------------------------------------------------------
	        -- Checking module access for CLR procdure  spMFGetObjectType
          ------------------------------------------------------------------
                 EXEC [dbo].[spMFCheckLicenseStatus] 
				      'spMFGetMFilesLogInternal'
					   ,@ProcedureName
					   ,@ProcedureStep


                  EXEC [dbo].[spMFGetMFilesLogInternal]
                    @VaultSettings
                  , @IsClearMFilesLog
                  , @Xml OUTPUT
            
			  IF @Debug > 0
				  SELECT @XML AS XMLReturned;

                  SELECT    @XMLDoc = @Xml

                  INSERT    INTO [dbo].[MFEventLog_OpenXML]
                            ( [XMLData], [LoadedDateTime] )
                  VALUES    ( @XMLDoc, @Loaddate )

				   IF @Debug > 0
				  SELECT * from MFEventLog_OpenXML;

		    -----------------------------------------------------
          -- Add events to MfilesEvents
          -----------------------------------------------------

		  

                  CREATE TABLE [#TempEvent]
                         (
                           [ID] INT
                         , [Type] NVARCHAR(100)
                         , [Category] NVARCHAR(100)
                         , [TimeStamp] NVARCHAR(100)
                         , [CausedByUser] NVARCHAR(100)
                         , [loaddate] DATETIME
                         , [Events] XML
                         )

                  INSERT    INTO [#TempEvent]
                            ( [loaddate]
                            , [Events]
                            )
                            SELECT  [MFEventLog_OpenXML].[LoadedDateTime]
                                  , [tab].[col].[query]('.') AS [event]
                            FROM    [dbo].[MFEventLog_OpenXML]
                            CROSS APPLY [XMLData].[nodes]('/root/event') AS [tab] ( [Col] )
							WHERE [MFEventLog_OpenXML].[LoadedDateTime] = @LoadDate


                  UPDATE    [te]
                  SET       [te].[ID] = [te].[Events].[value]('(/event/id)[1]', 'int')
                          , [te].[Type] = [te].[Events].[value]('(/event/type)[1]', 'varchar(100)')
                          , [te].[Category] = [te].[Events].[value]('(/event/category)[1]', 'varchar(100)')
                          , [te].[TimeStamp] = [te].[Events].[value]('(/event/timestamp)[1]', 'varchar(40)')
                          , [te].[CausedByUser] = [te].[Events].[value]('(/event/causedbyuser/@loginaccount)[1]', 'varchar(100)')
                  FROM      [#TempEvent] AS [te]
				  WHERE te.[loaddate] = @LoadDate

                  MERGE INTO [dbo].[MFilesEvents] [T]
                  USING [#TempEvent] AS [S]
                  ON [T].[ID] = [S].[ID]
                  WHEN MATCHED THEN
                    UPDATE SET [T].[loaddate] = [S].[loaddate]
                  WHEN NOT MATCHED THEN
                    INSERT
                    VALUES ( [S].[ID]
                           , [S].[Type]
                           , [S].[Category]
                           , [S].[TimeStamp]
                           , [S].[CausedByUser]
                           , [S].[loaddate]
                           , [S].[Events]
                           );


                  --SELECT    *
                  --FROM      [dbo].[MFilesEvents]

                  DROP TABLE [#TempEvent]


                  SET NOCOUNT OFF;

          
            END TRY

            BEGIN CATCH

                  SET NOCOUNT ON;

         
                --------------------------------------------------
                -- INSERTING ERROR DETAILS INTO LOG TABLE
                --------------------------------------------------
                  INSERT    INTO [dbo].[MFLog]
                            ( [SPName]
                            , [ErrorNumber]
                            , [ErrorMessage]
                            , [ErrorProcedure]
                            , [ErrorState]
                            , [ErrorSeverity]
                            , [ErrorLine]
                            , [ProcedureStep]
                            )
                  VALUES    ( 'spMFInsertValueList'
                            , ERROR_NUMBER()
                            , ERROR_MESSAGE()
                            , ERROR_PROCEDURE()
                            , ERROR_STATE()
                            , ERROR_SEVERITY()
                            , ERROR_LINE()
                            , @ProcedureStep
                            );

                  DECLARE @ErrNum INT = ERROR_NUMBER()
                        , @ErrProcedure NVARCHAR(100) = ERROR_PROCEDURE()
                        , @ErrSeverity INT = ERROR_SEVERITY()
                        , @ErrState INT = ERROR_STATE()
                        , @ErrMessage NVARCHAR(MAX) = ERROR_MESSAGE()
                        , @ErrLine INT = ERROR_LINE();

                  SET NOCOUNT OFF;

                  RAISERROR (@ErrMessage,@ErrSeverity,@ErrState,@ErrProcedure,@ErrState,@ErrMessage);
            END CATCH;
      END;

go
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFClassTableStats]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFClassTableStats' -- nvarchar(100)
                                    ,@Object_Release = '3.1.4.41'         -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-02
	Database: 
	Description: Listing of Class Table stats
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	2016-8-22		lc			mflastmodified date show in local time
	2016-9-9		lc			add input parameter to only show table requested
	2017-6-16		LC			remove flag = 1 from listing
	2017-6-29		lc			change mflastmodified date to localtime
	2017-7-22		lc			add parameter to allow the temp table to persist
	2017-11-23		lc			MF_lastModified set to deal with localization
	2017-12-27		lc			run tableaudit for each table to update status from MF
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====

  EXEC [spMFClassTableStats]  null , 0,1,0

  exec spmfclasstablestats 'MFCustomer'
  
-----------------------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFClassTableStats' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFClassTableStats]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFClassTableStats]
(
    @ClassTableName NVARCHAR(128) = NULL
   ,@Flag INT = NULL
   ,@WithReset INT = 0
   ,@IncludeOutput INT = 0
   ,@Debug SMALLINT = 0
)
AS
/*rST**************************************************************************

===================
spMFClassTableStats
===================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ClassTableName nvarchar(128) (optional)
    - Default = NULL (all tables will be listed)
    - ClassTableName to show table stats for
  @Flag int (optional)
    - Default = NULL
  @WithReset int (optional)
    - Default = 0
    - 1 = deleted object will be removed, sync error reset to 0, error 3 records deleted.
  @IncludeOutput int (optional)
    set to 1 to output result to a table ##spMFClassTableStats
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

To show an extract of all the Class Tables created in the Connector database, the IncludedInApp status of the tables in MFClass the number of records in the class table and the date and time of the last updated record in the table. The date of the most recent MF_Last_Modified is also shown.

Additional Info
===============

The procedure also show a summary of the key status records from the process_id column of the tables. The number of records in the following categories are shown:

==============  ===============================================================
Column          Description
--------------  ---------------------------------------------------------------
ClassID         MFID of the class
TableName       Name of Class table
IncludeInApp    IncludeInApp Flag
SQLRecordCount  Totals records in SQL (Note that this is not necessarily the same as the total per M-Files)
MFRecordCount   Total records in M-Files. This result is derived from the last time that spMFTableAudit procedure was run to produce a list of the objectversions of all the objects for a specific class
MFNotInSQL      Total record in M-Files not yet updated in SQL
Deleted         Total for Deleted flag set to 1
SyncError       Total Synchronization errors (process_id = 2)
Process_ID_1    Total of records with process_id = 1
MFError         Total of records with process_id = 3 as MFError
SQLError        Total of records with process_id =4 as SQL Error
LastModifed     Most recent date that SQL updated a record in the table
MFLastModified  Most recent that an update was made in M-Files on the record
SessionID       ID  of the latest spMFTableAudit procedure execution. 
==============  ===============================================================

Warnings
========

The MFRecordCount results of spMFClassTableStats is only accurate based on the last execution of spMFAuditTable for a particular class table.

Examples
========

.. code:: sql

   EXEC [dbo].[spMFClassTableStats]

----

To show a specific table.

.. code:: sql

   EXEC [dbo].[spMFClassTableStats] @ClassTableName = N'YourTablename'

----

To insert the report into a temporary table that can be used in messaging.

.. code:: sql

   EXEC [dbo].[spMFClassTableStats]
        @ClassTableName = N'YourTablename'
       ,@IncludeOutput = 1

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

SET NOCOUNT ON;

DECLARE @ClassIDs AS TABLE
(
    [ClassID] INT
);

IF @ClassTableName IS NULL
BEGIN
    INSERT INTO @ClassIDs
    (
        [ClassID]
    )
    SELECT [MFID]
    FROM [dbo].[MFClass];
END;
ELSE
BEGIN
    INSERT INTO @ClassIDs
    (
        [ClassID]
    )
    SELECT [MFID]
    FROM [dbo].[MFClass]
    WHERE [TableName] = @ClassTableName;
END;

if @Debug > 0
SELECT * FROM @ClassIDs;
 

IF EXISTS
(
    SELECT *
    FROM [tempdb].[INFORMATION_SCHEMA].[TABLES] AS [t]
    WHERE [t].[TABLE_NAME] = '##spMFClassTableStats'
)
    DROP TABLE [##spMFClassTableStats];

CREATE TABLE [##spMFClassTableStats]
(
    [ClassID] INT PRIMARY KEY NOT NULL
   ,[TableName] VARCHAR(100)
   ,[IncludeInApp] SMALLINT
   ,[SQLRecordCount] INT
   ,[MFRecordCount] INT
   ,[MFNotInSQL] INT
   ,[Deleted] INT
   ,[SyncError] INT
   ,[Process_ID_1] INT
   ,[MFError] INT
   ,[SQLError] INT
   ,[LastModified] DATETIME
   ,[MFLastModified] DATETIME
   ,[SessionID] INT
);

DECLARE @SQL       NVARCHAR(MAX)
       ,@params    NVARCHAR(100)
       ,@TableName VARCHAR(100)
       ,@ID        INT;
DECLARE @lastModifiedColumn NVARCHAR(100);
DECLARE @MFCount INT = 0;
DECLARE @NotINSQL INT = 0;
DECLARE @IncludeInApp INT;

SELECT @lastModifiedColumn = [mp].[ColumnName]
FROM [dbo].[MFProperty] AS [mp]
WHERE [mp].[MFID] = 21; --'Last Modified'

INSERT INTO [##spMFClassTableStats]
(
    [ClassID]
   ,[TableName]
   ,[IncludeInApp]
   ,[SQLRecordCount]
   ,[MFRecordCount]
   ,[MFNotInSQL]
   ,[Deleted]
   ,[SyncError]
   ,[Process_ID_1]
   ,[MFError]
   ,[SQLError]
   ,[LastModified]
   ,[MFLastModified]
)
SELECT [mc].[MFID]
      ,[mc].[TableName]
      ,[mc].[IncludeInApp]
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
FROM @ClassIDs                AS [cid]
    LEFT JOIN [dbo].[MFClass] AS [mc]
        ON [mc].[MFID] = [cid].[ClassID];

IF @Debug > 0
    SELECT *
    FROM [##spMFClassTableStats];

SELECT @ID = MIN([t].[ClassID])
FROM [##spMFClassTableStats] AS [t];



WHILE @ID IS NOT NULL
BEGIN
    SELECT @TableName    = [t].[TableName]
          ,@IncludeInApp = ISNULL([t].[IncludeInApp], 0)
    FROM [##spMFClassTableStats] AS [t]
    WHERE [t].[ClassID] = @ID;

    IF @Debug > 0
        SELECT @TableName;

    IF @IncludeInApp > 0
	Begin
        SET @params = '@Debug smallint';

    SET @SQL
        = N'
Declare @SQLcount INT, @LastModified datetime, @MFLastModified datetime, @Deleted int, @SyncError int, @ProcessID_1 int, @MFError INt, @SQLError Int


IF EXISTS(SELECT [t].[TABLE_NAME] FROM [INFORMATION_SCHEMA].[TABLES] AS [t] where Table_name = ''' + @TableName
          + ''')
Begin

SELECT @SQLcount = COUNT(*), @LastModified = max(LastModified), @MFLastModified = max('
          + QUOTENAME(@lastModifiedColumn) + ') FROM ' + QUOTENAME(@TableName)
          + '
--Select @MFLastModified = dateadd(hour,DATEDIFF(hour,GETUTCDATE(),GETDATE()),@MFLastModified)
Select @Deleted = count(*) FROM ' + QUOTENAME(@TableName) + ' where deleted <> 0;
Select @SyncError = count(*) FROM ' + QUOTENAME(@TableName)
          + ' where Process_id = 2;
Select @ProcessID_1 = count(*) FROM ' + QUOTENAME(@TableName)
          + ' where Process_id = 1;
Select @MFError = count(*) FROM ' + QUOTENAME(@TableName) + ' where Process_id = 3;
Select @SQLError = count(*) FROM ' + QUOTENAME(@TableName)
          + ' where Process_id = 4;
UPDATE t
SET t.[SQLRecordCount] =  @SQLcount, LastModified = @LastModified, MFLastModified = @MFLastModified,
Deleted = @Deleted, SyncError = @SyncError, Process_ID_1 = @ProcessID_1, MFError = @MFerror, SQLError = @SQLError

FROM [##spMFClassTableStats] AS [t]
WHERE t.[TableName] = ''' + @TableName + '''

END
Else 
If @Debug > 0
print ''' + @TableName + ' has not been created'';
 '  ;

    IF @Debug > 10
        PRINT @SQL;

    EXEC [sys].[sp_executesql] @Stmt = @SQL, @Param = @params, @Debug = @Debug;

    DECLARE @SQLCount INT
           ,@ToObjid  INT;

    SELECT @SQLCount = [smcts].[SQLRecordCount]
    FROM [##spMFClassTableStats] AS [smcts]
    WHERE [smcts].[ClassID] = @ID;

    SELECT @ToObjid = @SQLCount + 5000;

    

        --   declare @SessionIDOut    int
        --         , @NewObjectXml    nvarchar(max)
        --         , @DeletedInSQL    int
        --         , @UpdateRequired  bit
        --         , @OutofSync       int
        --         , @ProcessErrors   int
        --         , @ProcessBatch_ID INT
        --         ,@MFModifiedDate DATETIME
        --,@MFClassTableUpdate DATETIME
        EXEC [dbo].[spMFTableAuditinBatches] @MFTableName = @TableName -- nvarchar(100)
                                            ,@FromObjid = 1            -- int
                                            ,@ToObjid = @ToObjid       -- int
                                            ,@WithStats = 0            -- bit
                                            ,@Debug = 0;

                                                                       -- int

        --exec [dbo].[spMFTableAudit] @MFTableName = @TableName
        --                         , @MFModifiedDate = @MFModifiedDate
        --                          --@ObjIDs = ?,
        --                          , @SessionIDOut = @SessionIDOut output
        --                          , @NewObjectXml = @NewObjectXml output
        --                          , @DeletedInSQL = @DeletedInSQL output
        --                          , @UpdateRequired = @UpdateRequired output
        --                          , @OutofSync = @OutofSync output
        --                          , @ProcessErrors = @ProcessErrors output
        --                          , @ProcessBatch_ID = @ProcessBatch_ID output
        --                          , @Debug = @Debug;

        --if @Debug > 0
        --    select @SessionIDOut as [sessionID];
        SELECT @MFCount = COUNT(*)
        FROM [dbo].[MFAuditHistory] AS [mah]
        WHERE [mah].[Class] = @ID
              AND [mah].[StatusFlag] NOT IN ( 3, 4 ); --not in MF

        SELECT @NotINSQL = COUNT(*)
        FROM [dbo].[MFAuditHistory] AS [mah]
        WHERE [mah].[Class] = @ID
              AND [mah].[StatusFlag] IN ( 5, 6 ); -- templates and other records not in SQL

        UPDATE [smcts]
        SET [smcts].[MFRecordCount] = @MFCount
           ,[smcts].[MFNotInSQL] = @NotINSQL
        FROM [##spMFClassTableStats] AS [smcts]
        WHERE [smcts].[ClassID] = @ID;

        IF EXISTS
        (
            SELECT [t].[TABLE_NAME]
            FROM [INFORMATION_SCHEMA].[TABLES] AS [t]
            WHERE [t].[TABLE_NAME] = @TableName
        )
           AND @WithReset = 1
        BEGIN
            SET @SQL
                = N'delete from ' + QUOTENAME(@TableName)
                  + ' where deleted = 1
		update ##spMFClassTableStats set Deleted = 0 where TableName = ''' + @TableName + '''
		'   ;

            EXEC (@SQL);

            SET @SQL
                = N'delete from ' + QUOTENAME(@TableName)
                  + ' where process_ID = 3
		update ##spMFClassTableStats set MFError = 0 where TableName = ''' + @TableName + '''
		'   ;

            EXEC (@SQL);

            SET @SQL
                = N'Update t set process_ID=0 from ' + QUOTENAME(@TableName)
                  + ' t where process_ID = 2
		update ##spMFClassTableStats set SyncError = 0 where TableName = ''' + @TableName + '''
		'   ;

            EXEC (@SQL);
        END;
		END --included in app

    SELECT @ID = MIN([t].[ClassID])
    FROM [##spMFClassTableStats] AS [t]
    WHERE [t].[ClassID] > @ID;

    IF @Debug > 0
        SELECT @ID AS [nextID];
		
END; -- END while

IF @IncludeOutput = 0
BEGIN
    SELECT [ClassID]
          ,[TableName]
          ,[IncludeInApp]
          ,[SQLRecordCount]
          ,[MFRecordCount]
          ,[MFNotInSQL]
          ,[Deleted]
          ,[SyncError]
          ,[Process_ID_1]
          ,[MFError]
          ,[SQLError]
          ,[LastModified]
          ,[MFLastModified]
          ,1 AS [Flag]
    FROM [##spMFClassTableStats]
    WHERE ISNULL([SQLRecordCount], -1) <> -1;

    DROP TABLE [##spMFClassTableStats];
END;

RETURN 1;
GO

GO

PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFInsertUserMessage]';
GO

SET NOCOUNT ON;

EXEC [Setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFInsertUserMessage' -- nvarchar(100)
                                    ,@Object_Release = '4.4.10.49'           -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFInsertUserMessage' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFInsertUserMessage]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFInsertUserMessage]
    @ProcessBatch_ID INT = NULL
   ,@UserMessageEnabled INT = 0
   ,@Debug SMALLINT = 0
AS
/*rST**************************************************************************

=====================
spMFInsertUserMessage
=====================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ProcessBatch\_ID int (optional)
    Referencing the ID of the ProcessBatch logging table
  @UserMessageEnabled int
    fixme description
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

Additional Info
===============

Prerequisites
=============

Warnings
========

Examples
========

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-01-03  LC         Fix bug related to column names
2018-11-15  LC         Add error logging; fix null value bug; check for duplicate messages per process batch
2018-07-25  LC         Resolve issue with workflow_state_id
2018-06-26  LC         Localise workflow and state
2018-05-18  LC         Add workflow and state
2018-04-28  LC         Add user message enabling
2018-04-20  LC         Update procedure for the new MFClass table for MFUserMessages
2018-04-18  LC         Set default for ProcessBatch_ID
2017-06-26  AC         Remove @ClassTable,  retrieve based on ProcessBatch_ID
2017-06-26  AC         Update call to spMFResultMessageForUI to read the message with carriage return instead of \n
2017-06-26  AC         Add ItemCount based on using new methods to generate RecordCount info message in MFProcessBatchDetail
==========  =========  ========================================================

**rST*************************************************************************/

SET NOCOUNT ON;

BEGIN TRY

    -------------------------------------------------------------
    -- CONSTANTS: MFSQL Class Table Specific
    -------------------------------------------------------------
    DECLARE @MFTableName AS NVARCHAR(128) = 'MFUserMessage';
    DECLARE @ProcessType AS NVARCHAR(50);

    SET @ProcessType = ISNULL(@ProcessType, 'Create user message');

    -------------------------------------------------------------
    -- Logging Variables
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFInsertUserMessage';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
    DECLARE @DebugText AS NVARCHAR(256) = '';
    DECLARE @DetailLoggingIsActive SMALLINT = 0;
    DECLARE @rowcount AS INT = 0;

    -------------------------------------------------------------
    -- VARIABLES: MFSQL Processing
    -------------------------------------------------------------
    DECLARE @Update_ID INT;
    DECLARE @Update_IDOut INT;
    DECLARE @MFLastModified DATETIME;
    DECLARE @MFLastUpdateDate DATETIME;
    DECLARE @Validation_ID INT;

    -------------------------------------------------------------
    -- VARIABLES: LOGGING
    -------------------------------------------------------------
    DECLARE @LogType AS NVARCHAR(50) = 'Status';
    DECLARE @LogText AS NVARCHAR(4000) = '';
    DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
    DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
    DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
    DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
    DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
    DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
    DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
    DECLARE @count INT = 0;
    DECLARE @Now AS DATETIME = GETDATE();
    DECLARE @StartTime AS DATETIME = GETUTCDATE();
    DECLARE @MessageForMFilesOUT NVARCHAR(4000)
           ,@ClassTable          NVARCHAR(100)
           ,@ItemCount           INT
           ,@RecordCount         INT
           ,@UserID              INT
           ,@ClassTableList      NVARCHAR(100)
           ,@MessageTitle        NVARCHAR(100)
           ,@Workflow_ID         INT
           ,@WorkflowState_id    INT;

    IF @UserMessageEnabled = 1
    BEGIN
        SELECT @WorkflowState_id = [mws].[MFID]
              ,@Workflow_ID      = [mw].[MFID]
        FROM [dbo].[MFWorkflowState]      AS [mws]
            INNER JOIN [dbo].[MFWorkflow] AS [mw]
                ON [mw].[ID] = [mws].[MFWorkflowID]
        WHERE [mws].[Alias] = 'wfs.MFSQL_New_Message';

        SET @DebugText = 'WorkflowState_ID %i Workflow_ID %i';
        SET @DebugText = @DefaultDebugText + @DebugText;
        SET @ProcedureStep = 'Get workflow MFIDs';

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @WorkflowState_id, @Workflow_ID);
        END;

        EXEC [dbo].[spMFResultMessageForUI] @Processbatch_ID = @ProcessBatch_ID                -- int
                                                                                               --     @Detaillevel = 0,                                    -- int
                                                                                               --     @MessageOUT = @MessageOUT OUTPUT,                    -- nvarchar(4000)
                                           ,@MessageForMFilesOUT = @MessageForMFilesOUT OUTPUT -- nvarchar(4000)
                                                                                               --     @GetEmailContent = NULL,                             -- bit
                                                                                               --     @EMailHTMLBodyOUT = @EMailHTMLBodyOUT OUTPUT,        -- nvarchar(max)
                                           ,@RecordCount = @RecordCount OUTPUT                 -- int
                                           ,@UserID = @UserID OUTPUT                           -- int
                                           ,@ClassTableList = @ClassTableList OUTPUT           -- nvarchar(100)
                                           ,@MessageTitle = @MessageTitle OUTPUT
                                           ,@Debug = @Debug;                                   -- nvarchar(100)

        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;
        SET @ProcedureStep = 'Prepare Message ';

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        DECLARE @Workflow_name NVARCHAR(100);
        DECLARE @State_name NVARCHAR(100);
        DECLARE @Name_or_title_name NVARCHAR(100);
        DECLARE @SQL NVARCHAR(MAX);
        DECLARE @Params NVARCHAR(MAX);

        SELECT @Workflow_name = [ColumnName]
        FROM [dbo].[MFProperty]
        WHERE [MFID] = 38;

        SELECT @State_name = [ColumnName]
        FROM [dbo].[MFProperty]
        WHERE [MFID] = 39;

        SELECT @Name_or_title_name = [ColumnName]
        FROM [dbo].[MFProperty]
        WHERE [MFID] = 0;

	--	SELECT COUNT(*) FROM sys.columns WHERE [name] IN (@Workflow_name, @State_name, @Name_or_title_name) AND [object_id] = OBJECT_ID('..MFUserMessages')

		IF (SELECT COUNT(*) FROM sys.columns WHERE [name] IN (@Workflow_name, @State_name, @Name_or_title_name) AND [object_id] = OBJECT_ID('..MFUserMessages')) = 3
		Begin



        SET @Params
            = N'@MessageForMFilesOUT NVARCHAR(4000)
           ,@ProcessBatch_ID           INT
           ,@RecordCount         INT
           ,@UserID              INT
           ,@ClassTableList      NVARCHAR(100)
           ,@MessageTitle        NVARCHAR(100)
           ,@Workflow_ID         INT
           ,@WorkflowState_id    INT
'       ;
        SET @SQL
            = N'	
MERGE Into dbo.MFUserMessages t
USING (SELECT     ISNULL(@ClassTableList, '''') AS ClassTableList ,      
       ISNULL(@RecordCount, 0)  AS RecordCount,         
		@MessageForMFilesOUT AS MessageForMfilesOut,
       @ProcessBatch_ID  AS processBatch_ID,     
       @UserID AS UserID,              
	@Workflow_ID AS Workflow_ID,
		@WorkflowState_id AS WorkflowState_ID,
        ISNULL(@MessageTitle, '''') AS MessageTitle,
		Process_ID = 1) s 
		ON t.Mfsql_Process_Batch = s.processBatch_ID
		WHEN NOT MATCHED THEN insert
    (
        Mfsql_Class_Table,
        Mfsql_Count,
        Mfsql_Message,
        Mfsql_Process_Batch,
        Mfsql_User_ID,
		' + QUOTENAME(@Workflow_name) + ' ,
		' + QUOTENAME(@State_name) + ',
        ' + QUOTENAME(@Name_or_title_name)
              + ',
        Process_ID
    )
    VALUES
    (  s.ClassTableList,  
       RecordCount,         
       s.MessageForMFilesOUT,  
       s.ProcessBatch_ID,    
       s.UserID,              
	s.Workflow_ID, 
	s.WorkflowState_id, 
     s.MessageTitle,
	 s.Process_ID)
	 WHEN MATCHED THEN UPDATE Set
	 t.MFSQL_Class_Table = s.ClassTableList,
	 t.MFSQL_Count = s.RecordCount,
	 t.MFSQL_Message = s.MessageForMFilesOUT,
	 t.Name_or_title = s.Messagetitle,
	 t.process_ID = s.Process_ID
	 ;' ;

        IF @Debug > 0
        BEGIN
            SELECT ISNULL(@ClassTableList, '')      AS [ClassTableList]
                  ,ISNULL(@RecordCount, 0)          AS [RecordCount]
                  ,ISNULL(@MessageForMFilesOUT, '') AS [MessageForMfilesOut]
                  ,@ProcessBatch_ID                 AS [processBatch_ID]
                  ,@UserID                          AS [UserID]
                  ,@Workflow_ID                     AS [Workflow_ID]
                  ,@WorkflowState_id                AS [WorkflowState_ID]
                  ,ISNULL(@MessageTitle, '')        AS [MessageTitle]
                  ,[Process_ID]                     = 1;

            SELECT @SQL AS [SQL];
        END;

        EXEC [sys].[sp_executesql] @stmt = @SQL
                                  ,@param = @Params
                                  ,@ClassTableList = @ClassTableList
                                  ,@RecordCount = @RecordCount
                                  ,@MessageForMFilesOUT = @MessageForMFilesOUT
                                  ,@ProcessBatch_ID = @ProcessBatch_ID
                                  ,@UserID = @UserID
                                  ,@Workflow_ID = @Workflow_ID
                                  ,@WorkflowState_id = @WorkflowState_id
                                  ,@MessageTitle = @MessageTitle;

        UPDATE [dbo].[MFUserMessages]
        SET [Mfsql_Message] = @MessageForMFilesOUT
        WHERE [Mfsql_Process_Batch] = @ProcessBatch_ID;

        --        IF @Debug > 0
        --BEGIN
        --SELECT * FROM [dbo].[MFUserMessages] AS [mum] WHERE [mum].[Mfsql_Process_Batch] = @ProcessBatch_ID
        --END
        EXEC [dbo].[spMFUpdateTable] @MFTableName = N'MFUserMessages'     -- nvarchar(200)
                                    ,@UpdateMethod = 0
                                    ,@ProcessBatch_ID = @ProcessBatch_ID  -- int
                                    ,@Update_IDOut = @Update_IDOut OUTPUT --                @SyncErrorFlag = NULL,                      -- bit
                                    ,@Debug = 0;

                                                                          -- smallint

        --								        IF @Debug > 0
        --BEGIN

        --SELECT * FROM [dbo].[MFUserMessages] AS [mum] WHERE [mum].[Update_ID] = @Update_IDOut
        END -- columns exist
		ELSE 
		BEGIN
        Set @DebugText = 'Invalid columns in MFUserMessage Table'
        Set @DebugText = @DefaultDebugText + @DebugText
     
        
        --IF @debug > 0
        --	Begin
        --		RAISERROR(@DebugText,16,1,@ProcedureName,@ProcedureStep );
        --	END
        
		END
        RETURN 1;
    END;
END TRY
BEGIN CATCH
    SET @StartTime = GETUTCDATE();
    SET @LogStatus = 'Failed w/SQL Error';
    SET @LogTextDetail = ERROR_MESSAGE();

    --------------------------------------------------
    -- INSERTING ERROR DETAILS INTO LOG TABLE
    --------------------------------------------------
    INSERT INTO [dbo].[MFLog]
    (
        [SPName]
       ,[ErrorNumber]
       ,[ErrorMessage]
       ,[ErrorProcedure]
       ,[ErrorState]
       ,[ErrorSeverity]
       ,[ErrorLine]
       ,[ProcedureStep]
    )
    VALUES
    (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE()
    ,@ProcedureStep);

    SET @ProcedureStep = 'Catch Error';

    ---------------------------------------------------------------
    ---- Log Error
    ---------------------------------------------------------------   
    --EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
    --                                    ,@ProcessType = @ProcessType
    --                                    ,@LogType = N'Error'
    --                                    ,@LogText = @LogTextDetail
    --                                    ,@LogStatus = @LogStatus
    --                                    ,@debug = @Debug;

    --SET @StartTime = GETUTCDATE();

    --EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
    --                                          ,@LogType = N'Error'
    --                                          ,@LogText = @LogTextDetail
    --                                          ,@LogStatus = @LogStatus
    --                                          ,@StartTime = @StartTime
    --                                          ,@MFTableName = @MFTableName
    --                                          ,@Validation_ID = @Validation_ID
    --                                          ,@ColumnName = NULL
    --                                          ,@ColumnValue = NULL
    --                                          ,@Update_ID = @Update_ID
    --                                          ,@LogProcedureName = @ProcedureName
    --                                          ,@LogProcedureStep = @ProcedureStep
    --                                          ,@debug = 0;

    RETURN -1;
END CATCH;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFAliasesUpsert]';
GO
SET NOCOUNT ON;
EXEC [Setup].[spMFSQLObjectsControl]
    @SchemaName = N'dbo',
    @ObjectName = N'spMFAliasesUpsert', -- nvarchar(100)
    @Object_Release = '3.1.4.41',
    @UpdateFlag = 2;

GO
IF EXISTS
    (
        SELECT
            1
        FROM
            [INFORMATION_SCHEMA].[ROUTINES]
        WHERE
            [ROUTINE_NAME] = 'spMFAliasesUpsert' --name of procedure
            AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
            AND [ROUTINE_SCHEMA] = 'dbo'
    )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFAliasesUpsert]
AS
    SELECT
        'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO
ALTER PROCEDURE [dbo].[spMFAliasesUpsert]
    (
        @MFTableNames    NVARCHAR(400),
        @Prefix          NVARCHAR(10),
        @IsRemove        BIT      = 0,
        @WithUpdate      BIT      = 0,
        @ProcessBatch_ID INT      = NULL OUTPUT,
        @Debug           SMALLINT = 0
    )
AS
/*rST**************************************************************************

=================
spMFAliasesUpsert
=================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableNames nvarchar(400)
    Valid Metadata structure table
  @Prefix nvarchar(10)
    Prefix before name
  @IsRemove bit (optional)
    - Default = 0
    - If 1 then aliases with prefix will be removed.
  @WithUpdate bit
    Set to 1 push updates to M-Files
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode

Purpose
=======

Adding or removing aliases based on prefix.

Additional Info
===============

The following metadata tables include aliases:

- MFClass
- MFProperty
- MFObjectType
- MFValuelist
- MFWorkflow
- MFWorkflowState

The aliases can be synchronized with M-Files.  A switch on the procedure will determine if the update takes place from M-Files or to M-Files.

The following procedures will only update from M-Files to SQL:

- spMFSyncronizeMetadata
- spMFDropAndUpdateMetadata

Use spMFSyncronizeSpecificMetadata to update aliases from SQL to M-Files
Use spMFAliasesUpsert to bulk update aliases in M-Files

Using spMFAliasesUpsert to bulk update aliases
----------------------------------------------
This procedure allows selecting a prefix that would be added for all aliases in the execution. Select one or more of the metadata types that could have aliases.

- If @isRemove is set to 1 then all the aliases in the @MFTablesNames parameter with the set prefix will be removed.
- If @WithUpdate is set to 0 then the aliases will not be pushed into M-Files. This is mainly used to inspect the aliases before updating M-Files.

Suggested naming convensions are: (note that all special characters are removed, spaces are replaced with _)

WorkflowStates
  prefix.Workflow.WorkflowState (The full alias will be restricted to 100 characters)
Classes
  prefix.cl.Class
ObjectType
  prefix.ot.ObjectType
Property, Valuelists
  prefix.p.Name

Prefixes are flexible. For instance, use YourCompany.c.classname for classes, or p.property if you don't want any namespace prefix.
This procedure take approx 2 minutes per metadata table to update

Setting aliases
---------------
When setting aliases in SQL it is handy to use a special function that will remove the spaces and special characters in the name of the object
SET alias = dbo.fnMFReplaceSpecialCharacter(name)

Using aliases in SQL
--------------------
Use aliases when referencing workflow states in SQL procedures.  It is a better practice than using the name of the state.
Note that valuelist items does not have aliases.  However, the connector includes an internally generated unique reference called AppRef.  Use this reference in SQL procedures in the place of aliases.

Examples
========

.. code:: sql

    DECLARE @ProcessBatch_ID INT;
    EXEC [dbo].[spMFAliasesUpsert]
        @MFTableNames = 'MFWorkflowstate',
        @Prefix = 'LS',
        @IsRemove = 0, -- set to 1 to remove all aliases
        @WithUpdate = 1,
        @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
        @Debug = 0

    SELECT * FROM [dbo].[MFProcessBatchDetail] AS [mpbd] WHERE [mpbd].[ProcessBatch_ID] = @ProcessBatch_ID
    SELECT * FROM dbo.MFWorkflowState AS mws

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2017-07-30  LC         Create Procedure
==========  =========  ========================================================

**rST*************************************************************************/

    BEGIN
        SET NOCOUNT ON;

        -------------------------------------------------------------
        -- CONSTANTS: MFSQL Class Table Specific
        -------------------------------------------------------------

        DECLARE @ProcessType AS NVARCHAR(50);

        SET @ProcessType = ISNULL(@ProcessType, 'Create Aliases');

        -------------------------------------------------------------
        -- CONSTATNS: MFSQL Global 
        -------------------------------------------------------------
        DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
        DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
        DECLARE @Process_ID_1_Update TINYINT = 1;
        DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
        DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
        DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
        DECLARE @Process_ID_2_SyncError TINYINT = 2;
        DECLARE @ProcessBatchSize INT = 250;

        -------------------------------------------------------------
        -- VARIABLES: MFSQL Processing
        -------------------------------------------------------------
        DECLARE @Update_ID INT;
        DECLARE @MFLastModified DATETIME;
        DECLARE @Validation_ID INT;

        -------------------------------------------------------------
        -- VARIABLES: T-SQL Processing
        -------------------------------------------------------------
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT = 0;
        DECLARE @error AS INT = 0;

        -------------------------------------------------------------
        -- VARIABLES: DEBUGGING
        -------------------------------------------------------------
        DECLARE @ProcedureName AS NVARCHAR(128) = '[dbo].[spMFAliasesUpsert]';
        DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @Msg AS NVARCHAR(256) = '';
        DECLARE @MsgSeverityInfo AS TINYINT = 10;
        DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
        DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

        -------------------------------------------------------------
        -- VARIABLES: LOGGING
        -------------------------------------------------------------
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = '';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';

        DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
        DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
        DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;

        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;

        DECLARE @count INT = 0;
        DECLARE @Now AS DATETIME = GETDATE();
        DECLARE @StartTime AS DATETIME = GETUTCDATE();
        DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
        DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

        -------------------------------------------------------------
        -- VARIABLES: DYNAMIC SQL
        -------------------------------------------------------------
        DECLARE @sql NVARCHAR(MAX) = N'';
        DECLARE @sqlParam NVARCHAR(MAX) = N'';


        -------------------------------------------------------------
        -- INTIALIZE PROCESS BATCH
        -------------------------------------------------------------
        SET @ProcedureStep = 'Start Logging';

        SET @LogText = 'Processing ' + @ProcedureName;

        EXEC [dbo].[spMFProcessBatch_Upsert]
            @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
            @ProcessType = @ProcessType,
            @LogType = N'Status',
            @LogText = @LogText,
            @LogStatus = N'In Progress',
            @debug = @Debug;


        EXEC [dbo].[spMFProcessBatchDetail_Insert]
            @ProcessBatch_ID = @ProcessBatch_ID,
            @LogType = N'Debug',
            @LogText = @ProcessType,
            @LogStatus = N'Started',
            @StartTime = @StartTime,
            @MFTableName = @MFTableNames,
            @Validation_ID = @Validation_ID,
            @ColumnName = NULL,
            @ColumnValue = NULL,
            @Update_ID = @Update_ID,
            @LogProcedureName = @ProcedureName,
            @LogProcedureStep = @ProcedureStep,
            @ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT, --v38
            @debug = 0;


        BEGIN TRY
            -------------------------------------------------------------
            -- BEGIN PROCESS
            -------------------------------------------------------------
					-----------------------------------------------------------------
	                  -- Checking module access for CLR procedure  
                    ------------------------------------------------------------------
                     EXEC [dbo].[spMFCheckLicenseStatus] 
					      'spMFAliasesUpsert'
						  ,@ProcedureName
						  ,@ProcedureStep
					
            -------------------------------------------------------------
            -- Local declarations
            -------------------------------------------------------------

            --DECLARE @Delimiter NCHAR(1) = ';';
            DECLARE @ValidTableNamesList NVARCHAR(400);
            --DECLARE @NewAlias NVARCHAR(100);

            -------------------------------------------------------------
            -- SETUP VALID META DATA TABLES TO BE INCLUDED
            -------------------------------------------------------------
            SET @ProcedureStep = 'Setup valid metadata tables';

            DECLARE @ValidTableNames AS TABLE
                (
                    [TableName] NVARCHAR(50) NOT NULL
                );
            INSERT INTO @ValidTableNames
                (
                    [TableName]
                )
            VALUES
                (
                    'MFClass'
                ),
                (
                    'MFProperty'
                ),
                (
                    'MFObjectType'
                ),
                (
                    'MFValuelist'
                ),
                (
                    'MFWorkflow'
                ),
                (
                    'MFWorkflowState'
                );

            DECLARE @MetadataList AS TABLE
                (
                    [id]        INT           IDENTITY NOT NULL,
                    [TableName] NVARCHAR(100) NULL,
                    [Metadata]  NVARCHAR(100) NULL
                );

            INSERT INTO @MetadataList
                (
                    [TableName],
                    [Metadata]
                )
                        SELECT
                            LTRIM([ListItem]),
                            REPLACE([ListItem], 'MF', '')
                        FROM
                            [dbo].[fnMFParseDelimitedString](@MFTableNames, ',') AS [fmpds];

            IF @Debug > 0
                SELECT
                    *
                FROM
                    @MetadataList AS [ml];

            -------------------------------------------------------------
            -- vALIDATE TABLE PARAMETERS
            -------------------------------------------------------------
            SET @ProcedureStep = 'Validate input tables';


            SELECT
                @ValidTableNamesList = COALESCE(@ValidTableNamesList + ',', '') + [TableName]
            FROM
                @ValidTableNames AS [vtn];

            IF @Debug > 0
                BEGIN
                    SELECT
                        @ValidTableNamesList;
                    SELECT
                            'invalid' AS [invalids],
                            [ml].[TableName]
                    FROM
                            @MetadataList    AS [ml]
                        LEFT JOIN
                            @ValidTableNames AS [vtn]
                                ON [ml].[TableName] = [vtn].[TableName]
                    WHERE
                            [vtn].[TableName] IS NULL;
                END;

            IF EXISTS
                (
                    SELECT
                            [ml].[TableName]
                    FROM
                            @MetadataList    AS [ml]
                        LEFT JOIN
                            @ValidTableNames AS [vtn]
                                ON [ml].[TableName] = [vtn].[TableName]
                    WHERE
                            [vtn].[TableName] IS NULL
                )
                BEGIN
                    SET @error
                        = '' + @MFTableNames + ' ; Use one or more of the following list: ' + @ValidTableNamesList;
                    SET @DebugText = @DefaultDebugText + 'Invalid TableNames in:%s';



                    SET @LogTypeDetail = 'Validate';
                    SET @LogStatusDetail = 'Error';
                    SET @LogTextDetail = @error;
                    SET @LogColumnName = '';
                    SET @LogColumnValue = '';

                    EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
                        @ProcessBatch_ID = @ProcessBatch_ID,
                        @LogType = @LogTypeDetail,
                        @LogText = @LogTextDetail,
                        @LogStatus = @LogStatusDetail,
                        @StartTime = @StartTime,
                        @MFTableName = @MFTableNames,
                        @Validation_ID = @Validation_ID,
                        @ColumnName = @LogColumnName,
                        @ColumnValue = @LogColumnValue,
                        @Update_ID = @Update_ID,
                        @LogProcedureName = @ProcedureName,
                        @LogProcedureStep = @ProcedureStep,
                        @debug = @Debug;



                    RAISERROR(@DebugText, @MsgSeverityGeneralError, 1, @ProcedureName, @ProcedureStep, @error);

                    RETURN 0;
                END;


            -------------------------------------------------------------
            -- PROCESS INSERT ALIASES FOR EACH METADATA TABLE
            -------------------------------------------------------------


            SET @ProcedureStep = 'Process Aliases';
			 SET @StartTime = GETUTCDATE();

            BEGIN

                DECLARE @RowID INT;
                DECLARE @TableName NVARCHAR(100);
                DECLARE @MetadataName NVARCHAR(100);

                SELECT
                    @RowID = MIN([id])
                FROM
                    @MetadataList AS [ml];

                WHILE @RowID IS NOT NULL
                    BEGIN

                        SELECT
                            @TableName    = [TableName],
                            @MetadataName = [Metadata]
                        FROM
                            @MetadataList AS [ml]
                        WHERE
                            [id] = @RowID;

                        -------------------------------------------------------------
                        -- UPDATE METADATA TABLE
                        -------------------------------------------------------------
                        SET @ProcedureStep = 'Synchronize Metadata';

                        EXEC [dbo].[spMFSynchronizeSpecificMetadata]
                            @Metadata = @MetadataName,
                            @IsUpdate = 0,
                            @Debug = 0;

                        -------------------------------------------------------------
                        -- ADD ALIASES
                        -------------------------------------------------------------
                        SET @ProcedureStep = 'Add Aliases';
                        IF @IsRemove = 0
                            BEGIN

IF @TableName = 'MFWorkflowState'
BEGIN
                            
        UPDATE
            mws
        SET
         mws.alias =   SUBSTRING((@Prefix + '.' + [dbo].[fnMFReplaceSpecialCharacter](mw.Name) + '.' + [dbo].[fnMFReplaceSpecialCharacter](mws.Name)),1,100)
        FROM
            [dbo].[MFWorkflowState] AS mws
			INNER JOIN [dbo].[MFWorkflow] AS mw
			ON [mw].[ID] = [mws].[MFWorkflowID]

        WHERE
            mws.[Alias] = ''  

			SET @SQL = ''

END
IF @TableName <> 'MFWorkflowState'
BEGIN



                                SET @sqlParam = N'@Prefix nvarchar(10), @RowCount int output';
                                SET @sql
                                    = N'
        UPDATE
            [TB]
        SET
            [Alias] = @Prefix + ''.'' + [dbo].[fnMFReplaceSpecialCharacter](Name)
        FROM
            [dbo].' +           QUOTENAME(@TableName) + ' AS [TB]
        WHERE
            [Alias] = ''''
			
				 SET @rowcount = @@ROWCOUNT;

			'    ;

END

			IF @Debug > 0
			PRINT @SQL;
                                EXEC [sp_executesql]
                                    @stmt = @sql,
                                    @param = @sqlParam,
                                    @Prefix = @Prefix,
									@RowCount = @RowCount output;

						

IF @Debug > 0
EXEC ('Select * from ' + @TableName);




                                SET @LogTypeDetail = 'Status';
                                SET @LogStatusDetail = 'Completed';
                                SET @LogTextDetail = 'Added Aliases';
                                SET @LogColumnName = @MetadataName;
                                SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));


                                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
                                    @ProcessBatch_ID = @ProcessBatch_ID,
                                    @LogType = @LogTypeDetail,
                                    @LogText = @LogTextDetail,
                                    @LogStatus = @LogStatusDetail,
                                    @StartTime = @StartTime,
                                    @MFTableName = @MFTableNames,
                                    @Validation_ID = @Validation_ID,
                                    @ColumnName = @LogColumnName,
                                    @ColumnValue = @LogColumnValue,
                                    @Update_ID = @Update_ID,
                                    @LogProcedureName = @ProcedureName,
                                    @LogProcedureStep = @ProcedureStep,
                                    @debug = @Debug;



                                -------------------------------------------------------------
                                -- Re-assign duplicates with sequence number
                                -------------------------------------------------------------
                                SET @ProcedureStep = 'Re-assign duplicates';

								 SET @StartTime = GETUTCDATE();

                                CREATE TABLE [#DuplicateList]
                                    (
                                        [id]        INT,
                                        [Name]      NVARCHAR(100),
                                        [Alias]     NVARCHAR(100),
                                        [Rownumber] INT
                                    );

                                SET @sql
                                    = N'
SELECT id, mp.name,[mp].[Alias], ROW_NUMBER() OVER (PARTITION BY alias ORDER BY id)  FROM [dbo].'
                                      + QUOTENAME(@TableName)
                                      + ' AS [mp] WHERE alias IN (
SELECT listitem  FROM [dbo].' + QUOTENAME(@TableName)
                                      + ' AS [mp]
CROSS APPLY [dbo].[fnMFParseDelimitedString](mp.Alias,'';'') AS [fmpds]
GROUP BY [fmpds].[ListItem]
HAVING COUNT(*) > 1 ) '         ;

                                INSERT INTO [#DuplicateList]
                                    (
                                        [id],
                                        [Name],
                                        [Alias],
                                        [Rownumber]
                                    )
                                EXEC (@sql);

IF @Debug > 0
SELECT * FROM [#DuplicateList] AS [dl];


                                SET @sql = N'
SELECT * FROM #DuplicateList AS [dl]
INNER JOIN [dbo].' +            QUOTENAME(@TableName) + ' AS [mp]
ON dl.id = mp.[ID]'             ;

                                EXEC (@sql);

                                SET @rowcount = @@ROWCOUNT;

                                SET @LogTypeDetail = 'Status';
                                SET @LogStatusDetail = 'Completed';
                                SET @LogTextDetail = 'Renamed Duplicate Aliases';
                                SET @LogColumnName = @MetadataName;
                                SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));


                                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
                                    @ProcessBatch_ID = @ProcessBatch_ID,
                                    @LogType = @LogTypeDetail,
                                    @LogText = @LogTextDetail,
                                    @LogStatus = @LogStatusDetail,
                                    @StartTime = @StartTime,
                                    @MFTableName = @MFTableNames,
                                    @Validation_ID = @Validation_ID,
                                    @ColumnName = @LogColumnName,
                                    @ColumnValue = @LogColumnValue,
                                    @Update_ID = @Update_ID,
                                    @LogProcedureName = @ProcedureName,
                                    @LogProcedureStep = @ProcedureStep,
                                    @debug = @Debug;

                            END; --End add aliases

                        -------------------------------------------------------------
                        -- REMOVE ALIASSES BASED ON PREFIX
                        -------------------------------------------------------------
                        IF @IsRemove = 1
                            BEGIN

								 SET @StartTime = GETUTCDATE();
                                SET @ProcedureStep = 'Remove aliasses';

                                CREATE TABLE [#RemovalList]
                                    (
                                        [id]          INT,
                                        [Name]        NVARCHAR(100),
                                        [AliasString] NVARCHAR(100),
                                        [Alias]       NVARCHAR(100)
                                    );

                                SET @sqlParam = N'@Prefix nvarchar(10)';
                                SET @sql
                                    = N'SELECT [mp].[ID],
       [mp].[Name],
       [mp].[Alias],
     
       [fmpds].[ListItem] FROM ' + @TableName
                                      + ' AS [mp]
CROSS APPLY [dbo].[fnMFParseDelimitedString](Alias,'';'') AS [fmpds]
'                               ;



                                INSERT INTO [#RemovalList]
                                    (
                                        [id],
                                        [Name],
                                        [AliasString],
                                        [Alias]
                                    )
                                EXEC (@sql);

                                SET @sql
                                    = N'
UPDATE mp
SET alias =  REPLACE(rl.Alias,mp.alias,'''') FROM #RemovalList AS [rl] 
INNER JOIN ' +                  QUOTENAME(@TableName) + ' mp
ON mp.id = rl.id
WHERE rl.alias LIKE (@Prefix + ''%'')';

                                EXEC [sp_executesql]
                                    @stmt = @sql,
                                    @param = @sqlParam,
                                    @Prefix = @Prefix;

                                SET @rowcount = @@ROWCOUNT;

                                SET @LogTypeDetail = 'Status';
                                SET @LogStatusDetail = 'Completed';
                                SET @LogTextDetail = 'Removed Aliases';
                                SET @LogColumnName = @MetadataName;
                                SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));


                                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
                                    @ProcessBatch_ID = @ProcessBatch_ID,
                                    @LogType = @LogTypeDetail,
                                    @LogText = @LogTextDetail,
                                    @LogStatus = @LogStatusDetail,
                                    @StartTime = @StartTime,
                                    @MFTableName = @MFTableNames,
                                    @Validation_ID = @Validation_ID,
                                    @ColumnName = @LogColumnName,
                                    @ColumnValue = @LogColumnValue,
                                    @Update_ID = @Update_ID,
                                    @LogProcedureName = @ProcedureName,
                                    @LogProcedureStep = @ProcedureStep,
                                    @debug = @Debug;
                            END;

                        -------------------------------------------------------------
                        -- UPDATE M-FILES
                        -------------------------------------------------------------

                        SET @ProcedureStep = 'Update M-Files';
						 SET @StartTime = GETUTCDATE();
                        --	SELECT @Count = COUNT(*) FROM  
                        IF @WithUpdate = 1
                            EXEC [dbo].[spMFSynchronizeSpecificMetadata]
                                @Metadata = @MetadataName,
                                @IsUpdate = 1;

                        SET @rowcount = @@ROWCOUNT;

                        SET @LogTypeDetail = 'Status';
                        SET @LogStatusDetail = 'Completed';
                        SET @LogTextDetail = 'spMFSynchronizeSpecificMetadata with IsUpdate = 1';
                        SET @LogColumnName = @TableName;
                        SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));


                        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
                            @ProcessBatch_ID = @ProcessBatch_ID,
                            @LogType = @LogTypeDetail,
                            @LogText = @LogTextDetail,
                            @LogStatus = @LogStatusDetail,
                            @StartTime = @StartTime,
                            @MFTableName = @TableName,
                            @Validation_ID = @Validation_ID,
                            @ColumnName = @LogColumnName,
                            @ColumnValue = @LogColumnValue,
                            @Update_ID = @Update_ID,
                            @LogProcedureName = @ProcedureName,
                            @LogProcedureStep = @ProcedureStep,
                            @debug = @Debug;

                        SELECT
                            @RowID = MIN([id])
                        FROM
                            @MetadataList AS [ml]
                        WHERE
                            [id] > @RowID;
                    
					IF OBJECT_ID('tempdb..#DuplicateList') IS NOT NULL
					    DROP TABLE #DuplicateList;
					IF OBJECT_ID('tempdb..#RemovalList') IS NOT NULL
                        DROP TABLE #RemovalList;

                    END; -- end while 
            END; -- end raiseerror invalid name

            -------------------------------------------------------------
            --END PROCESS
            -------------------------------------------------------------


            END_RUN:
            SET @ProcedureStep = 'End';
            SET @LogStatus = 'Completed';
            -------------------------------------------------------------
            -- Log End of Process
            -------------------------------------------------------------   

            EXEC [dbo].[spMFProcessBatch_Upsert]
                @ProcessBatch_ID = @ProcessBatch_ID,
                @ProcessType = @ProcessType,
                @LogType = N'Message',
                @LogText = @LogText,
                @LogStatus = @LogStatus,
                @debug = @Debug;

            SET @StartTime = GETUTCDATE();

            EXEC [dbo].[spMFProcessBatchDetail_Insert]
                @ProcessBatch_ID = @ProcessBatch_ID,
                @LogType = N'Debug',
                @LogText = @ProcessType,
                @LogStatus = @LogStatus,
                @StartTime = @StartTime,
                @MFTableName = @MFTableNames,
                @Validation_ID = @Validation_ID,
                @ColumnName = NULL,
                @ColumnValue = NULL,
                @Update_ID = @Update_ID,
                @LogProcedureName = @ProcedureName,
                @LogProcedureStep = @ProcedureStep,
                @debug = 0;
            RETURN 1;
        END TRY
        BEGIN CATCH
            SET @StartTime = GETUTCDATE();
            SET @LogStatus = 'Failed w/SQL Error';
            SET @LogTextDetail = ERROR_MESSAGE();

            --------------------------------------------------
            -- INSERTING ERROR DETAILS INTO LOG TABLE
            --------------------------------------------------
            INSERT INTO [dbo].[MFLog]
                (
                    [SPName],
                    [ErrorNumber],
                    [ErrorMessage],
                    [ErrorProcedure],
                    [ErrorState],
                    [ErrorSeverity],
                    [ErrorLine],
                    [ProcedureStep]
                )
            VALUES
                (
                    @ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(),
                    ERROR_SEVERITY(), ERROR_LINE(), @ProcedureStep
                );

            SET @ProcedureStep = 'Catch Error';
            -------------------------------------------------------------
            -- Log Error
            -------------------------------------------------------------   
            EXEC [dbo].[spMFProcessBatch_Upsert]
                @ProcessBatch_ID = @ProcessBatch_ID,
                @ProcessType = @ProcessType,
                @LogType = N'Error',
                @LogText = @LogTextDetail,
                @LogStatus = @LogStatus,
                @debug = @Debug;

            SET @StartTime = GETUTCDATE();

            EXEC [dbo].[spMFProcessBatchDetail_Insert]
                @ProcessBatch_ID = @ProcessBatch_ID,
                @LogType = N'Error',
                @LogText = @LogTextDetail,
                @LogStatus = @LogStatus,
                @StartTime = @StartTime,
                @MFTableName = @MFTableNames,
                @Validation_ID = @Validation_ID,
                @ColumnName = NULL,
                @ColumnValue = NULL,
                @Update_ID = @Update_ID,
                @LogProcedureName = @ProcedureName,
                @LogProcedureStep = @ProcedureStep,
                @debug = 0;

            RETURN -1;
        END CATCH;

    END;

GO

PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFCreateAllLookups]';
GO

SET NOCOUNT ON;

EXEC [Setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFCreateAllLookups' -- nvarchar(100)
                                    ,@Object_Release = '4.2.8.48'
                                    ,@UpdateFlag = 2;
GO

/*------------------------------------------------------------------------------------------------
	Author: RemoteSQL
	Create date: 10/12/2017 16:29
	Database: 
	Description: Prodecedure to create all workflow and Valuelist lookups that is used in the included in App class tables

															
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  
-----------------------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFCreateAllLookups' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFCreateAllLookups]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFCreateAllLookups]
(
    @ProcessBatch_ID INT = NULL OUTPUT
   ,@Schema NVARCHAR(20) = 'dbo'
   ,@IncludeInApp INT = 1
   ,@WithMetadataSync BIT = 0
   ,@Debug SMALLINT = 0
)
AS
/*rST**************************************************************************

====================
spMFCreateAllLookups
====================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Schema nvarchar(20)
    - Default = 'dbo'
    - Which schema to operate on
  @IncludeInApp int (optional)
    - Default = 1
  @WithMetadataSync bit (optional)
    - Default = 0
    - 1 = call spMFDropAndUpdateMetadata internally
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

Prodecedure to create all workflow and Valuelist lookups that is used in the included in App class tables

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-01-30  LC         Valuelist name: Source Does not exist or is a duplicate
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -------------------------------------------------------------
    -- CONSTANTS: MFSQL Class Table Specific
    -------------------------------------------------------------
    DECLARE @MFTableName AS NVARCHAR(128) = 'MFValuelist';
    DECLARE @ProcessType AS NVARCHAR(50);

    SET @ProcessType = ISNULL(@ProcessType, 'Create Lookups');

    -------------------------------------------------------------
    -- CONSTATNS: MFSQL Global 
    -------------------------------------------------------------
    DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
    DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
    DECLARE @Process_ID_1_Update TINYINT = 1;
    DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
    DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
    DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
    DECLARE @Process_ID_2_SyncError TINYINT = 2;
    DECLARE @ProcessBatchSize INT = 250;

    -------------------------------------------------------------
    -- VARIABLES: MFSQL Processing
    -------------------------------------------------------------
    DECLARE @Update_ID INT;
    DECLARE @MFLastModified DATETIME;
    DECLARE @Validation_ID INT;

    -------------------------------------------------------------
    -- VARIABLES: T-SQL Processing
    -------------------------------------------------------------
    DECLARE @rowcount AS INT = 0;
    DECLARE @return_value AS INT = 0;
    DECLARE @error AS INT = 0;

    -------------------------------------------------------------
    -- VARIABLES: DEBUGGING
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = '[dbo].[spMFCreateAllLookups]';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @DebugText AS NVARCHAR(256) = '';
    DECLARE @Msg AS NVARCHAR(256) = '';
    DECLARE @MsgSeverityInfo AS TINYINT = 10;
    DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
    DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

    -------------------------------------------------------------
    -- VARIABLES: LOGGING
    -------------------------------------------------------------
    DECLARE @LogType AS NVARCHAR(50) = 'Status';
    DECLARE @LogText AS NVARCHAR(4000) = '';
    DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
    DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
    DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
    DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
    DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
    DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
    DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
    DECLARE @count INT = 0;
    DECLARE @Now AS DATETIME = GETDATE();
    DECLARE @StartTime AS DATETIME = GETUTCDATE();
    DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
    DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

    -------------------------------------------------------------
    -- VARIABLES: DYNAMIC SQL
    -------------------------------------------------------------
    DECLARE @sql NVARCHAR(MAX) = N'';
    DECLARE @sqlParam NVARCHAR(MAX) = N'';

    -------------------------------------------------------------
    -- INTIALIZE PROCESS BATCH
    -------------------------------------------------------------
    SET @ProcedureStep = 'Start Logging';
    SET @LogText = 'Processing ' + @ProcedureName;

    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Status'
                                        ,@LogText = @LogText
                                        ,@LogStatus = N'In Progress'
                                        ,@debug = @Debug;

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Debug'
                                              ,@LogText = @ProcessType
                                              ,@LogStatus = N'Started'
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                              ,@debug = 0;

    BEGIN TRY
        -------------------------------------------------------------
        -- BEGIN PROCESS
        -------------------------------------------------------------

        -------------------------------------------------------------
        -- CUSTOM VARIABLES
        -------------------------------------------------------------
        DECLARE @Lookuplist AS TABLE
        (
            [Rowid] INT IDENTITY
           ,[id] INT
           ,[Name] NVARCHAR(100)
        );

        DECLARE @RowID INT;
        DECLARE @LookupName NVARCHAR(100);
        DECLARE @ViewName NVARCHAR(100);

        -------------------------------------------------------------
        -- UPDATE WORKFLOWS AND VALUELISTS
        -------------------------------------------------------------
        SET @ProcedureStep = 'Update from M-Files';

        IF @WithMetadataSync = 1
        BEGIN
            EXEC [dbo].[spMFDropAndUpdateMetadata] @IsResetAll = 0
                                                  ,@IsStructureOnly = 0
                                                  ,@ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@Debug = 0;
        END;

        -------------------------------------------------------------
        -- GET WORKFLOWS
        -------------------------------------------------------------
        SET @ProcedureStep = 'Get Workflows to include';
        SET @MFTableName = 'MFWorkflow';

        MERGE INTO @Lookuplist AS [t]
        USING
        (
            SELECT DISTINCT
                   [mc].[MFWorkflow_ID]
                  ,[mw].[Name]
            FROM [INFORMATION_SCHEMA].[COLUMNS]    AS [c]
                INNER JOIN [dbo].[MFProperty]      AS [mp]
                    ON [mp].[ColumnName] = [c].[COLUMN_NAME]
                INNER JOIN [dbo].[MFClassProperty] AS [mcp]
                    ON [mcp].[MFProperty_ID] = [mp].[ID]
                INNER JOIN [dbo].[MFClass]         AS [mc]
                    ON [mc].[ID] = [mcp].[MFClass_ID]
                INNER JOIN [dbo].[MFWorkflow]      AS [mw]
                    ON [mw].[ID] = [mc].[MFWorkflow_ID]
            WHERE [c].[TABLE_NAME] IN (
                                          SELECT [TableName] FROM [dbo].[MFClass] WHERE [IncludeInApp] IS NOT NULL
                                      )
                  AND [mp].[MFDataType_ID] IN ( 8, 9 )
                  AND [mp].[MFID] > 1000
        ) AS [s]
        ON [t].[id] = [s].[MFWorkflow_ID]
        WHEN NOT MATCHED THEN
            INSERT
            (
                [id]
               ,[Name]
            )
            VALUES
            ([s].[MFWorkflow_ID], [s].[Name]);

        IF @Debug > 0
            SELECT *
            FROM @Lookuplist AS [l];

        -------------------------------------------------------------
        -- CREATE WORKFLOW LOOKUPS
        -------------------------------------------------------------
        SET @ProcedureStep = 'Create workflow lookups';

        SELECT @RowID = MIN([l].[Rowid])
        FROM @Lookuplist AS [l];

        WHILE @RowID IS NOT NULL
        BEGIN
            SELECT @LookupName = [l].[Name]
                  ,@ViewName   = 'WFvw' + [dbo].[fnMFReplaceSpecialCharacter]([l].[Name])
            FROM @Lookuplist AS [l]
            WHERE [l].[Rowid] = @RowID;

			
            IF NOT EXISTS
            (
                SELECT 1
                FROM [INFORMATION_SCHEMA].[TABLES] AS [t]
                WHERE [t].[TABLE_TYPE] = 'VIEW'
                      AND [t].[TABLE_NAME] = @ViewName
            )
            BEGIN

            EXEC [dbo].[spMFCreateWorkflowStateLookupView] @WorkflowName = @LookupName
                                                          ,@ViewName = @ViewName
                                                          ,@Schema = @Schema
                                                          ,@Debug = 0;

            SET @LogTypeDetail = 'Status';
            SET @LogStatusDetail = 'In Progress';
            SET @LogTextDetail = 'Created Workflow View ' + @Schema + '.' + @ViewName;
            SET @LogColumnName = @LookupName;
            SET @LogColumnValue = '';

            EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                         ,@LogType = @LogTypeDetail
                                                                         ,@LogText = @LogTextDetail
                                                                         ,@LogStatus = @LogStatusDetail
                                                                         ,@StartTime = @StartTime
                                                                         ,@MFTableName = @MFTableName
                                                                         ,@Validation_ID = @Validation_ID
                                                                         ,@ColumnName = @LogColumnName
                                                                         ,@ColumnValue = @LogColumnValue
                                                                         ,@Update_ID = @Update_ID
                                                                         ,@LogProcedureName = @ProcedureName
                                                                         ,@LogProcedureStep = @ProcedureStep          
			                                                            ,@debug = @Debug;
END;

            SELECT @RowID = MIN([l].[Rowid])
            FROM @Lookuplist AS [l]
            WHERE [l].[Rowid] > @RowID;
        END;

        -------------------------------------------------------------
        -- GET VALUELISTS
        -------------------------------------------------------------
        SET @ProcedureStep = 'Get Valuelists to include';
        SET @MFTableName = 'MFValuelist';

        DELETE FROM @Lookuplist;

        MERGE INTO @Lookuplist AS [t]
        USING
        (
            SELECT DISTINCT
                   [mvl].[ID]
                  ,[mvl].[Name]
            FROM [INFORMATION_SCHEMA].[COLUMNS]    AS [c]
                INNER JOIN [dbo].[MFProperty]      AS [mp]
                    ON [mp].[ColumnName] = [c].[COLUMN_NAME]
                INNER JOIN [dbo].[MFClassProperty] AS [mcp]
                    ON [mcp].[MFProperty_ID] = [mp].[ID]
                INNER JOIN [dbo].[MFValueList]     AS [mvl]
                    ON [mvl].[ID] = [mp].[MFValueList_ID]
            WHERE [c].[TABLE_NAME] IN (
                                          SELECT [TableName] FROM [dbo].[MFClass] WHERE [IncludeInApp] IS NOT NULL
                                      )
                  AND [mp].[MFDataType_ID] IN ( 8, 9 )
                  AND [mp].[MFID] > 1000
        ) AS [s]
        ON [t].[id] = [s].[ID]
        WHEN NOT MATCHED THEN
            INSERT
            (
                [id]
               ,[Name]
            )
            VALUES
            ([s].[ID], [s].[Name]);

        IF @Debug > 0
            SELECT *
            FROM @Lookuplist AS [l];

        -------------------------------------------------------------
        -- CREATE VALUELIST LOOKUPS
        -------------------------------------------------------------
        SET @ProcedureStep = 'Create valuelist lookups';

        SELECT @RowID = MIN([l].[Rowid])
        FROM @Lookuplist AS [l];

        WHILE @RowID IS NOT NULL
        BEGIN
            SELECT @LookupName = [l].[Name]
                  ,@ViewName   = 'VLvw' + [dbo].[fnMFReplaceSpecialCharacter]([l].[Name])
            FROM @Lookuplist AS [l]
            WHERE [l].[Rowid] = @RowID;

            IF NOT EXISTS
            (
                SELECT 1
                FROM [INFORMATION_SCHEMA].[TABLES] AS [t]
                WHERE [t].[TABLE_TYPE] = 'VIEW'
                      AND [t].[TABLE_NAME] = @ViewName
            )
            BEGIN
                EXEC [dbo].[spMFCreateValueListLookupView] @ValueListName = @LookupName
                                                          ,@ViewName = @ViewName
                                                          ,@Schema = @Schema
                                                          ,@Debug = 0;

                SET @LogTypeDetail = 'Status';
                SET @LogStatusDetail = 'In Progress';
                SET @LogTextDetail = 'Created Valuelist View ' + @Schema + '.' + @ViewName;
                SET @LogColumnName = @LookupName;
                SET @LogColumnValue = '';

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = @Debug;
            END;

            SELECT @RowID = MIN([l].[Rowid])
            FROM @Lookuplist AS [l]
            WHERE [l].[Rowid] > @RowID;
        END;

        -------------------------------------------------------------
        --END PROCESS
        -------------------------------------------------------------
        END_RUN:
        SET @ProcedureStep = 'End';

        -------------------------------------------------------------
        -- Log End of Process
        -------------------------------------------------------------   
        SET @LogStatus = 'Completed';

        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Message'
                                            ,@LogText = @LogText
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Debug'
                                                  ,@LogText = @ProcessType
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN 1;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFSearchForObjectbyPropertyValues]';
go
 

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'spMFSearchForObjectbyPropertyValues', -- nvarchar(100)
    @Object_Release = '4.3.9.49', -- varchar(50)
    @UpdateFlag = 2 -- smallint
 
go

IF EXISTS ( SELECT  1
            FROM   information_schema.Routines
            WHERE   ROUTINE_NAME = 'spMFSearchForObjectbyPropertyValues'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
BEGIN
	PRINT SPACE(10) + '...Stored Procedure: update'
    SET NOEXEC ON
END
ELSE
	PRINT SPACE(10) + '...Stored Procedure: create'
go
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFSearchForObjectbyPropertyValues]
AS
       SELECT   'created, but not implemented yet.'--just anything will do

go
-- the following section will be always executed
SET NOEXEC OFF
go

ALTER PROCEDURE [dbo].[spMFSearchForObjectbyPropertyValues] (@ClassID         [INT]
                                                              ,@PropertyIds    [NVARCHAR](2000)
                                                              ,@PropertyValues [NVARCHAR](2000)
                                                              ,@Count          [INT]
                                                              ,@OutputType int
                                                              ,@IsEqual int=0
                                                              ,@XMLOutPut xml output
                                                              ,@TableName varchar(200)='' output)
AS
/*rST**************************************************************************

===================================
spMFSearchForObjectbyPropertyValues
===================================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ClassID int
    ID of the class
  @PropertyIds nvarchar(2000)
    Property ID’s separated by comma
  @PropertyValues nvarchar(2000)
    Property values separated by comma
  @Count int
    The maximum number of results to return
  @OutputType int
    - 0 = output to XML (default)
    - 1 = output to temporary table and update MFSearchLog
  @XMLOutPut xml (output)
    Used if outputType = 0 then this parameter returns the result in XML format
  @TableName varchar(200) (output)
    Used if outputType = 1 then this parameter returns the name of the temporary file with the result

Purpose
=======

To search for objects with class id and some specific property id and value.

Additional Info
===============

This procedure will call spMFSearchForObjectByPropertyValuesInternal and get the objects details that satisfies the search conditions and shows the objects details in tabular format.

Examples
========

.. code:: sql

    DECLARE @RC INT
    DECLARE @ClassID INT
    DECLARE @PropertyIds NVARCHAR(2000)
    DECLARE @PropertyValues NVARCHAR(2000)
    DECLARE @Count INT
    DECLARE @OutputType INT
    DECLARE @XMLOutPut XML
    DECLARE @TableName VARCHAR(200)

    -- TODO: Set parameter values here.
    EXECUTE @RC = [dbo].[spMFSearchForObjectbyPropertyValues]
       @ClassID
      ,@PropertyIds
      ,@PropertyValues
      ,@Count
      ,@OutputType
      ,@XMLOutPut OUTPUT
      ,@TableName OUTPUT
    GO

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-08-13  LC         Added Additional option for search procedure
2019-05-08  LC         Change target table to a temporary table
2018-04-04  DEV2       Added License module validation code.
2016-09-26  DEV2       Removed vault settings parameters and pass them as comma separated string in @VaultSettings parameters.
2016-08-27  LC         Update variable function paramaters
2016-08-24  DEV2       TaskID 471
2014-04-29  DEV2       RETURN statement added
==========  =========  ========================================================

**rST*************************************************************************/
  BEGIN
      BEGIN TRY
          BEGIN TRANSACTION
		SET NOCOUNT ON
          -----------------------------------------------------
          --DECLARE LOCAL VARIABLE
          -----------------------------------------------------
          DECLARE @Xml             [NVARCHAR](MAX)
                  ,@IsFound        BIT
                  ,@VaultSettings  NVARCHAR(4000)
                  ,@XMLDoc         XML
                  ,@Columns        NVARCHAR(MAX)
                  ,@Query          NVARCHAR(MAX)

          -----------------------------------------------------
          --ACCESS CREDENTIALS
          -----------------------------------------------------
          

		  SELECT @VaultSettings=dbo.FnMFVaultSettings()

		-----------------------------------------------------------------
	    -- Checking module access for CLR procdure  spMFSearchForObjectByPropertyValuesInternal
		------------------------------------------------------------------
		EXEC [dbo].[spMFCheckLicenseStatus] 
		   'spMFSearchForObjectByPropertyValuesInternal'
		   ,'spMFSearchForObjectbyPropertyValues'
		   ,'Checking module access for CLR procdure spMFSearchForObjectByPropertyValuesInternal
'
          
          -----------------------------------------------------
          -- CLASS WRAPPER PROCEDURE
          -----------------------------------------------------
          EXEC dbo.spMFSearchForObjectByPropertyValuesInternal
             @VaultSettings
            ,@ClassID
            ,@PropertyIds
            ,@PropertyValues
            ,@Count
			,@IsEqual
            ,@Xml OUTPUT
            ,@IsFound OUTPUT

          IF ( @IsFound = 1 )
            BEGIN
                SELECT @XMLDoc = @Xml

                -----------------------------------------------------
                --CREATE TEMPORARY TABLE STORE DATA FROM XML
                -----------------------------------------------------
                CREATE TABLE #Properties
                  (
                     [objectId]       [INT]
                     ,[propertyId]    [INT] NULL
                     ,[propertyValue] [NVARCHAR](100) NULL
                     ,[propertyName]  [NVARCHAR](100) NULL
                     ,[dataType]      [NVARCHAR](100) NULL
                  )

                -----------------------------------------------------
                -- INSERT DATA FROM XML
                -----------------------------------------------------
                INSERT INTO #Properties
                            (objectId,
                             propertyId,
                             propertyValue,
                             dataType)
                SELECT t.c.value('(../@objectId)[1]', 'INT')              AS objectId
                       ,t.c.value('(@propertyId)[1]', 'INT')              AS propertyId
                       ,t.c.value('(@propertyValue)[1]', 'NVARCHAR(100)') AS propertyValue
                       ,t.c.value('(@dataType)[1]', 'NVARCHAR(1000)')     AS dataType
                FROM   @XMLDoc.nodes('/form/Object/properties')AS t(c)

                ----------------------------------------------------------------------
                -- UPDATE PROPERTY NAME WITH COLUMN NAME SPECIFIED IN MFProperty TABLE
                ----------------------------------------------------------------------				
                UPDATE #Properties
                SET    propertyName = ( SELECT ColumnName
                                        FROM   dbo.MFProperty
                                        WHERE  MFID = #Properties.propertyId )

                UPDATE #Properties
                SET    propertyName = Replace(propertyName, '_ID', '')
                WHERE  dataType = 'MFDatatypeLookup'
                    OR dataType = 'MFDatatypeMultiSelectLookup'

                -----------------------------------------------------
                ---------------PIVOT--------------------------
                -----------------------------------------------------
                SELECT @Columns = Stuff(( SELECT ',' + Quotename(propertyName)
                                          FROM   #Properties ppt
                                          GROUP  BY ppt.propertyName
                                          ORDER  BY ppt.propertyName
                                          FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

				------------------------------------------
				 --This code gets name of new table.
				------------------------------------------
				if @OutputType!=0 
				Begin
					Select @TableName=dbo.fnMFVariableTableName('##MFSearch', Default)
				End

                ----------------------------------
                --creating dynamic query for PIVOT
                ----------------------------------
                SET @Query = 'SELECT objectId
								,' + @Columns
                                + ' into '+@TableName+'
						FROM   ( SELECT objectId
										,propertyName new_col
										,value
								 FROM   #Properties
										UNPIVOT ( value
												FOR col IN (propertyValue) ) un ) src
							   PIVOT ( Max(value)
									 FOR new_col IN ( ' + @Columns
                                + ' ) ) p '


                --EXECUTE (@Query)

				 if @OutputType!=0
					begin
						EXECUTE (@Query)
						insert into MFSearchLog(TableName,SearchClassID,SearchText,SearchDate,ProcessID)
						values(@TableName,@ClassID,'PropertyIds:'+@PropertyIds+' PropertyValues:'+@PropertyValues,GETDATE(),2)
						
					End
				else
					Begin
						select @XMLOutPut= @Xml
					End

				
                DROP TABLE #Properties
            END
          ELSE
            BEGIN
                ----------------------------------
                --Showing not Found message
                ----------------------------------
                DECLARE @Output NVARCHAR(MAX)

                SET @Output = 'Object not exists in this vault'

                SELECT @Output
            END

          COMMIT TRANSACTION

		  RETURN 1
      END TRY

      BEGIN CATCH
          ROLLBACK TRANSACTION

          --------------------------------------------------
          -- INSERTING ERROR DETAILS INTO LOG TABLE
          --------------------------------------------------
          INSERT INTO MFLog
                      (SPName,
                       ErrorNumber,
                       ErrorMessage,
                       ErrorProcedure,
                       ErrorState,
                       ErrorSeverity,
                       ErrorLine,
                       ProcedureStep)
          VALUES      ('spMFSearchForObjectbyPropertyValues',
                       Error_number(),
                       Error_message(),
                       Error_procedure(),
                       Error_state(),
                       Error_severity(),
                       Error_line(),
                       '')
		RETURN 2
	  END CATCH
  END



go
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFObjectTypeUpdateClassIndex]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFObjectTypeUpdateClassIndex' -- nvarchar(100)
                                    ,@Object_Release = '4.2.7.47'                    -- varchar(50)
                                    ,@UpdateFlag = 2;                                -- smallint
GO

/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-04
	Description: Performs Insert Update for ObjectTypeClassIndex table.  only classes included in app will be updated. 
	 
	Use xxxx procedure to dinamically build a view on all the related class tables.
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	2017-11-23		lc			localization of MF-LastModified and MFLastModified by
	2018-12-15		lc			bug with last modified date; add option to set objecttype
	2018-13-21		LC			add feature to get reference of all objects in Vault
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====

  EXEC [spMFObjectTypeUpdateClassIndex]   @Debug = 0
  
-----------------------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFObjectTypeUpdateClassIndex' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFObjectTypeUpdateClassIndex]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROC [dbo].[spMFObjectTypeUpdateClassIndex]
    @IsAllTables BIT = 0
   ,@Debug SMALLINT = 0
AS
SET NOCOUNT ON;

BEGIN
    DECLARE @result        INT
           ,@ClassName     NVARCHAR(100)
           ,@TableName     NVARCHAR(100)
           ,@id            INT
           ,@schema        NVARCHAR(5)  = 'dbo'
           ,@SQL           NVARCHAR(MAX)
           ,@ObjectType    VARCHAR(100)
           ,@ObjectTypeID  INT
           ,@ProcessStep   sysname      = 'START'
           ,@ProcedureName sysname      = 'spMFObjectTypeUpdateClassIndex';

    --SELECT * FROM [dbo].[MFClass] AS [mc]
    --SELECT * FROM [dbo].[MFObjectType] AS [mot]
    IF @Debug > 0
    BEGIN
        RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcessStep);
    END;

    -------------------------------------------------------------
    --	Set all tables to be included
    -------------------------------------------------------------
    IF @IsAllTables = 1
        UPDATE [dbo].[MFClass]
        SET [IncludeInApp] = 10
        WHERE [IncludeInApp] IS NULL;

    -------------------------------------------------------------
    -- Get objvers
    -------------------------------------------------------------
    DECLARE @RowID INT = 1;
    DECLARE @outPutXML NVARCHAR(MAX);
    DECLARE @Idoc INT;
    DECLARE @Class_ID INT;

    WHILE @RowID IS NOT NULL
    BEGIN
        SELECT @id           = [mc].[ID]
              ,@Class_ID     = [mc].[MFID]
              ,@ClassName    = [mc].[Name]
              ,@TableName    = [mc].[TableName]
              ,@ObjectTypeID = [mot].[MFID]
        FROM [dbo].[MFClass]                [mc]
            INNER JOIN [dbo].[MFObjectType] AS [mot]
                ON [mc].[MFObjectType_ID] = [mot].[ID]
        WHERE [mc].[ID] = @RowID
              AND [mc].[IncludeInApp] IS NOT NULL;



        IF @id IS NOT NULL
        BEGIN
            EXEC [dbo].[spMFGetObjectvers] @TableName = @TableName         -- nvarchar(100)
                                          ,@dtModifiedDate = NULL          -- datetime
                                          ,@MFIDs = NULL                   -- nvarchar(4000)
                                          ,@outPutXML = @outPutXML OUTPUT; -- nvarchar(max)

            EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @outPutXML;

            MERGE INTO [dbo].[MFObjectTypeToClassObject] [t]
            USING
            (
                SELECT [xmlfile].[objId]
                      ,[xmlfile].[MFVersion]
                      ,[xmlfile].[GUID]
                      ,[xmlfile].[ObjectType_ID]
                FROM
                    OPENXML(@Idoc, '/form/objVers', 1)
                    WITH
                    (
                        [objId] INT './@objectID'
                       ,[MFVersion] INT './@version'
                       ,[GUID] NVARCHAR(100) './@objectGUID'
                       ,[ObjectType_ID] INT './@objectType'
                    ) [xmlfile]
            ) [s]
            ON [t].[ObjectType_ID] = [s].[ObjectType_ID]
               AND [t].[Object_MFID] = [s].[objId]
			   AND t.[Class_ID] = @Class_ID
            WHEN NOT MATCHED THEN
                INSERT
                (
                    [ObjectType_ID]
                   ,[Class_ID]
                   ,[Object_MFID]
                )
                VALUES
                ([s].[ObjectType_ID], @Class_ID, [s].[objId]);

            EXEC [sys].[sp_xml_removedocument] @Idoc;
        END;

        SET @RowID =
        (
            SELECT MIN([mc].[ID])
            FROM [dbo].[MFClass] [mc]
            WHERE [mc].[ID] > @RowID
                  AND [mc].[IncludeInApp] IS NOT NULL
        );
    END;

    /****************************Get all class and object type tables to be included*/
    DECLARE [CursorTable] CURSOR LOCAL FAST_FORWARD FOR
    SELECT [mc].[MFID]
          ,[mc].[Name]
          ,[mc].[TableName]
          ,[mot].MFID AS [MFObjectType_ID]
    FROM [dbo].[MFClass] AS [mc]
	INNER JOIN [dbo].[MFObjectType] AS [mot]
	ON mc.[MFObjectType_ID] = mot.id
    WHERE [mc].[IncludeInApp] IS NOT NULL
    ORDER BY [mc].[ID] ASC;

    -------------------------------------------------------------
    -- update object table using TableAudit with all objects
    -------------------------------------------------------------
    OPEN [CursorTable];

    FETCH NEXT FROM [CursorTable]
    INTO @id
        ,@ClassName
        ,@TableName
        ,@ObjectTypeID;

    WHILE @@Fetch_Status = 0
    BEGIN
        IF @Debug > 0
        BEGIN
            SELECT @id
                  ,@ClassName
                  ,@TableName
                  ,@ObjectTypeID;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM [INFORMATION_SCHEMA].[TABLES]
            WHERE [TABLE_NAME] = @TableName
                  AND [TABLE_SCHEMA] = @schema
        )
        BEGIN
            BEGIN
                DECLARE @lastModifiedColumn NVARCHAR(100);

                SELECT @lastModifiedColumn = [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [mp].[MFID] = 21; --'Last Modified'

                DECLARE @lastModifiedColumnBy NVARCHAR(100);

                SELECT @lastModifiedColumnBy = [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [mp].[MFID] = 23; --'Last Modified By'

                SET @ProcessStep = 'Merge Table ' + @ClassName;

                IF @Debug > 0
                BEGIN
                    RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcessStep);
                END;

                SET @SQL
                    = N'

DECLARE @ClassID INT;
SELECT  @ClassID = MFID
FROM    MFClass
WHERE   [MFClass].[TableName] = ''' + @TableName
                      + ''';

MERGE INTO MFObjectTypeToClassObject AS T
USING
    ( SELECT    mot.mfid as [MFObjectType_ID] ,
                mc.MFID ,
                ct.[ObjID] ,
                ct.' + QUOTENAME(@lastModifiedColumnBy) + ' ,
                ct.' + QUOTENAME(@lastModifiedColumn) + ' ,
                ct.[Deleted]
      FROM      [dbo].' + QUOTENAME(@TableName)
                      + ' ct
                INNER JOIN MFClass mc ON [mc].[MFID] = ct.[Class_ID]
				INNER JOIN [dbo].[MFObjectType] AS [mot]
	ON mc.[MFObjectType_ID] = mot.id
    ) AS S
ON T.[ObjectType_ID] = S.[MFObjectType_ID]
    AND [T].[Class_ID] = S.[MFID]
    AND T.[Object_MFID] = S.[ObjID]
WHEN NOT MATCHED THEN
    INSERT ( [ObjectType_ID] ,
             [Class_ID] ,
             [Object_MFID] ,
             [Object_LastModifiedBy] ,
             [Object_LastModified] ,
             [Object_Deleted]
           )
    VALUES ( S.[MFObjectType_ID] ,
             S.MFID ,
             S.[ObjID] ,
             S.' + QUOTENAME(@lastModifiedColumnBy) + ' ,
             S.' + QUOTENAME(@lastModifiedColumn)
                      + ' ,
             S.[Deleted]
           )
WHEN MATCHED THEN
    UPDATE SET 
               T.[Object_LastModifiedBy] = S.' + QUOTENAME(@lastModifiedColumnBy)
                      + ' ,
               T.[Object_LastModified] = S.' + QUOTENAME(@lastModifiedColumn)
                      + ' ,
               T.[Object_Deleted] = S.[Deleted]
;'    ;

                                   IF @Debug <> 0
                                       PRINT  @SQL;
                EXEC [sys].[sp_executesql] @SQL;
            END;
        END;

        FETCH NEXT FROM [CursorTable]
        INTO @id
            ,@ClassName
            ,@TableName
            ,@ObjectTypeID;
    END;

    CLOSE [CursorTable];
    DEALLOCATE [CursorTable];
END;

SET @ProcessStep = 'END';

IF @Debug > 0
BEGIN
    RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcessStep);
	END
    -------------------------------------------------------------
    --	ReSet all tables to be included
    -------------------------------------------------------------
    IF @IsAllTables = 1
        UPDATE [dbo].[MFClass]
        SET [IncludeInApp] = NULL
        WHERE [IncludeInApp] = 10;
--SELECT  *
--    FROM    [dbo].[MFObjectTypeToClassObject] AS [mottco];

GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.dbo.[spMFCreatePublicSharedLink]';

EXEC [Setup].[spMFSQLObjectsControl]
    @SchemaName = N'dbo'
  , @ObjectName = N'spMFCreatePublicSharedLink'
  , -- nvarchar(100)
    @Object_Release = '3.1.5.41'
  , -- varchar(50)
    @UpdateFlag = 2;
 -- smallint
 go
 
IF EXISTS ( SELECT  1
            FROM   information_schema.Routines
            WHERE   ROUTINE_NAME = 'spMFCreatePublicSharedLink'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
BEGIN
	PRINT SPACE(10) + '...Stored Procedure: update'
    SET NOEXEC ON
END
ELSE
	PRINT SPACE(10) + '...Stored Procedure: create'
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFCreatePublicSharedLink]
AS
BEGIN
       SELECT   'created, but not implemented yet.'--just anything will do
END
GO
-- the following section will be always executed
SET NOEXEC OFF
GO

ALTER PROCEDURE [dbo].[spMFCreatePublicSharedLink] ( 		
        @TableName Varchar(250)
	   ,@ExpiryDate DATETIME = null
       ,@ClassID int=null
	   ,@ObjectID int=null
	   ,@ProcessID int=1
)
AS
/*rST**************************************************************************

==========================
spMFCreatePublicSharedLink
==========================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @TableName varchar(250)
    Name of class table
  @ExpiryDate datetime
    Set to NULL to getdata() + 1 month
  @ClassID int (optional)
    - Default = NULL
    - Class_ID of the Record
  @ObjectID int (optional)
    - Default = NULL
    - ObjID column of the Record
  @ProcessID int (optional)
    - Default = 1
    - set process_id = 0 to update all the records with singlefile = 1 in the class
    - set process_id to a number > 4 if you want to create the link for a set list of records

Purpose
=======

Create or update the link to the specified object and add the link in the MFPublicLink table. A join can then be used to access the link and include it in any custom view.

Additional Info
===============

If you are making updates to a record and want to set the public link at the same time then run the shared link procedure after setting the process_id and before updating the records to M-Files.

The expire date can be set for the number of weeks or month from the current date by using the dateadd function (e.g. Dateadd(m,6,Getdate())).

Warnings
========

This procedure will use the ServerURL setting in MFSettings and expects eiher 'http://' or 'https://' and a fully qualified dns name as the value. Example: 'http://contoso.com'

Examples
========

.. code:: sql

    EXEC dbo.spMFCreatePublicSharedLink
         @TableName = 'ClassTableName', -- varchar(250)
         @ExpiryDate = '2017-05-21',    -- datetime
         @ClassID = nul,                -- int
         @ObjectID = ,                  -- int
         @ProcessID = 0                 -- int

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-04-04  DEV2       Added Licensing module validation code
==========  =========  ========================================================

**rST*************************************************************************/
      BEGIN
            SET NOCOUNT ON

    Begin Try

	   Declare 
         @ObjectType int
	    ,@Xml  nvarchar(max)
		,@VaultSettings NVARCHAR(4000)
		,@OutPutXML nvarchar(max)
		,@FilterCondition nvarchar(200) 
		,@Query NVARCHAR(MAX)
		,@XmlOut XML
		,@ServerUrl nvarchar(500)
		,@VaultGUID nvarchar(150)



	  -----------Fetching Vault Settings------------------------------- 
	   
	     SELECT   @VaultSettings = [dbo].[FnMFVaultSettings]();


		  select @VaultGUID=cast(value as nvarchar(150)) from MFSettings where Name='VaultGUID'
          select @ServerUrl=cast(value as nvarchar(500)) from MFSettings where Name='ServerURL'

	  ------------------------------------------

       
	  --------- classID is null the getting classID by using @TableName------------------
	   if @ClassID is Null          
	      Begin
		      Select @ClassID=MFID from MFClass where TableName=@TableName
		  End
      -----------------------------------------------------------------------------------

     
	 -----------------getting ObjectType of table using @TableName-----------------------
	   Select 
         @ObjectType=MFO.MFID 
	   from 
	    MFClass MFC inner join MFObjectType MFO 
	   on 
	     MFC.MFObjectType_ID=MFO.ID 
		 and 
		 MFC.TableName=@TableName
     ---------------------------------------------------------------------------------------
		


	  IF @ObjectType =0     ----If object Type=0 i.e object type is only document then continue process
	    Begin
		

		  if @ObjectID is Not Null
		  Begin

		    --If object ID is passed as parameter then only link of that object is only created
		    set @FilterCondition =' Deleted=0 and  Single_File=1 and  ObjID=' + Cast(@ObjectID as nvarchar(20))

		  End
		  Else
		   Begin

		       --If object ID is not passed as parameter then links are created for objects which are of type single file and has Process_ID=1
		       set @FilterCondition =' Deleted=0 and  Single_File=1 and Process_ID=' + cast(@ProcessID as varchar(20))

		   End
		  
		  set @Query=' select @Xml=(
										select 
											ObjID as ''ObjectDetails/@ID''
											,'''+cast(convert(date,@Expirydate) as varchar(20)) + ''' as ''ObjectDetails/@ExpiryDate''
											,'''' as ''ObjectDetails/@AccessKey''
										from 
											'+@TableName+' 
										where 
		
										 '+ @FilterCondition +' FOR XML PATH(''''),Root(''PSLink'')  )'

          --print @Query
		  EXEC [sys].[sp_executesql]
                     @Query
                    , N'@Xml nvarchar(max) OUTPUT'
                    , @Xml OUTPUT;

             -----------------------------------------------------------------
			-- Checking module access for CLR procdure  spMFCreatePublicSharedLinkInternal
			------------------------------------------------------------------
		   EXEC [dbo].[spMFCheckLicenseStatus] 
		             'spMFCreatePublicSharedLinkInternal'
		             ,'spMFCreatePublicSharedLink'
					 ,'Checking module access for CLR procdure  spMFCreatePublicSharedLinkInternal'			  

			EXEC spMFCreatePublicSharedLinkInternal @VaultSettings,@Xml ,@OutPutXML Output

			SET @XmlOut = @OutPutXML


				
				Create table #TmpLink
				(
				   ID int,
				   ExpiryDate nvarchar(20),
				   AccessKey nvarchar(max),
				   Name_Or_Title nvarchar(200)
				)

				

				insert into #TmpLink
				 (
				   ID,
				   ExpiryDate,
				   AccessKey
				 )

				 Select [t].[c].[value]('@ID[1]','INT') as ID,
				        [t].[c].[value]('@ExpiryDate[1]','NVARCHAR(20)') as ExpiryDate,
						[t].[c].[value]('@AccessKey[1]','NVARCHAR(max)') as AccessKey 
				  from 
				    @XmlOut.[nodes]('/form/ObjectDetails') AS [t] ( [c] )

			

			    set @Query='			

				Update T
				   set Name_Or_Title=TBL.Name_Or_Title
				from 
				   #TmpLink T inner join ' + @TableName+' TBL 
				on 
				   T.ID=TBL.ObjID '

				Exec(@Query)



				--Link='http://192.168.0.150/SharedLinks.aspx?accesskey='+TL.AccessKey+'&VaultGUID=E3DB829A-CDFE-4492-88C1-3E7B567FBD59'
				Update MFPL 
				 Set
				   Accesskey=TL.AccessKey,
				   ExpiryDate=TL.ExpiryDate,
				   DateModified=getdate(),
				   Link=@ServerUrl+'/SharedLinks.aspx?accesskey='+TL.AccessKey+'&VaultGUID='+@VaultGUID,
				   HtmlLink= '<a href="'+@ServerUrl+'/SharedLinks.aspx?accesskey='+TL.AccessKey+'&VaultGUID='+@VaultGUID+'" >'+ Name_Or_Title +'</a>'
				from
				   MFPublicLink MFPL inner join #TmpLink TL on MFPL.ObjectID=TL.ID


				insert into  MFPublicLink (ObjectID,ClassID,ExpiryDate,AccessKey,Link,DateCreated,HtmlLink)
				Select 
				   ID,
				   @ClassID,
				   ExpiryDate,
				   AccessKey,
				   @ServerUrl+'/SharedLinks.aspx?accesskey='+AccessKey+'&VaultGUID='+@VaultGUID,
				   getdate(),
				   '<a href="'+@ServerUrl+'/SharedLinks.aspx?accesskey='+AccessKey+'&VaultGUID='+@VaultGUID+'" >'+ Name_Or_Title +'</a>'
				 from 
				   #TmpLink
				  where 
				    ID not in (Select ObjectID from MFPublicLink )

         if(@ObjectID is null)
		   Begin
		     Declare @Sql nvarchar(500)
			 set @Sql='Update ' + @TableName + ' set Process_ID=0 where Process_ID='+ cast(@ProcessID as varchar(100)) +' and Single_File=1 ' 
		    --exec ('Update ' + @TableName + ' set Process_ID=0 where Process_ID='+ @ProcessID +' and Single_File=1 ' )
			exec (@Sql)
          End 
		
 
		 drop table #TmpLink
		End

 End try
 begin Catch
       DROP TABLE [#TmpLink]

	      
           exec ('Update ' + @TableName + ' set Process_ID=0 where Process_ID=3 and Single_File=1 ' )




                  INSERT    INTO [dbo].[MFLog]
                            ( [SPName]
                            , [ErrorNumber]
                            , [ErrorMessage]
                            , [ErrorProcedure]
                            , [ProcedureStep]
                            , [ErrorState]
                            , [ErrorSeverity]
                            , [Update_ID]
                            , [ErrorLine]
		                    )
                  VALUES    ( 'spMFCreatePublicSharedLink'
                            , ERROR_NUMBER()
                            , ERROR_MESSAGE()
                            , ERROR_PROCEDURE()
                            , ''
                            , ERROR_STATE()
                            , ERROR_SEVERITY()
                            , @ObjectID
                            , ERROR_LINE()
                            );
			
			RETURN -1
 End Catch
end 
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFResultMessageForUI]';
GO

SET NOCOUNT ON;

EXEC [Setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFResultMessageForUI' -- nvarchar(100)
                                    ,@Object_Release = '4.2.7.46'            -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFResultMessageForUI' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFResultMessageForUI]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFResultMessageForUI]
(
    -- Add the parameters for the function here
    @Processbatch_ID INT
   ,@Detaillevel INT = 0
   ,@MessageOUT NVARCHAR(4000) = NULL OUTPUT
   ,@MessageForMFilesOUT NVARCHAR(4000) = NULL OUTPUT
   ,@GetEmailContent BIT = 0
   ,@EMailHTMLBodyOUT NVARCHAR(MAX) = NULL OUTPUT
   ,@RecordCount INT = 0 OUTPUT
   ,@UserID INT = NULL OUTPUT
   ,@ClassTableList NVARCHAR(100) = NULL OUTPUT
   ,@MessageTitle NVARCHAR(100) = NULL OUTPUT
   ,@Debug INT = 0
)
AS
/*rST**************************************************************************

======================
spMFResultMessageForUI
======================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @Processbatch\_ID int
    The process batch ID to base the message on
  @Detaillevel int
    fixme description
  @MessageOUT nvarchar(4000) (output)
    - Formatted with /n as new line token
  @MessageForMFilesOUT nvarchar(4000) (output)
    - Formatted with CHAR(10) as new line character
  @GetEmailContent bit (optional)
    - Default = 0
    - 1 = format EMailHTMLBodyOUT as HTML message
  @EMailHTMLBodyOUT nvarchar(max) (output)
    - Formatted as HTML table using the stylesheet as defined by DefaultEMailCSS in MFSettings.
  @RecordCount int (output)
    fixme description
  @UserID int (output)
    fixme description
  @ClassTableList nvarchar(100) (output)
    fixme description
  @MessageTitle nvarchar(100) (output)
    fixme description
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

Format process messages based on logging in MFProcessBatch and MFProcessBatch_Detail for output to Context Menu UI, Mulit-Line Text Property/Field and/or HTML.

Additional Info
===============

When a single class table is part of a ProcessBatch_ID the message will be based on MFProcessBatch.LogText and Duration.

When multiple class tables are part of a ProcessBatch_ID the message will look at MFProcessBatch_Detail where LogType='Message' to compile a stacked message based on the LogText detail and the detail duration.

Regardless of what you include in the LogText the resulting message will always include the following elements:

.. code:: text

    [ProcessType]: [Status]
    Class Name: [Class Name]
    [LogText] -- with new lines based on ' | ' token in text
    Process Batch#: [ProcessBatch_ID]
    Started On: [CreatedOn]
    Duration: [DurationSeconds] --formatted as 00:00:00

The HTML Message is formatted as a table including a header row with the following elements:

.. code:: text

    M-Files Vault: [VaultName]


Add ' | ' (includes spaces both sides of pipe (I) sign) to indicate a new-line token in the message

Add ' | | ' in LogText to indicate two new lines, creating a spacer line in the resulting message

Example: #Records: 2 | #Updated: 1 | #Added: 1

Use with spMFLogProcessSummaryForClassTable to generate LogText based on various counts in the process.

Prerequisites
=============

Requires use MFProcessBatch in solution.

Warnings
========

This procedure to be used as part of an overall messaging and logging solution. It will typically be called as part of a context menu,  or by the spMFProcessBatch_Email procedure to notify a user of outcome of a process.

Examples
========

.. code:: sql

    DECLARE @MessageOUT NVARCHAR(4000)
           ,@MessageForMFilesOUT NVARCHAR(4000)
           ,@EMailHTMLBodyOUT NVARCHAR(MAX);

    EXEC [dbo].[spMFResultMessageForUI] @Processbatch_ID = ?
              ,@MessageOUT = @MessageOUT OUTPUT
              ,@MessageForMFilesOUT = @MessageForMFilesOUT OUTPUT
              ,@GetEmailContent = ?
              ,@EMailHTMLBodyOUT = @EMailHTMLBodyOUT OUTPUT

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-12-02  LC         Fix bug for returning more than one result in query
2018-11-18  LC         Fix count of records
2018-11-15  LC         Fix bug for MF message out
2018-05-20  LC         Modify result message for MFUserMessages
2017-12-29  LC         Allow for message from processbatchdetail level
2017-07-15  LC         Allow for default message when no table is involved in the process (e.g metadata synchronisation)
2017-06-26  AC         Add HTML Email Body Output
2017-06-26  AC         Remove @RowCount, RowCount calculated from ProcessBatch_ID as part of
2017-06-26  AC         Remove @ClassTable, Class Table derived from ProcessBatch_ID
2017-06-21  AC         Change @MessageOUT as optional (default = NULL)
2017-06-21  AC         Add MessageForMFilesOUT as optional (default=null) to allow for usage in multi-line text property
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    -- Declare the return variable here
    DECLARE @Message      NVARCHAR(4000)
           ,@ErrorMessage NVARCHAR(4000)
           ,@SumDuration  DECIMAL(18, 4);

    -------------------------------------------------------------
    -- VARIABLES: DEBUGGING
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFResultMessageForUI';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @DebugText AS NVARCHAR(256) = '';

    SELECT @SumDuration = SUM([mpbd].[DurationSeconds])
    FROM [dbo].[MFProcessBatchDetail] AS [mpbd]
    WHERE [mpbd].[ProcessBatch_ID] = @Processbatch_ID;

    --   BEGIN

    -------------------------------------------------------------
    -- Default message
    -------------------------------------------------------------
    --SELECT @Message
    --    = CASE
    --          WHEN @Detaillevel = 0 THEN
    --(
    --    SELECT ISNULL([mpb].[ProcessType], '(process type unknown)') + ': '
    --           + ISNULL([mpb].[Status], '(status unknown)') + ' | ' + ISNULL([mpb].[LogText], '(null)') + ' | '
    --           + 'Process Batch#: ' + ISNULL(CAST([mpb].[ProcessBatch_ID] AS VARCHAR(10)), '(null)') + ' | '
    --           + 'Started On: ' + ISNULL(CONVERT(VARCHAR(30), [mpb].[CreatedOn]), '(null)') + ' | '
    --           + 'Duration Seconds: ' + CONVERT(VARCHAR(25), @SumDuration)
    --    --+ CAST(RIGHT('0' + CAST(FLOOR((COALESCE([mpb].[DurationSeconds], 0) / 60) / 60) AS VARCHAR(8)), 2) + ':'
    --    --       + RIGHT('0' + CAST(FLOOR(COALESCE([mpb].[DurationSeconds], 0) / 60) AS VARCHAR(8)), 2) + ':' AS varchar(258))
    --    FROM [dbo].[MFProcessBatch] AS [mpb]
    --    WHERE [mpb].[ProcessBatch_ID] = @Processbatch_ID
    --)
    --          WHEN @Detaillevel = 1 THEN
    --(
    --    SELECT ISNULL([mpb].[ProcessType], '(process type unknown)') + ': '
    --           + ISNULL([mpbd].[Status], '(status unknown)') + ' | ' + ISNULL([mpbd].[LogText], '(null)') + ' | '
    --           + 'Process Batch#: ' + ISNULL(CAST([mpb].[ProcessBatch_ID] AS VARCHAR(10)), '(null)') + ' | '
    --           + 'Started On: ' + ISNULL(CONVERT(VARCHAR(30), [mpb].[CreatedOn]), '(null)') + ' | '
    --           + 'Duration Seconds: ' + CONVERT(VARCHAR(25), [mpbd].[DurationSeconds]),
    --           --+ CAST(RIGHT('0' + CAST(FLOOR((COALESCE([mpbd].[DurationSeconds], 0) / 60) / 60) AS VARCHAR(8)), 2) + ':'
    --           --       + RIGHT('0' + CAST(FLOOR(COALESCE([mpbd].[DurationSeconds], 0) / 60) AS VARCHAR(8)), 2) + ':' AS varchar(258))
    --           [mpb].[ProcessType],
    --           [mpbd].*
    --    FROM [dbo].[MFProcessBatch] AS [mpb]
    --        INNER JOIN [dbo].[MFProcessBatchDetail] AS [mpbd]
    --            ON [mpbd].[ProcessBatch_ID] = [mpb].[ProcessBatch_ID]
    --    WHERE [mpb].[ProcessBatch_ID] = @Processbatch_ID
    --          AND [mpbd].[LogType] = 'Message'
    --          AND [mpbd].[MFTableName] <> 'MFUserMessages'
    --)
    --      END;

    -- END;
    DECLARE @ClassName NVARCHAR(100);
    DECLARE @ClassTable NVARCHAR(100);
    DECLARE @ClassTableCount INT = 1;
	DECLARE @ID INT;

    SET @ProcedureStep = 'Get class list';

    DECLARE @ClassTables AS TABLE
    (id int IDENTITY,
        [TableName] NVARCHAR(100)
    );

    INSERT @ClassTables
    ( 
        [TableName]
    )
    SELECT DISTINCT
           [MFTableName]
    FROM [dbo].[MFProcessBatchDetail]
    WHERE [ProcessBatch_ID] = @Processbatch_ID
          AND
          (
              [MFTableName] IS NOT NULL
              OR [MFTableName] NOT IN ( 'MFUserMessages', '' )
          );

    SET @ClassTableCount = @@RowCount;
    SET @DebugText = ' Count of class tables %i';
    SET @DebugText = @DefaultDebugText + @DebugText;

    IF @Debug > 0
    BEGIN
        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ClassTableCount);
    END;

    IF @ClassTableCount = 1
       AND @Detaillevel = 0
    BEGIN
        SET @ProcedureStep = 'Single class table';

        SELECT @ClassName  = [c].[Name]
              ,@ClassTable = [t].[TableName]
        FROM @ClassTables              AS [t]
            INNER JOIN [dbo].[MFClass] AS [c]
                ON [t].[TableName] = [c].[TableName];

        SELECT @Message
            = ISNULL([mpb].[ProcessType], '(process type unknown)') + ': ' + ISNULL([mpb].[Status], '(status unknown)')
              + ' | ' + 'Class Name: ' + ISNULL(@ClassName, '(null)') + ' | ' + ISNULL([mpb].[LogText], '(null)')
              + ' | ' + 'Process Batch#: ' + ISNULL(CAST([mpb].[ProcessBatch_ID] AS VARCHAR(10)), '(null)') + ' | '
              + 'Started On: ' + ISNULL(CONVERT(VARCHAR(30), [mpb].[CreatedOn]), '(null)') + ' | '
              + 'Duration Seconds: ' + CONVERT(VARCHAR(25), [mpb].[DurationSeconds])
        --+ CAST(RIGHT('0' + CAST(FLOOR((COALESCE(@SumDuration, 0) / 60) / 60) AS VARCHAR(8)), 2)
        --       + ':'
        --       + RIGHT('0' + CAST(FLOOR(COALESCE([mpb].[DurationSeconds], 0) / 60) AS VARCHAR(8)), 2)
        --       + ':'
        --       + RIGHT('0' + CAST(FLOOR(COALESCE([mpb].[DurationSeconds], 0) % 60) AS VARCHAR(2)), 2) AS VARCHAR(10))
        FROM [dbo].[MFProcessBatch] AS [mpb]
        WHERE [mpb].[ProcessBatch_ID] = @Processbatch_ID;

        SET @DebugText = 'Message %s';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @Message);
        END;
    END; --IF @ClassTableCount = 1

    IF @ClassTableCount <> 1
       AND @Detaillevel = 0
    BEGIN
        SET @ProcedureStep = 'Multiple Class tables';

		SET @DebugText = ' ClassTable count %i';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ClassTableCount);
        END;

        DECLARE @MessageByClassTable AS TABLE
        (
            [id] INT IDENTITY(1, 1) PRIMARY KEY
           ,[ProcessBatch_ID] INT
           ,[ClassTable] NVARCHAR(100)
           ,[LogText] NVARCHAR(4000)
           ,[LogStatus] NVARCHAR(50)
           ,[Duration] DECIMAL(18, 4)
           ,[RecCount] INT
        );

        SELECT @ID = MIN(ID)
        FROM @ClassTables;

        WHILE @ID IS NOT NULL
        BEGIN
            --IF @IncludeClassTableStats = 1
            --	BEGIN
            --		INSERT INTO @ClassStats
            --		EXEC [dbo].[spMFClassTableStats] @ClassTableName = @ClassTable
            --									   , @Debug = 0;

            --	END --	IF @IncludeClassTableStats = 1
         SELECT @ClassTable = TableName FROM @ClassTables AS [ct] WHERE id = @ID

		 SET @ProcedureStep = 'Compile message by ';

		SET @DebugText = ' ClassTable  %s';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ClassTable);
        END;

		    INSERT @MessageByClassTable
            (
                [ProcessBatch_ID]
               ,[ClassTable]
               ,[LogText]
               ,[LogStatus]
            --       ,[Duration]
            )
            SELECT [pbd].[ProcessBatch_ID]
                  ,[pbd].[MFTableName]
                  ,[pbd].[LogText]
                  ,[pbd].[Status]
            --      ,[pbd].[DurationSeconds]
            FROM [dbo].[MFProcessBatchDetail] AS [pbd]
            WHERE [pbd].[ProcessBatch_ID] = @Processbatch_ID
                  AND [pbd].[LogType] = 'Message'
                  AND [pbd].[MFTableName] = @ClassTable
                  AND @ClassTable NOT IN ( 'MFUserMessages', '' )
            ORDER BY [pbd].[MFTableName]
                    ,[pbd].[ProcessBatch_ID];

					 SET @ProcedureStep = 'Update Duration ';

		SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

            UPDATE @MessageByClassTable
            SET [Duration] =
                (
                    SELECT SUM([mpbd].[DurationSeconds])
                    FROM [dbo].[MFProcessBatchDetail] AS [mpbd]
                    WHERE [mpbd].[ProcessBatch_ID] = @Processbatch_ID
                          AND [mpbd].[MFTableName] = @ClassTable
                )
            FROM @MessageByClassTable AS [mbct]
            WHERE [mbct].[ClassTable] = @ClassTable;

						 SET @ProcedureStep = 'Update Count ';

		SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

            UPDATE @MessageByClassTable
            SET [RecCount] =
                (
                    SELECT SUM(CAST([mpbd].[ColumnValue] AS INT))
                    FROM [dbo].[MFProcessBatchDetail] AS [mpbd]
                    WHERE [mpbd].[MFTableName] = @ClassTable
                          AND [mpbd].[ColumnName] = 'NewOrUpdatedObjectDetails'
                          AND [mpbd].[ProcessBatch_ID] = @Processbatch_ID
                )
            FROM @MessageByClassTable AS [mbct]
            WHERE [mbct].[ClassTable] = @ClassTable;

            SELECT @ID = (SELECT MIN(ID)
            FROM @ClassTables
            WHERE ID > @ID);
        END; --WHILE @ClassTable IS NOT NULL

		if @debug > 0
		SELECT * FROM @MessageByClassTable AS [mbct]; 

SET @ProcedureStep = 'Format messages'
SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        DECLARE @DetailStatus   NVARCHAR(50)
               ,@DetailLogText  NVARCHAR(4000)
               ,@DetailDuration DECIMAL(18, 4);

        SELECT @Message
            = ISNULL([mpb].[ProcessType], '(process type unknown)') + ': ' + ISNULL([mpb].[Status], '(status unknown)')
              + ' | ' + 'Process Batch#: ' + ISNULL(CAST([mpb].[ProcessBatch_ID] AS VARCHAR(10)), '(null)') + ' | '
              + 'Started On: ' + ISNULL(CONVERT(VARCHAR(30), [mpb].[CreatedOn]), '(null)')
        FROM [dbo].[MFProcessBatch] AS [mpb]
        WHERE [mpb].[ProcessBatch_ID] = @Processbatch_ID;

		
		IF @Debug > 0
		SELECT @Message AS MessageHeading;

        -- Build Extended Message to include class name
		SET @ID = Null
        SELECT @Id = MIN([id])
        FROM @MessageByClassTable;

        WHILE @Id IS NOT NULL
        BEGIN

            SELECT @ClassName = [c].[Name]
            FROM @MessageByClassTable      AS [t]
                INNER JOIN [dbo].[MFClass] AS [c]
                    ON [t].[ClassTable] = [c].[TableName]
            WHERE [t].[id] = @Id;

            SELECT @DetailStatus   = [LogStatus]
                  ,@DetailLogText  = [LogText]
                  ,@DetailDuration = [Duration]
                  ,@RecordCount    = [RecCount]
            FROM @MessageByClassTable
            WHERE [id] = @Id;

            SET @Message
                = @Message + ' |  | ' + 'Class Name: ' + ISNULL(@ClassName, '(null)') + ': '
                  + ISNULL(@DetailStatus, '(status unknown)') + ' | ' + ISNULL(@DetailLogText, '(null)') + ' | '
                  + 'Duration: ' + CONVERT(VARCHAR(25), @DetailDuration) + ' Count: '
                  + CAST(@RecordCount AS VARCHAR(10));

            --+ CAST(RIGHT('0' + CAST(FLOOR((COALESCE(@DetailDuration, 0) / 60) / 60) AS VARCHAR(8)), 2) + ':'
            --       + RIGHT('0' + CAST(FLOOR(COALESCE(@DetailDuration, 0) / 60) AS VARCHAR(8)), 2) + ':'
            --       + RIGHT('0' + CAST(FLOOR(COALESCE(@DetailDuration, 0) % 60) AS VARCHAR(2)), 2) AS VARCHAR(10));
            SELECT @Id = MIN([id])
            FROM @MessageByClassTable
            WHERE [id] > @Id
                  AND [ClassTable] NOT IN ( 'MFUserMessages', '' );
        END; --WHILE @Id IS NOT NULl

        SET @DebugText = 'Extended Message %s';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @Message);
        END;
    END;

    --IF @ClassTableCount > 1
    SET @ProcedureStep = 'format message for message box';

    -- Return @MessageOUT
    SELECT @MessageOUT = REPLACE(@Message, ' | ', '\n');

    SET @DebugText = 'MessageOut %s';
    SET @DebugText = @DefaultDebugText + @DebugText;

    IF @Debug > 0
    BEGIN
        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @MessageOUT);
    END;

    SET @ProcedureStep = 'format message for M-files property';
    -- Return @MessageForMFilesOUT
    SET @MessageForMFilesOUT = REPLACE(@Message, ' | ', CHAR(10));
    SET @DebugText = 'MessageForMfilesOut %s';
    SET @DebugText = @DefaultDebugText + @DebugText;

    IF @Debug > 0
    BEGIN
        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @MessageForMFilesOUT);
    END;

    SET @ProcedureStep = 'Setup email';

    --Return HTML Email Body
    IF @GetEmailContent = 1
    BEGIN
        -- Construct and Return @MessageForHTMLOUT
        DECLARE @EMAIL_BODY NVARCHAR(MAX);

        SET @EMAIL_BODY = N'<html>';

        --Get CSS Style Sheet for Emails
        SELECT @EMAIL_BODY = @EMAIL_BODY + CAST([Value] AS VARCHAR(8000))
        FROM [dbo].[MFSettings]
        WHERE [source_key] = 'Email'
              AND [Name] = 'DefaultEMailCSS';

        DECLARE @MFVaultSetting_VaultName VARCHAR(100);

        SELECT @MFVaultSetting_VaultName = [VaultName]
        FROM [dbo].[MFVaultSettings];

        SET @EMAIL_BODY
            = @EMAIL_BODY + N'
			<body><div id="body_style" >' + '<table>' + '<th>' + 'M-Files Vault: ' + @MFVaultSetting_VaultName
              + '</th>' + '<tr><td>' + REPLACE(@Message, ' | ', '</td></tr><tr><td>') + '</td></tr>' + '</table>'
              + '</div></body></html>';
        SET @EMailHTMLBodyOUT = @EMAIL_BODY;
    END;

    SET @ProcedureStep = 'Set other output variables';

    SELECT @ClassTableList = COALESCE(@ClassTableList, '', ' ') + [mpbd].[TableName] + CHAR(10)
    FROM @ClassTables AS [mpbd]
    WHERE [mpbd].[TableName] NOT IN ( 'MFUserMessages', '' );

    SELECT @ClassTableList = SUBSTRING(@ClassTableList, 1, LEN(@ClassTableList) - 1);

    SELECT @RecordCount = SUM(CAST([mpbd].[ColumnValue] AS INT))
    FROM [dbo].[MFProcessBatchDetail] AS [mpbd]
    WHERE [mpbd].[ProcessBatch_ID] = @Processbatch_ID
          AND [mpbd].[ColumnName] = 'NewOrUpdatedObjectDetails'
          AND [mpbd].[MFTableName] NOT IN ( 'MFUserMessages', '' );

    SELECT @MessageTitle = [mpb].[LogText] + ' ' + CAST([mpb].[CreatedOn] AS VARCHAR(25))
    FROM [dbo].[MFProcessBatch] AS [mpb]
    WHERE [mpb].[ProcessBatch_ID] = @Processbatch_ID;

    SELECT @UserID = [mua].[UserID]
    FROM [dbo].[MFUserAccount] AS [mua]
    WHERE [mua].[LoginName] =
    (
        SELECT [mvs].[Username] FROM [dbo].[MFVaultSettings] AS [mvs]
    );

    -- Return the result of the function
    RETURN 1;
END;
GO

GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFExportFiles]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo',
                                     @ObjectName = N'spMFExportFiles',
                                     -- nvarchar(100)
                                     @Object_Release = '4.2.7.47',
                                     -- varchar(50)
                                     @UpdateFlag = 2;
-- smallint
GO
IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFExportFiles' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFExportFiles]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO
ALTER PROCEDURE [dbo].[spMFExportFiles]
(
    @TableName NVARCHAR(128),
    @PathProperty_L1 NVARCHAR(128) = NULL,
    @PathProperty_L2 NVARCHAR(128) = NULL,
    @PathProperty_L3 NVARCHAR(128) = NULL,
    @IncludeDocID BIT = 1,
    @Process_id INT = 1,
    @ProcessBatch_ID INT = NULL OUTPUT,
    @Debug INT = 0
)
AS
/*rST**************************************************************************

===============
spMFExportFiles
===============

Return
  - 1 = Success
  - -1 = Error
Parameters
  @TableName nvarchar(128)
    Name of class table
  @PathProperty\_L1 nvarchar(128) (optional)
    - Default = NULL
    - Optional column for 1st level path
  @PathProperty\_L2 nvarchar(128) (optional)
    - Default = NULL
    - Optional column for 2nd level path
  @PathProperty\_L3 nvarchar(128) (optional)
    - Default = NULL
    - Optional column for 3rd level path
  @IncludeDocID bit (optional)
    - Default = 1
    - File name include Document id.
  @Process\_id int (optional)
    - Default = 1
    - process Id for records to be included
  @ProcessBatch\_ID int (optional, output)
    - Default = NULL
    - Referencing the ID of the ProcessBatch logging table
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

The procedure is used to export selected files for class records from M-Files to a designated explorer folder on the server.

Additional Info
===============

The main use case for this procedure is to allow access to the files as attachments to emails or other third party system applications. An example is bulk emailing of customer invoices.
Objects with Files and Document Type objects can be exported.

Use root folder parameter to set the UNC path, or location on the SQL Server e.g. D:\\MFSQLExport\\. On installation this folder is automatically set to c:\MFSQL\FileExport

Use FileExportFolder column in MFClass to set the 'What is being exported' e.g. SalesInvoices

If no path properties are set, then the files will be exported to D:\MFSQLExport\SalesInvoices

Each Path Property is the column values for the object. Level 3 is nested in Level 2 is nested in Level 1. E.g. CustomerABC\ProjectABC\InvoiceMonth.

The security context of the export functionality is using the SQL Service Account. The SQL Service Account must have appropriate permissions to create folders and files on the Root Folder.  Special care should be taken If a UNC path is used to set the SQL Service Account with appropriate permissions to access the UNC path.

Examples
========

Extract of all sales invoices by customer.

.. code:: sql

    UPDATE  [MFClass] SET   [FileExportFolder] = 'SalesInvoices' WHERE  [ID] = 36;
    EXEC [spMFCreateTable] 'Sales Invoice';
    EXEC [spMFUpdateTable] 'MFSalesInvoice', 1;
    SELECT * FROM  [mfsalesinvoice];
    UPDATE [mfsalesinvoice]
    SET    [process_id] = 1
    WHERE  [filecount] > 0
    EXEC [spMFExportFiles]
        'mfsalesinvoice', 'Customer', NULL, NULL, 0, 0, 1, 0;

----

Produce extract of all sales invoices by Customer by Month (assuming that the invoice Month is a property on the invoice)

.. code:: sql

    DECLARE @ProcessBatch_ID INT;
    EXEC [dbo].[spMFExportFiles] @TableName = 'MFSalesInvoice', -- nvarchar(128)
                                 @PathProperty_L1 = 'Customer', -- nvarchar(128)
                                 @PathProperty_L2 = 'Document_Date', -- nvarchar(128)
                                 @PathProperty_L3 = null, -- nvarchar(128)
                                 @IncludeDocID = 0, -- bit
                                 @Process_id = 1, -- int
                                 @ProcessBatch_ID = @ProcessBatch_ID OUTPUT, --int
                                 @Debug = 0 -- int

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-12-03  LC         Bug 'String or binary data truncated' in file name
2018-06-28  LC         Set return success = 1
2018-02-20  LC         Set processbatch_id to output
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    BEGIN TRY

        SET NOCOUNT ON;

        -----------------------------------------------------
        --DECLARE LOCAL VARIABLE
        ----------------------------------------------------

        DECLARE @VaultSettings NVARCHAR(4000);
        DECLARE @ClassID INT;
        DECLARE @ObjType INT;
        DECLARE @FilePath NVARCHAR(1000);
        DECLARE @FileExport NVARCHAR(MAX);
        DECLARE @ClassName NVARCHAR(128);
        DECLARE @OjectTypeName NVARCHAR(128);
        DECLARE @ID INT;
        DECLARE @ObjID INT;
        DECLARE @MFVersion INT;
        DECLARE @SingleFile BIT;
        DECLARE @Name_Or_Title_PropName NVARCHAR(250);
        DECLARE @Name_Or_title_ObjName NVARCHAR(250);
        DECLARE @IncludeDocIDTemp BIT;
        DECLARE @MFClassFileExportFolder NVARCHAR(200);
        DECLARE @ProcedureName sysname = 'spMFExportFiles';
        DECLARE @ProcedureStep sysname = 'Start';
        DECLARE @PathProperty_ColValL1 NVARCHAR(128) = NULL;
        DECLARE @PathProperty_ColValL2 NVARCHAR(128) = NULL;
        DECLARE @PathProperty_ColValL3 NVARCHAR(128) = NULL;


        -----------------------------------------------------
        --DECLARE VARIABLES FOR LOGGING
        -----------------------------------------------------
        --used on MFProcessBatchDetail;
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @LogTypeDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @ProcessType NVARCHAR(50);
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = '';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @Status AS NVARCHAR(128) = NULL;
        DECLARE @Validation_ID INT = NULL;
        DECLARE @StartTime AS DATETIME;
        DECLARE @RunTime AS DECIMAL(18, 4) = 0;

        DECLARE @error AS INT = 0;
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT;
        DECLARE @RC INT;
        DECLARE @Update_ID INT;
        DECLARE @IsIncludePropertyPath BIT = 0;
        DECLARE @IsValidProperty_L1 BIT;
        DECLARE @IsValidProperty_L2 BIT;
        DECLARE @IsValidProperty_L3 BIT;
        DECLARE @MultiDocFolder NVARCHAR(100);

        ----------------------------------------------------------------------
        --GET Vault LOGIN CREDENTIALS
        ----------------------------------------------------------------------
        DECLARE @Rootfolder NVARCHAR(100) = '';

        SET @ProcessType = @ProcedureName;
        SET @LogType = 'Status';
        SET @LogText = @ProcedureStep + ' | ';
        SET @LogStatus = 'Initiate';

        EXECUTE @RC = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
                                                      @ProcessType = @ProcessType,
                                                      @LogType = @LogType,
                                                      @LogText = @LogText,
                                                      @LogStatus = @LogStatus,
                                                      @debug = @Debug;

        SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();
		

        SELECT @Rootfolder = CAST([Value] AS NVARCHAR(100))
        FROM [dbo].[MFSettings]
        WHERE [Name] = 'RootFolder';

        SELECT @Name_Or_Title_PropName = [mp].[ColumnName]
        FROM [dbo].[MFProperty] AS [mp]
        WHERE [mp].[MFID] = 0;

				Set @DebugText = ' RootFolder %s'
		Set @DebugText = @DefaultDebugText + @DebugText
		Set @Procedurestep = 'Getting started'
		
		IF @debug > 0
			Begin
				RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep,@Rootfolder);
			END


        SELECT @ClassID = ISNULL([CL].[MFID], 0),
               @ObjType = [OT].[MFID],
               @ClassName = [CL].[Name],
               @OjectTypeName = [OT].[Name],
               @MFClassFileExportFolder = ISNULL([CL].[FileExportFolder], '')
        FROM [dbo].[MFClass] AS [CL]
            INNER JOIN [dbo].[MFObjectType] AS [OT]
                ON [CL].[MFObjectType_ID] = [OT].[ID]
                   AND [CL].[TableName] = @TableName;

        IF @ClassID != 0
           OR @Rootfolder != ''
        BEGIN

            SET @ProcedureStep = 'Calculating File download path';

							Set @DebugText = ''
		Set @DebugText = @DefaultDebugText + @DebugText
		
		IF @debug > 0
			Begin
				RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep);
			END

            ------------------------------------------------------------------------------------------------
            --Creating File path
            -------------------------------------------------------------------------------------------------


            IF @PathProperty_L1 IS NOT NULL
            BEGIN
                IF EXISTS
                (
                    SELECT [COLUMN_NAME]
                    FROM [INFORMATION_SCHEMA].[COLUMNS]
                    WHERE [TABLE_NAME] = @TableName
                          AND [COLUMN_NAME] = @PathProperty_L1
                )
                BEGIN
                    SET @IsValidProperty_L1 = 1;
                END;

            END;


            IF @PathProperty_L2 IS NOT NULL
            BEGIN
                IF EXISTS
                (
                    SELECT [COLUMN_NAME]
                    FROM [INFORMATION_SCHEMA].[COLUMNS]
                    WHERE [TABLE_NAME] = @TableName
                          AND [COLUMN_NAME] = @PathProperty_L2
                )
                BEGIN
                    SET @IsValidProperty_L2 = 1;
                END;
            END;


            IF @PathProperty_L3 IS NOT NULL
            BEGIN
                IF EXISTS
                (
                    SELECT [COLUMN_NAME]
                    FROM [INFORMATION_SCHEMA].[COLUMNS]
                    WHERE [TABLE_NAME] = @TableName
                          AND [COLUMN_NAME] = @PathProperty_L3
                )
                BEGIN
                    SET @IsValidProperty_L3 = 1;
                END;
            END;

            IF @IsValidProperty_L1 = 1
               OR @IsValidProperty_L2 = 1
               OR @IsValidProperty_L3 = 1
            BEGIN
                SET @IsIncludePropertyPath = 1;
            END;




            IF @Debug > 0
            BEGIN
                RAISERROR(
                             '%s : Step %s :MFClassFileExportFolder %s ',
                             10,
                             1,
                             @ProcedureName,
                             @ProcedureStep,
                             @MFClassFileExportFolder
                         );
                RAISERROR('%s : Step %s :PathProperty_L1 %s ', 10, 1, @ProcedureName, @ProcedureStep, @PathProperty_L1);
                RAISERROR('%s : Step %s :PathProperty_L2 %s ', 10, 1, @ProcedureName, @ProcedureStep, @PathProperty_L2);
                RAISERROR('%s : Step %s :PathProperty_L3 %s ', 10, 1, @ProcedureName, @ProcedureStep, @PathProperty_L3);

            END;

            IF @MFClassFileExportFolder != ''
               OR @MFClassFileExportFolder IS NOT NULL
            BEGIN

                SET @FilePath = CASE
                                    WHEN PATINDEX('%\%', @MFClassFileExportFolder) > 1 THEN
                                        @Rootfolder + @MFClassFileExportFolder
                                    WHEN @MFClassFileExportFolder = '' THEN
                                        @Rootfolder
                                    ELSE
                                        @Rootfolder + @MFClassFileExportFolder + '\'
                                END;
            END;



            --SET @FilePath = @FilePath + @PathProperty_L1 + '\' + @PathProperty_L2 + '\' + @PathProperty_L3 + '\';

            SELECT @ProcedureStep = 'Fetching records from ' + @TableName + ' to download document.';

            IF NOT EXISTS
            (
                SELECT [COLUMN_NAME]
                FROM [INFORMATION_SCHEMA].[COLUMNS]
                WHERE [TABLE_NAME] = @TableName
                      AND [COLUMN_NAME] = 'FileCount'
            )
            BEGIN
                EXEC ('alter table ' + @TableName + ' add FileCount int CONSTRAINT DK_FileCount_' + @TableName + ' DEFAULT 0 WITH VALUES');
            END;

            IF @Debug > 0
            BEGIN
                SELECT @FilePath AS [FileDownloadPath];
                --    PRINT 'Fetching records from ' + @TableName + ' to download document.';
                RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcedureStep);

            END;
            -----------------------------------------------------------------------------
            --Creating the cursor and cursor query.
            -----------------------------------------------------------------------------


            DECLARE @GetDetailsCursor AS CURSOR;
            DECLARE @CursorQuery NVARCHAR(200),
                    @process_ID_text VARCHAR(5),
                    @vsql AS NVARCHAR(MAX),
                    @vquery AS NVARCHAR(MAX);

            SET @process_ID_text = CAST(@Process_id AS VARCHAR(5));


            -----------------------------------------------------------------
            -- Checking module access for CLR procdure  spMFGetFilesInternal
            ------------------------------------------------------------------
            EXEC [dbo].[spMFCheckLicenseStatus] 'spMFGetFilesInternal',
                                                @ProcedureName,
                                                @ProcedureStep;


            IF @IsIncludePropertyPath = 1
            BEGIN

                SET @vquery
                    = 'SELECT ID,ObjID,MFVersion,isnull(Single_File,0) as Single_File,isnull('
                      + @Name_Or_Title_PropName + ','''') as Name_Or_Title';

                IF @IsValidProperty_L1 = 1
                BEGIN
                    SET @vquery = @vquery + ', isnull(' + @PathProperty_L1 + ', '''') as PathProperty_L1';
                END;
                ELSE
                BEGIN
                    SET @vquery = @vquery + ', '''' as PathProperty_L1';
                END;

                IF @IsValidProperty_L2 = 1
                BEGIN
                    SET @vquery = @vquery + ', isnull(' + @PathProperty_L2 + ', '''') as PathProperty_L2';
                END;
                ELSE
                BEGIN
                    SET @vquery = @vquery + ', '''' as PathProperty_L2';
                END;

                IF @IsValidProperty_L3 = 1
                BEGIN
                    SET @vquery = @vquery + ', isnull(' + @PathProperty_L3 + ', '''') as PathProperty_L3';
                END;
                ELSE
                BEGIN
                    SET @vquery = @vquery + ', '''' as PathProperty_L3';
                END;

                SET @vquery
                    = @vquery + ' from [' + @TableName + '] WHERE Process_ID = ' + @process_ID_text
                      + '    AND Deleted = 0';

                IF @Debug > 0
                    PRINT @vquery;
            END;
            ELSE
            BEGIN
                IF @Debug > 0
                    PRINT 'test';

                SET @vquery
                    = 'SELECT ID,ObjID,MFVersion,isnull(Single_File,0) as Single_File,isnull('
                      + @Name_Or_Title_PropName
                      + ','''') as Name_Or_Title,'''' as PathProperty_L1, '''' as  PathProperty_L2, '''' as PathProperty_L3  from ['
                      + @TableName + '] WHERE Process_ID = ' + @process_ID_text + '    AND Deleted = 0';
                IF @Debug > 0
                    PRINT @vquery;
            END;

            --SET @vquery
            --             = 'SELECT ID,ObjID,MFVersion,isnull(Single_File,0),isnull('+@Name_Or_Title_PropName+','''') from [' + @TableName
            --               + '] WHERE Process_ID = '+ @Process_id_text +'    AND Deleted = 0';


            SET @vsql = 'SET @cursor = cursor forward_only static FOR ' + @vquery + ' OPEN @cursor;';

            IF @Debug > 0
                PRINT @vsql;

            EXEC [sys].[sp_executesql] @vsql,
                                       N'@cursor cursor output',
                                       @GetDetailsCursor OUTPUT;






            FETCH NEXT FROM @GetDetailsCursor
            INTO @ID,
                 @ObjID,
                 @MFVersion,
                 @SingleFile,
                 @Name_Or_title_ObjName,
                 @PathProperty_ColValL1,
                 @PathProperty_ColValL2,
                 @PathProperty_ColValL3;

            WHILE (@@FETCH_STATUS = 0)
            BEGIN


                SELECT @ProcedureStep = 'Started downloading Files for  objectID: ' + CAST(@ObjID AS VARCHAR(10));
                IF @Debug > 0
                BEGIN
                    PRINT 'Started downloading Files for  objectID=' + CAST(@ObjID AS VARCHAR(10));
                    RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcedureStep);
                END;

                DECLARE @TempFilePath NVARCHAR(MAX);
                SET @TempFilePath = @FilePath;

                IF @IsIncludePropertyPath = 1
                BEGIN
                    --SET @TempFilePath = @TempFilePath+@PathProperty_ColValL1+'\'+@PathProperty_ColValL2+'\'+@PathProperty_ColValL3+'\';

                    IF @Debug > 0
                    BEGIN
                        SELECT @TempFilePath + @PathProperty_ColValL1 + @PathProperty_ColValL2
                               + +@PathProperty_ColValL3;
                    END;


                    --IF @PathProperty_ColValL1 IS NOT NULL
                    --   OR	@PathProperty_ColValL1 != ''
                    SET @TempFilePath = CASE
                                            WHEN @PathProperty_ColValL1 IS NOT NULL THEN
                                                @TempFilePath + CAST(@PathProperty_ColValL1 AS NVARCHAR(200)) + '\'
                                            ELSE
                                                @TempFilePath
                                        END;

                    --IF @PathProperty_ColValL2 IS NOT NULL
                    --   OR	@PathProperty_ColValL2 != ''
                    SET @TempFilePath = CASE
                                            WHEN @PathProperty_ColValL2 IS NULL THEN
                                                @TempFilePath
                                            WHEN @PathProperty_ColValL2 = '' THEN
                                                @TempFilePath
                                            WHEN @PathProperty_ColValL2 IS NOT NULL THEN
                                                @TempFilePath + CAST(@PathProperty_ColValL2 AS NVARCHAR(200)) + '\'
                                        END;

                    --IF @PathProperty_ColValL3 IS NOT NULL
                    --   OR	@PathProperty_ColValL3 != ''
                    SET @TempFilePath = CASE
                                            WHEN @PathProperty_ColValL3 IS NULL THEN
                                                @TempFilePath
                                            WHEN @PathProperty_ColValL3 = '' THEN
                                                @TempFilePath
                                            WHEN @PathProperty_ColValL3 IS NOT NULL THEN
                                                @TempFilePath + CAST(@PathProperty_ColValL3 AS NVARCHAR(200)) + '\'
                                        END;

                --SET @TempFilePath = @TempFilePath
                --					+ CAST(@PathProperty_ColValL3 AS NVARCHAR(200)) + '\';


                END;
                IF @Debug > 0
                BEGIN
                    SELECT @TempFilePath AS [TempFilePath];
                END;


                IF @SingleFile = 0
                BEGIN
                    SET @MultiDocFolder = @Name_Or_title_ObjName;
                    IF @IncludeDocID = 1
                    BEGIN
                        SELECT @TempFilePath
                            = @TempFilePath + '\' + REPLACE(REPLACE(@Name_Or_title_ObjName, ':', '{3}'), '/', '{2}')
                              + ' (ID ' + CAST(@ObjID AS VARCHAR(10)) + ')\';

                        SET @IncludeDocIDTemp = 0;
                    END;
                    ELSE
                    BEGIN
                        SELECT @TempFilePath
                            = @TempFilePath + '\' + REPLACE(REPLACE(@Name_Or_title_ObjName, ':', '{3}'), '/', '{2}')
                              + '\';
                        SET @IncludeDocIDTemp = 0;
                    END;

                    SET @ProcedureStep = 'Calculate multi-file document path';
                    IF @Debug > 0
                    BEGIN
                        PRINT 'testing2';

                        PRINT 'MultiFile document';
                        PRINT @TempFilePath;
                        RAISERROR('%s : Step %s', 10, 1, @ProcedureName, @ProcedureStep);
                        SELECT @TempFilePath AS [MultiFileDownloadPath];
                    END;
                END;
                ELSE
                BEGIN
                    SET @IncludeDocIDTemp = @IncludeDocID;
                END;
                IF @Debug > 0
                BEGIN
                    PRINT @TempFilePath;
                    SELECT @VaultSettings AS [VaulSettings];
                    SELECT @ClassID AS [ClassID];
                    SELECT @ObjID AS [ObjID];
                    SELECT @ObjType AS [ObjType];
                    SELECT @MFVersion AS [MFVersion];
                    SELECT @TempFilePath AS [TempFilePath];
                    SELECT @IncludeDocIDTemp AS [IncludeDocIDTemp];

                -------------------------------------------------------------------
                --- Calling  the CLR StoredProcedure to Download file for @ObJID
                -------------------------------------------------------------------

                END;
                SET @ProcedureStep = 'Calling CLR GetFilesInternal';

                EXEC [dbo].[spMFGetFilesInternal] @VaultSettings,
                                                  @ClassID,
                                                  @ObjID,
                                                  @ObjType,
                                                  @MFVersion,
                                                  @TempFilePath,
                                                  @IncludeDocIDTemp,
                                                  @FileExport OUT;


                IF @Debug > 0
                BEGIN
                    SELECT @FileExport AS [FileExport];
                END;

                IF @Debug > 0
                BEGIN
                    PRINT @TempFilePath;
                    PRINT 'Resetting the Process_ID column';
                END;

                IF @FileExport IS NULL
                    SET @DebugText = 'Failed to get File from MF for Objid %i ';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = '';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjID);
                END;


                DECLARE @XmlOut XML;
                SET @XmlOut = @FileExport;

                EXEC ('Update ' + @TableName + ' set Process_ID=0 where ObjID=' + 'cast(' + @ObjID + 'as varchar(10))');

				

                CREATE TABLE [#temp]
                (
                    [FileName] NVARCHAR(400),
                    [ClassID] INT,
                    [ObjID] INT,
                    [ObjType] INT,
                    [Version] INT,
                    [FileCheckSum] NVARCHAR(1000),
                    [FileCount] INT,
					[FileObjectID] INT
                );
                INSERT INTO [#temp]
                (
                    [FileName],
                    [ClassID],
                    [ObjID],
                    [ObjType],
                    [Version],
                    [FileCheckSum],
                    [FileCount],
					[FileObjectID]
                )
                SELECT [t].[c].[value]('(@FileName)[1]', 'NVARCHAR(400)') AS [FileName],
                       [t].[c].[value]('(@ClassID)[1]', 'INT') AS [ClassID],
                       [t].[c].[value]('(@ObjID)[1]', 'INT') AS [ObjID],
                       [t].[c].[value]('(@ObjType)[1]', 'INT') AS [ObjType],
                       [t].[c].[value]('(@Version)[1]', 'INT') AS [Version],
                       [t].[c].[value]('(@FileCheckSum)[1]', 'nvarchar(1000)') AS [FileCheckSum],
                       [t].[c].[value]('(@FileCount)[1]', 'INT') AS [FileCount],
					   [t].[c].[value]('(@FileObjecID)[1]','INT') as [FileObjectID]
                FROM @XmlOut.[nodes]('/Files/FileItem') AS [t]([c]);

			
                MERGE INTO [dbo].[MFExportFileHistory] [t]
                USING
                (
                    SELECT @FilePath AS [FileExportRoot],
                           @PathProperty_ColValL1 AS [subFolder_1],
                           @PathProperty_ColValL2 AS [subFolder_2],
                           @PathProperty_ColValL3 AS [subFolder_3],
                           [FileName],
                           [ClassID],
                           [ObjID],
                           [ObjType],
                           [Version],
                           @MultiDocFolder AS [MultiDocFolder],
                           [FileCheckSum],
                           [FileCount],
						   [FileObjectID]
                    FROM [#temp]
                ) [S]
                ON [t].[ClassID] = [S].[ClassID]
                   AND [t].[ObjID] = [S].[ObjID]
                   AND [t].[FileName] = [S].[FileName]
                WHEN NOT MATCHED THEN
                    INSERT
                    (
                        [FileExportRoot],
                        [SubFolder_1],
                        [SubFolder_2],
                        [SubFolder_3],
                        [FileName],
                        [ClassID],
                        [ObjID],
                        [ObjType],
                        [Version],
                        [MultiDocFolder],
                        [FileCheckSum],
                        [FileCount],
						[FileObjectID]
                    )
                    VALUES
                    ([S].[FileExportRoot], [S].[subFolder_1], [S].[subFolder_2], [S].[subFolder_3], [S].[FileName],
                     [S].[ClassID], [S].[ObjID], [S].[ObjType], [S].[Version], [S].[MultiDocFolder],
                     [S].[FileCheckSum], [S].[FileCount],[S].[FileObjectID])
                WHEN MATCHED THEN
                    UPDATE SET [t].[FileExportRoot] = [S].[FileExportRoot],
                               [t].[SubFolder_1] = [S].[subFolder_1],
                               [t].[SubFolder_2] = [S].[subFolder_2],
                               [t].[SubFolder_3] = [S].[subFolder_3],
                               [t].[Version] = [S].[Version],
                               [t].[MultiDocFolder] = [S].[MultiDocFolder],
                               [t].[FileCount] = [S].[FileCount],
                               [t].[Created] = GETDATE(),
							   [t].[FileObjectID]=[S].[FileObjectID];


                EXEC ('Update  MFT  set MFT.FileCount= t.FileCount
									From ' + @TableName + ' MFT inner join #temp t
									on MFT.ObjID=t.ObjID 
									where MFT.ObjID=cast(' + @ObjID + 'as varchar(10))');



                DROP TABLE [#temp];

                FETCH NEXT FROM @GetDetailsCursor
                INTO @ID,
                     @ObjID,
                     @MFVersion,
                     @SingleFile,
                     @Name_Or_title_ObjName,
                     @PathProperty_ColValL1,
                     @PathProperty_ColValL2,
                     @PathProperty_ColValL3;
            END;

            CLOSE @GetDetailsCursor;
            DEALLOCATE @GetDetailsCursor;



            SET @StartTime = GETUTCDATE();

            SET @LogTypeDetail = 'Download files';
            SET @LogTextDetail = @ProcedureName;
            SET @LogStatusDetail = 'Completed';
            SET @Validation_ID = NULL;
            SET @LogColumnValue = '';
            SET @LogColumnValue = '';

            EXECUTE @RC = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID,
                                                                @LogType = @LogTypeDetail,
                                                                @LogText = @LogTextDetail,
                                                                @LogStatus = @LogStatusDetail,
                                                                @StartTime = @StartTime,
                                                                @MFTableName = @TableName,
                                                                @Validation_ID = @Validation_ID,
                                                                @ColumnName = @LogColumnName,
                                                                @ColumnValue = @LogColumnValue,
                                                                @Update_ID = @Update_ID,
                                                                @LogProcedureName = @ProcedureName,
                                                                @LogProcedureStep = @ProcedureStep,
                                                                @debug = @Debug;

            RETURN 1;
        END;
        ELSE
        BEGIN
            PRINT 'Please check the ClassName';
        END;
    END TRY
    BEGIN CATCH

        EXEC ('Update ' + @TableName + ' set Process_ID=3 where ObjID=' + 'cast(' + @ObjID + 'as varchar(10))');

        INSERT INTO [dbo].[MFLog]
        (
            [SPName],
            [ErrorNumber],
            [ErrorMessage],
            [ErrorProcedure],
            [ProcedureStep],
            [ErrorState],
            [ErrorSeverity],
            [Update_ID],
            [ErrorLine]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), @ProcedureStep, ERROR_STATE(),
         ERROR_SEVERITY(), @Update_ID, ERROR_LINE());

        SET NOCOUNT OFF;
    END CATCH;
END;

GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFUpdateAllncludedInAppTables]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFUpdateAllncludedInAppTables' -- nvarchar(100)
                                    ,@Object_Release = '4.2.7.46'                     -- varchar(50)
                                    ,@UpdateFlag = 2;                                 -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFUpdateAllncludedInAppTables' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateAllncludedInAppTables]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFUpdateAllncludedInAppTables]
(
    @UpdateMethod INT = 1
   ,@RemoveDeleted INT = 1 --1 = Will remove all the deleted objects when this process is run
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0
)
AS
/*rST**************************************************************************

===============================
spMFUpdateAllncludedInAppTables
===============================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @UpdateMethod int
    - Default = 1
  @RemoveDeleted int
    - Default = 1
    - Remove all the deleted objects when this process is run
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

The purpose of this procedure is to allow for daily processing of all the class table tables with includedinapp = 1.

Examples
========

.. code:: sql

    DECLARE @Return int
    EXEC @Return = spMFUpdateAllncludedInAppTables 2, 0
    SELECT @return

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-11-18  LC         Remove duplicate Audit process
2017-08-28  LC         Convert proc to include logging and process batch control
2017-06-09  LC         Change to use spmfupdateMfilestoSQL method
2017-06-09  LC         Set default of updatemethod to 1
2016-09-09  LC         Add return value
2015-07-14  DEV2       Debug mode added
==========  =========  ========================================================

**rST*************************************************************************/
SET NOCOUNT ON;

-------------------------------------------------------------
-- CONSTANTS: MFSQL Class Table Specific
-------------------------------------------------------------
DECLARE @MFTableName AS NVARCHAR(128);
DECLARE @ProcessType AS NVARCHAR(50);

SET @ProcessType = 'Update All Tables';

-------------------------------------------------------------
-- CONSTATNS: MFSQL Global 
-------------------------------------------------------------
DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
DECLARE @Process_ID_1_Update TINYINT = 1;
DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
DECLARE @Process_ID_2_SyncError TINYINT = 2;
DECLARE @ProcessBatchSize INT = 250;

-------------------------------------------------------------
-- VARIABLES: MFSQL Processing
-------------------------------------------------------------
DECLARE @Update_ID INT;
DECLARE @MFLastModified DATETIME;
DECLARE @Validation_ID INT;

-------------------------------------------------------------
-- VARIABLES: T-SQL Processing
-------------------------------------------------------------
DECLARE @rowcount AS INT = 0;
DECLARE @return_value AS INT = 0;
DECLARE @error AS INT = 0;

-------------------------------------------------------------
-- VARIABLES: DEBUGGING
-------------------------------------------------------------
DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFUpdateAllncludedInAppTables';
DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
DECLARE @DebugText AS NVARCHAR(256) = '';
DECLARE @Msg AS NVARCHAR(256) = '';
DECLARE @MsgSeverityInfo AS TINYINT = 10;
DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

-------------------------------------------------------------
-- VARIABLES: LOGGING
-------------------------------------------------------------
DECLARE @LogType AS NVARCHAR(50) = 'Status';
DECLARE @LogText AS NVARCHAR(4000) = '';
DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
DECLARE @count INT = 0;
DECLARE @Now AS DATETIME = GETDATE();
DECLARE @StartTime AS DATETIME = GETUTCDATE();
DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

-------------------------------------------------------------
-- VARIABLES: DYNAMIC SQL
-------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @sqlParam NVARCHAR(MAX) = N'';

-------------------------------------------------------------
-- INTIALIZE PROCESS BATCH
-------------------------------------------------------------
SET @ProcedureStep = 'Start Logging';
SET @LogText = 'Processing ' + @ProcedureName;

EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                    ,@ProcessType = @ProcessType
                                    ,@LogType = N'Status'
                                    ,@LogText = @LogText
                                    ,@LogStatus = N'In Progress'
                                    ,@debug = @Debug;

EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                          ,@LogType = N'Debug'
                                          ,@LogText = @ProcessType
                                          ,@LogStatus = N'Started'
                                          ,@StartTime = @StartTime
                                          ,@MFTableName = @MFTableName
                                          ,@Validation_ID = @Validation_ID
                                          ,@ColumnName = NULL
                                          ,@ColumnValue = NULL
                                          ,@Update_ID = @Update_ID
                                          ,@LogProcedureName = @ProcedureName
                                          ,@LogProcedureStep = @ProcedureStep
                                          ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                          ,@debug = 0;

BEGIN TRY

    ----------------------------------------
    --DECLARE VARIABLES
    ----------------------------------------
    DECLARE @result            INT
           ,@ClassName         NVARCHAR(100)
           ,@TableLastModified DATETIME
           ,@id                INT
           ,@schema            NVARCHAR(5)  = 'dbo'
           ,@Param             NVARCHAR(MAX);

    IF @Debug > 0
        RAISERROR('Proc: %s Step: %s', 10, 1, @ProcedureName, @ProcedureStep);

    SELECT @ProcedureStep = 'Create Table list and update lastupdate date';

    IF EXISTS
    (
        SELECT [name]
        FROM [tempdb].[sys].[objects]
        WHERE [object_id] = OBJECT_ID('tempdb..#Tablelist')
    )
        DROP TABLE [#TableList];

    CREATE TABLE [#TableList]
    (
        [ID] INT
       ,[Name] VARCHAR(100)
       ,[TableName] VARCHAR(100)
       ,[TableLastModified] DATETIME
    );

    INSERT INTO [#TableList]
    (
        [ID]
       ,[Name]
       ,[TableName]
       ,[TableLastModified]
    )
    SELECT [mc].[ID]
          ,[mc].[Name]
          ,[mc].[TableName]
          ,NULL
    FROM [dbo].[MFClass]                                         AS [mc]
        INNER JOIN
        (SELECT [TABLE_NAME] FROM [INFORMATION_SCHEMA].[TABLES]) AS [t]
            ON [t].[TABLE_NAME] = [mc].[TableName]
    WHERE [mc].[IncludeInApp] IN ( 1, 2 );

    DECLARE @Row INT;

    SELECT @Row = MIN([tl].[ID])
    FROM [#TableList] AS [tl];

    -------------------------------------------------------------
    -- Begin loop
    -------------------------------------------------------------
    WHILE @Row IS NOT NULL
    BEGIN
        SELECT @id = @Row;

        SELECT @MFTableName = [TableName]
        FROM [#TableList]
        WHERE [ID] = @id;

        DECLARE @MFLastUpdateDate SMALLDATETIME
               ,@Update_IDOut     INT;

        EXEC [dbo].[spMFUpdateMFilesToMFSQL] @MFTableName = @MFTableName                  -- nvarchar(128)
                                            ,@MFLastUpdateDate = @MFLastUpdateDate OUTPUT -- smalldatetime
                                            ,@UpdateTypeID = 1                            -- tinyint
                                            ,@Update_IDOut = @Update_IDOut OUTPUT         -- int
                                            ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT   -- int
                                            ,@debug = 0;                                  -- tinyint

        UPDATE [#TableList]
        SET [TableLastModified] = @MFLastUpdateDate
        WHERE [ID] = @id;

        SELECT @Row =
        (
            SELECT MIN([tl].[ID]) AS [id]
            FROM [#TableList] AS [tl]
            WHERE [tl].[ID] > @Row
        );
    END;

    IF @Debug > 0
    BEGIN
        RAISERROR('Proc: %s Step: %s', 10, 1, @ProcedureName, @ProcedureStep);

        SELECT *
        FROM [#TableList];
    END;

    -------------------------------------------------------------
    --END PROCESS
    -------------------------------------------------------------
    END_RUN:
    SET @ProcedureStep = 'End';
    SET @LogType = 'debug';
    SET @LogText = 'Updated all included in App tables:Update Method ' + CAST(@UpdateMethod AS VARCHAR(10));
    SET @LogStatus = N'Completed';

    -------------------------------------------------------------
    -- Log End of Process
    -------------------------------------------------------------   
    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = @LogType
                                        ,@LogText = @LogText
                                        ,@LogStatus = @LogStatus
                                        ,@debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = @LogType
                                              ,@LogText = @ProcessType
                                              ,@LogStatus = @LogStatus
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@debug = 0;

    RETURN 1;
END TRY
BEGIN CATCH
    SET @StartTime = GETUTCDATE();
    SET @LogStatus = 'Failed w/SQL Error';
    SET @LogTextDetail = ERROR_MESSAGE();

    --------------------------------------------------
    -- INSERTING ERROR DETAILS INTO LOG TABLE
    --------------------------------------------------
    INSERT INTO [dbo].[MFLog]
    (
        [SPName]
       ,[ErrorNumber]
       ,[ErrorMessage]
       ,[ErrorProcedure]
       ,[ErrorState]
       ,[ErrorSeverity]
       ,[ErrorLine]
       ,[ProcedureStep]
    )
    VALUES
    (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE()
    ,@ProcedureStep);

    SET @ProcedureStep = 'Catch Error';

    -------------------------------------------------------------
    -- Log Error
    -------------------------------------------------------------   
    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Error'
                                        ,@LogText = @LogTextDetail
                                        ,@LogStatus = @LogStatus
                                        ,@debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Error'
                                              ,@LogText = @LogTextDetail
                                              ,@LogStatus = @LogStatus
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@debug = 0;

    RETURN -1;
END CATCH;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFProcessBatch_EMail]';
GO

SET NOCOUNT ON;
EXEC [Setup].[spMFSQLObjectsControl]
    @SchemaName = N'dbo',
    @ObjectName = N'spMFProcessBatch_EMail', -- nvarchar(100)
    @Object_Release = '3.1.4.41',            -- varchar(50)
    @UpdateFlag = 2                          -- smallint
;
GO
/*------------------------------------------------------------------------------------------------
	Author: Arnie Cilliers, Laminin Solutions
	Create date: 2017-22
	Database: 
	Description: To email MFProcessBatch and MFPRocessBatch_Detail along with error checking results from spMFCreateTableStats 

	PARAMETERS:
			@ProcessBatch_ID:				Required - ProcessBatch ID to report on
			@RecipientEmail:				Optional - If not provided will look for MFSettings setting Name= DefaultAREmailRecipients
			@RecipientFromMFSettingName:	Optional - if provided the setting will be looked up from MFSettings and added to the provided RecipientEmail if it too was provided.
			@ContextMenu_ID:				Optional - future use. Will lookup recipient e-mail based on UserId of Context Menu [Last Executed By]
			@DetailLevel:					Optional - Default(0) - Summary Only
															   1  - Include MFProcessBatchDetail for LogTypes in @LogTypes
															   2
															   -1 - Lookup DetailLevel from MFSettings																   										  		 		
			@LogTypes:						Optional - If provided along with DetailLevel=2, the LogTypes provided in CSV format will be included in the e-mail 

------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	2017-10-03		LC			Add parameter for Detaillevel, but not yet activate.  Add selection of ContextMenu user as email address.
	2017-11-24		LC			Fix issue with getting name of MFContextMenu user
	2017-12-28		lc			allow for messages with detail from ProcessBatchDetail
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====

USAGE:	EXEC spMFProcessBatch_EMail 
			  @@Debug = 1
  
-----------------------------------------------------------------------------------------------*/
IF EXISTS
    (
        SELECT
            1
        FROM
            [INFORMATION_SCHEMA].[ROUTINES]
        WHERE
            [ROUTINE_NAME] = 'spMFProcessBatch_EMail' --name of procedure
            AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
            AND [ROUTINE_SCHEMA] = 'dbo'
    )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFProcessBatch_EMail]
AS
    SELECT
        'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO
ALTER PROC [dbo].[spMFProcessBatch_EMail]
    @ProcessBatch_ID            INT,
    @RecipientEmail             NVARCHAR(258) = NULL,
    @RecipientFromMFSettingName NVARCHAR(258) = NULL,
    @ContextMenu_ID             INT           = NULL, --Future use once [Last_Executed_by] has been added to MFContextMenu
    @DetailLevel                INT           = 0,
	@LogTypes				NVARCHAR(258) = 'Message',
    @Debug                      INT           = 0
AS
    BEGIN

        --** Stored Proc Content

        ------------------------------------------------------
        -- SET SESSION STATE
        -------------------------------------------------------
        SET NOCOUNT ON;

        ------------------------------------------------------
        -- DECLARE VARIABLES
        ------------------------------------------------------
        DECLARE
            @ec            INT,
            @rowcount      INT,
            @ProcedureName sysname,
            @ProcedureStep sysname;

        DECLARE
            @ErrorSeverity   INT,
            @ErrorState      INT,
            @ErrorNumber     INT,
            @ErrorLine       INT,
            @ErrorMessage    NVARCHAR(500),
            @ErrorProcedure  NVARCHAR(128),
            @OptionalMessage VARCHAR(MAX);

        DECLARE
            @ErrStep VARCHAR(255),
            @Stage   VARCHAR(50),
            @Step    VARCHAR(30);

        ------------------------------------------------------
        -- DEFINE CONSTANTS
        ------------------------------------------------------
        SET @ProcedureName = '[dbo].[spMFProcessBatch_EMail]';
        SET @ec = 0;
        SET @rowcount = 0;
        SET @Stage = 'Email';

        BEGIN TRY
            SET @Step = 'Prepare';

            ------------------------------------------------------
            -- ignore if email is not setup
            ------------------------------------------------------

            IF
                (
                    SELECT
                        COUNT(*)
                    FROM
                        [msdb].[dbo].[sysmail_profile] AS [sp]
                ) > 0
                BEGIN

                    --############################## Get DBMail Profile ##############################
                    SET @ProcedureStep = 'Get Email Profile';

                    DECLARE @EMAIL_PROFILE VARCHAR(255);
                    DECLARE @ReturnValue INT;

                    EXEC @ReturnValue = [dbo].[spMFValidateEmailProfile]
                        @emailProfile = @EMAIL_PROFILE OUTPUT, -- varchar(100)
                        @debug = @Debug;                       -- smallint

                    IF @ReturnValue = 1
                        BEGIN

                            --		SELECT @EMAIL_PROFILE

                            SELECT
                                @EMAIL_PROFILE = CONVERT(VARCHAR(50), [Value])
                            FROM
                                [dbo].[MFSettings]
                            WHERE
                                [Name] = 'SupportEMailProfile';
                        END;


                    --############################## Get From, ReplyTo & CC ##############################
                    SET @ProcedureStep = 'Get Email Address';

                    DECLARE
                        @EMAIL_FROM_ADDR    VARCHAR(255),
                        @EMAIL_REPLYTO_ADDR VARCHAR(255),
                        @EMAIL_CC_ADDR      VARCHAR(255),
                        @EMAIL_TO_ADDR      VARCHAR(255);

                    SELECT
                        @EMAIL_FROM_ADDR = [a].[email_address]
                    FROM
                        [msdb].[dbo].[sysmail_account]            AS [a]
                        INNER JOIN
                            [msdb].[dbo].[sysmail_profileaccount] AS [pa]
                                ON [a].[account_id] = [pa].[account_id]
                        INNER JOIN
                            [msdb].[dbo].[sysmail_profile]        AS [p]
                                ON [pa].[profile_id] = [p].[profile_id]
                    WHERE
                        [p].[name] = @EMAIL_PROFILE
                        AND [pa].[sequence_number] = 1;


                    --############################## Get Recipients ##############################
                    SET @ProcedureStep = 'Get Email Recipients';

                    DECLARE @RecipientFromMFSetting NVARCHAR(258);
                    DECLARE @RecipientFromContextMenu NVARCHAR(258);


                    IF @RecipientFromMFSettingName IS NOT NULL
                        SELECT
                            @RecipientFromMFSetting = CONVERT(VARCHAR(258), [Value])
                        FROM
                            [dbo].[MFSettings]
                        WHERE
                            [Name] = @RecipientFromMFSettingName;

                    -- To be implemented when [Last_Executed_by] has been added to MFContextMenu
                    IF @ContextMenu_ID IS NOT NULL
                        SELECT
                            @RecipientFromContextMenu = [dbo].[MFLoginAccount].[EmailAddress]
                        FROM
                            [dbo].[MFContextMenu]
                            INNER JOIN
                                [dbo].[MFUserAccount] AS [mua]
                                    ON [mua].[UserID] = [MFContextMenu].[Last_Executed_By]
                            INNER JOIN
                                [dbo].[MFLoginAccount]
                                    ON [mua].[LoginName] = [MFLoginAccount].[UserName]
                        WHERE
                            [MFContextMenu].[ID] = @ContextMenu_ID;


                    SET @EMAIL_TO_ADDR = CASE
                                             WHEN @RecipientEmail IS NOT NULL
                                                 THEN @RecipientEmail
                                             ELSE
                                                 ''
                                         END + CASE
                                                   WHEN @RecipientFromMFSetting IS NOT NULL
                                                       THEN ';' + @RecipientFromMFSetting
                                                   ELSE
                                                       ''
                                               END + CASE
                                                         WHEN @RecipientFromContextMenu IS NOT NULL
                                                             THEN ';' + @RecipientFromContextMenu
                                                         ELSE
                                                             ''
                                                     END;

                    IF @Debug > 0
                        SELECT
                            @EMAIL_TO_ADDR;

                    IF ISNULL(@EMAIL_TO_ADDR, '') = ''
                        SELECT
                            @EMAIL_TO_ADDR = CONVERT(VARCHAR(100), [Value])
                        FROM
                            [dbo].[MFSettings]
                        WHERE
                            [Name] = 'SupportEmailRecipient'
                            AND [source_key] = 'Email';
          
		            IF @Debug > 0
                        SELECT
                            @EMAIL_TO_ADDR;

                    IF LEFT(@EMAIL_TO_ADDR, 1) = ';'
                        SET @EMAIL_TO_ADDR = SUBSTRING(@EMAIL_TO_ADDR, 2, LEN(@EMAIL_TO_ADDR));


                    --############################## Get Subject ##############################
                    SET @ProcedureStep = 'Get Email Subject';

                    DECLARE @EMAIL_SUBJECT VARCHAR(255);

                    SELECT
                        @EMAIL_SUBJECT
                        = 'MFSQL: ' + ISNULL([mpb].[ProcessType], '(process type unknown)') + ' | '
                          + ISNULL([mpb].[Status], '(status unknown)') + ' | Process Batch - ID '
                          + CAST(@ProcessBatch_ID AS VARCHAR(10))
                    FROM
                        [dbo].[MFProcessBatch] AS [mpb]
                    WHERE
                        [mpb].[ProcessBatch_ID] = @ProcessBatch_ID;

                    --############################## Get Body ##############################	
                    SET @ProcedureStep = 'Get Email Body';
                    DECLARE @EMAIL_BODY NVARCHAR(MAX);

               
				    EXEC [dbo].[spMFResultMessageForUI]
                        @Processbatch_ID = @ProcessBatch_ID,
                        @GetEmailContent = 1,
						@DetailLevel = @DetailLevel,
                        @EMailHTMLBodyOUT = @EMAIL_BODY OUTPUT;



                    SET @Step = 'Send';
                    SET @ProcedureStep = 'EXEC msdb.dbo.Sp_send_dbmail';

                    --------------------------------------
                    --EXECUTE Sp_send_dbmail TO SEND MAIL
                    ---------------------------------------
                    IF @Debug > 0
                        SELECT
                            @EMAIL_BODY;



                    BEGIN TRY

                        EXEC [msdb].[dbo].[sp_send_dbmail]
                            @profile_name = @EMAIL_PROFILE,
                            @recipients = @EMAIL_TO_ADDR, --, @copy_recipients = @EMAIL_CC_ADDR
                            @subject = @EMAIL_SUBJECT,
                            @body = @EMAIL_BODY,
                            @body_format = 'HTML';

                    END TRY
                    BEGIN CATCH

                        SELECT
                            @ErrorMessage   = ERROR_MESSAGE(),
                            @ErrorSeverity  = ERROR_SEVERITY(),
                            @ErrorState     = ERROR_STATE(),
                            @ErrorNumber    = ERROR_NUMBER(),
                            @ErrorLine      = ERROR_LINE(),
                            @ErrorProcedure = ERROR_PROCEDURE();


                        IF @Debug > 0
                            RAISERROR('ERROR in %s at %s: %s', 16, 1, @ErrorProcedure, @ProcedureStep, @ErrorMessage);

                        INSERT INTO [MFLog]
                            (
                                [SPName],
                                [ErrorNumber],
                                [ErrorMessage],
                                [ErrorProcedure],
                                [ErrorState],
                                [ErrorSeverity],
                                [ErrorLine],
                                [ProcedureStep]
                            )
                        VALUES
                            (
                                @ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(),
                                ERROR_SEVERITY(), ERROR_LINE(), @ProcedureStep
                            );

                        RAISERROR(   @ErrorMessage,  -- Message text.
                                     @ErrorSeverity, -- Severity.
                                     @ErrorState     -- State.
                                 );
                    END CATCH;




                    RETURN 1;

                END; --IF	(	SELECT COUNT(*)	FROM   [msdb].[dbo].[sysmail_profile] AS [sp]) > 0
            ELSE
                PRINT 'Database mail has not setup been setup. Complete the setup to receive notifications by email';
            RETURN 2;

        END TRY
        BEGIN CATCH


            SELECT
                @ErrorMessage   = ERROR_MESSAGE(),
                @ErrorSeverity  = ERROR_SEVERITY(),
                @ErrorState     = ERROR_STATE(),
                @ErrorNumber    = ERROR_NUMBER(),
                @ErrorLine      = ERROR_LINE(),
                @ErrorProcedure = ERROR_PROCEDURE();


            RAISERROR(   @ErrorMessage,  -- Message text.
                         @ErrorSeverity, -- Severity.
                         @ErrorState     -- State.
                     );

            RETURN -1;
        END CATCH;

    END;

GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFTableAudit]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFTableAudit' -- nvarchar(100)
                                    ,@Object_Release = '4.4.13.53'   -- varchar(50)
                                    ,@UpdateFlag = 2;                -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFTableAudit' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFTableAudit]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFTableAudit]
(
    @MFTableName NVARCHAR(128)
   ,@MFModifiedDate DATETIME = NULL    --NULL to select all records
   ,@ObjIDs NVARCHAR(4000) = NULL
   ,@SessionIDOut INT OUTPUT           -- output of session id
   ,@NewObjectXml NVARCHAR(MAX) OUTPUT -- return from M-Files
   ,@DeletedInSQL INT = 0 OUTPUT
   ,@UpdateRequired BIT = 0 OUTPUT     --1 is set when the result show a difference between MFiles and SQL  
   ,@OutofSync INT = 0 OUTPUT          -- > 0 eminent Sync Error when update from SQL to MF is processed
   ,@ProcessErrors INT = 0 OUTPUT      -- > 0 unfixed errors on table
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0                -- use 2 for listing of full tables during debugging
)
AS
/*rST**************************************************************************

==============
spMFTableAudit
==============

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(128)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @MFModifiedDate datetime
    Filter by MFiles Last Modified date as a datetime string. Set to null if all records must be selected
  @ObjIDs nvarchar(4000)
    Filter by comma delimited string of objid of the objects to process. Set as null if all records must be included
  @SessionIDOut int (output)
    Output of the session id used to update table MFAuditHistory
  @NewObjectXml nvarchar(max) (output)
    Output of the objver of the record set as a result in nvarchar datatype. This can be converted to an XML record for further processing
  @DeletedInSQL int (output)
    Output the number of items that will be marked as deleted when processing the next spmfUpdateTable
  @UpdateRequired bit (output)
    Set to 1 if any condition exist where M-Files and SQL is not the same.  This can be used to trigger a spmfUpdateTable only when it necessary
  @OutofSync int (output)
    If > 0 then the next updatetable procedure will have synchronisation errors
  @ProcessErrors int (output)
    If > 0 then there are unresolved errors in the table with process_id = 3 or 4
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

Update MFAuditHistory and return the sessionid and the M-Files objver of the selection class as a varchar that can be converted to XML if there is a need for further processing of the result.

Additional Info
===============

At the same time spMFTableAudit will set the deleted flag for all the records in the Class Table that is deleted in M-Files.  This is particularly relevant when this procedure is used in conjunction with the spMFUpdateTable procedure with the filter MFLastModified set.

See also spMFTableAuditInBatches for large scale class tables.

Examples
========

.. code:: sql

    DECLARE @SessionIDOut INT
           ,@NewObjectXml NVARCHAR(MAX)
           ,@DeletedInSQL INT
           ,@UpdateRequired BIT
           ,@OutofSync INT
           ,@ProcessErrors INT
           ,@ProcessBatch_ID INT;

    EXEC [dbo].[spMFTableAudit]
               @MFTableName = N'MFCustomer' -- nvarchar(128)
              ,@MFModifiedDate = null -- datetime
              ,@ObjIDs = null -- nvarchar(4000)
              ,@SessionIDOut = @SessionIDOut OUTPUT -- int
              ,@NewObjectXml = @NewObjectXml OUTPUT -- nvarchar(max)
              ,@DeletedInSQL = @DeletedInSQL OUTPUT -- int
              ,@UpdateRequired = @UpdateRequired OUTPUT -- bit
              ,@OutofSync = @OutofSync OUTPUT -- int
              ,@ProcessErrors = @ProcessErrors OUTPUT -- int
              ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT -- int
              ,@Debug = 0 -- smallint

    SELECT @SessionIDOut AS 'session', @UpdateRequired AS UpdateREquired, @OutofSync AS OutofSync, @ProcessErrors AS processErrors
    SELECT * FROM [dbo].[MFProcessBatch] AS [mpb] WHERE [mpb].[ProcessBatch_ID] = @ProcessBatch_ID
    SELECT * FROM [dbo].[MFProcessBatchDetail] AS [mpbd] WHERE [mpbd].[ProcessBatch_ID] = @ProcessBatch_ID

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-12  LC         Fix bug - remove deleted objects from table
2019-08-30  JC         Added documentation
2019-08-16  LC         Fix bug for removing destroyed objects
2019-06-22  LC         Objid parameter not yet functional
2019-05-18  LC         Add additional exception for deleted in SQL but not deleted in MF
2019-04-11  LC         Fix collection object type in table
2019-04-11  LC         Add large table protection
2019-04-11  LC         Add validation table exists
2018-12-15  LC         Add ability to get result for selected objids
2018-08-01  LC         Resolve issue with having try catch in transaction processing
2017-12-28  LC         Change insert to merge on audit table
2017-12-27  LC         Remove incorrect error message
2017-08-28  LC         Add param for update required
2017-08-28  LC         Add logging
2017-08-28  LC         Change sequence of params
2016-08-22  LC         Change objids to NVARCHAR(4000)
==========  =========  ========================================================

**rST*************************************************************************/

/*

DECLARE @SessionIDOut int, @return_Value int, @NewXML nvarchar(max)
EXEC @return_Value = spMFTableAudit 'MFOtherdocument' , null, null, 1, @SessionIDOut = @SessionIDOut output, @NewObjectXml = @NewXML output
SELECT @SessionIDOut ,@return_Value, @NewXML

*/

-------------------------------------------------------------
-- CONSTANTS: MFSQL Class Table Specific
-------------------------------------------------------------
SET NOCOUNT ON;

DECLARE @ProcessType AS NVARCHAR(50);

SET @ProcessType = 'Table Audit';

-------------------------------------------------------------
-- CONSTATNS: MFSQL Global 
-------------------------------------------------------------
DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
DECLARE @Process_ID_1_Update TINYINT = 1;
DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
DECLARE @Process_ID_2_SyncError TINYINT = 2;
DECLARE @ProcessBatchSize INT = 250;

-------------------------------------------------------------
-- VARIABLES: MFSQL Processing
-------------------------------------------------------------
DECLARE @Update_ID INT;
DECLARE @MFLastModified DATETIME;
DECLARE @Validation_ID INT;
-------------------------------------------------------------
-- VARIABLES: T-SQL Processing
-------------------------------------------------------------
DECLARE @rowcount AS INT = 0;
DECLARE @return_value AS INT = 0;
DECLARE @error AS INT = 0;

-------------------------------------------------------------
-- VARIABLES: DEBUGGING
-------------------------------------------------------------
DECLARE @ProcedureName AS NVARCHAR(128) = 'spMFTableAudit';
DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
DECLARE @DebugText AS NVARCHAR(256) = '';
DECLARE @Msg AS NVARCHAR(256) = '';
DECLARE @MsgSeverityInfo AS TINYINT = 10;
DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

-------------------------------------------------------------
-- VARIABLES: LOGGING
-------------------------------------------------------------
DECLARE @LogType AS NVARCHAR(50) = 'Status';
DECLARE @LogText AS NVARCHAR(4000) = '';
DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
DECLARE @count INT = 0;
DECLARE @Now AS DATETIME = GETDATE();
DECLARE @StartTime AS DATETIME = GETUTCDATE();
DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

-------------------------------------------------------------
-- VARIABLES: DYNAMIC SQL
-------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @sqlParam NVARCHAR(MAX) = N'';

-------------------------------------------------------------
-- INTIALIZE PROCESS BATCH
-------------------------------------------------------------
SET @ProcedureStep = 'Start Logging';
SET @LogText = 'Processing ' + @ProcedureName;

EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                    ,@ProcessType = @ProcessType
                                    ,@LogType = N'Status'
                                    ,@LogText = @LogText
                                    ,@LogStatus = N'In Progress'
                                    ,@debug = @Debug;

EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                          ,@LogType = N'Debug'
                                          ,@LogText = @LogText
                                          ,@LogStatus = N'Started'
                                          ,@StartTime = @StartTime
                                          ,@MFTableName = @MFTableName
                                          ,@Validation_ID = @Validation_ID
                                          ,@ColumnName = NULL
                                          ,@ColumnValue = NULL
                                          ,@Update_ID = @Update_ID
                                          ,@LogProcedureName = @ProcedureName
                                          ,@LogProcedureStep = @ProcedureStep
                                          ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                          ,@debug = @Debug;

BEGIN TRY


    SET XACT_ABORT ON;

    -----------------------------------------------------
    --DECLARE LOCAL VARIABLE
    -----------------------------------------------------
    DECLARE @Id              INT
           ,@objID           INT
           ,@ObjectIdRef     INT
           ,@ObjVersion      INT
           ,@XMLOut          NVARCHAR(MAX)
           ,@ObjIDsForUpdate NVARCHAR(MAX)
           ,@MinObjid        INT
           ,@MaxObjid        INT
           ,@DefaultDate     DATETIME       = '2000-01-01'
                                           --             @Output NVARCHAR(200) ,
           ,@FullXml         XML           --
           ,@SynchErrorObj   NVARCHAR(MAX) --Declared new paramater
           ,@DeletedObjects  NVARCHAR(MAX) --Declared new paramater
           ,@ObjectId        INT
           ,@ClassId         INT
           ,@ErrorInfo       NVARCHAR(MAX)
           ,@MFIDs           NVARCHAR(2500) = ''
           ,@RunTime         VARCHAR(20);
    DECLARE @Idoc INT;

    SET @StartTime = GETUTCDATE();

    IF EXISTS
    (
        SELECT *
        FROM [sys].[objects]
        WHERE [object_id] = OBJECT_ID(N'[dbo].[' + @MFTableName + ']')
              AND [type] IN ( N'U' )
    )
    BEGIN

        --        BEGIN TRAN [main];
        --IF @Debug > 0
        --BEGIN
        --    SET @RunTime = CONVERT(VARCHAR(20), GETDATE());

        --    RAISERROR('Proc: %s Step: %s Time: %s', 10, 1, @ProcedureName, @ProcedureStep, @RunTime);
        --END;

        -----------------------------------------------------
        --Set Object Type Id and class id
        -----------------------------------------------------
        SET @ProcedureStep = 'Get Object Type and Class';

        SELECT @ObjectIdRef = [mc].[MFObjectType_ID]
              ,@ObjectId    = [ob].[MFID]
              ,@ClassId     = [mc].[MFID]
        FROM [dbo].[MFClass]                AS [mc]
            INNER JOIN [dbo].[MFObjectType] AS [ob]
                ON [ob].[ID] = [mc].[MFObjectType_ID]
        WHERE [mc].[TableName] = @MFTableName;

        SELECT @ObjectId = [MFID]
        FROM [dbo].[MFObjectType]
        WHERE [ID] = @ObjectIdRef;

        IF @Debug > 0
        BEGIN
            RAISERROR(
                         'Proc: %s Step: %s ObjectType: %i Class: %i'
                        ,10
                        ,1
                        ,@ProcedureName
                        ,@ProcedureStep
                        ,@ObjectId
                        ,@ClassId
                     );

        --SELECT *
        --FROM [dbo].[MFClass]
        --WHERE [MFID] = @ClassId;
        END;

        --SET @DebugText = 'ObjectIDs for update %s';
        --SET @DebugText = @DefaultDebugText + @DebugText;
        --SET @ProcedureStep = '';

        --IF @Debug > 0
        --BEGIN
        --    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjIDsForUpdate);
        --END;

		-------------------------------------------------------------
		-- Get class table name
		-------------------------------------------------------------
	DECLARE @ClassTableColumn NVARCHAR(100)
		SELECT @ClassTableColumn = [ColumnName] FROM MFproperty WHERE mfid = 100
        -----------------------------------------------------
        --Wrapper Method
        -----------------------------------------------------
        SET @ProcedureStep = 'Filters';

        SELECT @ObjIDsForUpdate = @ObjIDs;

        SET @DebugText = ':on objids %s ';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjIDsForUpdate);
        END;

        SET @DefaultDate = CASE
                               WHEN @ObjIDs IS NOT NULL THEN
                                   @DefaultDate
                               WHEN @MFModifiedDate IS NULL THEN
                                   @DefaultDate
                               ELSE
                                   @MFModifiedDate
                           END;
        SET @DebugText = ' :on date ' + CAST(@DefaultDate AS NVARCHAR(30));
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        SET @ProcedureStep = 'Wrapper: getObjectvers ';

        EXEC @return_value = [dbo].[spMFGetObjectvers] @TableName = @MFTableName         -- nvarchar(max)
                                                      ,@dtModifiedDate = @DefaultDate    -- datetime
                                                      ,@MFIDs = @ObjIDs                  -- nvarchar(max)
                                                      ,@outPutXML = @NewObjectXml OUTPUT -- nvarchar(max)
                                                      ,@ProcessBatch_ID = @ProcessBatch_ID
                                                      ,@Debug = @Debug;

        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @NewObjectXml;

    
        BEGIN
            SET @ProcedureStep = 'Create Temp table';

            CREATE TABLE [#AllObjects]
            (
                [ID] INT
               ,[Class] INT
               ,[ObjectType] INT
               ,[ObjID] INT
               ,[MFVersion] INT
               ,[StatusFlag] SMALLINT
            );

            CREATE INDEX [idx_AllObjects_ObjID] ON [#AllObjects] ([ObjID]);
          
            SET @ProcedureStep = ' Insert items in Temp Table';

            WITH [cte]
            AS (SELECT [xmlfile].[objId]
                      ,[xmlfile].[MFVersion]
                      --       ,[xmlfile].[GUID]
                      ,[xmlfile].[ObjType]
                FROM
                    OPENXML(@Idoc, '/form/objVers', 1)
                    WITH
                    (
                        [objId] INT './@objectID'
                       ,[MFVersion] INT './@version'
                       --         ,[GUID] NVARCHAR(100) './@objectGUID'
                       ,[ObjType] INT './@objectType'
                    ) [xmlfile])
            --SELECT *
            --INTO [#AllObjects]
            --FROM [cte];
            INSERT INTO [#AllObjects]
            (
                [Class]
               ,[ObjectType]
               ,[MFVersion]
               ,[ObjID]
            )
            SELECT @ClassId
                  ,[cte].[ObjType]
                  ,[cte].[MFVersion]
                  ,[cte].[objId]
            FROM [cte];

            EXEC [sys].[sp_xml_removedocument] @Idoc;

            SET @rowcount = @@RowCount;
            SET @ProcedureStep = 'Get Object Versions';
            SET @StartTime = GETUTCDATE();
            SET @LogTypeDetail = 'Debug';
            SET @LogTextDetail = 'Objects from M-Files';
            SET @LogStatusDetail = 'Status';
            SET @LogColumnName = 'Objvers returned';
            SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));

            EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                      ,@LogType = @LogTypeDetail
                                                      ,@LogText = @LogTextDetail
                                                      ,@LogStatus = @LogStatusDetail
                                                      ,@StartTime = @StartTime
                                                      ,@MFTableName = @MFTableName
                                                      ,@Validation_ID = @Validation_ID
                                                      ,@ColumnName = @LogColumnName
                                                      ,@ColumnValue = @LogColumnValue
                                                      ,@Update_ID = @Update_ID
                                                      ,@LogProcedureName = @ProcedureName
                                                      ,@LogProcedureStep = @ProcedureStep
                                                      ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                                      ,@debug = 0;

            IF @Debug > 0
            BEGIN
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
                    SELECT 'PreFlag',*
                    FROM [#AllObjects] AS [ao];
			END

            DECLARE @Query     NVARCHAR(MAX)
                   ,@SessionID INT
                   ,@TranDate  DATETIME
                   ,@Params    NVARCHAR(MAX);

            SELECT @TranDate = GETDATE();

            SET @ProcedureStep = 'Get Session ID';

            -- check if MFAuditHistory has been initiated
            SELECT @count = COUNT(*)
            FROM [dbo].[MFAuditHistory] AS [mah];

            SELECT @SessionID = CASE
                                    WHEN @SessionIDOut IS NULL
                                         AND @count = 0 THEN
                                        1
                                    WHEN @SessionIDOut IS NULL
                                         AND @count > 0 THEN
            (
                SELECT MAX(ISNULL([SessionID], 0)) + 1 FROM [dbo].[MFAuditHistory]
            )
                                    ELSE
                                        @SessionIDOut
                                END;

            SET @DebugText = ' Session ID %i';
            SET @DebugText = @DefaultDebugText + @DebugText;

            IF @Debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @SessionID);
            END;

            -------------------------------------------------------------
            -- pre validations
            -------------------------------------------------------------
            /*

0 = identical : [ao].[MFVersion] = [t].[MFVersion] AND ISNULL([t].[deleted], 0) = 0
1 = MF IS Later : [ao].[MFVersion] > [t].[MFVersion] AND [t].[deleted] = 0 
2 = SQL is later : ao.[MFVersion] < ISNULL(t.[MFVersion],-1) 
3 = Deleted in MF : t.deleted = 1 and isnull(ao.MFversion,0) = 0
4 =  SQL to be Deleted : WHEN ao.[MFVersion]  IS NULL and isnull(t.deleted,0) = 0 and isnull(t.objid,0) > 0                                              
5 =  Not in SQL : N t.[MFVersion] is null and ao.[MFVersion] is not null                                                            
6 = Not yet process in SQL : t.id IS NOT NULL AND t.objid IS NULL


*/
            SET @ProcedureStep = ' set id and flags ';

            SELECT @Query
                = N'UPDATE ao
SET ao.[ID] = t.id
,StatusFlag = CASE WHEN [ao].[MFVersion] = ISNULL([t].[MFVersion],-1) AND ISNULL([t].[deleted], 0) = 0 THEN 0
WHEN [ao].[MFVersion] > ISNULL([t].[MFVersion],-1) AND [t].[deleted] = 0  THEN 1
WHEN ao.[MFVersion] < ISNULL(t.[MFVersion],-1) AND ISNULL(t.[objid],-1)	> 0 THEN 2
WHEN ISNULL(ao.MFVersion,0) = 0 THEN 4
WHEN ISNULL(t.id,0) = 0 AND ISNULL(t.[objid],0) = 0 THEN 5
WHEN ISNULL(t.id,0) > 0 AND ISNULL(t.[objid],0) = 0 THEN 5
END 
FROM [#AllObjects] AS [ao]
left JOIN ' +   QUOTENAME(@MFTableName) + ' t
ON ao.[objid] = t.[objid] ;';

      --           Print @Query;
            EXEC [sys].[sp_executesql] @Stmt = @Query;



            SET @DebugText = '';
            SET @DebugText = @DefaultDebugText + @DebugText;

            IF @Debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

             SELECT 'Postflag',* FROM [#AllObjects] AS [ao]
            END;

			DECLARE @TotalObjver INT
			DECLARE @FilteredObjver INT
			DECLARE @ToUpdateObjver INT
			DECLARE @NotInAuditHistory int

			SELECT @TotalObjver = COUNT(*) FROM [dbo].[MFAuditHistory] AS [mah] WHERE [mah].[Class] = @ClassId
			SELECT @FilteredObjver = COUNT(*) FROM [#AllObjects] AS [ao]
			SELECT @ToUpdateObjver = COUNT(*) FROM [#AllObjects] AS [ao] WHERE [ao].[StatusFlag] IN (1,5)
			SELECT @NotInAuditHistory = COUNT(*) FROM [#AllObjects] AS [ao]
			LEFT JOIN [dbo].[MFAuditHistory] AS [mah]
			ON [mah].[Class] = [ao].[Class] AND [mah].[ObjID] = [ao].[ObjID]
			WHERE mah.[Objid] IS null

			                           SET @LogTypeDetail = 'Status';
			                           SET @LogStatusDetail = 'In progress';
			                           SET @LogTextDetail = 'MFAuditHistory: Total: '+ CAST(COALESCE(@TotalObjver,0) AS NVARCHAR(10)) + ' Filtered: ' + CAST(COALESCE(@FilteredObjver,0) AS NVARCHAR(10)) + ' To update: ' + CAST(COALESCE(@ToUpdateObjver,0) AS NVARCHAR(10))
			                           SET @LogColumnName = 'Objvers to update';
			                           SET @LogColumnValue = CAST(COALESCE(@ToUpdateObjver,0) AS NVARCHAR(10));
			
			                           EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert]
			                            @ProcessBatch_ID = @ProcessBatch_ID
			                          , @LogType = @LogTypeDetail
			                          , @LogText = @LogTextDetail
			                          , @LogStatus = @LogStatusDetail
			                          , @StartTime = @StartTime
			                          , @MFTableName = @MFTableName
			                          , @Validation_ID = @Validation_ID
			                          , @ColumnName = @LogColumnName
			                          , @ColumnValue = @LogColumnValue
			                          , @Update_ID = @Update_ID
			                          , @LogProcedureName = @ProcedureName
			                          , @LogProcedureStep = @ProcedureStep
			                          , @debug = @debug

            --Delete redundant objects in class table in SQL: this can only be applied when a full Audit is performed
            --7 = Marked deleted in SQL not deleted in MF : [t].[Deleted] = 1
            SET @ProcedureStep = 'Delete redudants in SQL';

            IF @DeletedInSQL = 1
            BEGIN
                SELECT @Query
                    = N'DELETE FROM ' + QUOTENAME(@MFTableName)
                      + '
WHERE id IN (
SELECT t.id
FROM [#AllObjects] AS [ao]
right JOIN '                    + QUOTENAME(@MFTableName) + ' t
ON ao.objid = t.objid 
WHERE ao.objid IS NULL) ;';

            --            SELECT @Query;
                EXEC [sys].[sp_executesql] @Query;


                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;
            END; -- Delete from SQL

			-------------------------------------------------------------
			-- Process objversions to audit history
			-------------------------------------------------------------
			IF @ToUpdateObjver > 0 OR @NotInAuditHistory > 0
			BEGIN

            SET @ProcedureStep = 'Update records in Audit History';

			Set @DebugText = ' Count %i'
			Set @DebugText = @DefaultDebugText + @DebugText

	SELECT @rowcount = 	 COUNT(*) FROM [#AllObjects] AS [ao]	

			IF @debug > 0
				Begin
					RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep,@rowcount );
					

				END
			
			SELECT @ProcedureStep = 'Merge into MFAuditHistory'

            MERGE INTO [dbo].[MFAuditHistory] [targ]
            USING
            (
                SELECT [ao].[ID]
                      ,[ao].[ObjID]
                      ,[ao].[MFVersion]
                      ,[ao].[ObjectType] AS [ObjectID]
                      ,@SessionID        AS [SessionID]
                      ,@TranDate         AS [TranDate]
                      ,@ClassId          AS [Class]
                      ,[ao].[StatusFlag] AS [Statusflag]
                      ,CASE
                           WHEN [ao].[StatusFlag] = 0 THEN
                               'Identical'
                           WHEN [ao].[StatusFlag] = 1 THEN
                               'MF is later'
                           WHEN [ao].[StatusFlag] = 2 THEN
                               'SQL is later'
                           WHEN [ao].[StatusFlag] = 3 THEN
                               'Deleted in MF'
                           WHEN [ao].[StatusFlag] = 4 THEN
                               'SQL to be marked as deleted'
                           WHEN [ao].[StatusFlag] = 5 THEN
                               'Not in SQL'
                           WHEN [ao].[StatusFlag] = 6 THEN
                               'Not yet processed in SQL'
                       END               AS [StatusName]
                      ,CASE
                           WHEN [ao].[StatusFlag] <> 0 THEN
                               1
                           ELSE
                               0
                       END               [UpdateFlag]
                FROM [#AllObjects] AS [ao]
            ) AS [Src]
            ON [targ].[ObjID] = [Src].[ObjID]
               AND [targ].[Class] = [Src].[Class]
            WHEN NOT MATCHED THEN
                INSERT
                (
                    [RecID]
                   ,[SessionID]
                   ,[TranDate]
                   ,[ObjectType]
                   ,[Class]
                   ,[ObjID]
                   ,[MFVersion]
                   ,[StatusFlag]
                   ,[StatusName]
                   ,[UpdateFlag]
                )
                VALUES
                ([Src].[ID], [Src].[SessionID], [Src].[TranDate], [Src].[ObjectID], [Src].[Class], [Src].[ObjID]
                ,[Src].[MFVersion], [Src].[Statusflag], [Src].[StatusName], 1)
            WHEN MATCHED THEN
                UPDATE SET [targ].[RecID] = [Src].[ID]
                          ,[targ].[SessionID] = [Src].[SessionID]
                          ,[targ].[TranDate] = [Src].[TranDate]
                          ,[targ].[ObjectType] = [Src].[ObjectID]
                          ,[targ].[MFVersion] = [Src].[MFVersion]
                          ,[targ].[StatusFlag] = [Src].[Statusflag]
                          ,[targ].[StatusName] = [Src].[StatusName]
                          ,[targ].[UpdateFlag] = [Src].[UpdateFlag];

						  	Set @DebugText = ''
			Set @DebugText = @DefaultDebugText + @DebugText
     
	        IF @Debug > 0
            BEGIN
                RAISERROR('Proc: %s Step: %s', 10, 1, @ProcedureName, @ProcedureStep);
            END;

			END --update items into MFaudithisitory

			-------------------------------------------------------------
			-- Remove from MFauditHistory where objids is not returned from MF
			-------------------------------------------------------------
	  SET @ProcedureStep = 'Delete from audit history';
	  		
			IF @MFIDs IS NOT NULL
            BEGIN
            
			WITH cte AS
            (
			SELECT [ListItem] AS [Objid] from [dbo].[fnMFParseDelimitedString](@MFIDs,',') fps
			LEFT JOIN [#AllObjects] AS [ao]
			ON fps.[ListItem] = ao.[ObjID]
			WHERE ao.objid IS null
			)
			DELETE FROM [dbo].[MFAuditHistory] 
			WHERE [Class] = @ClassId AND [Objid] IN (SELECT cte.[Objid] FROM cte)
			END

            -----------------------------------------------------------
     --        Delete from audit history where item no longer in class table and flag = 4
            -----------------------------------------------------------
          

            IF
            (
                SELECT ISNULL([IncludeInApp], 0)
                FROM [dbo].[MFClass]
                WHERE [TableName] = @MFTableName
            ) != 0
            BEGIN
                SET @sql
                    = N'
   Delete FROM [dbo].[MFAuditHistory]
						   WHERE id IN (SELECT mah.id from [dbo].[MFAuditHistory] mah
						   left JOIN ' + QUOTENAME(@MFTableName)
                      + ' AS [mlv]
						   ON mlv.objid = mah.[ObjID] AND mlv.'+@ClassTableColumn+' = mah.[Class]
						   WHERE mlv.id IS NULL) and isnull(StatusFlag,-1) = -1  ;';

                EXEC (@sql);
            END;




        -------------------------------------------------------------
        -- Set UpdateRequired
        -------------------------------------------------------------
        DECLARE @MFRecordCount INT
               ,@MFNotInSQL    INT
               ,@LaterInMF     INT
               ,@Process_id_1  INT
               ,@NewSQL        INT;

        --EXEC [dbo].[spMFClassTableStats] @ClassTableName = @MFTableName -- nvarchar(128)
        --                                ,@Flag = 0             -- int
        --                                ,@IncludeOutput = 1    -- int
        --                                ,@Debug = 0            -- smallint

        --SELECT @MFNotInSQL = MFNotInSQL, @OutofSync = SyncError, @ProcessErrors = MFError + SQLError, @Process_id_1 = Process_id_1  FROM ##spmfclasstablestats
        --WHERE TableName = @MFTableName
        SELECT @LaterInMF = COUNT(*)
        FROM [dbo].[MFAuditHistory] AS [mah]
        WHERE [mah].[SessionID] = @SessionIDOut
              AND [mah].[StatusFlag] = 1;

        SELECT @NewSQL = COUNT(*)
        FROM [dbo].[MFAuditHistory] AS [mah]
        WHERE [mah].[SessionID] = @SessionIDOut
              AND [mah].[StatusFlag] = 5;

        SELECT @UpdateRequired = CASE
                                     WHEN @LaterInMF > 0
                                          OR @MFNotInSQL > 0
                                          OR @Process_id_1 > 0
                                          OR @NewSQL > 0 THEN
                                         1
                                     ELSE
                                         0
                                 END;

        SET @Msg = 'Session: ' + CAST(@SessionIDOut AS VARCHAR(5));

        IF @UpdateRequired > 0
            SET @Msg = @Msg + ' | Update Required: ' + CAST(@UpdateRequired AS VARCHAR(5));

        IF @LaterInMF > 0
            SET @Msg = @Msg + ' | MF Updates : ' + CAST(@LaterInMF AS VARCHAR(5));

        IF @Process_id_1 > 0
            SET @Msg = @Msg + ' | SQL Updates : ' + CAST(@Process_id_1 AS VARCHAR(5));

        IF @Process_id_1 > 0
            SET @Msg = @Msg + ' | SQL New : ' + CAST(@NewSQL AS VARCHAR(5));


	EXEC [dbo].[spMFProcessBatch_Upsert]
				@ProcessBatch_ID = @ProcessBatch_ID
			  , @ProcessType = @ProcessType
			  , @LogType = N'Debug'
			  , @LogText = @LogText
			  , @LogStatus = @LogStatus
			  , @debug = @Debug

        SET @StartTime = GETUTCDATE();
        SET @LogTypeDetail = 'Debug';
        SET @LogTextDetail = @Msg;
        SET @LogStatusDetail = 'Status';
        SET @LogColumnName = 'Objects';
        SET @LogColumnValue = '';

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = @LogTypeDetail
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatusDetail
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = @LogColumnName
                                                  ,@ColumnValue = @LogColumnValue
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                                  ,@debug = 0;

            --        COMMIT TRAN [main];
            DROP TABLE [#AllObjects];
        END; --nothing to update in AuditHistory
    END;
    ELSE
    BEGIN
        RAISERROR('Table does not exist', 10, 1);
    END;

   
    -------------------------------------------------------------
    --END PROCESS
    -------------------------------------------------------------
    END_RUN:
    SET @ProcedureStep = 'End';
    SET @LogStatus = 'Completed';
	SET @LogText = 'Completed ' + @ProcedureName;
	
	EXEC [dbo].[spMFProcessBatch_Upsert]
				@ProcessBatch_ID = @ProcessBatch_ID
			  , @ProcessType = @ProcessType
			  , @LogType = N'Debug'
			  , @LogText = @LogText
			  , @LogStatus = @LogStatus
			  , @debug = @Debug

        SET @StartTime = GETUTCDATE();
        SET @LogTypeDetail = 'Debug';
        SET @LogTextDetail =  @LogText;
        SET @LogStatusDetail = 'Status';
        SET @LogColumnName = '';
        SET @LogColumnValue = '';

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                  ,@LogType = @LogTypeDetail
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatusDetail
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = @LogColumnName
                                                  ,@ColumnValue = @LogColumnValue
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                                  ,@debug = 0;

    -------------------------------------------------------------
    -- Log End of Process
    ------------------------------------------------------------- 
    SELECT @SessionIDOut = @SessionID;

    IF @Debug > 0
        SELECT @SessionIDOut AS [SessionID];

    RETURN 1;
	 SET NOCOUNT OFF;
END TRY
BEGIN CATCH
    SET @StartTime = GETUTCDATE();
    SET @LogStatus = 'Failed w/SQL Error';
    SET @LogTextDetail = ERROR_MESSAGE();

    --------------------------------------------------
    -- INSERTING ERROR DETAILS INTO LOG TABLE
    --------------------------------------------------
    INSERT INTO [dbo].[MFLog]
    (
        [SPName]
       ,[ErrorNumber]
       ,[ErrorMessage]
       ,[ErrorProcedure]
       ,[ErrorState]
       ,[ErrorSeverity]
       ,[ErrorLine]
       ,[ProcedureStep]
    )
    VALUES
    (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE()
    ,@ProcedureStep);

    SET @ProcedureStep = 'Catch Error';

    -------------------------------------------------------------
    -- Log Error
    -------------------------------------------------------------   
    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Error'
                                        ,@LogText = @LogTextDetail
                                        ,@LogStatus = @LogStatus
                                        ,@debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Error'
                                              ,@LogText = @LogTextDetail
                                              ,@LogStatus = @LogStatus
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@debug = 0;

    RETURN -1;
END CATCH;
GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFUpdateClassAndProperties]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFUpdateClassAndProperties' -- nvarchar(100)
                                    ,@Object_Release = '3.1.4.41'                  -- varchar(50)
                                    ,@UpdateFlag = 2;                              -- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFUpdateClassAndProperties' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateClassAndProperties]
AS
SELECT 'created, but not implemented yet.'; --just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFUpdateClassAndProperties]
(
    @MFTableName NVARCHAR(128)
   ,@ObjectID INT
   ,@NewClassId INT = NULL
   ,@ColumnNames NVARCHAR(1000) = NULL
   ,@ColumnValues NVARCHAR(1000) = NULL
   ,@Update_IDOUT INT = NULL OUTPUT
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@Debug SMALLINT = 0 -- debug will detail all the stages and results
)
AS
/*rST**************************************************************************

============================
spMFUpdateClassAndProperties
============================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(128)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @ObjectID int
    ObjID of the object
  @NewClassId int (optional)
    - Default = NULL
    - New class ID
  @ColumnNames nvarchar(1000) (optional)
    - Default = NULL
    - New property ID�s(separated by comma) both MFID or property or columnName can be used.
  @ColumnValues nvarchar(1000) (optional)
    Value of the properties(separated by comma) Use # the separate the ids in case of a multilookup
  @Update\_IDOUT int (output)
    Output id of the record in MFUpdateHistory logging the update ; Also added to the record in the Update_ID column on the class table
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

The purpose of this procedure is to Change the class and update any property of an object

Additional Info
===============

The parameters 'ColumnNames' and 'ColumnValues'  follow this pattern.  'columnName1, ColumnName2', 'ValueforFirstColumn, ValueForSecondcolumn'

Use # to separate the values of a multi lookup property.  e.g. 'propvalue1,23#4#234,propvalue3

To set a property to null: include the ColumnName, and a empty string in the ColumnValues. In the example the value of column2 will be set to null.  (e.g. 'ColumnValue1,,ColumnValue3')

Warnings
========

Use the Column with ID in the case of a lookup column.  e.g. for including the Country Column in the procedure, then use the 'Country_ID'  column in the ColumnNames parameter.   Similarly the ID values must be used in the case of  lookup.

For columnNames and ColumnValues the single quote is only used at the start and end of the entire string (do enclose individual items in quotes)

The number of items in columnNames must be exactly the same as ColumnValues.

Examples
========

.. code:: sql

    EXEC [dbo].[spMFUpdateClassAndProperties]
               @MFTableName = N'MFOtherHrdocument', -- nvarchar(128)
               @ObjectID = 71, -- int
               @NewClassId = 1, -- int
               @ColumnNames = N'Name_or_Title', -- nvarchar(100)
               @ColumnValues = N'Area map of chicago.jpg', -- nvarchar(1000)
               @Debug = 0 -- smallint

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-04-22  AC         Resolve issue with "Conversion failed when converting the nvarchar value 'DELETE FROM {} WHERE OBJId = {} AND ' to data type int
2018-04-04  DEV2       Added License module validation code.
2017-12-20  LC         Set a default value for propertids and propertyValues; add parameters for UpdateID, and ProcessBatchID, Change naming conversion of Column related parameters, use MFUpdateTAble to process object in new class.
2017-11-23  LC         Localization of properties
2017-07-25  LC         Replace Settings with MFVaultSettings for getting username and vaultname
2016-09-21  DEV2       Removed @Username, @Password, @NetworkAddress,@VaultName and fetch default vault setting as commo separated in @VaultSettings Parameter.
2016-08-22  LC         Update settings index
2015-07-18  DEV2       New parameter add in spMFCreateObjectInternal
2015-07-02  DEV2       @PropertyIDs can be property ID or ColumnName
2015-07-02  DEV2       Bug Fixed: Adding New Property
2015-07-01  DEV2       Skip the object failed to update in M-Files
2015-07-01  DEV2       Error tracing logic updated
==========  =========  ========================================================

**rST*************************************************************************/

SET NOCOUNT ON;

-------------------------------------------------------------
-- CONSTANTS: MFSQL Class Table Specific
-------------------------------------------------------------
DECLARE @ProcessType AS NVARCHAR(50);

SET @ProcessType = ISNULL(@ProcessType, 'Change Class and Properties');

-------------------------------------------------------------
-- CONSTATNS: MFSQL Global 
-------------------------------------------------------------
DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
DECLARE @Process_ID_1_Update TINYINT = 1;
DECLARE @Process_ID_6_ObjIDs TINYINT = 6; --marks records for refresh from M-Files by objID vs. in bulk
DECLARE @Process_ID_9_BatchUpdate TINYINT = 9; --marks records previously set as 1 to 9 and update in batches of 250
DECLARE @Process_ID_Delete_ObjIDs INT = -1; --marks records for deletion
DECLARE @Process_ID_2_SyncError TINYINT = 2;
DECLARE @ProcessBatchSize INT = 250;

-------------------------------------------------------------
-- VARIABLES: MFSQL Processing
-------------------------------------------------------------
DECLARE @Update_ID INT;
DECLARE @MFLastModified DATETIME;
DECLARE @Validation_ID INT;

-------------------------------------------------------------
-- VARIABLES: T-SQL Processing
-------------------------------------------------------------
DECLARE @rowcount AS INT = 0;
DECLARE @return_value AS INT = 0;
DECLARE @error AS INT = 0;

-------------------------------------------------------------
-- VARIABLES: DEBUGGING
-------------------------------------------------------------
DECLARE @ProcedureName AS NVARCHAR(128) = 'spMFUpdateClassAndProperties';
DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
DECLARE @DebugText AS NVARCHAR(256) = @DefaultDebugText;
DECLARE @Msg AS NVARCHAR(256) = '';
DECLARE @MsgSeverityInfo AS TINYINT = 10;
DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11;
DECLARE @MsgSeverityGeneralError AS TINYINT = 16;

-------------------------------------------------------------
-- VARIABLES: LOGGING
-------------------------------------------------------------
DECLARE @LogType AS NVARCHAR(50) = 'Status';
DECLARE @LogText AS NVARCHAR(4000) = '';
DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System';
DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL;
DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
DECLARE @count INT = 0;
DECLARE @Now AS DATETIME = GETDATE();
DECLARE @StartTime AS DATETIME = GETUTCDATE();
DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;

-------------------------------------------------------------
-- VARIABLES: DYNAMIC SQL
-------------------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @sqlParam NVARCHAR(MAX) = N'';

-------------------------------------------------------------
-- INTIALIZE PROCESS BATCH
-------------------------------------------------------------
SET @ProcedureStep = 'Start Logging';
SET @LogText = 'Processing ' + @ProcedureName;

EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                    ,@ProcessType = @ProcessType
                                    ,@LogType = N'Status'
                                    ,@LogText = @LogText
                                    ,@LogStatus = N'In Progress'
                                    ,@debug = @Debug;

EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                          ,@LogType = N'Debug'
                                          ,@LogText = @ProcessType
                                          ,@LogStatus = N'Started'
                                          ,@StartTime = @StartTime
                                          ,@MFTableName = @MFTableName
                                          ,@Validation_ID = @Validation_ID
                                          ,@ColumnName = NULL
                                          ,@ColumnValue = NULL
                                          ,@Update_ID = @Update_ID
                                          ,@LogProcedureName = @ProcedureName
                                          ,@LogProcedureStep = @ProcedureStep
                                          ,@ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT --v38
                                          ,@debug = 0;

BEGIN TRY
    -------------------------------------------------------------
    -- BEGIN PROCESS
    -------------------------------------------------------------
    ------------------------------------------------------
    -- DEFINE CONSTANTS
    ------------------------------------------------------
    DECLARE @ErrStep VARCHAR(255)
           ,@Output  NVARCHAR(MAX);
    ------------------------------------------------------
    -- GET CLASS VARIABLES
    ------------------------------------------------------
    DECLARE @Id                  INT
           ,@objID               INT
           ,@ObjectIdRef         INT
           ,@ObjVersion          INT
           ,@VaultSettings       NVARCHAR(4000)
           ,@TableName           NVARCHAR(1000)
           ,@XmlOUT              NVARCHAR(MAX)
           ,@NewObjectXml        NVARCHAR(MAX)
           ,@FullXml             XML
           ,@SynchErrorObj       NVARCHAR(MAX) --Declared new paramater
           ,@DeletedObjects      NVARCHAR(MAX) --Declared new paramater
           ,@TABLE_ID            INT
           ,@RowExistQuery       NVARCHAR(100)
           ,@Definition          NVARCHAR(100)
           ,@ObjectTypeId        INT
           ,@ClassId             INT
           ,@Responce            NVARCHAR(MAX)
           ,@TableWhereClause    VARCHAR(1000)
           ,@Query               VARCHAR(MAX)
           ,@tempTableName       VARCHAR(1000)
           ,@XMLFile             XML
           ,@RecordDetailsQuery  NVARCHAR(500)
           ,@ObjIdOut            NVARCHAR(50)
           ,@ObjVerOut           NVARCHAR(50)
           ,@XML                 NVARCHAR(MAX)
           ,@ObjVerXML           XML
           ,@CreateXmlQuery      NVARCHAR(MAX)
           ,@SynchErrUpdateQuery NVARCHAR(MAX)
           ,@ParmDefinition      NVARCHAR(500)
           ,@UpdateQuery         NVARCHAR(1000)
           ,@NewXML              XML
           ,@ErrorInfo           NVARCHAR(MAX)
           ,@SynchErrCount       INT
           ,@ErrorInfoCount      INT
           ,@MFErrorUpdateQuery  NVARCHAR(1500)
           ,@MFIDs               NVARCHAR(2500) = '';

    SET @ProcedureStep = 'Table Exists';

    IF EXISTS
    (
        SELECT *
        FROM [sys].[objects]
        WHERE [object_id] = OBJECT_ID(N'[dbo].[' + @MFTableName + ']')
              AND [type] IN ( N'U' )
    )
    BEGIN
        SELECT @ProcedureStep = 'Get Security Variables';

        ------------------------------------------------------
        -- GET LOGIN CREDENTIALS
        ------------------------------------------------------		
        SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

        IF @Debug > 0
        BEGIN
            SELECT @VaultSettings;
        END;

        ------------------------------------------------------
        -- Does Objid exsit in source table
        ------------------------------------------------------			
        SET @ProcedureStep = 'Check Objid exists';

        SELECT @RowExistQuery
            = 'SELECT @retvalOUT  = COUNT(ID) FROM ' + @MFTableName + ' WHERE objID ='
              + CAST(@ObjectID AS NVARCHAR(10));

        SELECT @Definition = N'@retvalOUT int OUTPUT';

        EXEC [sp_executesql] @RowExistQuery
                            ,@Definition
                            ,@retvalOUT = @count OUTPUT;

        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'Check ObjectID';
        SET @LogTextDetail = 'Objid: ' + CAST(@ObjectID AS VARCHAR(10));
        SET @LogColumnName = 'Objects';
        SET @LogColumnValue = CAST(@count AS VARCHAR(5));

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

        RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

        IF (@count = 1)
        BEGIN --object exists

            ------------------------------------------------------
            --To Get Table Name
            ------------------------------------------------------
            SELECT @ProcedureStep = 'Reset Table name';

            SELECT @TableName = @MFTableName;

            SELECT @TableName = REPLACE(@TableName, '_', ' ');

            SELECT @TABLE_ID = [object_id]
            FROM [sys].[objects]
            WHERE [name] = @TableName;

            IF @Debug > 0
            BEGIN
                SELECT @TableName AS [TableName of class];

                RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);
            END;

            ------------------------------------------------------
            --Set Object Type Id
            ------------------------------------------------------
            SELECT @ProcedureStep = 'Get Object Type and Class';

            -------------------------------------------------------------
            -- Is class change
            -------------------------------------------------------------
            SET @ProcedureStep = 'Class or Columname exist';

            IF @ClassId IS NOT NULL
               OR @ColumnNames IS NOT NULL
            BEGIN

                ------------------------------------------------------
                --Set class id
                ------------------------------------------------------
                SELECT @ObjectTypeId = [mo].[MFID]
                      ,@ClassId      = ISNULL(@NewClassId, [mc].[MFID])
                FROM [dbo].[MFClass]                AS [mc]
                    INNER JOIN [dbo].[MFObjectType] AS [mo]
                        ON [mc].[MFObjectType_ID] = [mo].[ID]
                WHERE [mc].[TableName] = @MFTableName;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                    SELECT @ObjectTypeId AS [Object Type]
                          ,@ClassId      AS [Class];
                END;

-------------------------------------------------------------
-- Update object from MF
-------------------------------------------------------------
DECLARE @objids NVARCHAR(20)
SET @objids = cast(@ObjectID as NVARCHAR(20))
EXEC [dbo].[spMFUpdateTable] @MFTableName = @MFTableName
                            ,@UpdateMethod = @UpdateMethod_1_MFilesToMFSQL                           
                            ,@ObjIDs = @objids
                            ,@Update_IDOut = @Update_IDOut OUTPUT
                            ,@ProcessBatch_ID = @ProcessBatch_ID 
                            ,@Debug = @Debug

-------------------------------------------------------------
-- 
-------------------------------------------------------------

                DECLARE @ColumnValuePair TABLE
                (
                    [ColumnName] NVARCHAR(1000)
                   ,[ColumnValue] NVARCHAR(1000)
                );

                SELECT @ProcedureStep = 'Convert Values to Column Value Table';

                SELECT @TableWhereClause = 'y.ObjID=' + CONVERT(NVARCHAR(50), @ObjectID);

                ------------------------------------------------------
                --Retieving the object details
                ------------------------------------------------------
                SELECT @RecordDetailsQuery
                    = 'SELECT @objID = [OBJID] ,@ObjVersion = [MFVersion] FROM ' + @MFTableName + ' WHERE [objID] = '
                      + CAST(@ObjectID AS NVARCHAR(20)) + '';

                SELECT @ObjIdOut = N'@objID int OUTPUT,@ObjVersion int OUTPUT';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                    SELECT @RecordDetailsQuery AS [RecordDetailsQuery];
                END;

                EXEC [sp_executesql] @RecordDetailsQuery
                                    ,@ObjIdOut
                                    ,@objID = @objID OUTPUT
                                    ,@ObjVersion = @ObjVersion OUTPUT;

                ---------------------------------------------------------------------------
                ----Generate query to get column values as row value
                --------------------------------------------------------------------------- 
                SET @ProcedureStep = 'Generate Query';

                SELECT @Query
                    = STUFF(
                      (
                          SELECT ' UNION ' + 'SELECT ''' + [COLUMN_NAME] + ''' as name, CONVERT(VARCHAR(max),['
                                 + [COLUMN_NAME] + ']) as value FROM ' + @MFTableName + ' y'
                                 + ISNULL('  WHERE ' + @TableWhereClause, '')
                          FROM [INFORMATION_SCHEMA].[COLUMNS]
                          WHERE [TABLE_NAME] = @MFTableName
                          FOR XML PATH('')
                      )
                     ,1
                     ,7
                     ,''
                           );

                ------------------------------------------------------
                ----Insert to values INTo temp table
                ------------------------------------------------------
                INSERT INTO @ColumnValuePair
                EXEC (@Query);

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                    SELECT *
                    FROM @ColumnValuePair AS [cvp];
                END;

                SELECT @ProcedureStep = 'Add new columns';

                ------------------------------------------------------
                -- CONVERTING COMMA SEPARATED VALUES INTO TABLE
                ------------------------------------------------------
                DECLARE @NewPropertyValues_Table TABLE
                (
                    [ColumnName] NVARCHAR(1000)
                   ,[ColumnValue] NVARCHAR(1000)
                );

                ----------------------------------------------------------
                -- INSERT THE COMMA SEPARATED VALUES INTO TABLE
                ----------------------------------------------------------
                INSERT INTO @NewPropertyValues_Table
                SELECT [cvp].[PairColumn1]
                      ,[cvp].[PairColumn2]
                FROM [dbo].[fnMFSplitPairedStrings](@ColumnNames, @ColumnValues, ',', ';') AS [cvp];

              

                --UPDATE @NewPropertyValues_Table
                --SET [ColumnName] = [mfp].[MFID]
                --FROM @NewPropertyValues_Table AS [new]
                --    INNER JOIN [MFProperty]   AS [mfp]
                --        ON [mfp].[ColumnName] = [new].[ColumnName];

                --UPDATE @NewPropertyValues_Table
                --SET [ColumnName] = [mfp].[ColumnName]
                --FROM @NewPropertyValues_Table AS [new]
                --    INNER JOIN [MFProperty]   AS [mfp]
                --        ON [mfp].[MFID] = [new].[ColumnName];

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                    SELECT *
                    FROM @NewPropertyValues_Table;
                END;

                SELECT @ProcedureStep = 'Inserting values from @NewPropertyValues_Table into @ColumnValuePair';

                --------------------------------------------------------
                --INSERT THE NEW PROPERTY DETAILS
                --------------------------------------------------------
                UPDATE [Clm]
                SET [Clm].[ColumnValue] = [New].[ColumnValue]
                FROM @NewPropertyValues_Table   AS [New]
                    INNER JOIN @ColumnValuePair AS [Clm]
                        ON [Clm].[ColumnName] = [New].[ColumnName];

                INSERT INTO @ColumnValuePair
                SELECT [ColumnName]
                      ,[ColumnValue]
                FROM @NewPropertyValues_Table
                WHERE [ColumnName] NOT IN (
                                              SELECT [ColumnName] FROM @ColumnValuePair
                                          );

                DECLARE @lastModifiedColumn NVARCHAR(100);
                DECLARE @lastModifiedByColumn NVARCHAR(100);
                DECLARE @ClassColumn NVARCHAR(100);
                DECLARE @CreateColumn NVARCHAR(100);
                DECLARE @CreatedByColumn NVARCHAR(100);

                SELECT @lastModifiedColumn = [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [MFID] = 21; --'Last Modified'

                SELECT @lastModifiedByColumn = [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [MFID] = 23; --'Last Modified By'

                SELECT @ClassColumn = [mp].[Name]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [MFID] = 100; --'Class'

                SELECT @CreateColumn = [mp].[Name]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [MFID] = 20; --'Created'

                SELECT @CreatedByColumn = [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [MFID] = 25;

                --'Created By'

                --	SELECT * FROM mfproperty WHERE mfid < 100
                DELETE FROM @ColumnValuePair
                WHERE [ColumnName] IN ( @ClassColumn, @ClassColumn + '_ID', @lastModifiedColumn, @lastModifiedByColumn
                                       ,@CreateColumn, @CreatedByColumn
                                      );

                IF @Debug > 0
				Begin
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                SELECT [ColumnName]
                      ,[ColumnValue]
                FROM @ColumnValuePair;

				END

                ------------------------------------------------------
                -- CREATING XML
                ------------------------------------------------------
                SELECT @ProcedureStep = 'Generate XML File';

                SELECT @XMLFile
                    =
                (
                    SELECT @ObjectTypeId AS [Object/@id]
                          ,@Id           AS [Object/@sqlID]
                          ,@objID        AS [Object/@objID]
                          ,@ObjVersion   AS [Object/@objVesrion]
                          ,(
                               SELECT @ClassId AS [class/@id]
                                     ,(
                                          SELECT [mfp].[MFID]        AS [property/@id]
                                                ,(
                                                     SELECT [MFTypeID] FROM [MFDataType] WHERE [ID] = [mfp].[MFDataType_ID]
                                                 )                   AS [property/@dataType]
                                                ,[tmp].[ColumnValue] AS [property]
                                          FROM @ColumnValuePair       AS [tmp]
                                              INNER JOIN [MFProperty] AS [mfp]
                                                  ON [mfp].[ColumnName] = [tmp].[ColumnName]
                                          FOR XML PATH(''), TYPE
                                      )        AS [class]
                               FOR XML PATH(''), TYPE
                           )             AS [Object]
                    FOR XML PATH(''), ROOT('form')
                );

                SELECT @XMLFile =
                (
                    SELECT @XMLFile.[query]('/form/*')
                );

                DELETE FROM @ColumnValuePair;

                --------------------------------------------------------------------------------------------------
                SELECT @FullXml
                    = ISNULL(CAST(@FullXml AS NVARCHAR(MAX)), '') + ISNULL(CAST(@XMLFile AS NVARCHAR(MAX)), '');

                SELECT @XML = '<form>' + (CAST(@FullXml AS NVARCHAR(MAX))) + '</form>';

                DECLARE @objVerDetails_Count INT;

                IF @Debug > 0
				 BEGIN
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

               
                    SELECT @XML AS [XML File for update];
                END;

                SELECT @ProcedureStep = 'Wrapper Method spMFCreateObjectInternal ';

                IF @Debug > 0
                BEGIN
                    SELECT CAST(@XML AS XML);
                END;

                SELECT @MFIDs = @MFIDs + CAST(ISNULL([MFP].[MFID], '') AS NVARCHAR(10)) + ','
                FROM [INFORMATION_SCHEMA].[COLUMNS] AS [CLM]
                    LEFT JOIN [MFProperty]          AS [MFP]
                        ON [MFP].[ColumnName] = [CLM].[COLUMN_NAME]
                WHERE [TABLE_NAME] = @MFTableName;

                SELECT @MFIDs = LEFT(@MFIDs, LEN(@MFIDs) - 1); -- Remove last ','

                IF @Debug > 0
                BEGIN
                    SELECT @MFIDs AS [List of Properties];
                END;

                DECLARE @Username NVARCHAR(2000);
                DECLARE @VaultName NVARCHAR(2000);

                SELECT @Username  = [mvs].[Username]
                      ,@VaultName = [mvs].[VaultName]
                FROM [dbo].[MFVaultSettings] AS [mvs];

                INSERT INTO [MFUpdateHistory]
                (
                    [Username]
                   ,[VaultName]
                   ,[UpdateMethod]
                   ,[ObjectDetails]
                   ,[ObjectVerDetails]
                )
                VALUES
                (@Username, @VaultName, 0, @XML, NULL);

                SET @Update_ID = @@Identity;
                SET @LogTypeDetail = 'Debug';
                SET @LogTextDetail = 'XML Records in ObjVerDetails for MFiles';
                SET @LogStatusDetail = 'Output';
                SET @Validation_ID = NULL;
                SET @LogColumnValue = '';
                SET @LogColumnName = 'MFUpdateHistory: ObjectVerDetails';

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = @Debug;

							-----------------------------------------------------------------
							-- Checking module access for CLR procdure  spMFCreateObjectInternal
						   ------------------------------------------------------------------
                           EXEC [dbo].[spMFCheckLicenseStatus] 
						        'spMFCreateObjectInternal'
								,@ProcedureName
								,@ProcedureStep

                ------------------------------------------------------
                -- CALLING WRAPPER METHOD
                ------------------------------------------------------
                EXECUTE [spMFCreateObjectInternal] @VaultSettings
                                                  ,@XML
                                                  ,NULL
                                                  ,@MFIDs
                                                  ,0
                                                  ,NULL
                                                  ,NULL
                                                  ,@XmlOUT OUTPUT
                                                  ,@NewObjectXml OUTPUT
                                                  ,@SynchErrorObj OUTPUT  --Added new paramater
                                                  ,@DeletedObjects OUTPUT --Added new paramater	
                                                  ,@ErrorInfo OUTPUT;

                IF @Debug > 0
                BEGIN
                    RAISERROR('Proc: %s Step: %s ErrorInfo %s ', 10, 1, @ProcedureName, @ProcedureStep, @ErrorInfo);                  
                END;

                SET @LogTypeDetail = 'Debug';
                SET @LogTextDetail = 'Wrapper turnaround';
                SET @LogStatusDetail = 'Output';
                SET @Validation_ID = NULL;
                SET @LogColumnValue = '';
                SET @LogColumnName = '';

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = @Debug;

                IF (@Update_ID > 0)
                    UPDATE [MFUpdateHistory]
                    SET [NewOrUpdatedObjectVer] = @XmlOUT
                       ,[NewOrUpdatedObjectDetails] = @NewObjectXml
                       ,[SynchronizationError] = @SynchErrorObj
                       ,[DeletedObjectVer] = @DeletedObjects
                       ,[MFError] = @ErrorInfo
                    WHERE [Id] = @Update_ID;

                DECLARE @IDoc INT;

                CREATE TABLE [#ObjVer]
                (
                    [ID] INT
                   ,[ObjID] INT
                   ,[MFVersion] INT
                   ,[GUID] NVARCHAR(100)
                );

                SET @ProcedureStep = 'Updating MFTable with ObjID and MFVersion';
                SET @NewXML = CAST(@XmlOUT AS XML);

                IF @Debug > 10
                    SELECT @NewXML AS [newxml];

                INSERT INTO [#ObjVer]
                (
                    [MFVersion]
                   ,[ObjID]
                   ,[ID]
                   ,[GUID]
                )
                SELECT [t].[c].[value]('(@objVersion)[1]', 'INT')           AS [MFVersion]
                      ,[t].[c].[value]('(@objectId)[1]', 'INT')             AS [ObjID]
                      ,[t].[c].[value]('(@ID)[1]', 'INT')                   AS [ID]
                      ,[t].[c].[value]('(@objectGUID)[1]', 'NVARCHAR(100)') AS [GUID]
                FROM @NewXML.[nodes]('/form/Object') AS [t]([c]);

                IF @Debug > 0
                BEGIN
                    SELECT *
                    FROM [#ObjVer];
                END;

                SET @UpdateQuery
                    = '	UPDATE ['    + @MFTableName + ']
					SET ['         + @MFTableName + '].ObjID = #ObjVer.ObjID
					,['            + @MFTableName + '].MFVersion = #ObjVer.MFVersion
					,['            + @MFTableName
                      + '].GUID = #ObjVer.GUID
					,Process_ID = 0
					,Deleted = 0
					,LastModified = GETDATE()
					FROM #ObjVer
					WHERE ['       + @MFTableName + '].ID = #ObjVer.ID';

                EXEC (@UpdateQuery);

                DROP TABLE [#ObjVer];

                ----------------------------------------------------------------------------------------------------------
                --Update Process_ID to 2 when synch error occcurs--
                ----------------------------------------------------------------------------------------------------------
                SET @ProcedureStep = 'Updating MFTable with Process_ID = 2,if any synch error occurs';

                ----------------------------------------------------------------------------------------------------------
                --Create an internal representation of the XML document. 
                ---------------------------------------------------------------------------------------------------------                
                CREATE TABLE [#SynchErrObjVer]
                (
                    [ID] INT
                   ,[ObjID] INT
                   ,[MFVersion] INT
                );

                -----------------------------------------------------
                ----Inserting the Xml details into temp Table
                -----------------------------------------------------
                DECLARE @SynchErrorXML XML;

                SET @SynchErrorXML = CAST(@SynchErrorObj AS XML);

                INSERT INTO [#SynchErrObjVer]
                (
                    [MFVersion]
                   ,[ObjID]
                   ,[ID]
                )
                SELECT [t].[c].[value]('(@objVersion)[1]', 'INT') AS [MFVersion]
                      ,[t].[c].[value]('(@objectId)[1]', 'INT')   AS [ObjID]
                      ,[t].[c].[value]('(@ID)[1]', 'INT')         AS [ID]
                FROM @SynchErrorXML.[nodes]('/form/Object') AS [t]([c]);

                SELECT @SynchErrCount = COUNT(*)
                FROM [#SynchErrObjVer];

                IF @SynchErrCount > 0
                BEGIN
                    IF @Debug > 0
                    BEGIN
                        PRINT 'Synchronisation error';

                        SELECT *
                        FROM [#SynchErrObjVer];
                    END;

                    -------------------------------------------------------------------------------------
                    -- UPDATE THE SYNCHRONIZE ERROR
                    ------------------------------------------------------------------------------------
                    SET @SynchErrUpdateQuery
                        = '	UPDATE ['    + @MFTableName
                          + ']
					SET Process_ID = 2
					,LastModified = GETDATE()
					FROM #SynchErrObjVer
					WHERE ['                   + @MFTableName + '].ObjID = #SynchErrObjVer.ObjID';

                    EXEC (@SynchErrUpdateQuery);

                    ------------------------------------------------------
                    -- LOGGING THE ERROR
                    ------------------------------------------------------
                    SELECT @ProcedureStep = 'Update MFUpdateLog for Sync error objects';

                    ----------------------------------------------------------------
                    --Inserting Synch Error Details into MFLog
                    ----------------------------------------------------------------
                    INSERT INTO [MFLog]
                    (
                        [ErrorMessage]
                       ,[Update_ID]
                       ,[ErrorProcedure]
                       ,[ExternalID]
                       ,[ProcedureStep]
                       ,[SPName]
                    )
                    SELECT *
                    FROM
                    (
                        SELECT 'Synchronization error occured while updating ObjID : '
                               + CAST([#SynchErrObjVer].[ObjID] AS NVARCHAR(10)) + ' Version : '
                               + CAST([#SynchErrObjVer].[MFVersion] AS NVARCHAR(10)) + '' AS [ErrorMessage]
                              ,@Update_ID                                                 AS [Update_ID]
                              ,@TableName                                                 AS [ErrorProcedure]
                              ,''                                                         AS [ExternalID]
                              ,'Synchronization Error'                                    AS [ProcedureStep]
                              ,'spMFUpdateTable'                                          AS [SPName]
                        FROM [#SynchErrObjVer]
                    ) AS [vl];
                END;

                DROP TABLE [#SynchErrObjVer];

                -------------------------------------------------------------
                --Logging error details
                -------------------------------------------------------------
                CREATE TABLE [#ErrorInfo]
                (
                    [ObjID] INT
                   ,[SqlID] INT
                   ,[ExternalID] NVARCHAR(100)
                   ,[ErrorMessage] NVARCHAR(MAX)
                );

                SELECT @ProcedureStep = 'Updating MFTable with ObjID and MFVersion';

                DECLARE @ErrorInfoXML XML;

                SELECT @ErrorInfoXML = CAST(@ErrorInfo AS XML);

                INSERT INTO [#ErrorInfo]
                (
                    [ObjID]
                   ,[SqlID]
                   ,[ExternalID]
                   ,[ErrorMessage]
                )
                SELECT [t].[c].[value]('(@objID)[1]', 'INT')                  AS [objID]
                      ,[t].[c].[value]('(@sqlID)[1]', 'INT')                  AS [SqlID]
                      ,[t].[c].[value]('(@externalID)[1]', 'NVARCHAR(100)')   AS [ExternalID]
                      ,[t].[c].[value]('(@ErrorMessage)[1]', 'NVARCHAR(MAX)') AS [ErrorMessage]
                FROM @ErrorInfoXML.[nodes]('/form/errorInfo') AS [t]([c]);

                SELECT @ErrorInfoCount = COUNT(*)
                FROM [#ErrorInfo];

                IF @ErrorInfoCount > 0
                BEGIN
                    IF @Debug > 0
                    BEGIN
                        SELECT *
                        FROM [#ErrorInfo];
                    END;

                    SELECT @MFErrorUpdateQuery
                        = 'UPDATE [' + @MFTableName
                          + ']
									   SET Process_ID = 3
									   FROM #ErrorInfo err
									   WHERE err.SqlID = [' + @MFTableName + '].ID';

                    EXEC (@MFErrorUpdateQuery);

                    INSERT INTO [MFLog]
                    (
                        [ErrorMessage]
                       ,[Update_ID]
                       ,[ErrorProcedure]
                       ,[ExternalID]
                       ,[ProcedureStep]
                       ,[SPName]
                    )
                    SELECT 'ObjID : ' + CAST(ISNULL([ObjID], '') AS NVARCHAR(100)) + ',' + 'SQL ID : '
                           + CAST(ISNULL([SqlID], '') AS NVARCHAR(100)) + ',' + [ErrorMessage] AS [ErrorMessage]
                          ,@Update_ID
                          ,@TableName                                                          AS [ErrorProcedure]
                          ,[ExternalID]
                          ,'Error While inserting/Updating in M-Files'                         AS [ProcedureStep]
                          ,'spMFUpdateTable'                                                   AS [spname]
                    FROM [#ErrorInfo];
                END;

                DROP TABLE [#ErrorInfo];

                SET @ProcedureStep = 'Updating MFTable with deleted = 1,if object is deleted from MFiles';

                -------------------------------------------------------------------------------------
                --Update deleted column if record is deleled from M Files
                ------------------------------------------------------------------------------------               
                CREATE TABLE [#DeletedRecordId]
                (
                    [ID] INT
                );

                --INSERT INTO #DeletedRecordId
                DECLARE @DeletedXML XML;

                SET @DeletedXML = CAST(@DeletedObjects AS XML);

                INSERT INTO [#DeletedRecordId]
                (
                    [ID]
                )
                SELECT [t].[c].[value]('(@objectID)[1]', 'INT') AS [ID]
                FROM @DeletedXML.[nodes]('/form/objVers') AS [t]([c]);

                IF @Debug > 0
                BEGIN
                   

                    SELECT id AS DeletedRecord
                    FROM [#DeletedRecordId];
                END;

                -------------------------------------------------------------------------------------
                --UPDATE THE DELETED RECORD 
                -------------------------------------------------------------------------------------
                DECLARE @DeletedRecordQuery NVARCHAR(MAX);

                SET @DeletedRecordQuery
                    = '	UPDATE [' + @MFTableName + ']
											SET [' + @MFTableName
                      + '].Deleted = 1					
												,Process_ID = 0
												,LastModified = GETDATE()
											FROM #DeletedRecordId
											WHERE [' + @MFTableName + '].ObjID = #DeletedRecordId.ID';

                --select @DeletedRecordQuery
                EXEC (@DeletedRecordQuery);

                DROP TABLE [#DeletedRecordId];

                --------------------------------------------
                -- DELETING THE RECORD FROM CURRENT MFTABLE 
                --------------------------------------------
                IF (@NewObjectXml IS NOT NULL)
                BEGIN
                    SELECT @ProcedureStep = 'Delete Row from MFTable';

                    DECLARE @DeleteQuery NVARCHAR(100);

                    SELECT @DeleteQuery
                        = 'DELETE FROM [' + @MFTableName + '] WHERE OBJId =' + CAST(@ObjectID AS NVARCHAR(10)) + ' AND ' + CAST(@ClassID AS NVARCHAR(10))+ ' != ' + CAST(@NewClassID AS NVARCHAR(10));

  IF @Debug > 0
				Begin
                    RAISERROR(@DebugText, @MsgSeverityInfo, 1, @ProcedureName, @ProcedureStep);

                SELECT @DeleteQuery AS DeleteQuery

				END


                    EXEC [sp_executesql] @DeleteQuery;
                END;

                --------------------------------
                -- INSERTING RECORD INTO MFTABLE
                --------------------------------
                IF @NewClassId IS NOT NULL 
                BEGIN
                    SELECT @NewObjectXml = CAST(@NewObjectXml AS NVARCHAR(MAX));

                    SELECT @ProcedureStep = 'Select Table Name from NEW CLASS';

                    SELECT @TableName = [TableName]
                    FROM [MFClass]
                    WHERE [MFID] = @NewClassId;

                    -------------------------------------------------------------------------------------
                    -- CALL SPMFUpadteTableInternal TO INSERT PROPERTY DETAILS INTO TABLE
                    -------------------------------------------------------------------------------------
                    SET @StartTime = GETUTCDATE();

                    IF (@NewObjectXml != '<form />')
                    BEGIN
                        SET @ProcedureName = 'spMFUpdateTableInternal';
                        SET @ProcedureStep = 'Update property details from M-Files in new Class Table ';

                        IF @Debug > 9
                        BEGIN
                            RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

                            IF @Debug > 10
                                SELECT @NewObjectXml AS [@NewObjectXml before updateobjectinternal];
                        END;

                        EXEC @return_value = [dbo].[spMFUpdateTableInternal] @MFTableName
                                                                            ,@NewObjectXml
                                                                            ,@Update_ID
                                                                            ,@Debug = @Debug;
						END -- if ClassID is not null
                        --        ,@SyncErrorFlag = @SyncErrorFlag;
                        IF @return_value <> 1
                            RAISERROR('Proc: %s Step: %s FAILED ', 16, 1, @ProcedureName, @ProcedureStep);
                    END;

                    SET @LogTypeDetail = 'Status';
                    SET @LogStatusDetail = 'In progress';
                    SET @LogTextDetail = 'Insert record for table ' + @MFTableName;
                    SET @LogColumnName = '';
                    SET @LogColumnValue = '';

                    EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                                 ,@LogType = @LogTypeDetail
                                                                                 ,@LogText = @LogTextDetail
                                                                                 ,@LogStatus = @LogStatusDetail
                                                                                 ,@StartTime = @StartTime
                                                                                 ,@MFTableName = @MFTableName
                                                                                 ,@Validation_ID = @Validation_ID
                                                                                 ,@ColumnName = @LogColumnName
                                                                                 ,@ColumnValue = @LogColumnValue
                                                                                 ,@Update_ID = @Update_ID
                                                                                 ,@LogProcedureName = @ProcedureName
                                                                                 ,@LogProcedureStep = @ProcedureStep
                                                                                 ,@debug = @Debug;

                    IF (@return_value = 1)
                    BEGIN
                        UPDATE [MFUpdateHistory]
                        SET [UpdateStatus] = 'completed'
                        WHERE [Id] = @Update_ID;
                    END;
                    ELSE
                    BEGIN
                        UPDATE [MFUpdateHistory]
                        SET [UpdateStatus] = 'partial'
                        WHERE [Id] = @Update_ID;
                    END;

                    IF @SynchErrCount > 0
                        RETURN 2; --Synchronization Error
                    ELSE IF @ErrorInfoCount > 0
                        RETURN 3; --MFError
                END; -- @ClassID is not null or @ColumnNames is not null
                ELSE
                BEGIN
				Set @DebugText = ''
				Set @DebugText = @DefaultDebugText + @DebugText
				Set @Procedurestep = ''
				
				IF @debug > 0
					Begin
						RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep );
					END
				
                   SET @DebugText = ''
                    SET @ProcedureStep = 'Missing Parameters ';
                    SET @LogStatus = 'Error';
                    SET @LogTextDetail = 'Either ClassID or ColumnNames or both must be used ';
					 SET @DebugText = @DefaultDebugText + @DebugText;

                    RAISERROR(@DebugText, @MsgSeverityGeneralError, 1, @ProcedureName, @ProcedureStep);
                END;
            END; --Object exists
            ELSE
            BEGIN
			SET @DebugText = ''
                SET @DebugText = @DefaultDebugText + @DebugText;
				SET @ProcedureStep = 'Incorrect Object ';
                SET @LogStatus = 'Error';
                SET @LogTextDetail = 'Object ID is invalid ';

                RAISERROR(@DebugText, @MsgSeverityGeneralError, 1, @ProcedureName, @ProcedureStep);
            END; -- end else
        END; -- Table exists
        ELSE
        BEGIN
		SET @DebugText = ''
            SET @DebugText = @DefaultDebugText + @DebugText;
            SET @ProcedureStep = 'Check Tablename ';
            SET @LogStatus = 'Error';
            SET @LogTextDetail = 'Tablename does not exist';

            RAISERROR(@DebugText, @MsgSeverityGeneralError, 1, @ProcedureName, @ProcedureStep);
        END; --end else
  

    -------------------------------------------------------------
    --END PROCESS
    -------------------------------------------------------------
    END_RUN:
    SET @ProcedureStep = 'End';

    -------------------------------------------------------------
    -- Log End of Process
    -------------------------------------------------------------   
    SET @LogStatus = 'Completed';

    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Message'
                                        ,@LogText = @LogText
                                        ,@LogStatus = @LogStatus
                                        ,@debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Message'
                                              ,@LogText = @ProcessType
                                              ,@LogStatus = @LogStatus
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@debug = 0;

    SET @Update_IDOUT = @Update_ID;

    RETURN 1;
END TRY
BEGIN CATCH
    SET @StartTime = GETUTCDATE();

    --------------------------------------------------
    -- INSERTING ERROR DETAILS INTO LOG TABLE
    --------------------------------------------------
    INSERT INTO [dbo].[MFLog]
    (
        [SPName]
       ,[ErrorNumber]
       ,[ErrorMessage]
       ,[ErrorProcedure]
       ,[ErrorState]
       ,[ErrorSeverity]
       ,[ErrorLine]
       ,[ProcedureStep]
    )
    VALUES
    (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE()
    ,@ProcedureStep);

    SET @ProcedureStep = 'Catch Error';
    SET @LogTextDetail = ERROR_MESSAGE();
    SET @LogStatus = 'Not Updated';

    -------------------------------------------------------------
    -- Log Error
    -------------------------------------------------------------   
    EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                        ,@ProcessType = @ProcessType
                                        ,@LogType = N'Error'
                                        ,@LogText = @LogTextDetail
                                        ,@LogStatus = @LogStatus
                                        ,@debug = @Debug;

    SET @StartTime = GETUTCDATE();

    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                              ,@LogType = N'Error'
                                              ,@LogText = @LogTextDetail
                                              ,@LogStatus = @LogStatus
                                              ,@StartTime = @StartTime
                                              ,@MFTableName = @MFTableName
                                              ,@Validation_ID = @Validation_ID
                                              ,@ColumnName = NULL
                                              ,@ColumnValue = NULL
                                              ,@Update_ID = @Update_ID
                                              ,@LogProcedureName = @ProcedureName
                                              ,@LogProcedureStep = @ProcedureStep
                                              ,@debug = 0;

    RETURN -1;
END CATCH;
GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.dbo.[spMFUpdateMFilesToMFSQL]';

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFUpdateMFilesToMFSQL' -- nvarchar(100)
                                    ,@Object_Release = '4.4.13.53'            -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO


IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFUpdateMFilesToMFSQL' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateMFilesToMFSQL]
AS
BEGIN
    SELECT 'created, but not implemented yet.'; --just anything will do
END;
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFUpdateMFilesToMFSQL]
(
    @MFTableName NVARCHAR(128)
   ,@MFLastUpdateDate SMALLDATETIME = NULL OUTPUT
   ,@UpdateTypeID TINYINT = 1
   ,@Update_IDOut INT = NULL OUTPUT
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@debug TINYINT = 0
)
AS
/*rST**************************************************************************

=======================
spMFUpdateMFilesToMFSQL
=======================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(128)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @MFLastUpdateDate smalldatetime (output)
    returns the most recent MF Last modified date
  @UpdateTypeID tinyint (optional)
    - 1 = incremental update (default)
    - 0 = Full update
  @Update\_IDOut int (output)
    returns the id of the last updated batch
  @ProcessBatch\_ID int (optional, output)
    Referencing the ID of the ProcessBatch logging table
  @Debug tinyint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

The purpose of this procedure has migrated over time from processing records by objid to a routine that can be used by default for large and small tables to process records from M-Files to SQL.
The procedure is fundamentally based on updating M-Files to SQL using a rapid evaluation of the object version of each object and then to update based on the object id of the object.

Additional Info
===============

Setting UpdateTypeID = 0 (Full update) will perform a full audit of the class table by validating every object version in the class and run through an update of all the objects where the version in M-Files and SQL are not identical.

This will run spmfUpdateTableinBatches in silent mode. Note that the Max Objid to control the update is derived as the max(objid) in the class table + 500 of the class table.
Setting UpdateTypeID = 1 (incremental update) will perform an audit of the class table based on the date of the last modified object in the class table, and then update the records that is not identical

Deleted records in M-Files will be identified and removed.

The following importing scenarios apply:

- If the file already exist for the object then the existing file in M-Files will be overwritten. M-Files version control will record the prior version of the record.
- If the object is new in the class table (does not yet have a objid and guid) then the object will first be created in M-Files and then the file will be added.
- If the object in M-Files is a multifile document with no files, then the object will be converted to a single file object.
- if the object in M-files already have a file or files, then it would convert to a multifile object and the additional file will be added
- If the filename or location of the file cannot be found, then a error will be added in the filerror column in the MFFileImport Table.
- If the parameter option @IsFileDelete is set to 1, then the originating file will be deleted.  The default is to not delete.
- The MFFileImport table keeps track of all the file importing activity.

Warnings
========

Use spmfUpdateTableInBatches to initiate a class table instead of this procedure.

Examples
========

.. code:: sql

    --Full Update from MF to SQL

    DECLARE @MFLastUpdateDate SMALLDATETIME
       ,@Update_IDOut     INT
       ,@ProcessBatch_ID  INT;

    EXEC [dbo].[spMFUpdateMFilesToMFSQL] @MFTableName = 'YourTable'               -- nvarchar(128)
                                    ,@MFLastUpdateDate = @MFLastUpdateDate OUTPUT -- smalldatetime
                                    ,@UpdateTypeID = 0                            -- tinyint
                                    ,@Update_IDOut = @Update_IDOut OUTPUT         -- int
                                    ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT   -- int
                                    ,@debug = 0;                                  -- tinyint

    SELECT @MFLastUpdateDate AS [LastModifiedDate];

    DECLARE @MFLastUpdateDate SMALLDATETIME
       ,@Update_IDOut     INT
       ,@ProcessBatch_ID  INT;

    EXEC [dbo].[spMFUpdateMFilesToMFSQL] @MFTableName = 'YourTable'               -- nvarchar(128)
                                    ,@MFLastUpdateDate = @MFLastUpdateDate OUTPUT -- smalldatetime
                                    ,@UpdateTypeID = 1                            -- tinyint
                                    ,@Update_IDOut = @Update_IDOut OUTPUT         -- int
                                    ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT   -- int
                                    ,@debug = 0;                                  -- tinyint

    SELECT @MFLastUpdateDate;


Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-27  LC         Fix UpdateID in MFProcessBatchDetail
2019-09-03  LC         Set audittableinbatches to withstats = 0
2019-09-03  LC         Set default date for deleted record check to 2000-01-01
2019-08-30  JC         Added documentation
2019-08-05  LC         Fix bug in updating single record
2019-04-12  LC         Allow for large tables
2018-10-22  LC         Align logtext description for reporting, refine ProcessBatch messages
2018-10-20  LC         Fix processing time calculation
2018-05-10  LC         Add error if invalid table name is specified
2017-12-28  LC         Add routine to reset process_id 3,4 to 0
2017-12-25  LC         Change BatchProcessDetail log text for lastupdatedate
2017-06-29  AC         Change LogStatusDetail to 'Completed' from 'Complete'
2017-06-08  AC         Incorrect LogTypeDetail value
2017-06-08  AC         ProcessBatch_ID not passed into spMFAuditTable
2016-08-11  AC         Create Procedure
==========  =========  ========================================================

**rST*************************************************************************/


BEGIN
    SET NOCOUNT ON;

    SET XACT_ABORT ON;

    -------------------------------------------------------------
    -- Logging Variables
    -------------------------------------------------------------
    DECLARE @ProcedureName AS NVARCHAR(128) = 'spMFUpdateMFilesToMFSQL';
    DECLARE @ProcedureStep AS NVARCHAR(128) = 'Set Variables';
    DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
    DECLARE @DebugText AS NVARCHAR(256) = '';

    --used on MFProcessBatch;
    DECLARE @ProcessType NVARCHAR(50);
    DECLARE @LogType AS NVARCHAR(50) = 'Status';
    DECLARE @LogText AS NVARCHAR(4000) = '';
    DECLARE @LogStatus AS NVARCHAR(50) = 'Started';

    --used on MFProcessBatchDetail;
    DECLARE @LogTypeDetail AS NVARCHAR(50) = 'Debug';
    DECLARE @LogTextDetail AS NVARCHAR(4000) = @ProcedureStep;
    DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress';
    DECLARE @EndTime DATETIME;
    DECLARE @StartTime DATETIME;
    DECLARE @StartTime_Total DATETIME = GETUTCDATE();
    DECLARE @Validation_ID INT;
    DECLARE @LogColumnName NVARCHAR(128);
    DECLARE @LogColumnValue NVARCHAR(256);
    DECLARE @RunTime AS DECIMAL(18, 4) = 0;
    DECLARE @rowcount AS INT = 0;
    DECLARE @return_value AS INT = 0;
    DECLARE @error AS INT = 0;
    DECLARE @output NVARCHAR(200);
    DECLARE @sql NVARCHAR(MAX) = N'';
    DECLARE @sqlParam NVARCHAR(MAX) = N'';

    -------------------------------------------------------------
    -- Global Constants
    -------------------------------------------------------------
    DECLARE @UpdateMethod_1_MFilesToMFSQL TINYINT = 1;
    DECLARE @UpdateMethod_0_MFSQLToMFiles TINYINT = 0;
    DECLARE @UpdateType_0_FullRefresh TINYINT = 0;
    DECLARE @UpdateType_1_Incremental TINYINT = 1;
    DECLARE @UpdateType_2_Deletes TINYINT = 2;
    DECLARE @MFLastModifiedDate DATETIME;
    DECLARE @DeletedInSQL   INT
           ,@UpdateRequired BIT
           ,@OutofSync      INT
           ,@ProcessErrors  INT
           ,@Class_ID       INT
           ,@DefaultToObjid INT = 200000;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [dbo].[MFClass] WHERE [TableName] = @MFTableName)
        BEGIN
            SET @DebugText = '';
            SET @DebugText = @DefaultDebugText + @DebugText;
            SET @ProcedureStep = 'Start procedure';

            IF @debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
            END;

            -------------------------------------------------------------
            -- Get/Validate ProcessBatch_ID
            SET @ProcedureStep = 'Initialise M-Files to MFSQL';

            EXEC @return_value = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
                                                                ,@ProcessType = 'UpdateMFilesToMFSQL'
                                                                ,@LogText = @ProcedureStep
                                                                ,@LogStatus = 'Started'
                                                                ,@debug = @debug;

            SET @StartTime = GETUTCDATE();
            SET @LogTypeDetail = 'Status';
            SET @LogTextDetail = CASE
                                     WHEN @UpdateTypeID = 0 THEN
                                         'UpdateType full refresh'
                                     ELSE
                                         'UpdateType incremental refresh'
                                 END;
            SET @LogStatusDetail = 'Started';
            SET @LogColumnName = '';
            SET @LogColumnValue = '';

            EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                      ,@LogType = @LogTypeDetail
                                                      ,@LogText = @LogTextDetail
                                                      ,@LogStatus = @LogStatusDetail
                                                      ,@StartTime = @StartTime
                                                      ,@MFTableName = @MFTableName
                                                      ,@ColumnName = @LogColumnName
                                                      ,@ColumnValue = @LogColumnValue
                                                      ,@LogProcedureName = @ProcedureName
                                                      ,@LogProcedureStep = @ProcedureStep
                                                      ,@debug = @debug;

            /*************************************************************************************
	REFRESH M-FILES --> MFSQL	 (Process Codes: M2E2M | M2E | E2M2E | E2M ) --All Process Codes
*************************************************************************************/
            -------------------------------------------------------------
            -- Get column for last modified
            -------------------------------------------------------------
            DECLARE @lastModifiedColumn NVARCHAR(100);

            SELECT @lastModifiedColumn = [mp].[ColumnName]
            FROM [dbo].[MFProperty] AS [mp]
            WHERE [mp].[MFID] = 21;

            --'Last Modified'

            -------------------------------------------------------------
            -- Get last modified date
            -------------------------------------------------------------
            SET @ProcedureStep = 'Get last update date';
            SET @sqlParam = N'@MFLastModifiedDate Datetime output';
            SET @sql
                = N'
SELECT @MFLastModifiedDate = (SELECT MAX(' + QUOTENAME(@lastModifiedColumn) + ') FROM ' + QUOTENAME(@MFTableName)
                  + ' );';

            EXEC [sys].[sp_executesql] @Stmt = @sql
                                      ,@Params = @sqlParam
                                      ,@MFLastModifiedDate = @MFLastModifiedDate OUTPUT;

            SET @MFLastModifiedDate = CASE
                                          WHEN @UpdateTypeID = @UpdateType_2_Deletes THEN
                                              NULL
                                          ELSE
                                              ISNULL(DATEADD(DAY, -1, @MFLastModifiedDate), '2000-01-01')
                                      END;
            SET @DebugText = 'Filter Date: ' + CAST(@MFLastModifiedDate AS NVARCHAR(100));
            SET @DebugText = @DefaultDebugText + @DebugText;

            IF @debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
            END;

            -------------------------------------------------------------
            -- Determine the overall size of the object type index
            -------------------------------------------------------------
            DECLARE @NewObjectXml NVARCHAR(MAX);
            DECLARE @StatusFlag_1_MFilesIsNewer TINYINT = 1;
            DECLARE @StatusFlag_5_NotInMFSQL TINYINT = 5;

            -------------------------------------------------------------
            -- Get class id
            -------------------------------------------------------------
            SELECT @Class_ID = [mc].[MFID]
            FROM [dbo].[MFClass] AS [mc]
            WHERE [mc].[TableName] = @MFTableName;

            -------------------------------------------------------------
            -- Reset errors 3 and 4
            -------------------------------------------------------------
            SET @ProcedureStep = 'Reset errors 3 and 4';
            SET @sql = N'UPDATE [t]
                    SET process_ID = 0
                    FROM [dbo].' + QUOTENAME(@MFTableName) + ' AS t WHERE [t].[Process_ID] IN (3,4)';

            EXEC (@sql);

            -------------------------------------------------------------
            -- FULL REFRESH
            -------------------------------------------------------------
            BEGIN
                DECLARE @MFAuditHistorySessionID INT = NULL;

                IF @UpdateTypeID = (@UpdateType_0_FullRefresh)
                   --AND
                   --(
                   --    SELECT COUNT(*)
                   --    FROM [dbo].[MFAuditHistory] AS [mah]
                   --    WHERE [mah].[Class] = @Class_ID
                   --) = 0
                BEGIN
                    SET @StartTime = GETUTCDATE();
                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;
                    SET @ProcedureStep = 'Start full refresh';

                    IF @debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    -------------------------------------------------------------
                    -- o/s switch to batch when the class table is too large
                    -------------------------------------------------------------  
                    DECLARE @Tobjid INT;

                    SELECT @Tobjid = MAX([mah].[ObjID])
                    FROM [dbo].[MFAuditHistory] AS [mah]
                    WHERE [mah].[Class] = @Class_ID;

                    IF @Tobjid IS NULL
                    BEGIN
                        EXEC [dbo].[spMFTableAuditinBatches] @MFTableName = @MFTableName -- nvarchar(100)
                                                            ,@FromObjid = 1              -- int
                                                            ,@ToObjid = @DefaultToObjid  -- int
                                                            ,@WithStats = 0              -- bit
                                                            ,@ProcessBatch_ID = @ProcessBatch_ID
                                                            ,@Debug = @debug;            -- int
     END
	 ELSE 
	 BEGIN
     
	  EXEC [dbo].[spMFTableAuditinBatches] @MFTableName = @MFTableName -- nvarchar(100)
                                                            ,@FromObjid = 1              -- int
                                                            ,@ToObjid = @Tobjid  -- int
                                                            ,@WithStats = 0              -- bit
                                                            ,@ProcessBatch_ID = @ProcessBatch_ID
                                                            ,@Debug = @debug;            -- int


END

                        SET @ProcedureStep = 'Get Object Versions with Batch Audit';
                        SET @StartTime = GETUTCDATE();
                        SET @LogTypeDetail = 'Status';
                        SET @LogTextDetail = ' Batch Audit Max Object: ' + CAST(@DefaultToObjid AS VARCHAR(30));
                        SET @LogStatusDetail = 'In progress';
                        SET @LogColumnName = '';
                        SET @LogColumnValue = '';

                        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                  ,@LogType = @LogTypeDetail
                                                                  ,@LogText = @LogTextDetail
                                                                  ,@LogStatus = @LogStatusDetail
                                                                  ,@StartTime = @StartTime
                                                                  ,@MFTableName = @MFTableName
                                                                  ,@ColumnName = @LogColumnName
                                                                  ,@ColumnValue = @LogColumnValue
                                                                  ,@LogProcedureName = @ProcedureName
                                                                  ,@LogProcedureStep = @ProcedureStep
                                                                  ,@debug = @debug;
               

                    -------------------------------------------------------------
                    -- class table update in batches
                    -------------------------------------------------------------

                    SET @Tobjid = ISNULL(@Tobjid, 0) + 500;
                    SET @DebugText = 'Max Objid %i';
                    SET @DebugText = @DefaultDebugText + @DebugText;
                    SET @ProcedureStep = 'Set Max objid';

                    IF @debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @Tobjid);
                    END;

                    SET @ProcedureStep = 'class table update in batches';
                    SET @LogTypeDetail = 'Debug';
                    SET @LogTextDetail = ' Start Update in batches: Max objid ' + CAST(@Tobjid AS NVARCHAR(256));
                    SET @LogColumnName = '';
                    SET @LogColumnValue = '';

                    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                              ,@LogType = @LogTypeDetail
                                                              ,@LogText = @LogTextDetail
                                                              ,@LogStatus = @LogStatusDetail
                                                              ,@StartTime = @StartTime
                                                              ,@MFTableName = @MFTableName
                                                              ,@ColumnName = @LogColumnName
                                                              ,@ColumnValue = @LogColumnValue
                                                              ,@LogProcedureName = @ProcedureName
                                                              ,@LogProcedureStep = @ProcedureStep
                                                              ,@debug = @debug;

                    EXEC @return_value = [dbo].[spMFUpdateTableinBatches] @MFTableName = @MFTableName -- nvarchar(100)
                                                                         ,@UpdateMethod = 1           -- int
                                                                         ,@WithTableAudit =1         -- int
                                                                         ,@FromObjid = 1              -- bigint
                                                                         ,@ToObjid = @Tobjid          -- bigint
                                                                         ,@WithStats = 0              -- bit
                                                                         ,@ProcessBatch_ID = @ProcessBatch_ID
                                                                         ,@Debug = @debug;            -- int

                    SET @error = @@Error;
                    SET @LogStatusDetail = CASE
                                               WHEN
                                               (
                                                   @error <> 0
                                                   OR @return_value = -1
                                               ) THEN
                                                   'Failed'
                                               WHEN @return_value IN ( 1, 0 ) THEN
                                                   'Complete'
                                               ELSE
                                                   'Exception'
                                           END;
                    SET @LogTypeDetail = 'Debug';
                    SET @LogTextDetail = ' Batch updates completed ';
                    SET @LogColumnName = '';
                    SET @LogColumnValue = '';

                    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                              ,@LogType = @LogTypeDetail
                                                              ,@LogText = @LogTextDetail
                                                              ,@LogStatus = @LogStatusDetail
                                                              ,@StartTime = @StartTime
                                                              ,@MFTableName = @MFTableName
                                                              ,@ColumnName = @LogColumnName
                                                              ,@ColumnValue = @LogColumnValue
                                                              ,@LogProcedureName = @ProcedureName
                                                              ,@LogProcedureStep = @ProcedureStep
                                                              ,@debug = @debug;
                END; -- full update with no audit details

				-------------------------------------------------------------
                -- Incremental update
                -------------------------------------------------------------
                IF (
                       @UpdateTypeID = (@UpdateType_0_FullRefresh)
                       AND
                       (
                           SELECT COUNT(*)
                           FROM [dbo].[MFAuditHistory] AS [mah]
                           WHERE [mah].[Class] = @Class_ID
                       ) > 0
                   )
                   OR (@UpdateTypeID IN ( @UpdateType_1_Incremental, @UpdateType_2_Deletes ))
                BEGIN

                    -------------------------------------------------------------
                    -- perform table audit on with date filter
                    -------------------------------------------------------------
                    DECLARE @SessionIDOut INT;

                    IF @debug > 0
                        SELECT @MFLastModifiedDate AS [last_modified_date];

                    SET @ProcedureStep = 'Get Filtered Object Versions';
                    SET @StartTime = GETUTCDATE();
                    SET @LogTypeDetail = 'Status';
                    SET @LogTextDetail
                        = ' Last modified: ' + CAST(CONVERT(DATETIME, @MFLastModifiedDate, 105) AS VARCHAR(30));
                    SET @LogStatusDetail = 'In progress';
                    SET @LogColumnName = '';
                    SET @LogColumnValue = '';

                    EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                              ,@LogType = @LogTypeDetail
                                                              ,@LogText = @LogTextDetail
                                                              ,@LogStatus = @LogStatusDetail
                                                              ,@StartTime = @StartTime
                                                              ,@MFTableName = @MFTableName
                                                              ,@ColumnName = @LogColumnName
                                                              ,@ColumnValue = @LogColumnValue
                                                              ,@LogProcedureName = @ProcedureName
                                                              ,@LogProcedureStep = @ProcedureStep
                                                              ,@debug = @debug;

                    EXEC [dbo].[spMFTableAudit] @MFTableName = @MFTableName                -- nvarchar(128)
                                               ,@MFModifiedDate = @MFLastModifiedDate      -- datetime
                                               ,@ObjIDs = NULL                             -- nvarchar(4000)
                                               ,@SessionIDOut = @SessionIDOut              -- int
                                               ,@NewObjectXml = @NewObjectXml OUTPUT       -- nvarchar(max)
                                               ,@DeletedInSQL = @DeletedInSQL OUTPUT       -- int
                                               ,@UpdateRequired = @UpdateRequired OUTPUT   -- bit
                                               ,@OutofSync = @OutofSync OUTPUT             -- int
                                               ,@ProcessErrors = @ProcessErrors OUTPUT     -- int
                                               ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT -- int
                                               ,@Debug = @debug;                           -- smallint
                END;

                SELECT @Tobjid = MAX([mah].[ObjID])
                FROM [dbo].[MFAuditHistory] AS [mah]
                WHERE [mah].[Class] = @Class_ID;

                SET @Tobjid = ISNULL(@Tobjid, 0) + 500;
                SET @DebugText = 'Max Objid %i';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Update M-Files';

                IF @debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @Tobjid);
                END;


             

                    SELECT @rowcount = COUNT(*)
                    FROM [dbo].[MFAuditHistory]
                    WHERE [Class] = @Class_ID
                          AND [StatusFlag] IN ( @StatusFlag_1_MFilesIsNewer,4, @StatusFlag_5_NotInMFSQL )
                          AND [ObjectType] <> 9;

                        SET @LogColumnName = 'Status flag 1,4 and 5:  ';
                        SET @LogColumnValue = CAST(@rowcount AS NVARCHAR(256));
                        SET @LogStatusDetail = CASE
                                                   WHEN
                                                   (
                                                       @error <> 0
                                                       OR @return_value = -1
                                                   ) THEN
                                                       'Failed'
                                                   WHEN @return_value IN ( 1, 0 ) THEN
                                                       'Completed'
                                                   ELSE
                                                       'Exception'
                                               END;
                        SET @LogTextDetail = ' Object Versions update start';

                        EXEC @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                                  ,@LogType = @LogTypeDetail
                                                                                  ,@LogText = @LogTextDetail
                                                                                  ,@LogStatus = @LogStatusDetail
                                                                                  ,@StartTime = @StartTime
                                                                                  ,@MFTableName = @MFTableName
                                                                                  ,@ColumnName = @LogColumnName
                                                                                  ,@ColumnValue = @LogColumnValue
                                                                                  ,@LogProcedureName = @ProcedureName
                                                                                  ,@LogProcedureStep = @ProcedureStep
                                                                                  ,@debug = @debug;
				
				-------------------------------------------------------------
				-- object versions updated
				-------------------------------------------------------------

				-------------------------------------------------------------
				-- Get list of objects to update
				-------------------------------------------------------------
				    IF @rowcount > 0
                    BEGIN

                        SET @ProcedureStep = 'Create Class table objid list';



                        IF OBJECT_ID('tempdb..#ObjIdList') IS NOT NULL
                            DROP TABLE [#ObjIdList];

                        CREATE TABLE [#ObjIdList]
                        (
                            [ObjId] INT
                        );

                        INSERT [#ObjIdList]
                        (
                            [ObjId]
                        )
                        SELECT [ObjID]
                        FROM [dbo].[MFAuditHistory]
                        WHERE  [StatusFlag] IN ( @StatusFlag_1_MFilesIsNewer, 4, @StatusFlag_5_NotInMFSQL ) AND [Class] = @Class_ID;

                        SET @rowcount = @@RowCount;

                        IF @debug > 9
                        BEGIN
						SELECT * FROM [#ObjIdList] AS [oil]
                            SET @DebugText = @DefaultDebugText + ' %i Object list record(s) ';

                            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @rowcount);
                        END;

                        -------------------------------------------------------------
                        -- Group object list
                        -------------------------------------------------------------
                        SET @ProcedureStep = 'Group ObjID Lists';

                        IF OBJECT_ID('tempdb..#ObjIdGroups') IS NOT NULL
                            DROP TABLE [#ObjIdGroups];

                        CREATE TABLE [#ObjIdGroups]
                        (
                            [GroupNumber] INT PRIMARY KEY
                           ,[ObjIds] NVARCHAR(4000)
                        );

                        INSERT [#ObjIdGroups]
                        (
                            [GroupNumber]
                           ,[ObjIds]
                        )
                        EXEC [dbo].[spMFUpdateTable_ObjIds_GetGroupedList] @Debug = @debug;

                        SET @rowcount = @@RowCount;

                        IF @debug > 9
                        BEGIN
                            SET @DebugText = @DefaultDebugText + ' %d group(s) ';

                            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @rowcount);
                        END;

                        --Loop through Groups of ObjIDs
                        DECLARE @CurrentGroup    INT
                               ,@ObjIds_toUpdate NVARCHAR(4000);

                        SELECT @CurrentGroup = MIN([GroupNumber])
                        FROM [#ObjIdGroups];

                        WHILE @CurrentGroup IS NOT NULL
                        BEGIN
                            SELECT @ObjIds_toUpdate = [ObjIds]
                            FROM [#ObjIdGroups]
                            WHERE [GroupNumber] = @CurrentGroup;

                            SET @ProcedureStep = 'spMFUpdateTable UpdateMethod 1';
                            SET @StartTime = GETUTCDATE();
                            SET @LogTextDetail = ' for Group# ' + ISNULL(CAST(@CurrentGroup AS VARCHAR(20)), '(null)');
                            SET @LogStatusDetail = 'Started';
                            SET @LogColumnName = 'Group# ' + ISNULL(CAST(@CurrentGroup AS VARCHAR(20)), '(null)');
                            SET @LogColumnValue =
                            (
                                SELECT CAST(COUNT(*) AS VARCHAR(10))FROM [#ObjIdList] AS [oil]
                            );

                            EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                      ,@LogType = @LogTypeDetail
                                                                      ,@LogText = @LogTextDetail
                                                                      ,@LogStatus = @LogStatusDetail
                                                                      ,@StartTime = @StartTime
                                                                      ,@MFTableName = @MFTableName
                                                                      ,@ColumnName = @LogColumnName
                                                                      ,@ColumnValue = @LogColumnValue
                                                                      ,@LogProcedureName = @ProcedureName
                                                                      ,@LogProcedureStep = @ProcedureStep
                                                                      ,@debug = @debug;

                            IF @debug > 9
                            BEGIN
                                RAISERROR(@DefaultDebugText, 10, 1, @ProcedureName, @ProcedureStep);
                            END;

                            SET @StartTime = GETUTCDATE();

                            EXEC @return_value = [dbo].[spMFUpdateTable] @MFTableName = @MFTableName
                                                                        ,@UpdateMethod = @UpdateMethod_1_MFilesToMFSQL --M-Files to MFSQL
                                                                        ,@UserId = NULL
                                                                        ,@MFModifiedDate = NULL
                                                                        ,@ObjIDs = @ObjIds_toUpdate                    -- CSV List
                                                                        ,@Update_IDOut = @Update_IDOut OUTPUT
                                                                        ,@ProcessBatch_ID = @ProcessBatch_ID
                                                                        ,@Debug = @debug;

                            SET @error = @@Error;
                            SET @LogStatusDetail = CASE
                                                       WHEN
                                                       (
                                                           @error <> 0
                                                           OR @return_value = -1
                                                       ) THEN
                                                           'Failed'
                                                       WHEN @return_value IN ( 1, 0 ) THEN
                                                           'Completed'
                                                       ELSE
                                                           'Exception'
                                                   END;
                            SET @LogText = 'Return Value: ' + CAST(@return_value AS NVARCHAR(256));
                            SET @LogColumnName = 'MFUpdate_ID ';
                            SET @LogColumnValue = CAST(@Update_IDOut AS NVARCHAR(256));

                            EXEC @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                                      ,@LogType = @LogTypeDetail
                                                                                      ,@LogText = @LogTextDetail
                                                                                      ,@LogStatus = @LogStatusDetail
                                                                                      ,@StartTime = @StartTime
                                                                                      ,@MFTableName = @MFTableName
                                                                                      ,@ColumnName = @LogColumnName
                                                                                      ,@ColumnValue = @LogColumnValue
                                                                                      ,@LogProcedureName = @ProcedureName
                                                                                      ,@LogProcedureStep = @ProcedureStep
                                                                                      ,@debug = @debug;

                            SELECT @CurrentGroup = MIN([GroupNumber])
                            FROM [#ObjIdGroups]
                            WHERE [GroupNumber] > @CurrentGroup;
                        END; --WHILE @CurrentGroup IS NOT NULL	

			
                    END;
                    ELSE
                    BEGIN
                        SET @LogTypeDetail = 'Status';
                        SET @LogStatusDetail = 'In progress';
                        SET @LogTextDetail = 'Nothing to update';
                        SET @LogColumnName = '';
                        SET @LogColumnValue = '';

                        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                                     ,@LogType = @LogTypeDetail
                                                                                     ,@LogText = @LogTextDetail
                                                                                     ,@LogStatus = @LogStatusDetail
                                                                                     ,@StartTime = @StartTime
                                                                                     ,@MFTableName = @MFTableName
                                                                                     ,@Validation_ID = @Validation_ID
                                                                                     ,@ColumnName = @LogColumnName
                                                                                     ,@ColumnValue = @LogColumnValue
                                                                                     ,@Update_ID = @Update_IDOut
                                                                                     ,@LogProcedureName = @ProcedureName
                                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                                     ,@debug = @debug;
                    END; --IF EXISTS(SELECT 1 FROM dbo.MFAuditHistory WHERE SessionId = @SessionID AND StatusFlag IN(1,5)) record count to update > 0

				-------------------------------------------------------------
						-- Remove deletions
				-------------------------------------------------------------

						SET @ProcedureStep = 'Remove deletions'

						EXEC [dbo].[spMFGetDeletedObjects] @MFTableName = @MFTableName      -- nvarchar(200)
						                                  ,@LastModifiedDate = '2000-01-01' -- datetime
						                                  ,@RemoveDeleted = 1    -- bit
						                                  ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT                -- int
						                                  ,@Debug = 0            -- smallint
						
                -------------------------------------------------------------
                -- Get last update date
                -------------------------------------------------------------
                SET @ProcedureStep = 'Get update date for output';
                SET @sqlParam = N'@MFLastModifiedDate Datetime output';
                SET @sql
                    = N'
SELECT @MFLastModifiedDate = (SELECT MAX(' + QUOTENAME(@lastModifiedColumn) + ') FROM ' + QUOTENAME(@MFTableName)
                      + ' );';

                EXEC [sys].[sp_executesql] @Stmt = @sql
                                          ,@Params = @sqlParam
                                          ,@MFLastModifiedDate = @MFLastModifiedDate OUTPUT;

                SET @MFLastUpdateDate = @MFLastModifiedDate;

                -------------------------------------------------------------
                -- end logging
                -------------------------------------------------------------s
                SET @error = @@Error;
                SET @ProcessType = 'Update Tables';
                SET @LogType = 'Debug';
                SET @LogStatusDetail = CASE
                                           WHEN (@error <> 0) THEN
                                               'Failed'
                                           ELSE
                                               'Completed'
                                       END;
                SET @ProcedureStep = 'finalisation';
                SET @LogTypeDetail = 'Debug';
                SET @LogTextDetail = 'MF Last Modified: ' + CONVERT(VARCHAR(20), @MFLastUpdateDate, 120);
                --		SET @LogStatusDetail = 'Completed'
                SET @LogColumnName = @MFTableName;
                SET @LogColumnValue = '';
                SET @LogText = 'Update : ' + @MFTableName + ':Update Type ' + CASE
                                                                                  WHEN @UpdateTypeID = 1 THEN
                                                                                      'Incremental'
                                                                                  ELSE
                                                                                      'Full'
                                                                              END;
                SET @LogStatus = 'Completed';
                SET @LogStatusDetail = 'Completed';

                EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                      -- int
                                                    ,@ProcessType = @ProcessType
                                                    ,@LogText = @LogText
                                                    ,@LogType = @LogType
                                                                      -- nvarchar(4000)
                                                    ,@LogStatus = @LogStatus
                                                                      -- nvarchar(50)
                                                    ,@debug = @debug; -- tinyint

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_IDOut
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             --        @ProcessBatchDetail_ID = @ProcessBatchDetail_IDOUT OUTPUT,
                                                                             ,@debug = @debug;
            END; --REFRESH M-FILES --> MFSQL

            SET NOCOUNT OFF;

            RETURN 1;
        END;
        ELSE
        BEGIN
            SET @ProcedureStep = 'Validate Class Table';

            RAISERROR('Invalid Table Name', 16, 1);
        END;
    END TRY
    BEGIN CATCH
        -----------------------------------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        -----------------------------------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ProcedureStep]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
        )
        VALUES
        (@ProcedureName, @ProcedureStep, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE()
        ,ERROR_SEVERITY(), ERROR_LINE());

        -----------------------------------------------------------------------------
        -- DISPLAYING ERROR DETAILS
        -----------------------------------------------------------------------------
        SELECT ERROR_NUMBER()    AS [ErrorNumber]
              ,ERROR_MESSAGE()   AS [ErrorMessage]
              ,ERROR_PROCEDURE() AS [ErrorProcedure]
              ,ERROR_STATE()     AS [ErrorState]
              ,ERROR_SEVERITY()  AS [ErrorSeverity]
              ,ERROR_LINE()      AS [ErrorLine]
              ,@ProcedureName    AS [ProcedureName]
              ,@ProcedureStep    AS [ProcedureStep];

        RETURN -1;
    END CATCH;
END;
GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFLogProcessSummaryForClassTable]';
go

SET NOCOUNT ON; 
EXEC Setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',
    @ObjectName = N'spMFLogProcessSummaryForClassTable', -- nvarchar(100)
    @Object_Release = '3.1.4.41', -- varchar(50)
    @UpdateFlag = 2;
 -- smallint
go

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFLogProcessSummaryForClassTable'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
go
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFLogProcessSummaryForClassTable]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

go
-- the following section will be always executed
SET NOEXEC OFF;
go

ALTER PROCEDURE [dbo].[spMFLogProcessSummaryForClassTable]
	(
	    @ProcessBatch_ID INT
	  , @MFTableName NVARCHAR(100)
	  , @IncludeStats BIT = 0 --Future Use
	  , @IncludeAudit BIT = 0 --Future Use
	  , @InsertCount INT = NULL	
	  , @UpdateCount INT = NULL
	  , @LogProcedureName NVARCHAR(100) = NULL
	  , @LogProcedureStep NVARCHAR(100) = NULL
	  , @LogTextDetailOUT NVARCHAR(4000) = NULL OUTPUT
	  , @LogStatusDetailOUT NVARCHAR(50) = NULL OUTPUT
	  , @debug TINYINT = 0
	)
AS
/*rST**************************************************************************

==================================
spMFLogProcessSummaryForClassTable
==================================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @ProcessBatch\_ID int (optional)
    Referencing the ID of the ProcessBatch logging table
  @MFTableName nvarchar(100)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @IncludeStats bit
    - Reserved
  @IncludeAudit bit
    - Reserved
  @InsertCount int (optional)
    - Default = NULL
    - Use to set #Inserted in LogText
  @UpdateCount int (optional)
    - Default = NULL
    - Use to set #Updated in LogText
  @LogProcedureName nvarchar(100) (optional)
    - Default = NULL
    - The calling stored procedure name
  @LogProcedureStep nvarchar(100) (optional)
    - Default = NULL
    - The step from the calling stored procedure to include in the Log
  @LogTextDetailOUT nvarchar(4000) (output)
    - The LogText written to MFProcessBatchDetail
  @LogStatusDetailOUT nvarchar(50) (output)
    - The LogStatus written to MFProcessBatchDetail
  @debug tinyint
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

Calculate various totals, including error counts and update MFProcessBatch and MFProcessBatchDetail LogText and Status.

Additional Info
===============

Calculate various totals, including error counts and update MFProcessBatch and MFProcessBatchDetail LogText and Status.

Counts are performed on the MFClassTable based on MFSQL_Process_Batch and Process_ID

Counts included:

- Record Count
- Deleted Count
- Synchronization Error Count
- M-Files Error Count
- SQL Error Count
- MFLog Count related to

Based on any of the Error count being larger than 0, the LogStatusDetail will be appended with 'w/Errors' text.

The LogTextDetail is set to the following value, with only displaying the counts larger than 0:

.. code:: text

    #Records: @RecordCount | #Inserted: @InsertCount | #Updated: @UpdateCount | #Deleted: @DeletedCount | #Sync Errors: @SyncErrorCount | #MF Errors: @MFErrorCount | #SQL Errors: @SQLErrorCount | #MFLog Errors: @MFLogErrorCount

Add the following properties to M-Files Classes: MFSQL Process Batch



Prerequisites
=============

Requires use MFProcessBatch in solution.

Requires use of MFSQL Process Batch on class tables.

Warnings
========

This procedure to be used as part of an overall messaging and logging solution. It will typically be called towards the end of your processes against a specific MFClassTable.

Relies on the usage of MFSQL_Process_Batch as a property in all M-Files classes that are part of your solution. Your solution code should also be written to set the MFSQL_Process_Batch to the ProcessBatch_ID for all operations where you set the Process_ID to 1.

Examples
========

.. code:: sql

    DECLARE @LogTextDetailOUT NVARCHAR(4000)
       , @LogStatusDetailOUT NVARCHAR(50);

    EXEC [dbo].[spMFLogProcessSummaryForClassTable] @ProcessBatch_ID = ?
                 , @MFTableName = ?
                 , @InsertCount = ?
                 , @UpdateCount = ?
                 , @LogProcedureName = ?
                 , @LogProcedureStep = ?
                 , @LogTextDetailOUT = @LogTextDetailOUT OUTPUT
                 , @LogStatusDetailOUT = @LogStatusDetailOUT OUTPUT
                 , @debug = 0

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

/*******************************************************************************
  ** Desc:  Format Messages for output to Context Menu UI and/or Mulit-Line Text Property
  ** NB  this procedure relies on the use of MFSQL_Process_Batch as part of the infrastructure

  ** Parameters and acceptable values:
  **	@MFTableName:			Optional - Error message from Stats output is NOT included if not provided.
  **	@Processbatch_ID		Required - Retrieve message content values from MFProcessBatch
  **	@MessageOUT:			Optional - Return message formatted for display by Context Menu with non-asyncronous process (includes newline as \n)
  ******************************************************************************/
	BEGIN
		-------------------------------------------------------------
		-- VARIABLES: DYNAMIC SQL
		-------------------------------------------------------------
		DECLARE @sql NVARCHAR(MAX) = N''
		DECLARE @sqlParam NVARCHAR(MAX) = N''
		-------------------------------------------------------------
		-- VARIABLES: DEBUGGING
		-------------------------------------------------------------
		DECLARE @ProcedureName AS NVARCHAR(128) = 'dbo.spMFLogProcessSummaryForClassTable';
		DECLARE @ProcedureStep AS NVARCHAR(128) = 'Start';
		DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s'
		DECLARE @DebugText AS NVARCHAR(256) = ''
		DECLARE @Msg AS NVARCHAR(256) = ''
		DECLARE @MsgSeverityInfo AS TINYINT = 10
		DECLARE @MsgSeverityObjectDoesNotExist AS TINYINT = 11
		DECLARE @MsgSeverityGeneralError AS TINYINT = 16

		-------------------------------------------------------------
		-- VARIABLES: LOGGING
		-------------------------------------------------------------
		DECLARE @LogType AS NVARCHAR(50) = 'Status'
		DECLARE @LogText AS NVARCHAR(4000) = '';
		DECLARE @LogStatus AS NVARCHAR(50) = 'Started'

		DECLARE @LogTypeDetail AS NVARCHAR(50) = 'System'
		DECLARE @LogTextDetail AS NVARCHAR(4000) = '';
		DECLARE @LogStatusDetail AS NVARCHAR(50) = 'In Progress'
		DECLARE @ProcessBatchDetail_IDOUT AS INT = NULL

		DECLARE @LogColumnName AS NVARCHAR(128) = NULL
		DECLARE @LogColumnValue AS NVARCHAR(256) = NULL

		DECLARE @count INT = 0;
		DECLARE @Now AS DATETIME = GETDATE();
		DECLARE @StartTime AS DATETIME = GETUTCDATE();
		DECLARE @StartTime_Total AS DATETIME = GETUTCDATE();
		DECLARE @RunTime_Total AS DECIMAL(18, 4) = 0;


		
		-------------------------------------------------------------
		-- VARIABLES:THIS PROC
		-------------------------------------------------------------
		DECLARE @Message NVARCHAR(4000);

		DECLARE
    @RecordCount                 INT,
    @SQLRecordCount              INT,
    @MFRecordCount               INT,
    @SyncError                   INT,
    @Process_ID_1                INT,
    @MFError                     INT,
    @SQLError                    INT,
    @MFLastModified              Datetime,
    @SessionID                   INT,
    @DeletedCount                INT,
    @SyncErrorCount_Process_ID_2 INT,
    @MFErrorCount_Process_ID_3   INT,
    @SQLErrorCount_Process_ID_4  INT,
    @MFLogError_Count            INT,
    @ProcessType                 NVARCHAR(50),
    @ClassName                   NVARCHAR(100);

		SELECT @LogStatusDetail = 'Completed'
			,  @ProcessType = [ProcessType]	
			,  @StartTime = [CreatedOnUTC]
		FROM [dbo].[MFProcessBatch]
		WHERE [ProcessBatch_ID] = @ProcessBatch_ID

		SELECT @ClassName = [Name]
		FROM [dbo].[MFClass]
		WHERE [TableName] = @MFTableName

		BEGIN try
-- Total Records updated Count
		SET @sql = N'SELECT @Count = COUNT(*)
						FROM   [dbo].' + QUOTENAME(@MFTableName) + '
						WHERE  [Mfsql_Process_Batch] = @ProcessBatch_ID'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'
		
		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @RecordCount OUTPUT

-- Deleted Count
		SET @sql = N'SELECT @Count = COUNT(*)
						FROM   [dbo].' + QUOTENAME(@MFTableName) + '
						WHERE  [Mfsql_Process_Batch] = @ProcessBatch_ID
						AND [Deleted] = 1'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'

		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @DeletedCount OUTPUT

-- SyncError Count
		SET @sql = N'SELECT @Count = COUNT(*)
						FROM   [dbo].' + QUOTENAME(@MFTableName) + '
						WHERE  [Mfsql_Process_Batch] = @ProcessBatch_ID
						AND [Process_ID] = 2
						AND [Deleted] = 0'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'

		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @SyncErrorCount_Process_ID_2 OUTPUT


-- MFError Count
		SET @sql = N'SELECT @Count = COUNT(*)
						FROM   [dbo].' + QUOTENAME(@MFTableName) + '
						WHERE  [Mfsql_Process_Batch] = @ProcessBatch_ID
						AND [Process_ID] = 3
						AND [Deleted] = 0'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'

		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @MFErrorCount_Process_ID_3 OUTPUT

-- SQLError Count
		SET @sql = N'SELECT @Count = COUNT(*)
						FROM   [dbo].' + QUOTENAME(@MFTableName) + '
						WHERE  [Mfsql_Process_Batch] = @ProcessBatch_ID
						AND [Process_ID] = 4
						AND [Deleted] = 0'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'

		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @SQLErrorCount_Process_ID_4 OUTPUT

			
-- MFLogError Count
		SET @sql = N'SELECT @Count = COUNT(DISTINCT [LogID])
						FROM   [dbo].' + QUOTENAME(@MFTableName) + ' [cl]
						INNER JOIN [dbo].[MFLog] ON [cl].[Update_ID] = [MFLog].[Update_ID]
						WHERE  [cl].[Mfsql_Process_Batch] = @ProcessBatch_ID
						AND [cl].[Deleted] = 0'

		SET @sqlParam = '@ProcessBatch_ID INT,@Count INT OUTPUT'

		EXEC [sys].[sp_executesql] @sql
								 , @sqlParam
								 , @ProcessBatch_ID
								 , @MFLogError_Count OUTPUT

--Get LogStatusDetail
		SET @LogStatusDetail = @LogStatusDetail + CASE WHEN @SyncErrorCount_Process_ID_2 > 0
												OR @MFErrorCount_Process_ID_3 > 0
												OR @SQLErrorCount_Process_ID_4 > 0
												OR @MFLogError_Count > 0 THEN ' w/Errors'
											ELSE ''
										END

--Get LogTextDetail
		SET @LogTextDetail =  '#Records: ' + ISNULL(CAST(@RecordCount AS VARCHAR(10)), '(null)')
							  + CASE WHEN @InsertCount > 0 THEN
										 ' | ' + '#Inserted: ' + ISNULL(CAST(@InsertCount AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @UpdateCount > 0 THEN
										 ' | ' + '#Updated: ' + ISNULL(CAST(@UpdateCount AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @DeletedCount > 0 THEN
										 ' | ' + '#Deleted: ' + ISNULL(CAST(@DeletedCount AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @SyncErrorCount_Process_ID_2 > 0 THEN
										 ' | ' + '#Sync Errors: '
										 + ISNULL(CAST(@SyncErrorCount_Process_ID_2 AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @MFErrorCount_Process_ID_3 > 0 THEN
										 ' | ' + '#MF Errors: '
										 + ISNULL(CAST(@MFErrorCount_Process_ID_3 AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @SQLErrorCount_Process_ID_4 > 0 THEN
										 ' | ' + '#SQL Errors: '
										 + ISNULL(CAST(@SQLErrorCount_Process_ID_4 AS VARCHAR(10)), '(null)')
									 ELSE ''
								END
							  + CASE WHEN @MFLogError_Count > 0 THEN
										 ' | ' + '#MFLog Errors: '
										 + ISNULL(CAST(@MFLogError_Count AS VARCHAR(10)), '(null)')
									 ELSE ''
								END


--Get Class Table Stats
		IF @IncludeStats = 1
			BEGIN
		--Update Class Table Audit
				IF @IncludeAudit = 1
				BEGIN
					DECLARE @SessionIDOut INT
							, @NewObjectXml NVARCHAR(MAX);

					EXEC [dbo].[spMFTableAudit] @MFTableName = @MFTableName
												, @MFModifiedDate = NULL
												, @ObjIDs = NULL
												, @ProcessBatch_ID = @ProcessBatch_ID 
												, @SessionIDOut = @SessionIDOut OUTPUT
												, @NewObjectXml = @NewObjectXml OUTPUT



				END--IF @IncludeAudit = 1

			
				EXEC [dbo].[spMFClassTableStats] @ClassTableName = @MFTableName
				,@IncludeOutput = 1


				-- smallint
				SELECT 
					  @SQLRecordCount = [s].[SQLRecordCount]
					 , @MFRecordCount  = [s].[MFRecordCount]
					 , @SyncError	   = [s].[SyncError]
					 , @Process_ID_1   = [s].[Process_ID_1]
					 , @MFError		   = [s].[MFError]
					 , @SQLError	   = [s].[SQLError]
					 , @MFLastModified = [s].[MFLastModified]
					 , @SessionID	   = [s].[sessionID]
				FROM   ##spMFClassTableStats AS [s];

			SET @LogTextDetail = @LogTextDetail + ' |  | ' + 'TOTALS' + ' | '


			END--IF @IncludeStats = 1

--Insert Log Detail

		SET @LogColumnName = 'RecordCount'
		SET @LogColumnValue = CAST(@RecordCount AS NVARCHAR(256))

		EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
													, @LogType = 'Message'
													, @LogText = @LogTextDetail
													, @LogStatus = @LogStatusDetail
													, @StartTime = @StartTime
													, @MFTableName = @MFTableName
													, @ColumnName = @LogColumnName
													, @ColumnValue = @LogColumnValue
													, @LogProcedureName = @LogProcedureName
													, @LogProcedureStep = @LogProcedureStep
													, @debug = 0
														 		
	  SET @LogTextDetailOUT = @LogTextDetail
	  SET @LogStatusDetailOUT = @LogStatusDetail

		-- Return the result of the function
		RETURN 1;

	END TRY
    
			BEGIN CATCH
			SET @StartTime = GETUTCDATE()
			SET @LogStatus = 'Failed w/SQL Error'
			SET @LogTextDetail = ERROR_MESSAGE()

			--------------------------------------------------
			-- INSERTING ERROR DETAILS INTO LOG TABLE
			--------------------------------------------------
			INSERT INTO [dbo].[MFLog] ( [SPName]
									  , [ErrorNumber]
									  , [ErrorMessage]
									  , [ErrorProcedure]
									  , [ErrorState]
									  , [ErrorSeverity]
									  , [ErrorLine]
									  , [ProcedureStep]
									  )
			VALUES (
					   @ProcedureName
					 , ERROR_NUMBER()
					 , ERROR_MESSAGE()
					 , ERROR_PROCEDURE()
					 , ERROR_STATE()
					 , ERROR_SEVERITY()
					 , ERROR_LINE()
					 , @ProcedureStep
				   );

			SET @ProcedureStep = 'Catch Error'
			-------------------------------------------------------------
			-- Log Error
			-------------------------------------------------------------   
			EXEC [dbo].[spMFProcessBatch_Upsert]
				@ProcessBatch_ID = @ProcessBatch_ID OUTPUT
			  , @ProcessType = @ProcessType
			  , @LogType = N'Error'
			  , @LogText = @LogTextDetail
			  , @LogStatus = @LogStatus
			  , @debug = @Debug

			SET @StartTime = GETUTCDATE()

			EXEC [dbo].[spMFProcessBatchDetail_Insert]
				@ProcessBatch_ID = @ProcessBatch_ID
			  , @LogType = N'Error'
			  , @LogText = @LogTextDetail
			  , @LogStatus = @LogStatus
			  , @StartTime = @StartTime
			  , @MFTableName = @MFTableName
			  , @Validation_ID = NULL
			  , @ColumnName = NULL
			  , @ColumnValue = NULL
			  , @Update_ID = NULL
			  , @LogProcedureName = @ProcedureName
			  , @LogProcedureStep = @ProcedureStep
			  , @debug = 0

			RETURN -1
		END CATCH

	END

GO



GO

PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFGetHistory]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFGetHistory'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.4.12.53'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;

GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFGetHistory' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

CREATE PROCEDURE [dbo].[spMFGetHistory]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFGetHistory]
(
    @MFTableName NVARCHAR(128)
   ,@Process_id INT = 0
   ,@ColumnNames NVARCHAR(4000)
   ,@SearchString nvarchar(4000) = null
   ,@IsFullHistory BIT = 1
   ,@NumberOFDays INT = null
   ,@StartDate DATETIME = null
   ,@Update_ID INT = NULL OUTPUT
   ,@ProcessBatch_id INT = NULL OUTPUT
   ,@Debug INT = 0
)
AS
/*rST**************************************************************************

==============
spMFGetHistory
==============

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(128)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @Process\_id int
    - Set process_id in the class table for records to be selected
    - Use process_id not in (1-4) e.g. 5
  @ColumnNames nvarchar(4000)
    - Comma delimited list of the columns to be included in the export
  @IsFullHistory bit
    - Default = 1
    - 1 will include all the changes of the object for the specified column names
    - Set to 0 to specify any of the other filters
  @SearchString nvarchar(4000)
    - Search for objects included in the object select and property selection with a specific value
    - Search is a 'contain' search
  @NumberOFDays int
    - Set this to show the last x number of days of changes
  @StartDate datetime
    - set to a specific date to only show change history from a specific date (e.g. for the last month)
  @ProcessBatch\_id int (output)
    - Processbatch id for logging
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode

Purpose
=======

Allows to update MFObjectChangeHistory table with the change history of the specific property of the object based on certain filters

Additional Info
===============

When the history table is updated it will only report the versions that the property was changed. If the property included in the filter did not change, then to specific version will not be recorded in the table.
Process_id is reset to 0 after completion of the processing.

Use Cases(s)

- Show coimments made on object
- Show a state was entered and exited
- Show when a property was changed
- Discovery reports for changes to certain properties

Prerequisites
=============

Set process_id in the class table to 5 for all the records to be included

Warnings
========

Note that the same filter will apply to all the columns included in the run.  Split the get procedure into different runs if different filters must be applied to different columns.

Producing on the history for all objects in a large table could take a considerable time to complete. Use the filters to limit restrict the number of records to fetch from M-Files to optimise the search time.

Examples
========

This procedure can be used to show all the comments  or the last 5 comments made for a object.  It is also handly to assess when a workflow state was changed

.. code:: sql

    UPDATE mfcustomer
    SET Process_ID = 5
    FROM MFCustomer  WHERE id in (9,10)

    DECLARE @RC INT
    DECLARE @TableName NVARCHAR(128) = 'MFCustomer'
    DECLARE @Process_id INT = 5
    DECLARE @ColumnNames NVARCHAR(4000) = 'Address_Line_1,Country'
    DECLARE @IsFullHistory BIT = 1
    DECLARE @NumberOFDays INT
    DECLARE @StartDate DATETIME --= DATEADD(DAY,-1,GETDATE())
    DECLARE @ProcessBatch_id INT
    DECLARE @Debug INT = 0

    EXECUTE @RC = [dbo].[spMFGetHistory]
    @TableName
    ,@Process_id
    ,@ColumnNames
    ,@IsFullHistory
    ,@NumberOFDays
    ,@StartDate
    ,@ProcessBatch_id OUTPUT
    ,@Debug

    SELECT * FROM [dbo].[MFProcessBatch] AS [mpb] WHERE [mpb].[ProcessBatch_ID] = @ProcessBatch_id
    SELECT * FROM [dbo].[MFProcessBatchDetail] AS [mpbd] WHERE [mpbd].[ProcessBatch_ID] = @ProcessBatch_id

----

Show the results of the table including the name of the property

.. code:: sql

    SELECT toh.*,mp.name AS propertyname FROM mfobjectchangehistory toh
    INNER JOIN mfproperty mp
    ON mp.[MFID] = toh.[Property_ID]
    ORDER BY [toh].[Class_ID],[toh].[ObjID],[toh].[MFVersion],[toh].[Property_ID]

----

Show the results of the table for a state change

.. code:: sql

    SELECT toh.*,mws.name AS StateName, mp.name AS propertyname FROM mfobjectchangehistory toh
    INNER JOIN mfproperty mp
    ON mp.[MFID] = toh.[Property_ID]
    INNER JOIN [dbo].[MFWorkflowState] AS [mws]
    ON [toh].[Property_Value] = mws.mfid
    WHERE [toh].[Property_ID] = 39
    ORDER BY [toh].[Class_ID],[toh].[ObjID],[toh].[MFVersion],[toh].[Property_ID]

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-19  LC         Resolve dropping of temp table
2019-09-05  LC         Reset defaults
2019-09-05  LC         Add searchstring option
2019-08-30  JC         Added documentation
2019-08-02  LC         Set lastmodifiedUTC datetime conversion to 105
2019-06-02  LC         Fix bug with lastmodifiedUTC date
2019-01-02  LC         Add ability to show updates in MFUpdateHistory
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        -----------------------------------------------------
        --DECLARE LOCAL VARIABLE
        ----------------------------------------------------
        DECLARE @VaultSettings NVARCHAR(4000);
        DECLARE @PropertyIDs NVARCHAR(4000);
        DECLARE @ObjIDs NVARCHAR(MAX);
        DECLARE @ObjectType INT;
        DECLARE @ProcedureName sysname = 'spMFGetHistory';
        DECLARE @ProcedureStep sysname = 'Start';
        -----------------------------------------------------
        --DECLARE VARIABLES FOR LOGGING
        -----------------------------------------------------
        --used on MFProcessBatchDetail;
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @LogTypeDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @ProcessType NVARCHAR(50) = 'Object History';
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = 'Get History Initiated';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @Status AS NVARCHAR(128) = NULL;
        DECLARE @Validation_ID INT = NULL;
        DECLARE @StartTime AS DATETIME = GETUTCDATE();
        DECLARE @RunTime AS DECIMAL(18, 4) = 0;
        DECLARE @Update_IDOut INT;
        DECLARE @error AS INT = 0;
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT;
        DECLARE @RC INT;
        --  DECLARE @Update_ID INT;

        ----------------------------------------------------------------------
        --GET Vault LOGIN CREDENTIALS
        ----------------------------------------------------------------------
        DECLARE @Username NVARCHAR(2000);
        DECLARE @VaultName NVARCHAR(2000);

        SELECT TOP 1
               @Username  = [Username]
              ,@VaultName = [VaultName]
        FROM [dbo].[MFVaultSettings];

        INSERT INTO [dbo].[MFUpdateHistory]
        (
            [Username]
           ,[VaultName]
           ,[UpdateMethod]
        )
        VALUES
        (@Username, @VaultName, -1);

        SELECT @Update_ID = @@Identity;

        SELECT @Update_IDOut = @Update_ID;

        SET @ProcessType = @ProcedureName;
        SET @LogText = @ProcedureName + ' Started ';
        SET @LogStatus = 'Initiate';
        SET @StartTime = GETUTCDATE();

        EXECUTE @RC = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                                     ,@ProcessType = @ProcessType
                                                     ,@LogType = @LogType
                                                     ,@LogText = @LogText
                                                     ,@LogStatus = @LogStatus
                                                     ,@debug = @Debug;

        SET @ProcedureStep = 'GET Vault LOGIN CREDENTIALS';

        IF @Debug = 1
        BEGIN
            PRINT @ProcedureStep;
        END;

        SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

        IF @Debug = 1
        BEGIN
            SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();
        END;

        ----------------------------------------------------------------------
        --GET PropertyIDS as comma separated string  
        ----------------------------------------------------------------------
        SET @ProcedureStep = 'Get PropertyIDS';
        SET @LogTypeDetail = 'Message';
        SET @LogStatusDetail = 'Started';
        SET @StartTime = GETUTCDATE();

        IF (SELECT OBJECT_ID('tempdb..#TempProperty')) IS NOT NULL
        DROP TABLE #TempProperty;
        CREATE TABLE [#TempProperty]
        (
            [ID] INT IDENTITY(1, 1)
           ,[ColumnName] NVARCHAR(200)
           ,[IsValidProperty] BIT
        );

        INSERT INTO [#TempProperty]
        (
            [ColumnName]
        )
        SELECT [ListItem]
        FROM [dbo].[fnMFParseDelimitedString](@ColumnNames, ',');

        DECLARE @Counter  INT
               ,@MaxRowID INT;

        SELECT @MaxRowID = MAX([ID])
        FROM [#TempProperty];

        SET @Counter = 1;

        WHILE @Counter <= @MaxRowID
        BEGIN
            DECLARE @PropertyName NVARCHAR(200);

            SELECT @PropertyName = [ColumnName]
            FROM [#TempProperty]
            WHERE [ID] = @Counter;

            IF EXISTS
            (
                SELECT TOP 1
                       *
                FROM [dbo].[MFProperty] WITH (NOLOCK)
                WHERE [ColumnName] = @PropertyName
            )
            BEGIN
                UPDATE [#TempProperty]
                SET [IsValidProperty] = 1
                WHERE [ID] = @Counter;
            END;
            ELSE
            BEGIN
                SET @PropertyName = @PropertyName + '_ID';

                IF EXISTS
                (
                    SELECT TOP 1
                           *
                    FROM [dbo].[MFProperty] WITH (NOLOCK)
                    WHERE [ColumnName] = @PropertyName
                )
                BEGIN
                    UPDATE [#TempProperty]
                    SET [IsValidProperty] = 1
                       ,[ColumnName] = @PropertyName
                    WHERE [ID] = @Counter;
                END;
                ELSE
                BEGIN
                    DECLARE @ErrorMsg NVARCHAR(1000);

                    SELECT @ErrorMsg = 'Invalid columnName ' + @PropertyName + ' provided';

                    IF @Debug > 0
                        --	   SELECT @ErrorMsg;
                        RAISERROR(
                                     'Proc: %s Step: %s ErrorInfo %s '
                                    ,16
                                    ,1
                                    ,'spmfGetHistory'
                                    ,'Validating property column name'
                                    ,@ErrorMsg
                                 );
                END;
            END;

            SET @Counter = @Counter + 1;
        END;

        SET @ColumnNames = '';

        SELECT @ColumnNames = COALESCE(@ColumnNames + ',', '') + [ColumnName]
        FROM [#TempProperty];

        SELECT @PropertyIDs = COALESCE(@PropertyIDs + ',', '') + CAST([MFID] AS VARCHAR(20))
        FROM [dbo].[MFProperty] WITH (NOLOCK)
        WHERE [ColumnName] IN (
                                  SELECT [ListItem] FROM [dbo].[fnMFParseDelimitedString](@ColumnNames, ',')
                              );

        SELECT @rowcount = COUNT(*)
        FROM [dbo].[fnMFParseDelimitedString](@ColumnNames, ',');

        SET @LogTextDetail = 'Columns: ' + @ColumnNames;
        SET @LogColumnName = 'Count of columns';
        SET @LogColumnValue = CAST(@rowcount AS VARCHAR(10));

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

        ----------------------------------------------------------------------
        --GET ObjectType of Table
        ----------------------------------------------------------------------
        SET @ProcedureStep = 'GET ObjectType of class table ' + @MFTableName;

        SELECT @ObjectType = [OT].[MFID]
        FROM [dbo].[MFClass]                AS [CLS]
            INNER JOIN [dbo].[MFObjectType] AS [OT]
                ON [CLS].[MFObjectType_ID] = [OT].[ID]
        WHERE [CLS].[TableName] = @MFTableName;

        IF @Debug = 1
        BEGIN
            SELECT @ObjectType AS [ObjectType];
        END;

        ---------------------------------------------------------------------
        --GET Comma separated ObjIDS for Getting the History        
        ----------------------------------------------------------------------
        SET @ProcedureStep = 'ObjIDS for History ';

        IF @Debug = 1
        BEGIN
            PRINT @ProcedureStep;
        END;

        SET @StartTime = GETUTCDATE();

        DECLARE @VQuery NVARCHAR(4000)
               ,@Filter NVARCHAR(4000);

        SET @Filter = 'where  Process_ID=' + CONVERT(VARCHAR(10), @Process_id);

        CREATE TABLE [#TempObjIDs]
        (
            [ObjIDS] NVARCHAR(MAX)
        );

        SET @VQuery
            = 'insert into #TempObjIDs(ObjIDS)  select STUFF(( SELECT '',''
											  , CAST([ObjID] AS VARCHAR(10))
										 FROM  ' + @MFTableName + '
										  ' + @Filter
              + '
									   FOR
										 XML PATH('''')
									   ), 1, 1, '''') ';

        EXEC (@VQuery);

        SELECT @ObjIDs = [ObjIDS]
        FROM [#TempObjIDs];

        SELECT @rowcount = COUNT(*)
        FROM [#TempObjIDs] AS [toid];

        SET @LogTypeDetail = 'Message';
        SET @LogStatusDetail = 'Completed';
        SET @LogTextDetail = 'ObjIDS for History';
        SET @LogColumnName = 'Objids count';
        SET @LogColumnValue = CAST(@rowcount AS VARCHAR(100));

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

        IF @Debug = 1
        BEGIN
            SELECT @ObjIDs AS [ObjIDS];
        END;

        ---------------------------------------------------------------------
        --Calling spMFGetHistoryInternal  procedure to objects history
        ----------------------------------------------------------------------
        DECLARE @Result NVARCHAR(MAX);
        DECLARE @Idoc INT;

        --select @VaultSettings as 'VaultSettings'
        --select @ObjectType as 'ObjectType'
        --select @ObjIDs as 'ObjIDs'
        --select @PropertyIDs as 'PropertyIDs'
        SET @ProcedureStep = 'Calling spMFGetHistoryInternal';

        DECLARE @Criteria VARCHAR(258);

        SET @Criteria = CASE
                            WHEN @IsFullHistory = 1 THEN
                                'Full History '
                            WHEN @IsFullHistory = 0
                                 AND @NumberOFDays > 0 THEN
                                'For Number of days: ' + CAST(@NumberOFDays AS VARCHAR(5)) + ''
                            WHEN @IsFullHistory = 0
                                 AND @NumberOFDays < 0
                                 AND @StartDate <> '1901-01-10' THEN
                                'From date: ' + CAST((CONVERT(DATE, @StartDate)) AS VARCHAR(25)) + ''
                            ELSE
                                'No Criteria'
                        END;

        DECLARE @Params NVARCHAR(MAX);

        SET @VQuery
            = N'SELECT @rowcount = COUNT(*) FROM ' + @MFTableName + ' where process_ID = '
              + CAST(@Process_id AS VARCHAR(5)) + '';
        SET @Params = N'@RowCount int output';

        EXEC [sys].[sp_executesql] @VQuery, @Params, @RowCount = @rowcount OUTPUT;

        SET @LogTypeDetail = 'Message';
        SET @LogStatusDetail = 'Completed';
        SET @LogTextDetail = 'Criteria:  ' + @Criteria;
        SET @LogColumnName = 'Object Count';
        SET @LogColumnValue = CAST(@rowcount AS VARCHAR(5));
        SET @StartTime = GETUTCDATE();

        UPDATE [dbo].[MFUpdateHistory]
        SET [ObjectDetails] = @ObjIDs
           ,[ObjectVerDetails] = @PropertyIDs
        WHERE [Id] = @Update_ID;

        -- note that ability to use a search criteria is not yet active.

        -----------------------------------------------------------------
        -- Checking module access for CLR procdure  spMFGetHistoryInternal
        ------------------------------------------------------------------
        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;
        SET @ProcedureStep = 'Check License';

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        EXEC [dbo].[spMFCheckLicenseStatus] 'spMFGetHistory'
                                           ,@ProcedureName
                                           ,@ProcedureStep;

        EXEC [dbo].[spMFGetHistoryInternal] @VaultSettings
                                           ,@ObjectType
                                           ,@ObjIDs
                                           ,@PropertyIDs
                                           ,@SearchString
                                           ,@IsFullHistory
                                           ,@NumberOFDays
                                           ,@StartDate
                                           ,@Result OUT;

        IF @Debug > 1
        BEGIN
            SELECT CAST(@Result AS XML) AS [HistoryXML];
        END;

        IF (@Update_ID > 0)
            UPDATE [dbo].[MFUpdateHistory]
            SET [NewOrUpdatedObjectVer] = @Result
            WHERE [Id] = @Update_ID;

        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @Result;

        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;
        SET @ProcedureStep = 'Geet history in wrapper performed';

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

        ----------------------------------------------------------------------------------
        --Creating temp table #Temp_ObjectHistory for storing object history xml records
        --------------------------------------------------------------------------------
        SET @ProcedureStep = 'Creating temp table #Temp_ObjectHistory';

        IF (SELECT OBJECT_ID('tempdb..#TempObjIDs')) IS NOT NULL
        DROP TABLE #TempObjids;
        CREATE TABLE [#Temp_ObjectHistory]
        (
            [RowNr] INT IDENTITY
           ,[ObjectType_ID] INT
           ,[Class_ID] INT
           ,[ObjID] INT
           ,[MFVersion] INT
           ,[LastModifiedUTC] NVARCHAR(100)
           ,[MFLastModifiedBy_ID] INT
           ,[Property_ID] INT
           ,[Property_Value] NVARCHAR(300)
           ,[CreatedOn] DATETIME
        );

        INSERT INTO [#Temp_ObjectHistory]
        (
            [ObjectType_ID]
           ,[Class_ID]
           ,[ObjID]
           ,[MFVersion]
           ,[LastModifiedUTC]
           ,[MFLastModifiedBy_ID]
           ,[Property_ID]
           ,[Property_Value]
           ,[CreatedOn]
        )
        SELECT [ObjectType]
              ,[ClassID]
              ,[ObjID]
              ,[Version]
              ,[LastModifiedUTC]
              ,[LastModifiedBy_ID]
              ,[Property_ID]
              ,[Property_Value]
              ,GETDATE()
        FROM
            OPENXML(@Idoc, '/form/Object/Property', 1)
            WITH
            (
                [ObjectType] INT '../@ObjectType'
               ,[ClassID] INT '../@ClassID'
               ,[ObjID] INT '../@ObjID'
               ,[Version] INT '../@Version'
               --      , [LastModifiedUTC] NVARCHAR(30) '../@LastModifiedUTC'
               ,[LastModifiedUTC] NVARCHAR(100) '../@CheckInTimeStamp'
               ,[LastModifiedBy_ID] INT '../@LastModifiedBy_ID'
               ,[Property_ID] INT '@Property_ID'
               ,[Property_Value] NVARCHAR(300) '@Property_Value'
            );

        IF @Debug > 0
            SELECT *
            FROM [#Temp_ObjectHistory] AS [toh];

        EXEC [sys].[sp_xml_removedocument] @Idoc;

        ----------------------------------------------------------------------------------
        --Merge/Inserting records into the MFObjectChangeHistory from Temp_ObjectHistory
        --------------------------------------------------------------------------------
        SET @ProcedureStep = 'Update MFObjectChangeHistory';

        DECLARE @BeforeCount INT;

        SELECT @BeforeCount = COUNT(*)
        FROM [dbo].[MFObjectChangeHistory];

        MERGE INTO [dbo].[MFObjectChangeHistory] AS [t]
        USING
        (SELECT * FROM [#Temp_ObjectHistory] AS [toh]) AS [s]
        ON [t].[ObjectType_ID] = [s].[ObjectType_ID]
           AND [t].[Class_ID] = [s].[Class_ID]
           AND [t].[ObjID] = [s].[ObjID]
           AND [t].[MFVersion] = [s].[MFVersion]
           AND [t].[Property_ID] = [s].[Property_ID]
        WHEN MATCHED THEN
        UPDATE SET 
		[t].[LastModifiedUtc] = dbo.[fnMFTextToDate](s.[LastModifiedUTC],'/')
		,[t].[Property_Value] = s.[Property_Value]
		WHEN NOT MATCHED BY TARGET THEN
            INSERT
            (
                [ObjectType_ID]
               ,[Class_ID]
               ,[ObjID]
               ,[MFVersion]
               ,[LastModifiedUtc]
               ,[MFLastModifiedBy_ID]
               ,[Property_ID]
               ,[Property_Value]
               ,[CreatedOn]
            )
            VALUES
            (   [s].[ObjectType_ID], [s].[Class_ID], [s].[ObjID], [s].[MFVersion]
               ,dbo.[fnMFTextToDate](s.[LastModifiedUTC],'/'), [s].[MFLastModifiedBy_ID], [s].[Property_ID]
               ,[s].[Property_Value], [s].[CreatedOn]);

        -------------------------------------------------------------
        -- Delete duplicate change records
        -------------------------------------------------------------
        DELETE [dbo].[MFObjectChangeHistory]
        WHERE [ID] IN (
                          SELECT [toh].[ID]
                          FROM [#Temp_ObjectHistory]                   AS [toh2]
                              INNER JOIN [dbo].[MFObjectChangeHistory] AS [toh]
                                  ON [toh].[ObjID] = [toh2].[ObjID]
                                     AND [toh].[Class_ID] = [toh2].[Class_ID]
                                     AND [toh].[Property_ID] = [toh2].[Property_ID]
                                     AND [toh].[MFVersion] = [toh2].[MFVersion]
                              INNER JOIN [dbo].[MFObjectChangeHistory] AS [moch]
                                  ON [toh].[ObjID] = [moch].[ObjID]
                                     AND [toh].[Class_ID] = [moch].[Class_ID]
                                     AND [toh].[Property_ID] = [moch].[Property_ID]
                                     AND [toh].[Property_Value] = [moch].[Property_Value]
                          WHERE [toh].[MFVersion] = [moch].[MFVersion] + 1
                      );

        SET @rowcount =
        (
            SELECT COUNT(*) FROM [dbo].[MFObjectChangeHistory] AS [moch]
        ) - @BeforeCount;
        -------------------------------------------------------------
        -- Reset process_ID
        -------------------------------------------------------------
        SET @VQuery = N'
					UPDATE ' + @MFTableName + '
					SET Process_ID = 0 WHERE process_ID = ' + CAST(@Process_id AS VARCHAR(5)) + '';

        EXEC (@VQuery);

        --truncate table MFObjectChangeHistory
        IF (SELECT OBJECT_ID('tempdb..#Temp_ObjectHistory')) IS NOT NULL
        DROP TABLE [#Temp_ObjectHistory];
         IF (SELECT OBJECT_ID('tempdb..#TempObjIDs')) IS NOT NULL
        DROP TABLE #TempObjids;

        SET @ProcessType = @ProcedureName;
        SET @LogText = @ProcedureName + ' Ended ';
        SET @LogStatus = 'Completed';
        SET @StartTime = GETUTCDATE();

        EXECUTE @RC = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id
                                                     ,@ProcessType = @ProcessType
                                                     ,@LogType = @LogType
                                                     ,@LogText = @LogText
                                                     ,@LogStatus = @LogStatus
                                                     ,@debug = @Debug;

        SET @LogTypeDetail = 'Message';
        SET @LogTextDetail = 'History inserted in MFObjectChangeHistory';
        SET @LogStatusDetail = 'Completed';
        SET @Validation_ID = NULL;
        SET @LogColumnValue = 'New History';
        SET @LogColumnValue = CAST(@rowcount AS VARCHAR(5));

        EXECUTE @RC = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                           ,@LogType = @LogTypeDetail
                                                           ,@LogText = @LogTextDetail
                                                           ,@LogStatus = @LogStatusDetail
                                                           ,@StartTime = @StartTime
                                                           ,@MFTableName = @MFTableName
                                                           ,@Validation_ID = @Validation_ID
                                                           ,@ColumnName = @LogColumnName
                                                           ,@ColumnValue = @LogColumnValue
                                                           ,@Update_ID = @Update_ID
                                                           ,@LogProcedureName = @ProcedureName
                                                           ,@LogProcedureStep = @ProcedureStep
                                                           ,@debug = @Debug;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = @Debug;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;
GO

GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFAddCommentForObjects]';
GO

SET NOCOUNT ON;

EXEC setup.spMFSQLObjectsControl @SchemaName = N'dbo',
                                 @ObjectName = N'spMFAddCommentForObjects',
                                 -- nvarchar(100)
                                 @Object_Release = '3.1.5.41',
                                 -- varchar(50)
                                 @UpdateFlag = 2;
-- smallint
GO

/*
MODIFICATIONS

*/

IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_NAME = 'spMFAddCommentForObjects' --name of procedure
          AND ROUTINE_TYPE = 'PROCEDURE' --for a function --'FUNCTION'
          AND ROUTINE_SCHEMA = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE dbo.spMFAddCommentForObjects
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO


ALTER PROCEDURE dbo.spMFAddCommentForObjects
    @MFTableName NVARCHAR(250) = 'MFPicture',
    @Process_id INT = 1,
    @Comment NVARCHAR(1000),
    @Debug SMALLINT = 0
AS
/*rST**************************************************************************

========================
spMFAddCommentForObjects
========================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MFTableName nvarchar(250)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @Process\_id int
    process id of the object(s) to add the comment to
  @Comment nvarchar(1000)
    the text of the comment
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

Add a new comment to an object, or objects using SQL with the procedure spMFAddCommentsForObjects.

Additional Info
===============

Set the process_ID for the selected objects before executing the procedure.
Use spGetHistory procedure to access the history of comments of an object in SQL

Warnings
========

Adding a comment is a separate process from making a change to the object. The two processes must run one after the other rather than simultaneously
The same comment will be applied to all the selected objects.

Examples
========

.. code:: sql

    UPDATE [dbo].[MFCustomer]
    SET process_id = 5
    WHERE id IN (1,3,6,9)
    DECLARE @Comment NVARCHAR(100)
    SET @Comment = 'Added a comment for illustration '
    EXEC [dbo].[spMFAddCommentForObjects]
        @MFTableName = 'MFCustomer',
        @Process_id = 5,
        @Comment = @Comment ,
        @Debug = 0

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN


    BEGIN TRY
        DECLARE @Update_ID INT,
                @ProcessBatch_ID INT,
                @return_value INT = 1;


        DECLARE @Id INT,
                @UpdateMethod INT = 0,
                @objID INT,
                @ObjectIdRef INT,
                @ObjVersion INT,
                @VaultSettings NVARCHAR(4000),
                @TableName NVARCHAR(1000),
                @XmlOUT NVARCHAR(MAX),
                @NewObjectXml NVARCHAR(MAX),
                @ObjIDsForUpdate NVARCHAR(MAX),
                @FullXml XML,
                @SynchErrorObj NVARCHAR(MAX),  --Declared new paramater
                @DeletedObjects NVARCHAR(MAX), --Declared new paramater
                @ProcedureName sysname = 'spmfAddCommentForObjects',
                @ProcedureStep sysname = 'Start',
                @ObjectId INT,
                @ClassId INT,
                @Table_ID INT,
                @ErrorInfo NVARCHAR(MAX),
                @Query NVARCHAR(MAX),
                @Params NVARCHAR(MAX),
                @SynchErrCount INT,
                @ErrorInfoCount INT,
                @MFErrorUpdateQuery NVARCHAR(1500),
                @MFIDs NVARCHAR(2500) = '',
                @ExternalID NVARCHAR(120);

        -----------------------------------------------------
        --DECLARE VARIABLES FOR LOGGING
        -----------------------------------------------------
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogTypeDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @ProcessType NVARCHAR(50);
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = '';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @Status AS NVARCHAR(128) = NULL;
        DECLARE @Validation_ID INT = NULL;
        DECLARE @StartTime AS DATETIME;
        DECLARE @RunTime AS DECIMAL(18, 4) = 0;


        IF EXISTS
        (
            SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[' + @MFTableName + ']')
                  AND type IN ( N'U' )
        )
        BEGIN
            -----------------------------------------------------
            --GET LOGIN CREDENTIALS
            -----------------------------------------------------
            SET @ProcedureStep = 'Get Security Variables';

            DECLARE @Username NVARCHAR(2000);
            DECLARE @VaultName NVARCHAR(2000);

            SELECT TOP 1
                   @Username = Username,
                   @VaultName = VaultName
            FROM dbo.MFVaultSettings;

            SELECT @VaultSettings = dbo.FnMFVaultSettings();

            IF @Debug > 9
            BEGIN
                RAISERROR('Proc: %s Step: %s Vault: %s', 10, 1, @ProcedureName, @ProcedureStep, @VaultName);

                SELECT @VaultSettings;
            END;

            SET @StartTime = GETUTCDATE();
            /*
	Create ids for process start
	*/
            SET @ProcedureStep = 'Get Update_ID';

            SELECT @ProcessType = CASE
                                      WHEN @UpdateMethod = 0 THEN
                                          'UpdateMFiles'
                                      ELSE
                                          'UpdateSQL'
                                  END;

            INSERT INTO dbo.MFUpdateHistory
            (
                Username,
                VaultName,
                UpdateMethod
            )
            VALUES
            (@Username, @VaultName, -1);

            SELECT @Update_ID = @@IDENTITY;




            IF @Debug > 9
            BEGIN
                SET @DebugText = @DefaultDebugText + 'ProcessBatch_ID %i: Update_ID %i';
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ProcessBatch_ID, @Update_ID);
            END;

            SET @ProcedureStep = 'Start ProcessBatch';
            SET @StartTime = GETUTCDATE();
            SET @ProcessType = @ProcedureName;
            SET @LogType = 'Status';
            SET @LogStatus = 'Started';
            SET @LogText = 'Update using Update_ID: ' + CAST(@Update_ID AS VARCHAR(10));

            EXECUTE @return_value = dbo.spMFProcessBatch_Upsert @ProcessBatch_ID = @ProcessBatch_ID OUTPUT,
                                                                @ProcessType = @ProcessType,
                                                                @LogType = @LogType,
                                                                @LogText = @LogText,
                                                                @LogStatus = @LogStatus,
                                                                @debug = @Debug;

            IF @Debug > 9
            BEGIN
                SET @DebugText = @DefaultDebugText;
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
            END;

            -----------------------------------------------------
            --Determine if any filter have been applied
            --if no filters applied then full refresh, else apply filters
            -----------------------------------------------------
            DECLARE @IsFullUpdate BIT;


            -----------------------------------------------------
            --Convert @UserId to UNIQUEIDENTIFIER type
            -----------------------------------------------------
            --SET @UserId = CONVERT(UNIQUEIDENTIFIER, @UserId);
            -----------------------------------------------------
            --To Get Table_ID 
            -----------------------------------------------------
            SET @ProcedureStep = 'Get Table ID';
            SET @TableName = @MFTableName;
            SET @TableName = REPLACE(@TableName, '_', ' ');

            SELECT @Table_ID = object_id
            FROM sys.objects
            WHERE name = @TableName;

            IF @Debug > 9
            BEGIN
                SET @DebugText = @DefaultDebugText + 'Table: %s';
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @TableName);
            END;

            -----------------------------------------------------
            --Set Object Type Id
            -----------------------------------------------------
            SET @ProcedureStep = 'Get Object Type and Class';

            SELECT @ObjectIdRef = MFObjectType_ID
            FROM dbo.MFClass
            WHERE TableName = @MFTableName; --SUBSTRING(@TableName, 3, LEN(@TableName))

            SELECT @ObjectId = MFID
            FROM dbo.MFObjectType
            WHERE ID = @ObjectIdRef;

            IF @Debug > 9
            BEGIN
                SET @DebugText = @DefaultDebugText + 'ObjectType: %i';
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjectId);
            END;

            -----------------------------------------------------
            --Set class id
            -----------------------------------------------------
            SELECT @ClassId = MFID
            FROM dbo.MFClass
            WHERE TableName = @MFTableName; --SUBSTRING(@TableName, 3, LEN(@TableName))

            IF @Debug > 9
            BEGIN
                SET @DebugText = @DefaultDebugText + 'Class: %i';
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ClassId);
            END;

            SET @ProcedureStep = 'Prepare Table';
            SET @LogTypeDetail = 'Status';
            SET @LogStatusDetail = 'Start';
            SET @LogTextDetail = 'For UpdateMethod ' + CAST(@UpdateMethod AS VARCHAR(10));
            SET @LogColumnName = '';
            SET @LogColumnValue = '';

            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;


            SELECT @MFIDs = @MFIDs + CAST(ISNULL(MFP.MFID, '') AS NVARCHAR(10)) + ','
            FROM INFORMATION_SCHEMA.COLUMNS CLM
                LEFT JOIN dbo.MFProperty MFP
                    ON MFP.ColumnName = CLM.COLUMN_NAME
            WHERE CLM.TABLE_NAME = @MFTableName;

            SELECT @MFIDs = LEFT(@MFIDs, LEN(@MFIDs) - 1); -- Remove last ','


            --    IF @UpdateMethod = 0 --- processing of process_ID = 1
            BEGIN

                DECLARE @Count NVARCHAR(10),
                        @SelectQuery NVARCHAR(MAX),
                        @ParmDefinition NVARCHAR(500);

                SET @SelectQuery
                    = 'SELECT @retvalOUT  = COUNT(ID) FROM [' + @MFTableName + '] WHERE Process_ID = '
                      + CAST(@Process_id AS NVARCHAR(20)) + ' AND Deleted = 0';






            END;

            SET @ParmDefinition = N'@retvalOUT int OUTPUT';

            --IF @Debug > 9

            EXEC sys.sp_executesql @SelectQuery,
                                   @ParmDefinition,
                                   @retvalOUT = @Count OUTPUT;


            BEGIN
                DECLARE @ClassPropName NVARCHAR(100);
                SELECT @ClassPropName = mp.ColumnName
                FROM dbo.MFProperty AS mp
                WHERE mp.MFID = 100;

                SET @Params = N'@ClassID int';
                SET @Query
                    = N'UPDATE t
					SET t.' + @ClassPropName + ' = @ClassId
					FROM ' + QUOTENAME(@MFTableName) + ' t WHERE t.process_ID = ' + CAST(@Process_id AS NVARCHAR(20))
                      + ' AND (' + @ClassPropName + ' IS NULL or ' + @ClassPropName + '= -1) AND t.Deleted = 0';

                EXEC sys.sp_executesql @stmt = @Query,
                                       @Param = @Params,
                                       @Classid = @ClassId;
            END;






            ----------------------------------------------------------------------------------------------------------
            --If Any record Updated/Insert in SQL and @UpdateMethod = 0(0=Update from SQL to MF only)
            ----------------------------------------------------------------------------------------------------------
            --SET @StartTime = GETUTCDATE();

            IF (@Count > 0 AND @UpdateMethod != 1)
            BEGIN
                DECLARE @GetDetailsCursor AS CURSOR;
                DECLARE @CursorQuery NVARCHAR(200),
                        @vsql AS NVARCHAR(MAX),
                        @vquery AS NVARCHAR(MAX);

                --SET @ProcedureStep = 'Cursor Condition';
                -----------------------------------------------------
                --Creating Dynamic CURSOR With input Table name
                -----------------------------------------------------

                SET @vquery
                    = 'SELECT ID,ObjID,MFVersion,ExternalID from [' + @MFTableName + '] WHERE Process_ID = '
                      + CAST(@Process_id AS NVARCHAR(20)) + ' AND Deleted = 0';




                --IF ( @ObjIDs IS NOT NULL )
                --                                             BEGIN
                --                                                   SET @vquery = @vquery
                --                                                      + ' AND ObjID in (SELECT * FROM dbo.fnMFSplitString('''
                --                                                       + @ObjIDs + ','','',''))';
                --                                             END;


                SET @vsql = 'SET @cursor = cursor forward_only static FOR ' + @vquery + ' OPEN @cursor;';

                --                                      

                EXEC sys.sp_executesql @vsql,
                                       N'@cursor cursor output',
                                       @GetDetailsCursor OUTPUT;

                -- SET @ProcedureStep = 'Fetch next';

                -----------------------------------------------------
                --CURSOR
                -----------------------------------------------------
                FETCH NEXT FROM @GetDetailsCursor
                INTO @Id,
                     @objID,
                     @ObjVersion,
                     @ExternalID;

                WHILE (@@FETCH_STATUS = 0)
                BEGIN
                    DECLARE @ColumnValuePair TABLE
                    (
                        ColunmName NVARCHAR(200),
                        ColumnValue NVARCHAR(4000)
                    );
                    DECLARE @TableWhereClause VARCHAR(1000),
                            @tempTableName VARCHAR(1000),
                            @XMLFile XML;

                    SET @ProcedureStep = 'Convert Values to Column Value Table';
                    SET @TableWhereClause = 'y.ID=' + CONVERT(NVARCHAR(100), @Id);

                    ----------------------------------------------------------------------------------------------------------
                    --Generate query to get column values as row value
                    ----------------------------------------------------------------------------------------------------------
                    SELECT @Query
                        = STUFF(
                          (
                              SELECT ' UNION ' + 'SELECT ''' + COLUMN_NAME + ''' as name, CONVERT(VARCHAR(max),['
                                     + COLUMN_NAME + ']) as value FROM [' + @MFTableName + '] y'
                                     + ISNULL('  WHERE ' + @TableWhereClause, '')
                              FROM INFORMATION_SCHEMA.COLUMNS
                              WHERE TABLE_NAME = @MFTableName
                              FOR XML PATH('')
                          ),
                          1,
                          7,
                          ''
                               );
                    -----------------------------------------------------
                    --List of columns to exclude
                    -----------------------------------------------------
                    DECLARE @ExcludeList AS TABLE
                    (
                        ColumnName VARCHAR(100)
                    );
                    INSERT INTO @ExcludeList
                    (
                        ColumnName
                    )
                    SELECT mp.ColumnName
                    FROM dbo.MFProperty AS mp
                    WHERE mp.MFID IN ( 20, 21, 23, 25 ); --Last Modified, Last Modified by, Created, Created by


                    -----------------------------------------------------
                    --Insert to values INTo temp table
                    -----------------------------------------------------
                    INSERT INTO @ColumnValuePair
                    EXEC (@Query);

                    DELETE FROM @ColumnValuePair
                    WHERE ColunmName IN (
                                            SELECT el.ColumnName FROM @ExcludeList AS el
                                        );

                    SET @ProcedureStep = 'Delete Blank Columns';



                    UPDATE cp
                    SET cp.ColumnValue = CONVERT(DATE, CAST(cp.ColumnValue AS NVARCHAR(100)))
                    FROM @ColumnValuePair cp
                        INNER JOIN INFORMATION_SCHEMA.COLUMNS AS c
                            ON c.COLUMN_NAME = cp.ColunmName
                    WHERE c.DATA_TYPE = 'datetime'
                          AND cp.ColumnValue IS NOT NULL;


                    INSERT INTO @ColumnValuePair
                    (
                        ColunmName,
                        ColumnValue
                    )
                    VALUES
                    ('Comment', @Comment);

                    SET @ProcedureStep = 'Creating XML for Process_ID = 1';
                    -----------------------------------------------------
                    --Generate xml file -- 
                    -----------------------------------------------------
                    SET @XMLFile =
                    (
                        SELECT @ObjectId AS 'Object/@id',
                               @Id AS 'Object/@sqlID',
                               @objID AS 'Object/@objID',
                               @ObjVersion AS 'Object/@objVesrion',
                               @ExternalID AS 'Object/@DisplayID', --Added For Task #988



                               (
                                   SELECT
                                       (
                                           SELECT TOP 1
                                                  tmp.ColumnValue
                                           FROM @ColumnValuePair tmp
                                               INNER JOIN dbo.MFProperty mfp
                                                   ON mfp.ColumnName = tmp.ColunmName
                                           WHERE mfp.MFID = 100
                                       ) AS 'class/@id',
                                       (
                                           SELECT mfp.MFID AS 'property/@id',
                                                  (
                                                      SELECT MFTypeID FROM dbo.MFDataType WHERE ID = mfp.MFDataType_ID
                                                  ) AS 'property/@dataType',
                                                  tmp.ColumnValue AS 'property'
                                           FROM @ColumnValuePair tmp
                                               INNER JOIN dbo.MFProperty mfp
                                                   ON mfp.ColumnName = tmp.ColunmName
                                           WHERE mfp.MFID <> 100
                                                 AND tmp.ColumnValue IS NOT NULL --- excluding duplicate class


                                           FOR XML PATH(''), TYPE
                                       ) AS 'class'
                                   FOR XML PATH(''), TYPE
                               ) AS 'Object'
                        FOR XML PATH(''), ROOT('form')
                    );
                    SET @XMLFile =
                    (
                        SELECT @XMLFile.query('/form/*')
                    );



                    DELETE FROM @ColumnValuePair
                    WHERE ColunmName IS NOT NULL;



                    --------------------------------------------------------------------------------------------------


                    SET @FullXml
                        = ISNULL(CAST(@FullXml AS NVARCHAR(MAX)), '') + ISNULL(CAST(@XMLFile AS NVARCHAR(MAX)), '');

                    FETCH NEXT FROM @GetDetailsCursor
                    INTO @Id,
                         @objID,
                         @ObjVersion,
                         @ExternalID;
                END;

                CLOSE @GetDetailsCursor;

                DEALLOCATE @GetDetailsCursor;
            END;

            DECLARE @XML NVARCHAR(MAX);

            SET @ProcedureStep = 'Get Full Xml';



            -----------------------------------------------------
            --IF Null Creating XML with ObjectTypeID and ClassId
            -----------------------------------------------------
            IF (@FullXml IS NULL)
            BEGIN
                SET @FullXml =
                (
                    SELECT @ObjectId AS 'Object/@id',
                           @Id AS 'Object/@sqlID',
                           @objID AS 'Object/@objID',
                           @ObjVersion AS 'Object/@objVesrion',
                           @ExternalID AS 'Object/@DisplayID', --Added for Task #988
                           (
                               SELECT @ClassId AS 'class/@id' FOR XML PATH(''), TYPE
                           ) AS 'Object'
                    FOR XML PATH(''), ROOT('form')
                );
                SET @FullXml =
                (
                    SELECT @FullXml.query('/form/*')
                );
            END;


            SET @XML = '<form>' + (CAST(@FullXml AS NVARCHAR(MAX))) + '</form>';


            UPDATE dbo.MFUpdateHistory
            SET ObjectDetails = @XML
            --,[MFUpdateHistory].[ObjectVerDetails] = @ObjVerXmlString
            WHERE Id = @Update_ID;


			-----------------------------------------------------------------
	           -- Checking module access for CLR procdure  spMFGetObjectType
            ------------------------------------------------------------------
              EXEC [dbo].[spMFCheckLicenseStatus] 
			       'spMFCreateObjectInternal'
				   ,@ProcedureName
				   ,@ProcedureStep



            --------------------------------------------------------------------
            --create XML if @UpdateMethod !=0 (0=Update from SQL to MF only)
            -----------------------------------------------------
            SET @StartTime = GETUTCDATE();

            EXECUTE @return_value = dbo.spMFCreateObjectInternal @VaultSettings,
                                                                 @XML,
                                                                 NULL,
                                                                 @MFIDs,
                                                                 0,
                                                                 NULL,
                                                                 @ObjIDsForUpdate,
                                                                 @XmlOUT OUTPUT,
                                                                 @NewObjectXml OUTPUT,
                                                                 @SynchErrorObj OUTPUT,  --Added new paramater
                                                                 @DeletedObjects OUTPUT, --Added new paramater
                                                                 @ErrorInfo OUTPUT;

            --select @XmlOUT as '@XmlOUT'
            --select @NewObjectXml as '@NewObjectXml'
            --                  select @SynchErrorObj as '@SynchErrorObj' --Added new paramater
            --                  select @DeletedObjects as '@DeletedObjects' --Added new paramater
            --                  select @ErrorInfo as '@ErrorInfo';


            -- select  @XmlOUT 
            --                  select @NewObjectXml 
            IF @Debug > 10
            BEGIN
                RAISERROR('Proc: %s Step: %s ErrorInfo %s ', 10, 1, @ProcedureName, @ProcedureStep, @ErrorInfo);
            END;



            IF (@Update_ID > 0)
                UPDATE dbo.MFUpdateHistory
                SET NewOrUpdatedObjectVer = @XmlOUT,
                    NewOrUpdatedObjectDetails = @NewObjectXml,
                    SynchronizationError = @SynchErrorObj,
                    DeletedObjectVer = @DeletedObjects,
                    MFError = @ErrorInfo
                WHERE Id = @Update_ID;

            DECLARE @NewOrUpdatedObjectDetails_Count INT,
                    @NewOrUpdateObjectXml XML;

            SET @NewOrUpdateObjectXml = CAST(@NewObjectXml AS XML);

            SELECT @NewOrUpdatedObjectDetails_Count = COUNT(o.objectid)
            FROM
            (
                SELECT t1.c1.value('(@objectId)[1]', 'INT') objectid
                FROM @NewOrUpdateObjectXml.nodes('/form/Object') AS t1(c1)
            ) AS o;



            SET @LogTypeDetail = 'Debug';
            SET @LogTextDetail = 'XML ObjDetails returned';
            SET @LogStatusDetail = 'Output';
            SET @Validation_ID = NULL;
            SET @LogColumnValue = CAST(@NewOrUpdatedObjectDetails_Count AS VARCHAR(10));
            SET @LogColumnName = 'MFUpdateHistory: NewOrUpdatedObjectDetails';


            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;


            DECLARE @NewOrUpdatedObjectVer_Count INT,
                    @NewOrUpdateObjectVerXml XML;

            SET @NewOrUpdateObjectVerXml = CAST(@XmlOUT AS XML);

            SELECT @NewOrUpdatedObjectVer_Count = COUNT(o.objectid)
            FROM
            (
                SELECT t1.c1.value('(@objectId)[1]', 'INT') objectid
                FROM @NewOrUpdateObjectVerXml.nodes('/form/Object') AS t1(c1)
            ) AS o;




            SET @LogTypeDetail = 'Debug';
            SET @LogTextDetail = 'ObjVer returned';
            SET @LogStatusDetail = 'Output';
            SET @Validation_ID = NULL;
            SET @LogColumnValue = CAST(@NewOrUpdatedObjectVer_Count AS VARCHAR(10));
            SET @LogColumnName = 'NewOrUpdatedObjectVer';


            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;



            DECLARE @IDoc INT;

            SET @ProcedureName = 'spMFAddCommentForObjects';
            SET @ProcedureStep = 'Updating MFTable with ObjID and MFVersion';
            SET @StartTime = GETUTCDATE();

            CREATE TABLE #ObjVer
            (
                ID INT,
                ObjID INT,
                MFVersion INT,
                GUID NVARCHAR(100),
                FileCount INT ---- Added for task 106
            );

            DECLARE @NewXML XML;

            SET @NewXML = CAST(@XmlOUT AS XML);

            DECLARE @NewObjVerDetails_Count INT;

            SELECT @NewObjVerDetails_Count = COUNT(o.objectid)
            FROM
            (
                SELECT t1.c1.value('(@objectId)[1]', 'INT') objectid
                FROM @NewXML.nodes('/form/Object') AS t1(c1)
            ) AS o;

            INSERT INTO #ObjVer
            (
                MFVersion,
                ObjID,
                ID,
                GUID,
                FileCount
            )
            SELECT t.c.value('(@objVersion)[1]', 'INT') AS MFVersion,
                   t.c.value('(@objectId)[1]', 'INT') AS ObjID,
                   t.c.value('(@ID)[1]', 'INT') AS ID,
                   t.c.value('(@objectGUID)[1]', 'NVARCHAR(100)') AS GUID,
                   t.c.value('(@FileCount)[1]', 'INT') AS FileCount -- Added for task 106
            FROM @NewXML.nodes('/form/Object') AS t(c);

            SET @Count = @@ROWCOUNT;

            IF @Debug > 9
            BEGIN
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

                IF @Debug > 10
                    SELECT *
                    FROM #ObjVer;
            END;

            DECLARE @UpdateQuery NVARCHAR(MAX);

            SET @UpdateQuery
                = '	UPDATE ['    + @MFTableName + ']
					SET ['     + @MFTableName + '].ObjID = #ObjVer.ObjID
					,['        + @MFTableName + '].MFVersion = #ObjVer.MFVersion
					,['        + @MFTableName + '].GUID = #ObjVer.GUID
					,['        + @MFTableName
                  + '].FileCount = #ObjVer.FileCount     ---- Added for task 106
					,Process_ID = 0
					,Deleted = 0
					,LastModified = GETDATE()
					FROM #ObjVer
					WHERE ['   + @MFTableName + '].ID = #ObjVer.ID';

            EXEC (@UpdateQuery);
            SET @ProcedureStep = 'Update Records in ' + @MFTableName + '';

            SET @LogTextDetail = @ProcedureStep;
            SET @LogStatusDetail = 'Output';
            SET @Validation_ID = NULL;
            SET @LogColumnName = 'NewObjVerDetails';
            SET @LogColumnValue = CAST(@NewObjVerDetails_Count AS VARCHAR(10));

            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;


            DROP TABLE #ObjVer;

            ----------------------------------------------------------------------------------------------------------
            --Update Process_ID to 2 when synch error occcurs--
            ----------------------------------------------------------------------------------------------------------
            SET @ProcedureStep = 'Updating MFTable with Process_ID = 2,if any synch error occurs';
            SET @StartTime = GETUTCDATE();

            ----------------------------------------------------------------------------------------------------------
            --Create an internal representation of the XML document. 
            ---------------------------------------------------------------------------------------------------------                
            CREATE TABLE #SynchErrObjVer
            (
                ID INT,
                ObjID INT,
                MFVersion INT
            );

            IF @Debug > 9
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

            -----------------------------------------------------
            ----Inserting the Xml details into temp Table
            -----------------------------------------------------
            DECLARE @SynchErrorXML XML;

            SET @SynchErrorXML = CAST(@SynchErrorObj AS XML);

            INSERT INTO #SynchErrObjVer
            (
                MFVersion,
                ObjID,
                ID
            )
            SELECT t.c.value('(@objVersion)[1]', 'INT') AS MFVersion,
                   t.c.value('(@objectId)[1]', 'INT') AS ObjID,
                   t.c.value('(@ID)[1]', 'INT') AS ID
            FROM @SynchErrorXML.nodes('/form/Object') AS t(c);

            SELECT @SynchErrCount = COUNT(*)
            FROM #SynchErrObjVer;

            IF @SynchErrCount > 0
            BEGIN
                IF @Debug > 9
                BEGIN
                    RAISERROR(
                                 'Proc: %s Step: %s SyncronisationErrors %i ',
                                 10,
                                 1,
                                 @ProcedureName,
                                 @ProcedureStep,
                                 @SynchErrCount
                             );

                    PRINT 'Synchronisation error';

                    IF @Debug > 10
                        SELECT *
                        FROM #SynchErrObjVer;
                END;

                SET @ProcedureStep = 'Syncronisation Errors ';
                SET @LogTypeDetail = 'User';
                SET @LogTextDetail = @ProcedureStep + ' in ' + @MFTableName + '';
                SET @LogStatusDetail = 'Error';
                SET @Validation_ID = 2;
                SET @LogColumnName = 'Count of errors';
                SET @LogColumnValue = ISNULL(CAST(@SynchErrCount AS VARCHAR(10)), 0);

                EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                          @LogType = @LogTypeDetail,
                                                                          @LogText = @LogTextDetail,
                                                                          @LogStatus = @LogStatusDetail,
                                                                          @StartTime = @StartTime,
                                                                          @MFTableName = @MFTableName,
                                                                          @Validation_ID = @Validation_ID,
                                                                          @ColumnName = @LogColumnName,
                                                                          @ColumnValue = @LogColumnValue,
                                                                          @Update_ID = @Update_ID,
                                                                          @LogProcedureName = @ProcedureName,
                                                                          @LogProcedureStep = @ProcedureStep,
                                                                          @debug = @Debug;


                -------------------------------------------------------------------------------------
                -- UPDATE THE SYNCHRONIZE ERROR
                -------------------------------------------------------------------------------------
                DECLARE @SynchErrUpdateQuery NVARCHAR(MAX);

                SET @SynchErrUpdateQuery
                    = '	UPDATE ['    + @MFTableName + ']
					SET ['                 + @MFTableName + '].ObjID = #SynchErrObjVer.ObjID	,[' + @MFTableName
                      + '].MFVersion = #SynchErrObjVer.MFVersion
					,Process_ID = 2
					,LastModified = GETDATE()
					,Update_ID = '         + CAST(@Update_ID AS VARCHAR(15))
                      + '
					FROM #SynchErrObjVer
					WHERE ['               + @MFTableName + '].ID = #SynchErrObjVer.ID';

                EXEC (@SynchErrUpdateQuery);

                ------------------------------------------------------
                -- LOGGING THE ERROR
                ------------------------------------------------------
                SELECT @ProcedureStep = 'Update MFUpdateLog for Sync error objects';

                IF @Debug > 9
                    RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

                ----------------------------------------------------------------
                --Inserting Synch Error Details into MFLog
                ----------------------------------------------------------------
                INSERT INTO dbo.MFLog
                (
                    ErrorMessage,
                    Update_ID,
                    ErrorProcedure,
                    ExternalID,
                    ProcedureStep,
                    SPName
                )
                SELECT *
                FROM
                (
                    SELECT 'Synchronization error occured while updating ObjID : ' + CAST(ObjID AS NVARCHAR(10))
                           + ' Version : ' + CAST(MFVersion AS NVARCHAR(10)) + '' AS ErrorMessage,
                           @Update_ID AS Update_ID,
                           @TableName AS ErrorProcedure,
                           '' AS ExternalID,
                           'Synchronization Error' AS ProcedureStep,
                           'spMFUpdateTable' AS SPName
                    FROM #SynchErrObjVer
                ) vl;
            END;

            DROP TABLE #SynchErrObjVer;

            IF @Debug > 9
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

            -------------------------------------------------------------
            --Logging error details
            -------------------------------------------------------------
            CREATE TABLE #ErrorInfo
            (
                ObjID INT,
                SqlID INT,
                ExternalID NVARCHAR(100),
                ErrorMessage NVARCHAR(MAX)
            );

            SELECT @ProcedureStep = 'Updating MFTable with ObjID and MFVersion';

            DECLARE @ErrorInfoXML XML;

            SELECT @ErrorInfoXML = CAST(@ErrorInfo AS XML);

            INSERT INTO #ErrorInfo
            (
                ObjID,
                SqlID,
                ExternalID,
                ErrorMessage
            )
            SELECT t.c.value('(@objID)[1]', 'INT') AS objID,
                   t.c.value('(@sqlID)[1]', 'INT') AS SqlID,
                   t.c.value('(@externalID)[1]', 'NVARCHAR(100)') AS ExternalID,
                   t.c.value('(@ErrorMessage)[1]', 'NVARCHAR(MAX)') AS ErrorMessage
            FROM @ErrorInfoXML.nodes('/form/errorInfo') AS t(c);

            SELECT @ErrorInfoCount = COUNT(*)
            FROM #ErrorInfo;



            IF @ErrorInfoCount > 0
            BEGIN
                IF @Debug > 10
                BEGIN
                    SELECT *
                    FROM #ErrorInfo;
                END;

                SELECT @MFErrorUpdateQuery
                    = 'UPDATE [' + @MFTableName
                      + ']
									   SET Process_ID = 3
									   FROM #ErrorInfo err
									   WHERE err.SqlID = [' + @MFTableName + '].ID';

                EXEC (@MFErrorUpdateQuery);

                SET @ProcedureStep = 'M-Files Errors ';
                SET @LogTypeDetail = 'User';
                SET @LogTextDetail = @ProcedureStep + ' in ' + @MFTableName + '';
                SET @LogStatusDetail = 'Error';
                SET @Validation_ID = 3;
                SET @LogColumnName = 'Count of errors';
                SET @LogColumnValue = ISNULL(CAST(@ErrorInfoCount AS VARCHAR(10)), 0);

                EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                          @LogType = @LogTypeDetail,
                                                                          @LogText = @LogTextDetail,
                                                                          @LogStatus = @LogStatusDetail,
                                                                          @StartTime = @StartTime,
                                                                          @MFTableName = @MFTableName,
                                                                          @Validation_ID = @Validation_ID,
                                                                          @ColumnName = @LogColumnName,
                                                                          @ColumnValue = @LogColumnValue,
                                                                          @Update_ID = @Update_ID,
                                                                          @LogProcedureName = @ProcedureName,
                                                                          @LogProcedureStep = @ProcedureStep,
                                                                          @debug = @Debug;


                INSERT INTO dbo.MFLog
                (
                    ErrorMessage,
                    Update_ID,
                    ErrorProcedure,
                    ExternalID,
                    ProcedureStep,
                    SPName
                )
                SELECT 'ObjID : ' + CAST(ISNULL(ObjID, '') AS NVARCHAR(100)) + ',' + 'SQL ID : '
                       + CAST(ISNULL(SqlID, '') AS NVARCHAR(100)) + ',' + ErrorMessage AS ErrorMessage,
                       @Update_ID,
                       @TableName AS ErrorProcedure,
                       ExternalID,
                       'Error While inserting/Updating in M-Files' AS ProcedureStep,
                       'spMFUpdateTable' AS spname
                FROM #ErrorInfo;
            END;

            DROP TABLE #ErrorInfo;

            IF @Debug > 9
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);


            SET @ProcedureStep = 'Updating MFTable with deleted = 1,if object is deleted from MFiles';
            -------------------------------------------------------------------------------------
            --Update deleted column if record is deleled from M Files
            ------------------------------------------------------------------------------------               
            SET @StartTime = GETUTCDATE();

            CREATE TABLE #DeletedRecordId
            (
                ID INT
            );

            --INSERT INTO #DeletedRecordId
            DECLARE @DeletedXML XML;

            SET @DeletedXML = CAST(@DeletedObjects AS XML);

            INSERT INTO #DeletedRecordId
            (
                ID
            )
            SELECT t.c.value('(@objectID)[1]', 'INT') AS ID
            FROM @DeletedXML.nodes('/form/objVers') AS t(c);

            SET @Count = @@ROWCOUNT;

            IF @Debug > 9
            BEGIN
                RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

                IF @Debug > 10
                    SELECT *
                    FROM #DeletedRecordId;
            END;

            -------------------------------------------------------------------------------------
            --UPDATE THE DELETED RECORD 
            -------------------------------------------------------------------------------------
            DECLARE @DeletedRecordQuery NVARCHAR(MAX);

            SET @DeletedRecordQuery
                = '	UPDATE [' + @MFTableName + ']
											SET [' + @MFTableName
                  + '].Deleted = 1					
												,Process_ID = 0
												,LastModified = GETDATE()
											FROM #DeletedRecordId
											WHERE [' + @MFTableName + '].ObjID = #DeletedRecordId.ID';

            --select @DeletedRecordQuery
            EXEC (@DeletedRecordQuery);

            SET @ProcedureStep = 'Deleted records';
            SET @LogTypeDetail = 'Debug';
            SET @LogTextDetail = 'In ' + @MFTableName + '';
            SET @LogStatusDetail = 'Output';
            SET @Validation_ID = NULL;
            SET @LogColumnName = 'Count of deletions';
            SET @LogColumnValue = ISNULL(CAST(@Count AS VARCHAR(10)), 0);

            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;

            DROP TABLE #DeletedRecordId;

            ------------------------------------------------------------------
            SET @NewObjectXml = CAST(@NewObjectXml AS NVARCHAR(MAX));
            -------------------------------------------------------------------------------------
            -- CALL SPMFUpadteTableInternal TO INSERT PROPERTY DETAILS INTO TABLE
            -------------------------------------------------------------------------------------
            SET @StartTime = GETUTCDATE();

            IF (@NewObjectXml != '<form />')
            BEGIN
                SET @ProcedureName = 'spMFUpdateTableInternal';
                SET @ProcedureStep = 'Update property details from M-Files ';

                IF @Debug > 9
                BEGIN
                    RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

                    IF @Debug > 10
                        SELECT @NewObjectXml AS '@NewObjectXml before updateobjectinternal';
                END;

                EXEC @return_value = dbo.spMFUpdateTableInternal @MFTableName,
                                                                 @NewObjectXml,
                                                                 @Update_ID,
                                                                 @Debug = @Debug,
                                                                 @SyncErrorFlag = 0;

                IF @return_value <> 1
                    RAISERROR('Proc: %s Step: %s FAILED ', 16, 1, @ProcedureName, @ProcedureStep);
            END;


        END;
        ELSE
        BEGIN
            SELECT 'Check the table Name Entered';
        END;

        --          SET NOCOUNT OFF;
        --COMMIT TRANSACTION
        SET @ProcedureName = 'spMFUpdateTable';
        SET @ProcedureStep = 'Set update Status';

        IF @Debug > 9
            RAISERROR(
                         'Proc: %s Step: %s ReturnValue %i ProcessCompleted ',
                         10,
                         1,
                         @ProcedureName,
                         @ProcedureStep,
                         @return_value
                     );

        SET @ProcedureStep = 'Updating Table ';
        SET @LogType = 'Status';
        SET @LogText = 'Class Table: ' + @TableName + ':Update Method ' + CAST(@UpdateMethod AS VARCHAR(10));
        SET @LogStatus = N'Completed';

        IF @return_value = 1
        BEGIN
            UPDATE dbo.MFUpdateHistory
            SET UpdateStatus = 'completed',
                SynchronizationError = @SynchErrorXML
            WHERE Id = @Update_ID;


            EXEC dbo.spMFProcessBatch_Upsert @ProcessBatch_ID = @ProcessBatch_ID,
                                                              -- int
                                             @LogType = @LogType,
                                                              -- nvarchar(50)
                                             @LogText = @LogText,
                                                              -- nvarchar(4000)
                                             @LogStatus = @LogStatus,
                                                              -- nvarchar(50)
                                             @debug = @Debug; -- tinyint

            SET @LogTypeDetail = @LogType;
            SET @LogTextDetail = @LogText;
            SET @LogStatusDetail = @LogStatus;
            SET @Validation_ID = NULL;
            SET @LogColumnName = NULL;
            SET @LogColumnValue = NULL;

            EXECUTE @return_value = dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                                      @LogType = @LogTypeDetail,
                                                                      @LogText = @LogTextDetail,
                                                                      @LogStatus = @LogStatusDetail,
                                                                      @StartTime = @StartTime,
                                                                      @MFTableName = @MFTableName,
                                                                      @Validation_ID = @Validation_ID,
                                                                      @ColumnName = @LogColumnName,
                                                                      @ColumnValue = @LogColumnValue,
                                                                      @Update_ID = @Update_ID,
                                                                      @LogProcedureName = @ProcedureName,
                                                                      @LogProcedureStep = @ProcedureStep,
                                                                      @debug = @Debug;

            RETURN 1; --For More information refer Process Table
        END;
        ELSE
        BEGIN
            UPDATE dbo.MFUpdateHistory
            SET UpdateStatus = 'partial'
            WHERE Id = @Update_ID;

            SET @LogStatus = N'Partial Successful';
            SET @LogText = N'Partial Completed';

            EXEC dbo.spMFProcessBatch_Upsert @ProcessBatch_ID = @ProcessBatch_ID,
                                                              -- int
                                                              --				    @LogType = @ProcedureStep, -- nvarchar(50)
                                             @LogText = @LogText,
                                                              -- nvarchar(4000)
                                             @LogStatus = @LogStatus,
                                                              -- nvarchar(50)
                                             @debug = @Debug; -- tinyint

            EXEC dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                   @Update_ID = @Update_ID,
                                                   @LogText = @LogText,
                                                   @LogType = @LogType,
                                                   @LogStatus = @LogStatus,
                                                   @StartTime = @StartTime,
                                                   @MFTableName = @MFTableName,
                                                   @ColumnName = @LogColumnName,
                                                   @ColumnValue = @LogColumnValue,
                                                   @LogProcedureName = @ProcedureName,
                                                   @LogProcedureStep = @ProcedureStep,
                                                   @debug = @Debug;

            RETURN 1; --For More information refer Process Table
        END;

        IF @SynchErrCount > 0
        BEGIN
            SET @LogStatus = N'Errors';
            SET @LogText = @ProcedureStep + 'with sycnronisation errors: ' + @TableName + ':Return Value 2 ';

            EXEC dbo.spMFProcessBatch_Upsert @ProcessBatch_ID = @ProcessBatch_ID,
                                                              -- int
                                                              --				    @LogType = @ProcedureStep, -- nvarchar(50)
                                             @LogText = @LogText,
                                                              -- nvarchar(4000)
                                             @LogStatus = @LogStatus,
                                                              -- nvarchar(50)
                                             @debug = @Debug; -- tinyint

            EXEC dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                   @Update_ID = @Update_ID,
                                                   @LogText = @LogText,
                                                   @LogType = @LogType,
                                                   @LogStatus = @LogStatus,
                                                   @StartTime = @StartTime,
                                                   @MFTableName = @MFTableName,
                                                   @ColumnName = @LogColumnName,
                                                   @ColumnValue = @LogColumnValue,
                                                   @LogProcedureName = @ProcedureName,
                                                   @LogProcedureStep = @ProcedureStep,
                                                   @debug = @Debug;

            RETURN 2;
        END;
        ELSE
        BEGIN
            IF @ErrorInfoCount > 0
                SET @LogStatus = N'Partial Successful';
            SET @LogText = @LogText + ':' + @ProcedureStep + 'with M-Files errors: ' + @TableName + 'Return Value 3';

            EXEC dbo.spMFProcessBatch_Upsert @ProcessBatch_ID = @ProcessBatch_ID,
                                                              -- int
                                             @ProcessType = @ProcessType,
                                             @LogText = @LogText,
                                                              -- nvarchar(4000)
                                             @LogStatus = @LogStatus,
                                                              -- nvarchar(50)
                                             @debug = @Debug; -- tinyint

            EXEC dbo.spMFProcessBatchDetail_Insert @ProcessBatch_ID = @ProcessBatch_ID,
                                                   @Update_ID = @Update_ID,
                                                   @LogText = @LogText,
                                                   @LogType = @LogType,
                                                   @LogStatus = @LogStatus,
                                                   @StartTime = @StartTime,
                                                   @MFTableName = @MFTableName,
                                                   @ColumnName = @LogColumnName,
                                                   @ColumnValue = @LogColumnValue,
                                                   @LogProcedureName = @ProcedureName,
                                                   @LogProcedureStep = @ProcedureStep,
                                                   @debug = @Debug;

            RETURN 3;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        SET NOCOUNT ON;

        UPDATE dbo.MFUpdateHistory
        SET UpdateStatus = 'failed'
        WHERE Id = @Update_ID;

        INSERT INTO dbo.MFLog
        (
            SPName,
            ErrorNumber,
            ErrorMessage,
            ErrorProcedure,
            ProcedureStep,
            ErrorState,
            ErrorSeverity,
            Update_ID,
            ErrorLine
        )
        VALUES
        ('spMFUpdateTable', ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), @ProcedureStep, ERROR_STATE(),
         ERROR_SEVERITY(), @Update_ID, ERROR_LINE());

        IF @Debug > 9
        BEGIN
            SELECT ERROR_NUMBER() AS ErrorNumber,
                   ERROR_MESSAGE() AS ErrorMessage,
                   ERROR_PROCEDURE() AS ErrorProcedure,
                   @ProcedureStep AS ProcedureStep,
                   ERROR_STATE() AS ErrorState,
                   ERROR_SEVERITY() AS ErrorSeverity,
                   ERROR_LINE() AS ErrorLine;
        END;

        SET NOCOUNT OFF;

        RETURN -1; --For More information refer Process Table
    END CATCH;
END;





PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFSynchronizeFilesToMFiles]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFSynchronizeFilesToMFiles'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.2.8.47'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

/*
 ********************************************************************************
  ** Change History
  ********************************************************************************
  ** Date        Author     Description
  ** ----------  ---------  -----------------------------------------------------
  2019-1-15		LC			Fix bug with file import using GUID as unique ref; improve logging messages

  ********************************************************************************
*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFSynchronizeFilesToMFiles' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFSynchronizeFilesToMFiles]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFSynchronizeFilesToMFiles]
    @SourceTableName NVARCHAR(100)
   ,@FileUniqueKeyColumn NVARCHAR(100)
   ,@FileNameColumn NVARCHAR(100)
   ,@FileDataColumn NVARCHAR(100)
   ,@MFTableName NVARCHAR(100)
   ,@TargetFileUniqueKeycolumnName NVARCHAR(100) = 'MFSQL_Unique_File_Ref'
   ,@BatchSize INT = 500
   ,@Process_ID INT = 5
   ,@ProcessBatch_id INT = NULL OUTPUT
   ,@Debug INT = 0
AS
/*rST**************************************************************************

============================
spMFSynchronizeFilesToMFiles
============================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @SourceTableName nvarchar(100)
    fixme description
  @FileUniqueKeyColumn nvarchar(100)
    fixme description
  @FileNameColumn nvarchar(100)
    fixme description
  @FileDataColumn nvarchar(100)
    fixme description
  @MFTableName nvarchar(100)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @TargetFileUniqueKeycolumnName nvarchar(100)
    fixme description
  @BatchSize int
    fixme description
  @Process\_ID int
    fixme description
  @ProcessBatch\_id int (output)
    fixme description
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode


Purpose
=======

Additional Info
===============

Prerequisites
=============

Warnings
========

Examples
========

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
  RAISERROR('This procedure is currently under revision',16,1)
    BEGIN TRY
        SET NOCOUNT ON;

        -----------------------------------------------------
        --DECLARE VARIABLES FOR LOGGING
        -----------------------------------------------------
        --used on MFProcessBatchDetail;
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @LogTypeDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @ProcessType NVARCHAR(50) = 'Object History';
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = 'Get History Initiated';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @Status AS NVARCHAR(128) = NULL;
        DECLARE @Validation_ID INT = NULL;
        DECLARE @StartTime AS DATETIME = GETUTCDATE();
        DECLARE @RunTime AS DECIMAL(18, 4) = 0;
        DECLARE @Update_IDOut INT;
        DECLARE @error AS INT = 0;
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT;
        DECLARE @RC INT;
        DECLARE @Update_ID INT;
        DECLARE @ProcedureName sysname = 'spMFSynchronizeFilesToMFiles';
        DECLARE @ProcedureStep sysname = 'Start';

        ----------------------------------------------------------------------
        --GET Vault LOGIN CREDENTIALS
        ----------------------------------------------------------------------
        DECLARE @Username NVARCHAR(2000);
        DECLARE @VaultName NVARCHAR(2000);

        SELECT TOP 1
               @Username  = [Username]
              ,@VaultName = [VaultName]
        FROM [dbo].[MFVaultSettings];

        INSERT INTO [dbo].[MFUpdateHistory]
        (
            [Username]
           ,[VaultName]
           ,[UpdateMethod]
        )
        VALUES
        (@Username, @VaultName, -1);

        SELECT @Update_ID = @@Identity;

        SELECT @Update_IDOut = @Update_ID;

        SET @ProcessType = 'Import Files';
        SET @LogText = ' Started ';
        SET @LogStatus = 'Initiate';
        SET @StartTime = GETUTCDATE();
        SET @LogTypeDetail = 'Debug';
        SET @LogStatusDetail = 'In Progress';

        EXECUTE @RC = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                                     ,@ProcessType = @ProcessType
                                                     ,@LogType = @LogType
                                                     ,@LogText = @LogText
                                                     ,@LogStatus = @LogStatus
                                                     ,@debug = 0;

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = 0;

        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        ----------------------------------------
        --DECLARE VARIABLES
        ----------------------------------------
        DECLARE @TargetClassMFID INT;
        DECLARE @ObjectTypeID INT;
        DECLARE @VaultSettings NVARCHAR(MAX);
        DECLARE @XML NVARCHAR(MAX);
        DECLARE @Counter INT;
        DECLARE @MaxRowID INT;
        DECLARE @ObjIDs NVARCHAR(4000);
        DECLARE @FileLocation VARCHAR(200);
        DECLARE @Sql NVARCHAR(MAX);
        DECLARE @Params NVARCHAR(MAX);

        SET @ProcedureStep = 'Checking Target class ';
        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        IF EXISTS
        (
            SELECT TOP 1
                   *
            FROM [dbo].[MFClass]
            WHERE [TableName] = @MFTableName
        )
        BEGIN
            SET @LogTextDetail = @MFTableName + ' is present in the MFClass table';

            EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                         ,@LogType = @LogTypeDetail
                                                                         ,@LogText = @LogTextDetail
                                                                         ,@LogStatus = @LogStatusDetail
                                                                         ,@StartTime = @StartTime
                                                                         ,@MFTableName = @MFTableName
                                                                         ,@Validation_ID = @Validation_ID
                                                                         ,@ColumnName = @LogColumnName
                                                                         ,@ColumnValue = @LogColumnValue
                                                                         ,@Update_ID = @Update_ID
                                                                         ,@LogProcedureName = @ProcedureName
                                                                         ,@LogProcedureStep = @ProcedureStep
                                                                         ,@debug = 0;

            SELECT @TargetClassMFID = [MC].[MFID]
                  ,@ObjectTypeID    = [OT].[MFID]
            FROM [dbo].[MFClass]                [MC]
                INNER JOIN [dbo].[MFObjectType] [OT]
                    ON [MC].[MFObjectType_ID] = [OT].[ID]
            WHERE [MC].[TableName] = @MFTableName;

            SET @ProcedureStep = 'Checking File unique key property ';
            SET @DebugText = '';
            SET @DebugText = @DefaultDebugText + @DebugText;

            IF @Debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
            END;

            IF EXISTS
            (
                SELECT *
                FROM [INFORMATION_SCHEMA].[COLUMNS] [C]
                WHERE [C].[TABLE_NAME] = @MFTableName
                      AND [C].[COLUMN_NAME] = @TargetFileUniqueKeycolumnName
            )
            BEGIN
                SET @LogTextDetail
                    = @TargetFileUniqueKeycolumnName + ' is present in the Target class ' + @MFTableName;

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = 0;

                ------------------------------------------------
                --Getting Vault Settings
                ------------------------------------------------
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Getting Vault credentials ';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

                -------------------------------------------------------------
                -- Validate unique reference
                -------------------------------------------------------------
                SET @ProcedureStep = 'Duplicate unique ref count  ';
                SET @rowcount = NULL;
                SET @Params = N'@rowCount int output';
                SET @Sql = N'	
SELECT @Rowcount = COUNT(*) FROM ' + QUOTENAME(@MFTableName) + '
where ' +       QUOTENAME(@TargetFileUniqueKeycolumnName) + ' is not null 
GROUP BY ' +    QUOTENAME(@TargetFileUniqueKeycolumnName) + ' HAVING COUNT(*) > 1';

                EXEC [sys].[sp_executesql] @stmt = @Sql
                                          ,@param = @Params
                                          ,@rowcount = @rowcount OUTPUT;

                --IF @Debug > 0
                --    PRINT @Sql;
                SELECT @rowcount = ISNULL(@rowcount, 0);

                SET @DebugText = 'Duplicate Rows: %i';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @rowcount);
                END;

                IF @rowcount > 0
                BEGIN
                    SET @DebugText = 'Unique Ref has duplicate items - not allowed ';
                    SET @DebugText = @DefaultDebugText + @DebugText;
                    SET @ProcedureStep = 'Validate Unique File reference ';

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 16, 1, @ProcedureName, @ProcedureStep);
                    END;

                    SET @LogTextDetail = @DebugText;
                    SET @LogTypeDetail = 'Error';
                    SET @LogStatusDetail = 'Error';

                    EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                                 ,@LogType = @LogTypeDetail
                                                                                 ,@LogText = @LogTextDetail
                                                                                 ,@LogStatus = @LogStatusDetail
                                                                                 ,@StartTime = @StartTime
                                                                                 ,@MFTableName = @MFTableName
                                                                                 ,@Validation_ID = @Validation_ID
                                                                                 ,@ColumnName = @LogColumnName
                                                                                 ,@ColumnValue = @LogColumnValue
                                                                                 ,@Update_ID = @Update_ID
                                                                                 ,@LogProcedureName = @ProcedureName
                                                                                 ,@LogProcedureStep = @ProcedureStep
                                                                                 ,@debug = 0;
                END;

                ------------------------------------------------
                --Getting Temp File location to store File
                ------------------------------------------------
                SELECT @FileLocation = ISNULL(CAST([Value] AS NVARCHAR(200)), 'Invalid location')
                FROM [dbo].[MFSettings]
                WHERE [source_key] = 'Files_Default'
                      AND [Name] = 'FileTransferLocation';

                SET @DebugText = ' ' + @FileLocation;
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Get file transfer location: ';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                ------------------------------------------------
                --Creating Temp table to fecth only 500 records
                ------------------------------------------------
                SET @ProcedureStep = 'Create Temp file';

                DECLARE @TempFile VARCHAR(100);

                SELECT @TempFile = '##' + [dbo].[fnMFVariableTableName]('InsertFiles', '');

                SET @DebugText = 'Tempfile %s';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = '';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @TempFile);
                END;

                --SET @SQL = N'
                --            CREATE TABLE '+@TempFile + '
                --            (
                --                [RowID] INT IDENTITY(1, 1)
                --               ,[FileUniqueID] NVARCHAR(250)
                --            );'

                --            EXEC (@SQL)
                -----------------------------------------------------
                --Inserting @BatchSize records into the Temp table
                ----------------------------------------------------
                SET @ProcedureStep = 'Insert records into TempFile';
                SET @Sql
                    = N' Select * into ' + @TempFile + ' From (select top ' + CAST(@BatchSize AS VARCHAR(10))
                      + ' TN.ID as RowID, SR.' + @FileUniqueKeyColumn + ' as FileUniqueID from ' + @SourceTableName
                      + ' SR inner join ' + @MFTableName + ' TN on SR.' + @FileUniqueKeyColumn + '=TN.'
                      + @TargetFileUniqueKeycolumnName + ' and TN.Process_ID= ' + CAST(@Process_ID AS VARCHAR(5))
                      + ')list;';

                IF @Debug > 0
                    PRINT @Sql;

                EXEC [sys].[sp_executesql] @Stmt = @Sql;

                IF @Debug > 0
                BEGIN
                    EXEC (N'Select Count(*) as FileCount from ' + @TempFile);
                END;

                SET @DebugText = 'TempFile: %s';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @TempFile);
                END;

                SET @LogTextDetail = 'Records insert in Temp file';
                SET @LogColumnName = @TempFile;
                SET @LogColumnValue = CAST(@BatchSize AS VARCHAR(10));

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = 0;

                SET @Params = N'@RowID int output';
                SET @Sql = N'
                SELECT @RowID = Min([RowID])
                FROM ' + @TempFile;

                EXEC [sys].[sp_executesql] @Stmt = @Sql
                                          ,@param = @Params
                                          ,@RowID = @Counter OUTPUT;

                SET @DebugText = '  Min RowID %i';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @Counter);
                END;

                SET @ProcedureStep = 'Loop for importing file from source ';

                WHILE @Counter IS NOT NULL
                BEGIN
                    DECLARE @FileID NVARCHAR(250);
                    DECLARE @ParmDefinition NVARCHAR(500);
                    DECLARE @XMLOut        XML
                           ,@SqlID         INT
                           ,@ObjId         INT
                           ,@ObjectVersion INT;

                    SET @ProcedureStep = 'Get latest version';

					SET @params = N'@ObjIDs nvarchar(4000) output, @Counter int'
					SET @SQL = N'Select @ObjIDs = CAST(Objid AS VARCHAR(4000)) FROM '+QUOTENAME(@MFTableName) + ' WHERE ID = @Counter'

					EXEC sp_executeSQL @SQL, @Params, @Objids OUTPUT, @Counter

					Set @DebugText = ' Objids %s'
					Set @DebugText = @DefaultDebugText + @DebugText
					Set @Procedurestep = 'Get Objids for update'
					
					IF @debug > 0
						Begin
							RAISERROR(@DebugText,10,1,@ProcedureName,@ProcedureStep,@Objids );
						END
					
					SET @Params = N'@Objids nvarchar(4000)'
					SET @SQL = N'UPDATE '+ QUOTENAME(@MFTableName)+' SET [Process_ID] = 0 WHERE objid = CAST(@Objids AS int)'
					EXEC sp_executeSQL @SQL, @Params, @Objids 

                    EXEC [dbo].[spMFUpdateTable] @MFTableName = @MFTableName                 -- nvarchar(200)
                                                ,@UpdateMethod = 1                           -- int                          
                                                ,@ObjIDs = @ObjIDs                           -- nvarchar(max)
                                                ,@Update_IDOut = @Update_IDOut OUTPUT        -- int
                                                ,@ProcessBatch_ID = @ProcessBatch_id; -- int
					
					SET @Params = N'@Process_ID int, @Objids nvarchar(4000)'
					SET @SQL = N'UPDATE '+ QUOTENAME(@MFTableName)+' SET [Process_ID] = @Process_ID WHERE objid = CAST(@Objids AS int)'
					EXEC sp_executeSQL @SQL, @Params, @process_ID, @Objids 


                    SET @ProcedureStep = 'Get uniqueID';
                    SET @Params = N'@FileID nvarchar(250) output, @Counter int';
                    SET @Sql = N'SELECT @FileID = [FileUniqueID] FROM ' + @TempFile + ' WHERE [RowID] = @Counter;';

                    EXEC [sys].[sp_executesql] @Sql, @Params, @FileID OUTPUT, @Counter;

                    SET @DebugText = ' FileID: %s';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @FileID);
                    END;

                    SET @ProcedureStep = 'Get object Details';
                    SET @Params
                        = N'@SQLID int OUTPUT,@ObjId  INT OUTPUT,@ObjectVersion  INT OUTPUT,@FileID nvarchar(250)';
                    SET @Sql
                        = 'select @SqlID=ID,@ObjId=ObjID,@ObjectVersion=MFVersion  from ' + @MFTableName + ' where '
                          + @TargetFileUniqueKeycolumnName + '= ''' + @FileID + '''';

                    IF @Debug > 0
                        PRINT @Sql;

                    EXEC [sys].[sp_executesql] @stmt = @Sql
                                              ,@param = @Params
                                              ,@SQLID = @SqlID OUTPUT
                                              ,@ObjId = @ObjId OUTPUT
                                              ,@ObjectVersion = @ObjectVersion OUTPUT
                                              ,@FileID = @FileID;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

					-------------------------------------------------------------
					-- Validate file data  (filename not null)
					-------------------------------------------------------------
					DECLARE @FileNameExist nvarchar(250) 
					SET @params = '@FileNameExist nvarchar(250) output, @Counter int'
					SET @SQL = N'
					SELECT @FileNameExist = FileName FROM '+ @SourceTableName +' S
					INNER JOIN '+ @Tempfile + ' t
					ON s.'+ @FileUniqueKeyColumn +' = t.FileUniqueID
					WHERE t.RowID = @Counter;'

					IF @Debug > 0
					PRINT @SQL;

					EXEC sp_executeSQL @SQL, @Params, @FileNameExist OUTPUT, @counter

					IF ISNULL(@FileNameExist,'') <> ''
					Begin

                    -----------------------------------------------------
                    --Creating the xml 
                    ----------------------------------------------------
                    DECLARE @Query NVARCHAR(MAX);

                    SET @ProcedureStep = 'Prepare ColumnValue pair';

                    DECLARE @ColumnValuePair TABLE
                    (
                        [ColunmName] NVARCHAR(200)
                       ,[ColumnValue] NVARCHAR(4000)
                       ,[Required] BIT ---Added for checking Required property for table
                    );

                    DECLARE @TableWhereClause VARCHAR(1000)
                           ,@tempTableName    VARCHAR(1000)
                           ,@XMLFile          XML;

                    SET @TableWhereClause
                        = 'y.' + @TargetFileUniqueKeycolumnName + '=cast(''' + @FileID
                          + ''' as nvarchar(100)) and Process_Id= ' + CAST(@Process_ID AS VARCHAR(5));

                    IF @Debug > 0
                        PRINT @TableWhereClause;

                    ----------------------------------------------------------------------------------------------------------
                    --Generate query to get column values as row value
                    ----------------------------------------------------------------------------------------------------------
                    SET @ProcedureStep = 'Prepare query';

                    SELECT @Query
                        = STUFF(
                          (
                              SELECT ' UNION ' + 'SELECT ''' + [COLUMN_NAME] + ''' as name, CONVERT(VARCHAR(max),['
                                     + [COLUMN_NAME] + ']) as value, 0  as Required FROM [' + @MFTableName + '] y'
                                     + ISNULL('  WHERE ' + @TableWhereClause, '')
                              FROM [INFORMATION_SCHEMA].[COLUMNS]
                              WHERE [TABLE_NAME] = @MFTableName
                              FOR XML PATH('')
                          )
                         ,1
                         ,7
                         ,''
                               );

                    IF @Debug > 0
                        PRINT @Query;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    -----------------------------------------------------
                    --List of columns to exclude
                    -----------------------------------------------------
                    SET @ProcedureStep = 'Prepare exclusion list';

                    DECLARE @ExcludeList AS TABLE
                    (
                        [ColumnName] VARCHAR(100)
                    );

                    INSERT INTO @ExcludeList
                    (
                        [ColumnName]
                    )
                    SELECT [mp].[ColumnName]
                    FROM [dbo].[MFProperty] AS [mp]
                    WHERE [mp].[MFID] IN ( 20, 21, 23, 25 );

                    --Last Modified, Last Modified by, Created, Created by

                    -----------------------------------------------------
                    --Insert to values INTo temp table
                    -----------------------------------------------------
                    --               PRINT @Query;
                    SET @ProcedureStep = 'Execute query';

					DELETE FROM @ColumnValuePair 
					--IF @Debug > 0
					--SELECT * FROM @ColumnValuePair AS [cvp];

                    INSERT INTO @ColumnValuePair
                    EXEC (@Query);

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
								SELECT * FROM @ColumnValuePair AS [cvp];
                    END;

                    SET @ProcedureStep = 'Remove exclusions';

                    DELETE FROM @ColumnValuePair
                    WHERE [ColunmName] IN (
                                              SELECT [el].[ColumnName] FROM @ExcludeList AS [el]
                                          );

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    --SELECT *
                    --FROM @ColumnValuePair;

                    ----------------------	 Add for checking Required property--------------------------------------------
                    SET @ProcedureStep = 'Check for required properties';

                    UPDATE [CVP]
                    SET [CVP].[Required] = [CP].[Required]
                    FROM @ColumnValuePair                  [CVP]
                        INNER JOIN [dbo].[MFProperty]      [P]
                            ON [CVP].[ColunmName] = [P].[ColumnName]
                        INNER JOIN [dbo].[MFClassProperty] [CP]
                            ON [P].[ID] = [CP].[MFProperty_ID]
                        INNER JOIN [dbo].[MFClass]         [C]
                            ON [CP].[MFClass_ID] = [C].[ID]
                    WHERE [C].[TableName] = @MFTableName;

                    UPDATE @ColumnValuePair
                    SET [ColumnValue] = 'ZZZ'
                    WHERE [Required] = 1
                          AND [ColumnValue] IS NULL;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    ------------------	 Add for checking Required property------------------------------------
                    SET @ProcedureStep = 'Convert datatime';

                    --DELETE FROM @ColumnValuePair
                    --WHERE  ColumnValue IS NULL
                    UPDATE [cp]
                    SET [cp].[ColumnValue] = CONVERT(DATE, CAST([cp].[ColumnValue] AS NVARCHAR(100)))
                    FROM @ColumnValuePair                         AS [cp]
                        INNER JOIN [INFORMATION_SCHEMA].[COLUMNS] AS [c]
                            ON [c].[COLUMN_NAME] = [cp].[ColunmName]
                    WHERE [c].[DATA_TYPE] = 'datetime'
                          AND [cp].[ColumnValue] IS NOT NULL;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    SET @ProcedureStep = 'Creating XML';
                    -----------------------------------------------------
                    --Generate xml file -- 
                    -----------------------------------------------------
                    --SELECT *
                    --FROM @ColumnValuePair;
                    SET @XMLFile =
                    (
                        SELECT @ObjectTypeID  AS [Object/@id]
                              ,@SqlID         AS [Object/@sqlID]
                              ,@ObjId         AS [Object/@objID]
                              ,@ObjectVersion AS [Object/@objVesrion]
                              ,0              AS [Object/@DisplayID]
                              ,(
                                   SELECT
                                       (
                                           SELECT TOP 1
                                                  [tmp].[ColumnValue]
                                           FROM @ColumnValuePair             AS [tmp]
                                               INNER JOIN [dbo].[MFProperty] AS [mfp]
                                                   ON [mfp].[ColumnName] = [tmp].[ColunmName]
                                           WHERE [mfp].[MFID] = 100
                                       ) AS [class/@id]
                                      ,(
                                           SELECT [mfp].[MFID] AS [property/@id]
                                                 ,(
                                                      SELECT [MFTypeID]
                                                      FROM [dbo].[MFDataType]
                                                      WHERE [ID] = [mfp].[MFDataType_ID]
                                                  )            AS [property/@dataType]
                                                 ,CASE
                                                      WHEN [tmp].[ColumnValue] = 'ZZZ' THEN
                                                          NULL
                                                      ELSE
                                                          [tmp].[ColumnValue]
                                                  END          AS 'property' ----Added case statement for checking Required property
                                           FROM @ColumnValuePair             AS [tmp]
                                               INNER JOIN [dbo].[MFProperty] AS [mfp]
                                                   ON [mfp].[ColumnName] = [tmp].[ColunmName]
                                           WHERE [mfp].[MFID] <> 100
                                                 AND [tmp].[ColumnValue] IS NOT NULL --- excluding duplicate class and [tmp].[ColumnValue] is not null added for task 1103
                                           FOR XML PATH(''), TYPE
                                       ) AS [class]
                                   FOR XML PATH(''), TYPE
                               )              AS [Object]
                        FOR XML PATH(''), ROOT('form')
                    );
                    SET @XMLFile =
                    (
                        SELECT @XMLFile.[query]('/form/*')
                    );
                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

                        SELECT @XMLFile;
                    END;

                    SET @ProcedureStep = 'Get Checksum';

                    DECLARE @FileCheckSum NVARCHAR(MAX);

                    IF EXISTS
                    (
                        SELECT TOP 1
                               [FileCheckSum]
                        FROM [dbo].[MFFileImport]
                        WHERE [FileUniqueRef] = @FileID
                              AND [SourceName] = @SourceTableName
                    )
                    BEGIN
                        CREATE TABLE [#TempCheckSum]
                        (
                            [FileCheckSum] NVARCHAR(MAX)
                        );

                        INSERT INTO [#TempCheckSum]
                        SELECT TOP 1
                               ISNULL([FileCheckSum], '')
                        FROM [dbo].[MFFileImport]
                        WHERE [FileUniqueRef] = @FileID
                              AND [SourceName] = @SourceTableName
                        ORDER BY 1 DESC;

                        SELECT *
                        FROM [#TempCheckSum];

                        SELECT @FileCheckSum = ISNULL([FileCheckSum], '')
                        FROM [#TempCheckSum];

                        DROP TABLE [#TempCheckSum];
                    END;
                    ELSE
                    BEGIN
                        SET @FileCheckSum = '';
                    END;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    SET @ProcedureStep = 'Prepare XML out';
                    SET @Sql = '';
                    SET @Sql
                        = 'select @XMLOut=(  Select ''' + @FileID + ''' as ''FileListItem/@ID'' , ' + @FileNameColumn
                          + ' as ''FileListItem/@FileName'', [' + @FileDataColumn + '] as ''FileListItem/@File'', '
                          + CAST(@TargetClassMFID AS VARCHAR(100)) + ' as ''FileListItem/@ClassId'', '
                          + CAST(@ObjectTypeID AS VARCHAR(10)) + ' as ''FileListItem/@ObjType'',''' + @FileCheckSum
                          + ''' as ''FileListItem/@FileCheckSum'' from ' + @SourceTableName + ' where '
                          + @FileUniqueKeyColumn + '=''' + @FileID + ''' FOR XML PATH('''') , ROOT(''XMLFILE'') )';

                    IF @Debug > 0
                        PRINT @Sql;

                    EXEC [sys].[sp_executesql] @Sql, N'@XMLOut XML OUTPUT', @XMLOut OUTPUT;

                    ;

                    SELECT @XML = CAST(@XMLOut AS NVARCHAR(MAX));

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    -- PRINT @XML;

                    -------------------------------------------------------------------
                    --Getting the Filedata in @Data variable
                    -------------------------------------------------------------------
                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;
                    SET @ProcedureStep = 'Getting the Filedata in @Data variable';

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    DECLARE @Data VARBINARY(MAX);

                    SET @Sql = '';
                    SET @Sql
                        = 'select @Data=[' + @FileDataColumn + ']  from ' + @SourceTableName + ' where '
                          + @FileUniqueKeyColumn + '=''' + @FileID + '''';

                    -- PRINT @Sql;
                    EXEC [sys].[sp_executesql] @Sql
                                              ,N'@Data  varbinary(max) OUTPUT'
                                              ,@Data OUTPUT;;

                    -------------------------------------------------------------------
                    --Importing File into M-Files using Connector
                    -------------------------------------------------------------------
                    SET @ProcedureStep = 'Importing file';

                    DECLARE @XMLStr   NVARCHAR(MAX)
                           ,@Result   NVARCHAR(MAX)
                           ,@ErrorMsg NVARCHAR(MAX);

                    SET @XMLStr = '<form>' + CAST(@XMLFile AS NVARCHAR(MAX)) + '</form>';
                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

                        SELECT CAST(@XML AS XML) AS '@XML Length';

                        SELECT @Data AS '@data';

                        SELECT CAST(@XMLStr AS XML) AS '@XMLStr';
						SELECT @FileLocation AS filelocation

                    END;

					DECLARE @Result1   NVARCHAR(MAX)
					       ,@ErrorMsg1 NVARCHAR(MAX);

						 
/*					
					EXEC [dbo].[spMFSynchronizeFileToMFilesInternal] @VaultSettings = ? -- nvarchar(4000)
					                                                ,@FileName = ?      -- nvarchar(max)
					                                                ,@XMLFile = ?       -- nvarchar(max)
					                                                ,@FilePath = ?      -- nvarchar(max)
					                                                ,@Result = @Result1 OUTPUT                              -- nvarchar(max)
					                                                ,@ErrorMsg = @ErrorMsg1 OUTPUT                          -- nvarchar(max)
					                                                ,@IsFileDelete = ?  -- int
					
                    EXEC [dbo].[spMFSynchronizeFileToMFilesInternal] @VaultSettings
                                                                    ,@XML
                                                                    ,@Data
                                                                    ,@XMLStr
                                                                    ,@FileLocation
                                                                    ,@Result OUT
                                                                    ,@ErrorMsg OUT
																	;

*/
                  IF @Debug > 0  
				  Begin
					SELECT CAST(@Result AS XML) AS Result
					SELECT @ErrorMsg AS errormsg
					END
                    
                    IF @ErrorMsg IS NOT NULL
                       AND LEN(@ErrorMsg) > 0
                    BEGIN
                        --  SET @Sql='update '+@MFTableName+' set Process_Id=2 where '+@FileUniqueKeyColumn+'='+@ID
                        SET @Sql
                            = 'update ' + QUOTENAME(@MFTableName) + ' set Process_ID=2 where '
                              + QUOTENAME(@TargetFileUniqueKeycolumnName) + ' =''' + @FileID + '''';

                        --          PRINT @Sql;
                        EXEC (@Sql);
                    END;

                    SET @DebugText = '';
                    SET @DebugText = @DefaultDebugText + @DebugText;
                    SET @ProcedureStep = 'Insert result in MFFileImport table';

                    IF @Debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    DECLARE @ResultXml XML;

                    SET @ResultXml = CAST(@Result AS XML);

                    CREATE TABLE [#TempFileDetails]
                    (
                        [FileName] NVARCHAR(200)
                       ,[FileUniqueRef] VARCHAR(100)
                       ,[MFCreated] DATETIME
                       ,[MFLastModified] DATETIME
                       ,[ObjID] INT
                       ,[ObjVer] INT
                       ,[FileObjectID] INT
                       ,[FileCheckSum] NVARCHAR(MAX)
                    );

                    INSERT INTO [#TempFileDetails]
                    (
                        [FileName]
                       ,[FileUniqueRef]
                       ,[MFCreated]
                       ,[MFLastModified]
                       ,[ObjID]
                       ,[ObjVer]
                       ,[FileObjectID]
                       ,[FileCheckSum]
                    )
                    SELECT [t].[c].[value]('(@FileName)[1]', 'NVARCHAR(200)')     AS [FileName]
                          ,[t].[c].[value]('(@FileUniqueRef)[1]', 'VARCHAR(100)') AS [FileUniqueRef]
                          ,[t].[c].[value]('(@MFCreated)[1]', 'DATETIME')         AS [MFCreated]
                          ,[t].[c].[value]('(@MFLastModified)[1]', 'DATETIME')    AS [MFLastModified]
                          ,[t].[c].[value]('(@ObjID)[1]', 'INT')                  AS [ObjID]
                          ,[t].[c].[value]('(@ObjVer)[1]', 'INT')                 AS [ObjVer]
                          ,[t].[c].[value]('(@FileObjectID)[1]', 'INT')           AS [FileObjectID]
                          ,[t].[c].[value]('(@FileCheckSum)[1]', 'NVARCHAR(MAX)') AS [FileCheckSum]
                    FROM @ResultXml.[nodes]('/form/Object') AS [t]([c]);

                    IF EXISTS
                    (
                        SELECT TOP 1
                               *
                        FROM [dbo].[MFFileImport]
                        WHERE [FileUniqueRef] = @FileID
                              AND [TargetClassID] = @TargetClassMFID
                    )
                    BEGIN
                        UPDATE [FI]
                        SET [FI].[MFCreated] = [FD].[MFCreated]
                           ,[FI].[MFLastModified] = [FD].[MFLastModified]
                           ,[FI].[ObjID] = [FD].[ObjID]
                           ,[FI].[Version] = [FD].[ObjVer]
                           ,[FI].[FileObjectID] = [FD].[FileObjectID]
                           ,[FI].[FileCheckSum] = [FD].[FileCheckSum]
                        FROM [dbo].[MFFileImport]         [FI]
                            INNER JOIN [#TempFileDetails] [FD]
                                ON [FI].[FileUniqueRef] = [FD].[FileUniqueRef];
                    END;
                    ELSE
                    BEGIN
                        INSERT INTO [dbo].[MFFileImport]
                        (
                            [FileName]
                           ,[FileUniqueRef]
                           ,[CreatedOn]
                           ,[SourceName]
                           ,[TargetClassID]
                           ,[MFCreated]
                           ,[MFLastModified]
                           ,[ObjID]
                           ,[Version]
                           ,[FileObjectID]
                           ,[FileCheckSum]
                        )
                        SELECT [FileName]
                              ,[FileUniqueRef]
                              ,GETDATE()
                              ,@SourceTableName
                              ,@TargetClassMFID
                              ,[MFCreated]
                              ,[MFLastModified]
                              ,[ObjID]
                              ,[ObjVer] 
                              ,[FileObjectID]
                              ,[FileCheckSum]
                        FROM [#TempFileDetails];
                    END;

                    DROP TABLE [#TempFileDetails];

					END --end filename exist
					ELSE 
					BEGIN
                    Set @DebugText = 'UniqueID %s'
                    Set @DebugText = @DefaultDebugText + @DebugText
                    Set @Procedurestep = 'Filename missing'

                    RAISERROR(@DebugText,16,1,@ProcedureName,@ProcedureStep,@FileID );

					END -- Else end


                    SET @Sql = N'
                    Select @Counter = (SELECT MIN(RowID) FROM ' + @TempFile + ' WHERE Rowid > @Counter);';

                    EXEC [sys].[sp_executesql] @Sql, N'@Counter int output', @Counter OUTPUT;
                END; -- end loop

                SELECT @tempTableName = 'tempdb..' + @TempFile;

                IF
                (
                    SELECT OBJECT_ID(@tempTableName)
                ) IS NOT NULL
                    EXEC ('Drop table ' + @TempFile);

                SET @Sql = ' Synchronizing records  from M-files to the target ' + @MFTableName;

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = 0;

                -------------------------------------------------------------------
                --Synchronizing target table from M-Files
                -------------------------------------------------------------------
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Synchronizing target table from M-Files';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                SET @Sql
                    = 'Update ' + @MFTableName + ' set Process_ID=0 where Process_ID= '
                      + CAST(@Process_ID AS VARCHAR(5));;

                --           PRINT @Sql;
                EXEC (@Sql);

				DECLARE @Return_LastModified DATETIME

                EXEC [dbo].[spMFUpdateTableWithLastModifiedDate] @UpdateMethod = 1                                  -- int
                                                                ,@Return_LastModified = @Return_LastModified OUTPUT -- datetime
                                                                ,@TableName = @MFTableName                          -- sysname
                                                                ,@Update_IDOut = @Update_IDOut OUTPUT               -- int
                                                                ,@ProcessBatch_ID = @ProcessBatch_id         -- int
                                                                ,@debug = 0;                                        -- smallint
            END;
            ELSE
            BEGIN
                SET @DebugText = 'File unique column name does not belongs to the table';
                SET @DebugText = @DefaultDebugText + @DebugText;

                RAISERROR(@DebugText, 16, 1, @ProcedureName, @ProcedureStep);
            END;
        END;
        ELSE
        BEGIN
            SET @DebugText = 'Target Table ' + @MFTableName + ' does not belong to MFClass table';
            SET @DebugText = @DefaultDebugText + @DebugText;

            RAISERROR(@DebugText, 16, 1, @ProcedureName, @ProcedureStep);
        END;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();

        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = 0;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;

        RETURN -1;
    END CATCH;
END;

GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFUpdateHistoryShow]';
GO

SET NOCOUNT ON;
EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo',
                                     @ObjectName = N'spMFUpdateHistoryShow', -- nvarchar(100)
                                     @Object_Release = '4.1.5.43',           -- varchar(50)
                                     @UpdateFlag = 2;
-- smallint
GO


/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-01
	Database: 
	Description: Show the records of an update id
------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------
  MODIFICATION HISTORY
  ====================
 	DATE			NAME		DESCRIPTION
	YYYY-MM-DD		{Author}	{Comment}
    2017-06-09      Arnie       Move @Debug as last parameter
    2017-06-09      Arnie       Change logic to produce single result sets for easier usage in other procs; Change SELECT to PRINT for information message 
	2017-06-09		LC			Change options to print either summary or detail
	2018-08-01		LC			Fix bug with showing deletions
	2018-05-9		LC			Fix bug with column 1
------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====

  EXEC [spMFUpdateHistoryShow] @Debug = 1, @Update_ID = 9372, @UpdateColumn = 2
  UpdateColumn 1 = ObjecVerDetails: Data from SQL to QML
  UpdateColumn 2 = NewOrUpdateObjectDetails: Data From M-Files to SQL
  UpdateColumn 3 = NewOrUpdatedObjectVer: Objects to be updated in M-Files
  UpdateColumn 4 = SyncronisationErrors  (no object currently showing
  UpdateColumn 5 = MFError  (no object currently showing
  UpdateColumn 6 = DeletedObjects
  UpdateColumn 7 = ObjectDetails = ObjectType & class & properities of new object  (updatemethod = 0)

  exec spmfupdateHistoryShow 9366, 1, 0, 0
  Select * from MFupdatehistory where updatemethod = 0
  select * from mfupdatehistory where id = 9366
-----------------------------------------------------------------------------------------------*/
IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFUpdateHistoryShow' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';
    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateHistoryShow]
AS
SELECT 'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO
ALTER PROCEDURE [dbo].[spMFUpdateHistoryShow]
(
    @Update_ID INT,
    @IsSummary SMALLINT = 1,
    @UpdateColumn INT = 0,
    @Debug SMALLINT = 0
) AS;

SET NOCOUNT ON;

IF @Debug > 0
    SELECT *
    FROM [dbo].[MFUpdateHistory]
    WHERE [Id] = @Update_ID;

DECLARE @XML XML,
        @XML1 XML,
        @XML2 XML,
        @XML3 XML,
        @XML4 XML,
        @XML5 XML,
        @XML6 XML,
        @XML7 XML,
        @Query NVARCHAR(MAX),
        @Param NVARCHAR(MAX),
        @UpdateDescription VARCHAR(100);
DECLARE @RowCount INT;
DECLARE @TableName sysname;
DECLARE @UpdateMethod INT;
DECLARE @Idoc INT;


CREATE TABLE [#Summary]
(
    [UpdateColumn] SMALLINT,
    [ColumnName] NVARCHAR(100),
    [UpdateDescription] NVARCHAR(100),
    [UpdateMethod] SMALLINT,
    [RecCount] INT,
    [Class] NVARCHAR(100),
    [ObjectType] NVARCHAR(100),
    [TableName] NVARCHAR(100)
);
INSERT INTO [#Summary]
(
    [UpdateColumn],
    [ColumnName],
    [UpdateDescription]
)
VALUES
(0, N'ObjectDetails', 'Object Details'),
(1, N'ObjectVerDetails', 'Data from SQL to M-Files'),
(2, N'NewOrUpdatedObjectVer', 'Object updated in M-Files'),
(3, N'NewOrUpdateObjectDetails', 'Data From M-Files to SQL'),
(4, N'SyncronisationErrors', 'SyncronisationErrors'),
(5, N'MFError ', 'MFError'),
(6, N'DeletedObjects', 'Deleted Objects'),
(7, N'ObjectDetails', 'New Object from SQL');

SELECT @UpdateDescription = [UpdateDescription]
FROM [#Summary]
WHERE [UpdateColumn] = @UpdateColumn;


DECLARE @ClassPropName NVARCHAR(100);
SELECT @ClassPropName = [mp].[ColumnName]
FROM [dbo].[MFProperty] AS [mp]
WHERE [mp].[MFID] = 100;

SELECT @XML = [muh].[ObjectDetails],
       @XML1 = [muh].[ObjectVerDetails],
       @XML2 = [muh].[NewOrUpdatedObjectVer],
       @XML3 = [muh].[NewOrUpdatedObjectDetails],
       @XML4 = [muh].[SynchronizationError],
       @XML5 = [muh].[MFError],
       @XML6 = [muh].[DeletedObjectVer],
       @XML7 = [muh].[ObjectDetails],
       @UpdateMethod = [muh].[UpdateMethod]
FROM [dbo].[MFUpdateHistory] AS [muh]
WHERE [muh].[Id] = @Update_ID;

IF @UpdateMethod = 0
    DELETE FROM [#Summary]
    WHERE [UpdateColumn] = 7;

DECLARE @ObjectDetails AS TABLE
(
    [ObjectType] INT,
    [Class] INT,
    [Updatemethod] INT
);
INSERT INTO @ObjectDetails
SELECT [t].[c].[value]('Object[1]/@id', 'int') AS [ObjectType],
       [t].[c].[value]('Object[1]/class[1]/@id', 'int') AS [Class],
       @UpdateMethod AS [UpdateMethod]
FROM @XML.[nodes]('/form') AS [t]([c]);

IF @Debug > 0
    SELECT '@ObjectDetails' AS [ObjectDetails],
           *
    FROM @ObjectDetails;

SELECT @TableName = [TableName]
FROM @ObjectDetails
    INNER JOIN [dbo].[MFClass]
        ON [MFID] = [Class];

IF @Debug > 0
    SELECT @TableName AS [TableName];


UPDATE [#Summary]
SET [UpdateMethod] = [od].[Updatemethod],
    [Class] = [mc].[Name],
    [ObjectType] = [mo].[Name],
    [TableName] = [mc].[TableName]
FROM [#Summary]
    CROSS JOIN @ObjectDetails [od]
    INNER JOIN [dbo].[MFClass] [mc]
        ON [mc].[MFID] = [od].[Class]
    INNER JOIN [dbo].[MFObjectType] [mo]
        ON [mo].[MFID] = [od].[ObjectType];
--WHERE #Summary.UpdateColummn = 0;


--  @UpdateColumn = 1

BEGIN


    IF @Debug > 0
    BEGIN
        SELECT @XML1 AS [ObjectVerDetails];
    END;

    CREATE TABLE [#ObjectID_1]
    (
        [ObjectID] INT,
        [UpdateColumn] INT
    );
    INSERT INTO [#ObjectID_1]
    (
        [ObjectID],
        [UpdateColumn]
    )
    SELECT [t].[c].[value]('@objectID', 'int') [id],
           @UpdateColumn
    FROM @XML1.[nodes]('/form/objVers') AS [t]([c]);

    SET @RowCount = @@ROWCOUNT;
    UPDATE [#Summary]
    SET [RecCount] = @RowCount
    WHERE [UpdateColumn] = 1;


END;

-- @UpdateColumn = 2

BEGIN


    IF @Debug > 0
    BEGIN
        SELECT @XML2 AS [NewOrUpdatedObjectVer];
    END;

    INSERT INTO [#ObjectID_1]
    (
        [ObjectID],
        [UpdateColumn]
    )
    SELECT [t].[c].[value]('(@objectId)[1]', 'int') [objectid],
           @UpdateColumn
    FROM @XML2.[nodes]('/form/Object') AS [t]([c]);

    SET @RowCount = @@ROWCOUNT;
    UPDATE [#Summary]
    SET [RecCount] = @RowCount
    WHERE [UpdateColumn] = 2;

END;

-- @UpdateColumn = 3

BEGIN



    BEGIN



        IF @Debug > 0
        BEGIN

            SELECT @XML3 AS [NewOrUpdatedObjectDetails];
        END;
        --  SET @ProcedureStep = 'Parse the Input XML';
        --Parse the Input XML


        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @XML3;

        CREATE TABLE [#ObjectID_3]
        (
            [objId] INT,
            [MFVersion] INT,
            [GUID] NVARCHAR(100),
            [ExternalID] NVARCHAR(100),
            [propertyId] INT,
            [propertyName] NVARCHAR(100),
            [propertyValue] NVARCHAR(100),
            [dataType] NVARCHAR(100),
            [UpdateColumn] INT
        );

        INSERT INTO [#ObjectID_3]
        (
            [objId],
            [MFVersion],
            [GUID],
            [ExternalID],
            [propertyId],
            [propertyName],
            [propertyValue],
            [dataType],
            [UpdateColumn]
        )
        SELECT [x].[objId],
               [x].[MFVersion],
               [x].[GUID],
               [x].[ExternalID],
               [x].[propertyId],
               [mp].[Name],
               [x].[propertyValue],
               [x].[dataType],
               3
        FROM
            OPENXML(@Idoc, '/form/Object/properties', 1)
            WITH
            (
                [objId] INT '../@objectId',
                [MFVersion] INT '../@objVersion',
                [GUID] NVARCHAR(100) '../@objectGUID',
                [ExternalID] NVARCHAR(100) '../@DisplayID',
                [propertyId] INT '@propertyId',
                [propertyValue] NVARCHAR(100) '@propertyValue',
                [dataType] NVARCHAR(100) '@dataType'
            ) [x]
            LEFT JOIN [dbo].[MFProperty] [mp]
                ON [mp].[MFID] = [x].[propertyId];


        SET @RowCount = @@ROWCOUNT;
        UPDATE [#Summary]
        SET [RecCount] = @RowCount
        WHERE [UpdateColumn] = 3;



    END;

END;



-- @UpdateColumn = 4 
BEGIN



    IF @Debug > 0
    BEGIN
        SELECT @XML4 AS [SynchronizationError];
    END;

    INSERT INTO [#ObjectID_1]
    (
        [ObjectID],
        [UpdateColumn]
    )
    SELECT [t].[c].[value]('(@objectId)[1]', 'INT') [objectid],
           @UpdateColumn
    FROM @XML4.[nodes]('/form/Object') AS [t]([c]);

    SET @RowCount = @@ROWCOUNT;
    UPDATE [#Summary]
    SET [RecCount] = @RowCount
    WHERE [UpdateColumn] = 4;

END;

-- @UpdateColumn = 5 

BEGIN


    IF @Debug > 0
    BEGIN
        SELECT @XML5 AS [MFError];
    END;

    INSERT INTO [#ObjectID_1]
    (
        [ObjectID],
        [UpdateColumn]
    )
    SELECT [t].[c].[value]('(@objID)[1]', 'INT') [objectid],
           @UpdateColumn
    FROM @XML5.[nodes]('/form/errorInfo') AS [t]([c]);

    SET @RowCount = @@ROWCOUNT;
    UPDATE [#Summary]
    SET [RecCount] = @RowCount
    WHERE [UpdateColumn] = 5;

END;

-- @UpdateColumn 6

BEGIN


    IF @Debug > 0
    BEGIN
        SELECT @XML6 AS [DeletedObjectVer];
    END;

    CREATE TABLE [#ObjectID_6]
    (
        [ObjId] INT,
        [Updatecolumn] INT
    );


    INSERT INTO [#ObjectID_6]
    (
        [ObjId],
        [Updatecolumn]
    )
    SELECT [t].[c].[value]('(@objectID)[1]', 'INT') [objId],
           @UpdateColumn
    FROM @XML6.[nodes]('objVers') AS [t]([c]);

    SET @RowCount = @@ROWCOUNT;
    UPDATE [#Summary]
    SET [RecCount] = @RowCount
    WHERE [UpdateColumn] = 6;


END;

-- @UpdateColumn = 7

BEGIN

    IF @Debug > 0
    BEGIN

        SELECT @XML7 AS [ObjectDetails];
    END;

    IF @UpdateMethod = 1
    BEGIN

        EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @XML7;

        INSERT INTO [#ObjectID_3]
        (
            [objId],
            [MFVersion],
            [propertyId],
            [propertyName],
            [propertyValue],
            [dataType],
            [UpdateColumn]
        )
        SELECT [i].[pd].[value]('../../@objID', 'int') AS [ObjectType],
               [i].[pd].[value]('../../@objVesrion', 'int') AS [Version],
               [i].[pd].[value]('@id', 'int') AS [propertyId],
               [mp].[Name],
               [i].[pd].[value]('.', 'NVARCHAR(100)') AS [propertyValue],
               [i].[pd].[value]('@dataType', 'NVARCHAR(100)') AS [dataType],
               7
        FROM @XML7.[nodes]('/form/Object/class/property') AS [i]([pd])
            CROSS APPLY @XML7.[nodes]('/form') AS [t2]([c2])
            LEFT JOIN [dbo].[MFProperty] [mp]
                ON [mp].[MFID] = [i].[pd].[value]('@id', 'int');

        Select @RowCount = COUNT(*) FROM  [#ObjectID_3]
        UPDATE [#Summary]
        SET [RecCount] = @RowCount
        WHERE [UpdateColumn] = 7;

        IF @Debug > 0
        BEGIN
            SELECT @RowCount AS [UpdateColumn_7];
            SELECT *
            FROM [#ObjectID_3] AS [oi];
        END;

    END;


END;

IF @IsSummary = 1
BEGIN
    SELECT *
    FROM [#Summary];
END;

IF @IsSummary = 0
   AND @UpdateColumn IN ( 1, 2, 4, 5 )
BEGIN

    IF @Debug > 0
        SELECT *
        FROM [#ObjectID_1] AS [oi];

    SET @Param = '@UpdateColumn int';
    SET @Query
        = N'
							SELECT c.TableName,  t.* FROM #ObjectID_1  AS [ovd]						
							INNER JOIN ' + QUOTENAME(@TableName)
          + ' t
							ON ovd.[ObjectID] = t.[ObjID]
							inner join MFClass c
							on c.mfid = t.' + @ClassPropName + ' where ovd.updatecolumn = @UpdateColumn ';

    EXEC [sys].[sp_executesql] @Query, @Param, @UpdateColumn = @UpdateColumn;

END;

IF @IsSummary = 0
   AND @UpdateColumn = 6
BEGIN


    SELECT *
    FROM [#ObjectID_6] AS [oi];


END;


IF @IsSummary = 0
   AND @UpdateColumn = 7
BEGIN

    IF @Debug > 0
        SELECT *
        FROM [#ObjectID_1] AS [oi];

    SET @Param = '@UpdateColumn int';
    SET @Query
        = N'
							SELECT c.TableName,  t.* FROM #ObjectID_1  AS [ovd]						
							INNER JOIN ' + QUOTENAME(@TableName)
          + ' t
							ON ovd.[ObjectID] = t.[ID]
							inner join MFClass c
							on c.mfid = t.' + @ClassPropName + ' where ovd.updatecolumn = @UpdateColumn ';

    IF @Debug > 0
        PRINT @Query;

    EXEC [sys].[sp_executesql] @Query, @Param, @UpdateColumn = @UpdateColumn;
END;

IF @IsSummary <> 1
   AND @UpdateColumn = 3
BEGIN

    SELECT *
    FROM [#ObjectID_3] AS [oi]
    WHERE [oi].[UpdateColumn] = 3;

END;

IF @IsSummary = 0
   AND @UpdateColumn = 7
   AND
   (
       SELECT [UpdateMethod] FROM [#Summary] WHERE [UpdateColumn] = 0
   ) = 0
BEGIN

    SELECT *
    FROM [#ObjectID_3]
        AS
        [oi]
    WHERE [oi].[UpdateColumn] = 7
    ORDER BY [oi].[objId],
             [oi].[propertyId];

END;
DROP TABLE [#ObjectID_1];
DROP TABLE [#ObjectID_3];
DROP TABLE [#Summary];



GO

go

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFUpdateItemByItem]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'spMFUpdateItemByItem', -- nvarchar(100)
    @Object_Release = '2.1.1.13', -- varchar(50)
    @UpdateFlag = 2 -- smallint
go

/*-----------------------------------------------------------------------------------------------
  USAGE:
  =====
  debug mode
  DECLARE @Sessionid int
  EXEC [spMFUpdateItemByItem] 'MFOtherDocument', 1, @SessionIDOut = @SessionID output
  SELECT @SessionID
-----------------------------------------------------------------------------------------------*/

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFUpdateItemByItem'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateItemByItem]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFUpdateItemByItem]
    @TableName VARCHAR(100) ,
    @Debug SMALLINT = 0 ,
    @SingleItems BIT = 1, --1 = processed one by one, 0 = processed in blocks
    @SessionIDOut INT OUTPUT
AS
/*rST**************************************************************************

====================
spMFUpdateItemByItem
====================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @TableName varchar(100)
    Name of table to be updated
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode
  @SingleItems bit (optional)
    - Default = 1; processed one-by-one
    - 0 = processed in blocks
  @SessionIDOut int (output)
    Output of the session id that was used to update the results in the MFAuditHistory Table

Purpose
=======

This is a special procedure that is useful when there are data errors in M-Files and it is necessary to determine which specific records are not being able to be processed.

Additional Info
===============

Note that this procedure use updatemethod 1 by default.  It returns a session id.  this id can be used to inspect the result in the MFAuditHistory Table. Refer to Using Audit History for more information on this table

Examples
========

.. code:: sql

    DECLARE @RC INT
    DECLARE @TableName VARCHAR(100) = 'MFCustomer'
    DECLARE @Debug SMALLINT
    DECLARE @SessionIDOut INT

    -- TODO: Set parameter values here.
    EXECUTE @RC = [dbo].[spMFUpdateItemByItem]
                        @TableName
                       ,@Debug
                       ,@SessionIDOut OUTPUT
    SELECT @SessionIDOut

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/
 /*
update check by record from objvers list
*/
    SET NOCOUNT ON;

    BEGIN
        BEGIN TRY
    

            DECLARE @ClassName VARCHAR(100) ,
                @ProcedureStep VARCHAR(100) = 'Start' ,
                @ProcedureName VARCHAR(100) = 'spMFUpdateItemByItem' ,
                @Result INT ,
                @RunTime DATETIME ,
                @Query NVARCHAR(MAX);

            SELECT  @ClassName = Name
            FROM    MFClass
            WHERE   [MFClass].[TableName] = @TableName; 
            SET @Query = N'SELECT OBJECT_ID(''' + @TableName + ''')';
            EXEC @Result = sp_executesql @Query;

            IF @Debug > 0
                SELECT  @Result;

            IF @Result = 0
                BEGIN
                    EXEC [dbo].[spMFCreateTable] @ClassName = @ClassName;-- nvarchar(128)
                END;

            DECLARE @NewXML XML ,
                @NewObjectXml VARCHAR(MAX); 

            EXEC [dbo].[spMFGetObjectvers] @TableName = @TableName, -- nvarchar(max)
                @dtModifiedDate = NULL, -- datetime
                @MFIDs = NULL, -- nvarchar(max)
                @outPutXML = @NewObjectXml OUTPUT;
 -- nvarchar(max)

            IF @Debug <> 0
                SELECT  @NewObjectXml;

            CREATE TABLE #ObjVersList
                (
                  ObjectType INT ,
                  [ObjID] INT ,
                  [MFVersion] INT ,
                  UpdateStatus INT
                );

            SET @NewXML = CAST(@NewObjectXml AS XML);
            IF @Debug = 2
                BEGIN
                    SELECT  @NewXML;
                    SELECT  t.c.value('(@version)[1]', 'INT') AS [MFVersion] ,
                            t.c.value('(@objectID)[1]', 'INT') AS [ObjID] ,
                            t.c.value('(@objectType)[1]', 'INT') AS [ObjectType]
                    FROM    @NewXML.nodes('/form/objVers') AS t ( c );
                END;

            INSERT  INTO [#ObjVersList]
                    ( [MFVersion] ,
                      [ObjID] ,
                      [ObjectType] 
                 
                    )
                    SELECT  t.c.value('(@version)[1]', 'INT') AS [MFVersion] ,
                            t.c.value('(@objectID)[1]', 'INT') AS [ObjID] ,
                            t.c.value('(@objectType)[1]', 'INT') AS [ObjectType]
                    FROM    @NewXML.nodes('/form/objVers') AS t ( c );
 
            DECLARE @Objids VARCHAR(10) ,
                @Objid INT ,
                @ReturnValue INT;
            SELECT  @Objid = CAST(MIN([ObjID]) AS VARCHAR(10))
            FROM    [#ObjVersList] AS [ovl]; 

			
			DECLARE @session int
			EXEC [dbo].[spMFTableAudit] @MFTableName = @TableName, -- nvarchar(128)
			    @MFModifiedDate = null, -- datetime
			    @ObjIDs = null, -- nvarchar(2500)
			    @Debug = 0, -- smallint
			    @SessionIDOut = @session output, -- int
			    @NewObjectXml = N'' -- nvarchar(max)
			
			DECLARE @Deletelist AS TABLE ([Objid] int)
			INSERT INTO @Deletelist
			        ( [Objid] )
			
			SELECT mah.[objid] FROM [dbo].[MFAuditHistory] AS [mah]
			INNER JOIN [#ObjVersList] AS [ovl]
			ON [ovl].[ObjID] = [mah].[ObjID]

			WHERE [mah].[SessionID] = @session AND [mah].[StatusFlag] <> 0

--			DELETE FROM [#ObjVersList] WHERE objid IN (SELECT objid FROM @Deletelist AS [d])

 
            WHILE EXISTS ( SELECT   ObjID
                           FROM     [#ObjVersList] AS [ovl]
                           WHERE    ObjID > @Objid )
                BEGIN
 
 
                    SELECT TOP 1
                            @Objid = ObjID
                    FROM    [#ObjVersList] AS [ovl]
                    WHERE   [ObjID] > @Objid
                    ORDER BY [ObjID];

                    IF @Debug <> 0
                        SELECT  @Objid AS nextObjid;

                    SET @Objids = CAST(@Objid AS VARCHAR(10)); 

UPDATE [mah]
SET UpdateFlag = 1

FROM [dbo].[MFAuditHistory] AS [mah] WHERE objid = @objid
              
SET @ProcedureStep = 'Updating object '+ @Objids 

                    EXEC @ReturnValue = [dbo].[spMFUpdateTable] @MFTableName = @TableName, -- nvarchar(128)
                        @UpdateMethod = 1, -- int
                        @UserId = NULL, -- nvarchar(200)
                        @MFModifiedDate = NULL, -- datetime
                        @ObjIDs = @ObjIDs, -- nvarchar(2500)
                        @Debug = 0; -- smallint

                    UPDATE  [#ObjVersList]
                    SET     [#ObjVersList].[UpdateStatus] = @ReturnValue
                    WHERE   ObjID = @Objid;

IF @ReturnValue <> 1
BEGIN
 INSERT  INTO MFLog
                    ( SPName ,
                      ProcedureStep ,
                      ErrorNumber ,
                      ErrorMessage ,
                      ErrorProcedure ,
                      ErrorState ,
                      ErrorSeverity ,
                      ErrorLine
                    )
            VALUES  ( @ProcedureName ,
                      @ProcedureStep ,
                      ERROR_NUMBER() ,
                      'Failed to process object' ,
                      'MFUpdateTable',
                      ERROR_STATE() ,
                      ERROR_SEVERITY() ,
                      ERROR_LINE()
                    );

END


                END;

            IF @Debug > 0
                BEGIN
                    SELECT  *
                    FROM    [#ObjVersList] AS [ovl];
                END;
	
			-----------------------------------------------------
			--Set Object Type Id and class id
			-----------------------------------------------------
            SET @ProcedureStep = 'Get Object Type and Class';

            DECLARE @objectIDRef INT ,
                @objectID INT ,
                @ClassID INT;
            SELECT  @objectIDRef = mc.MFObjectType_ID ,
                    @objectID = ob.MFID ,
                    @ClassID = mc.MFID
            FROM    dbo.MFClass mc
                    INNER JOIN dbo.MFObjectType ob ON ob.[ID] = mc.[MFObjectType_ID]
            WHERE   mc.TableName = @TableName;

            SELECT  @objectID = MFID
            FROM    dbo.MFObjectType
            WHERE   ID = @objectIDRef;

            IF @Debug > 0
                BEGIN
                    RAISERROR('Proc: %s Step: %s ObjectType: %i Class: %i',10,1,@ProcedureName, @ProcedureStep,@objectID, @ClassID);
                    IF @Debug = 2
                        BEGIN
                            SELECT  *
                            FROM    MFClass
                            WHERE   MFID = @ClassID;
                        END;
                END;
		
            IF @Debug > 0
                BEGIN
                    RAISERROR('Proc: %s Step: %s ',10,1,@ProcedureName, @ProcedureStep );
                           
                END;

            DECLARE @SessionID INT ,
                @TranDate DATETIME ,
                @Params NVARCHAR(MAX);
            SELECT  @TranDate = GETDATE();
            SELECT  @SessionID = ( SELECT   MAX(SessionID) + 1
                                   FROM     dbo.MFAuditHistory
                                 );
            SELECT  @SessionID = ISNULL(@SessionID, 1);

            SELECT  @SessionIDOut = @SessionID;

            BEGIN TRANSACTION;
            SET @ProcedureStep = 'Insert records into Audit History';

            SET @Params = N'@SessionID int, @TranDate datetime, @ObjectID int, @ClassID int';
            SELECT  @Query = N'INSERT INTO [dbo].[MFAuditHistory]
        ( RecID,
		[SessionID] ,
          [TranDate] ,
          [ObjectType] ,
          [Class] ,
          [ObjID] ,
          [MFVersion] ,
          [StatusFlag] ,
          [StatusName]
        )
                   
					SELECT 
					 t.[ID],
					@SessionID,
					@TranDate,
					@objectID,
					@ClassID,
                    CASE WHEN ao.[ObjID] IS NULL
                                            THEN t.[ObjID]
                                            ELSE ao.[ObjID]
                                       END ,
					ao.MFVersion,
                            CASE				WHEN t.Deleted = 1
                                                 THEN 3 --- Marked DELETED in SQL
												 WHEN ao.[MFVersion] IS NULL and isnull(t.deleted,0) = 0
                                                 THEN  4 --SQL to be deleted
                                                 WHEN ao.[MFVersion] = ISNULL(t.[MFVersion],
                                                              -1) and isnull(t.deleted,0) = 0 THEN 0 -- CURRENT VERSIONS ARE THE SAME
                                                 WHEN ao.[MFVersion] < ISNULL(t.[MFVersion],
                                                              -1) THEN 2 -- SQL version is later than M-Files - Sync error
                                                 WHEN t.[MFVersion] is null and ao.[MFVersion] is not null
                                                               THEN 5 -- new in SQL
												 WHEN ao.[MFVersion] > t.[MFVersion] and t.deleted = 0
                                                               THEN 1 -- MFiles is more up to date than SQL
                                            END,
							CASE				WHEN  t.deleted = 1 
                                                 THEN ''Deleted in MF''
										WHEN ao.[MFVersion]  IS NULL and isnull(t.deleted,0) = 0
                                                 THEN ''SQL to be deleted''
                                                 WHEN ao.[MFVersion] = ISNULL(t.[MFVersion],-1) THEN ''Identical''
                                                 WHEN ao.[MFVersion] < ISNULL(t.[MFVersion],-1) THEN ''SQL is later''
                                                 WHEN t.[MFVersion] is null and ao.[MFVersion] is not null
                                                               THEN ''New in SQL''
												 WHEN ao.[MFVersion] > t.[MFVersion] and t.deleted = 0 THEN ''MF is Later''
                                            END
                    FROM    [#ObjVerslist] AS [ao]
                            FULL OUTER JOIN [dbo].' + @TableName
                    + ' AS t ON t.[ObjID] = ao.[ObjID]
							;';


							
            IF @Debug > 0
                BEGIN                            
                    RAISERROR('Proc: %s Step: %s',10,1,@ProcedureName, @ProcedureStep);
                END; 



            EXEC sp_executesql @Query, @Params, @SessionID = @SessionID,
                @TranDate = @TranDate, @ObjectID = @objectID,
                @ClassId = @ClassID;

            SET @ProcedureStep = 'Update Processed';
							
            COMMIT TRAN [main];
            DROP TABLE [#ObjVersList];
           
            SET NOCOUNT OFF;

        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT <> 0
                BEGIN
                    ROLLBACK TRANSACTION;
                END;

            SET NOCOUNT ON;

            IF @Debug > 0
                BEGIN
                    SELECT  ERROR_NUMBER() AS ErrorNumber ,
                            ERROR_MESSAGE() AS ErrorMessage ,
                            ERROR_PROCEDURE() AS ErrorProcedure ,
                            @ProcedureStep AS ProcedureStep ,
                            ERROR_STATE() AS ErrorState ,
                            ERROR_SEVERITY() AS ErrorSeverity ,
                            ERROR_LINE() AS ErrorLine;
                END;

            SET NOCOUNT OFF;

            RETURN 2; --For More information refer Process Table

        END CATCH;
    END;


GO
GO

PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].spMFClassTableColumns';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFClassTableColumns'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.4.11.53'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO


IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFClassTableColumns' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFClassTableColumns]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFClassTableColumns] 
AS
/*rST**************************************************************************

=====================
spMFClassTableColumns
=====================

Return
  - 1 = Success
  - 0 = Partial (some records failed to be inserted)
  - -1 = Error
Parameters
  @Debug smallint (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

This special procedure analyses the M-Files classes and show types of columns and any potential anomalies between the metadata structure and the columns for the table in SQL.

Additional Info
===============

The report include some columns  to extract and compare data and other columns to interpret or report a status.  Each row represents a property / Class relationship. A listing by class would show all the properties applied on the class, both defined on the metadata card and added ad hoc to the class.  Filtered by property it will show all the classes where the property has been applied to.

Key result columns in report:

ColumnType
  Show the type of usage of the property:

  - Additional property
  - Lookup label
  - M-Files system (related to metadata class)
  - Excluded from M-Files (not related to M-Files properties)
  - MFSQL system property (used for SQL processes)
  - Not used (M-Files property not used in SQL)
Additional Property
  Property column is on class table, but the property is not included in the metadata configuration
Lookup type
  Show if the lookup property relates to a valuelist, another class table, or workflow
Column DataType Error
  Show if there is a miss match between the SQL column data type definition and M-Files data type definition.
Missing Columns
  Show properties on the metadata table that is not included in the class table
Missing Table
  Slow classes defined as included in property but the class table is missing
Redundant table
  Show if class table exist but it is not included in app in class table

The listing will identify the columns added to the table related to Additional properties.

The procedure combines the data from various dimensions including:

- MFProperty + MFClass + MFClassProperty for the M-Files property and class usage
- InformationSchema + MFDataType to compare the structure with the deployment of the structure in SQL

The following design considerations are supported by this result set:

- The use of ad hoc properties on classes.

Examples
========

.. code:: sql

    EXEC [dbo].[spMFClassTableColumns] -- nvarchar(200)
    --review result
    SELECT * FROM ##spMFClassTableColumns

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2019-08-29  LC         Add predefined or automatic column
2019-06-07  LC         Add error for lookup column label with incorrect length
2019-03-25  LC         Add error checking for text columns that is not varchar 200
2019-01-19  LC         Change datatype from bit to smallint for error columns
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    SET NOCOUNT ON;

    IF
    (
        SELECT ISNULL(OBJECT_ID('tempdb..##spMFClassTableColumns'), 0)
    ) > 0
        DROP TABLE [##spMFClassTableColumns];



    --SELECT * FROM [dbo].[MFvwClassTableColumns] AS [mfctc]
    DECLARE @IsUpToDate BIT;

    EXEC [dbo].[spMFGetMetadataStructureVersionID] @IsUpToDate = @IsUpToDate OUTPUT; -- bit

    IF @IsUpToDate = 0
    BEGIN
        EXEC [dbo].[spMFSynchronizeSpecificMetadata] @Metadata = 'Property'; -- varchar(100)

        EXEC [dbo].[spMFSynchronizeSpecificMetadata] @Metadata = 'Class'; -- varchar(100)
    END;

    CREATE TABLE [##spMFClassTableColumns]
    (
        [id] INT IDENTITY
       ,[ColumnType] NVARCHAR(100)
       ,[Class] NVARCHAR(200)
       ,[TableName] NVARCHAR(200)
       ,[Property] NVARCHAR(100)
       ,[Property_MFID] INT
       ,[columnName] NVARCHAR(100)
       ,[AdditionalProperty] BIT
       ,[IncludedInApp] BIT
       ,[Required] BIT
	   ,PredefinedOrAutomatic bit
       ,[LookupType] NVARCHAR(100)
       ,[MFdataType_ID] INT
       ,[MFDataType] NVARCHAR(100)
       ,[column_DataType] NVARCHAR(100)
       ,[length] INT
       ,[ColumnDataTypeError] smallint
       ,[MissingColumn] smallint
       ,[MissingTable] smallint
       ,[RedundantTable] smallint
    );

    INSERT INTO [##spMFClassTableColumns]
    (
        [Property]
       ,[Property_MFID]
       ,[columnName]
       ,[Class]
       ,[TableName]
       ,[IncludedInApp]
       ,[Required]
	   ,PredefinedOrAutomatic
       ,[LookupType]
       ,[MFdataType_ID]
       ,[MFDataType]
       ,[AdditionalProperty]
    )
    SELECT [mp2].[Name] [property]
          ,[mp2].[MFID]
          ,[mp2].[ColumnName]
          ,[mc2].[Name] AS [class]
          ,[mc2].[TableName]
          ,[mc2].[IncludeInApp]
          ,[mcp2].[Required]
		  ,[mp2].[PredefinedOrAutomatic]
          ,CASE
               WHEN [mvl].[RealObjectType] = 1
                    AND [mdt].[MFTypeID] IN ( 9, 10 ) THEN
                   'ClassTable_' + [mvl].[Name]
               WHEN [mvl].[RealObjectType] = 0
                    AND [mvl].[Name] NOT IN ( 'class', 'Workflow', 'Workflow State' )
                    AND [mdt].[MFTypeID] IN ( 9, 10 ) THEN
                   'Table_MFValuelist_' + [mvl].[Name]
           END
          ,[mdt].[MFTypeID]
          ,[mdt].[Name]
          ,0
    --select *
    FROM [dbo].[MFProperty]                AS [mp2]
        INNER JOIN [dbo].[MFClassProperty] AS [mcp2]
            ON [mcp2].[MFProperty_ID] = [mp2].[ID]
        INNER JOIN [dbo].[MFClass]         AS [mc2]
            ON [mc2].[ID] = [mcp2].[MFClass_ID]
        INNER JOIN [dbo].[MFDataType]      AS [mdt]
            ON [mdt].[ID] = [mp2].[MFDataType_ID]
        INNER JOIN [dbo].[MFValueList]     AS [mvl]
            ON [mvl].[ID] = [mp2].[MFValueList_ID]
    --		WHERE mc2.name = 'Customer';
    ;

    MERGE INTO [##spMFClassTableColumns] [t]
    USING
    (
        SELECT [sc].[name]         AS [ColumnName]
              ,[sc].[max_length]   AS [length]
              ,[sc].[is_nullable]
              ,[st].[name]         AS [TableName]
              ,[t].[name]          AS [Column_DataType]
              ,[mc].[Name]         AS [class]
              ,[mc].[IncludeInApp] AS [IncludedInApp]
        FROM [sys].[columns]           [sc]
            INNER JOIN [sys].[tables]  [st]
                ON [st].[object_id] = [sc].[object_id]
            INNER JOIN [dbo].[MFClass] AS [mc]
                ON [mc].[TableName] = [st].[name]
            INNER JOIN [sys].[types]   AS [t]
                ON [sc].[user_type_id] = [t].[user_type_id]
    ) [s]
    ON [s].[ColumnName] = [t].[ColumnName]
       AND [s].[TableName] = [t].[TableName]
    WHEN MATCHED THEN
        UPDATE SET [t].[Column_Datatype] = [s].[Column_DataType]
                  ,[t].[Length] = [s].[length]
                  ,[t].[IncludedInApp] = [s].[IncludedInApp]
    WHEN NOT MATCHED THEN
        INSERT
        (
            [TableName]
           ,[ColumnName]
           ,[Column_DataType]
           ,[length]
           ,[class]
           ,[IncludedInApp]
        )
        VALUES
        ([s].[TableName], [s].[ColumnName], [s].[Column_DataType], [s].[length], [s].[class], [s].[IncludedInApp]);

    UPDATE [##spMFClassTableColumns]
    SET [Property] = [mp].[Name]
       ,[Property_MFID] = [mp].[MFID]
       ,[MFdataType_ID] = [mdt].[MFTypeID]
       ,[MFDataType] = [mdt].[Name]
       ,[Required] = 0
    ,[LookupType] = CASE
                           WHEN [mp].[MFID] = 100 THEN
                               'Table_MFClass'
                           WHEN [mp].[MFID] = 38 THEN
                               'Table_MFWorkflow'
                           WHEN [mp].[MFID] = 39 THEN
                               'Table_MFWorkflowState'
							  END
		
	FROM [##spMFClassTableColumns]    AS [pc]
        INNER JOIN [dbo].[MFProperty] AS [mp]
            ON [pc].[columnName] = [mp].[ColumnName]
        INNER JOIN [dbo].[MFDataType] [mdt]
            ON [mp].[MFDataType_ID] = [mdt].[ID]
    WHERE [pc].[Property] IS NULL;

    UPDATE [##spMFClassTableColumns]
    SET [AdditionalProperty] = CASE
                                   WHEN [pc].[Property] IN ( 'GUID', 'Objid', 'MFVersion', 'ExternalID' ) THEN
                                       0
                                   WHEN [pc].[columnName] IN ( 'ID', 'Process_id', 'Lastmodified', 'FileCount'
                                                              ,'Deleted', 'Update_ID'
                                                             ) THEN
                                       0
                                   WHEN SUBSTRING([pc].[columnName], 1, 2) = 'MX' THEN
                                       0
                                   WHEN [pc].[Property_MFID] > 101
                                        AND [pc].[AdditionalProperty] IS NULL THEN
                                       1
                               END
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[AdditionalProperty] IS NULL;

  
    UPDATE [##spMFClassTableColumns]
    SET [ColumnType] = CASE
                           WHEN [IncludedInApp] IS NULL
                                AND [column_DataType] IS NULL THEN
                               'Not used'
                           WHEN [Property_MFID] > 100
                                AND [AdditionalProperty] = 0 THEN
                               'Metadata Card Property'
                           WHEN [AdditionalProperty] = 1 THEN
                               'Additional Property'
                           WHEN [Property_MFID] < 101 THEN
                               'MFSystem Property'
                           WHEN [columnName] IN ( 'GUID', 'Objid', 'MFVersion', 'ExternalID' ) THEN
                               'MFSystem Property'
                           WHEN [columnName] IN ( 'ID', 'Process_id', 'Lastmodified', 'FileCount', 'Deleted'
                                                 ,'Update_ID'
                                                ) THEN
                               'MFSQL System Property'
                           WHEN SUBSTRING([columnName], 1, 2) = 'MX' THEN
                               'Excluded from MF'
                           WHEN [Property] IS NULL
                                AND [IncludedInApp] = 1
                                AND [ColumnType] IS NULL THEN
                               'Lookup Lable Column'
                       END;

					         
WITH [cte]
AS (SELECT REPLACE([columnName], '_ID', '') AS [columnname]
          ,[columnType]
          ,[Property]
          ,[Property_MFID]
          ,[lookupType]
          ,[MFdatatype]
          ,[MFDataType_ID]
    FROM [##spMFClassTablecolumns]
    WHERE [MFDataType_ID] IN ( 9, 10 )
          AND [columnname] LIKE '%_ID')
UPDATE [c]
SET [columnType] = 'Lookup Lable Column'
   ,[lookupType] = [cte].[lookuptype]
   ,[property] = [cte].[property]
   ,[property_mfid] = [cte].[property_mfid]
   ,[MFDataType] = [cte].[MFDataType]
   ,[MFDatatype_ID] = [cte].[MFDatatype_ID]
--SELECT *
FROM [cte]
    INNER JOIN [##spMFClassTablecolumns] [c]
        ON [cte].[columnname] = [c].[columnname]
WHERE [c].[property_mfid] IS NULL;

  UPDATE [##spMFClassTableColumns]
    SET [MissingColumn] = 1
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[IncludedInApp] IS NOT NULL
          AND [pc].[column_DataType] IS NULL;

    UPDATE [##spMFClassTableColumns]
    SET [RedundantTable] = 1
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[IncludedInApp] IS NULL
          AND [pc].[column_DataType] IS NOT NULL;

    UPDATE [##spMFClassTableColumns]
    SET [MissingTable] = 1
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[IncludedInApp] IS NOT NULL
          AND [pc].[column_DataType] IS NULL
          AND [pc].[MissingColumn] IS NULL;

		      UPDATE [##spMFClassTableColumns]
    SET [ColumnDataTypeError] = 1
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[MFdataType_ID] in (1)
          AND [pc].[length] <> 200
          AND [pc].[IncludedInApp] = 1;

    UPDATE [##spMFClassTableColumns]
    SET [ColumnDataTypeError] = 1
    FROM [##spMFClassTableColumns] AS [pc]
    WHERE [pc].[MFdataType_ID] in (10,13)
          AND [pc].[length] <> 8000
          AND [pc].[IncludedInApp] IS NOT NULL;


--SELECT *
--FROM [##spMFClassTableColumns] AS [pc]
--WHERE [pc].[TableName] = @TableName
--      OR @TableName IS NULL
--ORDER BY [pc].[TableName]
--        ,[pc].[columnName];
END;
GO
GO
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFUpdateExplorerFileToMFiles]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFUpdateExplorerFileToMFiles'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.3.09.48'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFUpdateExplorerFileToMFiles' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFUpdateExplorerFileToMFiles]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE [dbo].[spMFUpdateExplorerFileToMFiles]
    @FileName NVARCHAR(256)
   ,@FileLocation NVARCHAR(256)
   ,@MFTableName NVARCHAR(100)
   ,@SQLID INT
   ,@IsFileDelete BIT = 0
   ,@ProcessBatch_id INT = NULL OUTPUT
   ,@Debug INT = 0
AS
/*rST**************************************************************************

==============================
spMFUpdateExplorerFileToMFiles
==============================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @FileName nvarchar(256)
    Name of file
  @FileLocation nvarchar(256)
    UNC path or Fully qualified path to file
  @MFTableName nvarchar(100)
    - Valid Class TableName as a string
    - Pass the class table name, e.g.: 'MFCustomer'
  @SQLID int
    the ID column on the class table
  @IsFileDelete bit (optional)
    - Default = 0
    - 1 = the file should be deleted in folder
  @ProcessBatch\_id int (output)
    Output ID in MFProcessBatch for logging the process
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

MFSQL Connector file import provides the capability of attaching a file to a object in a class table.

Additional Info
===============

This functionality will:

- Add the file to an object.  If the object exist as a multidocument object with no files attached, the file will be added to the multidocument object and converted to a single file object.  If the files already exist for the object, the file will be added to the collection.
- The object must pre-exist in the class table. The class table metadata will be applied to object when adding the file. This procedure will add a new object from the class table, or update an existing object in M-Files using the class table metadata.
- The source file will optionally be deleted from the source folder.

Warnings
========

The procedure use the ID in the class table and not the objid column to reference the object.  This allows for referencing an record which does not yet exist in M-Files.

Examples
========

.. code:: sql

    DECLARE @ProcessBatch_id INT;
    DECLARE @FileLocation NVARCHAR(256) = 'C:\Share\Fileimport\2\'
    DECLARE @FileName NVARCHAR(100) = 'CV - Tommy Hart.docx'
    DECLARE @TableName NVARCHAR(256) = 'MFOtherDocument'
    DECLARE @SQLID INT = 1

    EXEC [dbo].[spMFUpdateExplorerFileToMFiles]
        @FileName = @FileName
       ,@FileLocation = @FileLocation
       ,@SQLID = @SQLID
       ,@MFTableName = @TableName
       ,@ProcessBatch_id = @ProcessBatch_id OUTPUT
       ,@Debug = 0
       ,@IsFileDelete = 0

    SELECT * from [dbo].[MFFileImport] AS [mfi]

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        -----------------------------------------------------
        --DECLARE VARIABLES FOR LOGGING
        -----------------------------------------------------
        DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
        DECLARE @DebugText AS NVARCHAR(256) = '';
        DECLARE @LogTypeDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
        DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
        DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
        DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
        DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
        DECLARE @ProcessType NVARCHAR(50) = 'Object History';
        DECLARE @LogType AS NVARCHAR(50) = 'Status';
        DECLARE @LogText AS NVARCHAR(4000) = 'Get History Initiated';
        DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
        DECLARE @Status AS NVARCHAR(128) = NULL;
        DECLARE @Validation_ID INT = NULL;
        DECLARE @StartTime AS DATETIME = GETUTCDATE();
        DECLARE @RunTime AS DECIMAL(18, 4) = 0;
        DECLARE @Update_IDOut INT;
        DECLARE @error AS INT = 0;
        DECLARE @rowcount AS INT = 0;
        DECLARE @return_value AS INT;
        DECLARE @RC INT;
        DECLARE @Update_ID INT;
        DECLARE @ProcedureName sysname = 'spMFUpdateExplorerFileToMFiles';
        DECLARE @ProcedureStep sysname = 'Start';

        ----------------------------------------------------------------------
        --GET Vault LOGIN CREDENTIALS
        ----------------------------------------------------------------------
        DECLARE @Username NVARCHAR(2000);
        DECLARE @VaultName NVARCHAR(2000);

        SELECT TOP 1
               @Username  = [Username]
              ,@VaultName = [VaultName]
        FROM [dbo].[MFVaultSettings];

        INSERT INTO [dbo].[MFUpdateHistory]
        (
            [Username]
           ,[VaultName]
           ,[UpdateMethod]
        )
        VALUES
        (@Username, @VaultName, -1);

        SELECT @Update_ID = @@Identity;

        SELECT @Update_IDOut = @Update_ID;

        SET @ProcessType = 'Import File';
        SET @LogText = ' Started ';
        SET @LogStatus = 'Initiate';
        SET @StartTime = GETUTCDATE();
        SET @LogTypeDetail = 'Debug';
        SET @LogStatusDetail = 'In Progress';

        EXECUTE @RC = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                                     ,@ProcessType = @ProcessType
                                                     ,@LogType = @LogType
                                                     ,@LogText = @LogText
                                                     ,@LogStatus = @LogStatus
                                                     ,@debug = 0;

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @MFTableName
                                                                     ,@Validation_ID = @Validation_ID
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = 0;

        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        ----------------------------------------
        --DECLARE VARIABLES
        ----------------------------------------
        DECLARE @TargetClassMFID INT;
        DECLARE @ObjectTypeID INT;
        DECLARE @VaultSettings NVARCHAR(MAX);
        DECLARE @XML NVARCHAR(MAX);
        --     DECLARE @Counter INT;
        DECLARE @MaxRowID INT;
        DECLARE @ObjIDs NVARCHAR(4000);
        DECLARE @Objid INT;
        DECLARE @Sql NVARCHAR(MAX);
        DECLARE @Params NVARCHAR(MAX);
        DECLARE @FileID NVARCHAR(250);
        DECLARE @ParmDefinition NVARCHAR(500);
        DECLARE @XMLOut        XML
               ,@ObjectVersion INT;
        DECLARE @Start INT;
        DECLARE @End INT;
        DECLARE @length INT;
        DECLARE @SearchTerm NVARCHAR(50) = 'System.';

        SET @ProcedureStep = 'Checking Target class ';
        SET @DebugText = '';
        SET @DebugText = @DefaultDebugText + @DebugText;

        IF @Debug > 0
        BEGIN
            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;

        IF EXISTS
        (
            SELECT TOP 1
                   *
            FROM [dbo].[MFClass]
            WHERE [TableName] = @MFTableName
        )
        BEGIN
            SET @LogTextDetail = @MFTableName + ' is valid MFClass table';

            EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                         ,@LogType = @LogTypeDetail
                                                                         ,@LogText = @LogTextDetail
                                                                         ,@LogStatus = @LogStatusDetail
                                                                         ,@StartTime = @StartTime
                                                                         ,@MFTableName = @MFTableName
                                                                         ,@Validation_ID = @Validation_ID
                                                                         ,@ColumnName = @LogColumnName
                                                                         ,@ColumnValue = @LogColumnValue
                                                                         ,@Update_ID = @Update_ID
                                                                         ,@LogProcedureName = @ProcedureName
                                                                         ,@LogProcedureStep = @ProcedureStep
                                                                         ,@debug = 0;

            SELECT @TargetClassMFID = [MC].[MFID]
                  ,@ObjectTypeID    = [OT].[MFID]
            FROM [dbo].[MFClass]                [MC]
                INNER JOIN [dbo].[MFObjectType] [OT]
                    ON [MC].[MFObjectType_ID] = [OT].[ID]
            WHERE [MC].[TableName] = @MFTableName;

            ------------------------------------------------
            --Getting Vault Settings
            ------------------------------------------------
            SET @DebugText = '';
            SET @DebugText = @DefaultDebugText + @DebugText;
            SET @ProcedureStep = 'Getting Vault credentials ';

            IF @Debug > 0
            BEGIN
                RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
            END;

            SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();

            DECLARE @TempFile VARCHAR(100);

            -------------------------------------------------------------
            -- 
            -------------------------------------------------------------
            SET @ProcedureStep = ' import file from source ';

            --               WHILE @Counter IS NOT NULL
            BEGIN

                -------------------------------------------------------------
                -- Get objid for record
                -------------------------------------------------------------
                SET @ProcedureStep = 'Get latest version';
                SET @Params = N'@ObjID INT output, @SQLID int';
                SET @Sql
                    = N'Select @ObjID = Objid FROM ' + QUOTENAME(@MFTableName) + ' WHERE ID = '
                      + CAST(@SQLID AS VARCHAR(10));

                PRINT @Sql;

                EXEC [sys].[sp_executesql] @Sql, @Params, @Objid OUTPUT, @SQLID;

                SELECT @ObjIDs = CAST(@Objid AS VARCHAR(4000));

                SELECT @Objid AS '@ObjId';

                SET @DebugText = ' Objids %s';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Get Objids for update';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @ObjIDs);
                END;

                -------------------------------------------------------------
                -- get latest version of object
                -------------------------------------------------------------	
                IF @Objid IS NOT NULL
                BEGIN
                    SET @Params = N'@Objid int';
                    SET @Sql = N'UPDATE ' + QUOTENAME(@MFTableName) + ' SET [Process_ID] = 0 WHERE objid = @Objid';

                    EXEC [sys].[sp_executesql] @Sql, @Params, @Objid;

                    EXEC [dbo].[spMFUpdateTable] @MFTableName = @MFTableName          -- nvarchar(200)
                                                ,@UpdateMethod = 1                    -- int                          
                                                ,@ObjIDs = @ObjIDs                    -- nvarchar(max)
                                                ,@Update_IDOut = @Update_IDOut OUTPUT -- int
                                                ,@ProcessBatch_ID = @ProcessBatch_id;

                    -- int
                    SET @Params = N'@ObjectVersion int output,@Objid int';
                    SET @Sql
                        = N' SELECT @ObjectVersion=MFVersion from ' + QUOTENAME(@MFTableName)
                          + ' where objid = 
                          @ObjID;';

                    --            PRINT @Sql;
                    EXEC [sys].[sp_executesql] @Sql, @Params, @ObjectVersion OUTPUT, @Objid;
                END;

                IF @Objid IS NULL
                BEGIN
                    SET @Params = N'@Objid int';
                    SET @Sql = N'UPDATE ' + QUOTENAME(@MFTableName) + ' SET [Process_ID] = 1 WHERE objid = @Objid';

                    EXEC [sys].[sp_executesql] @Sql, @Params, @Objid;

                    EXEC [dbo].[spMFUpdateTable] @MFTableName = @MFTableName          -- nvarchar(200)
                                                ,@UpdateMethod = 0                    -- int                          
                                                ,@ObjIDs = @ObjIDs                    -- nvarchar(max)
                                                ,@Update_IDOut = @Update_IDOut OUTPUT -- int
                                                ,@ProcessBatch_ID = @ProcessBatch_id; -- int

                    SET @Params = N'@ObjectVersion int output,@Objid int';
                    SET @Sql
                        = N' SELECT @ObjectVersion=MFVersion from ' + QUOTENAME(@MFTableName)
                          + ' where objid = @ObjID;';

                    --           PRINT @Sql;
                    EXEC [sys].[sp_executesql] @Sql, @Params, @ObjectVersion OUTPUT, @Objid;
                END;

                IF @Debug > 0
                    SELECT @Objid         AS [Objid]
                          ,@ObjIDs        AS [Objids]
                          ,@ObjectVersion AS [Version];

                -----------------------------------------------------
                --Creating the xml 
                ----------------------------------------------------
                DECLARE @Query NVARCHAR(MAX);

                SET @ProcedureStep = 'Prepare ColumnValue pair';

                DECLARE @ColumnValuePair TABLE
                (
                    [ColunmName] NVARCHAR(200)
                   ,[ColumnValue] NVARCHAR(4000)
                   ,[Required] BIT ---Added for checking Required property for table
                );

                DECLARE @TableWhereClause VARCHAR(1000)
                       ,@tempTableName    VARCHAR(1000)
                       ,@XMLFile          XML;

                SET @TableWhereClause = 'y.ID = ' + CAST(@SQLID AS VARCHAR(20));
                --+'  

                --IF @Debug > 0
                --    PRINT @TableWhereClause;

                ----------------------------------------------------------------------------------------------------------
                --Generate query to get column values as row value
                ----------------------------------------------------------------------------------------------------------
                SET @ProcedureStep = 'Prepare query';

                SELECT @Query
                    = STUFF(
                      (
                          SELECT ' UNION ' + 'SELECT ''' + [COLUMN_NAME] + ''' as name, CONVERT(VARCHAR(max),['
                                 + [COLUMN_NAME] + ']) as value, 0  as Required FROM [' + @MFTableName + '] y'
                                 + ISNULL('  WHERE ' + @TableWhereClause, '')
                          FROM [INFORMATION_SCHEMA].[COLUMNS]
                          WHERE [TABLE_NAME] = @MFTableName
                          FOR XML PATH('')
                      )
                     ,1
                     ,7
                     ,''
                           );

                --IF @Debug > 0
                --    PRINT @Query;
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                -----------------------------------------------------
                --List of columns to exclude
                -----------------------------------------------------
                SET @ProcedureStep = 'Prepare exclusion list';

                DECLARE @ExcludeList AS TABLE
                (
                    [ColumnName] VARCHAR(100)
                );

                INSERT INTO @ExcludeList
                (
                    [ColumnName]
                )
                SELECT [mp].[ColumnName]
                FROM [dbo].[MFProperty] AS [mp]
                WHERE [mp].[MFID] IN ( 20, 21, 23, 25 );

                -----------------------------------------------------
                --Insert to values INTo temp table
                -----------------------------------------------------
                --               PRINT @Query;
                SET @ProcedureStep = 'Execute query';

                DELETE FROM @ColumnValuePair;

                --IF @Debug > 0
                --SELECT * FROM @ColumnValuePair AS [cvp];
                INSERT INTO @ColumnValuePair
                EXEC (@Query);

                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

                    SELECT *
                    FROM @ColumnValuePair AS [cvp];
                END;

                SET @ProcedureStep = 'Remove exclusions';

                DELETE FROM @ColumnValuePair
                WHERE [ColunmName] IN (
                                          SELECT [el].[ColumnName] FROM @ExcludeList AS [el]
                                      );

                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                --SELECT *
                --FROM @ColumnValuePair;

                ----------------------	 Add for checking Required property--------------------------------------------
                SET @ProcedureStep = 'Check for required properties';

                UPDATE [CVP]
                SET [CVP].[Required] = [CP].[Required]
                FROM @ColumnValuePair                  [CVP]
                    INNER JOIN [dbo].[MFProperty]      [P]
                        ON [CVP].[ColunmName] = [P].[ColumnName]
                    INNER JOIN [dbo].[MFClassProperty] [CP]
                        ON [P].[ID] = [CP].[MFProperty_ID]
                    INNER JOIN [dbo].[MFClass]         [C]
                        ON [CP].[MFClass_ID] = [C].[ID]
                WHERE [C].[TableName] = @MFTableName;

                UPDATE @ColumnValuePair
                SET [ColumnValue] = 'ZZZ'
                WHERE [Required] = 1
                      AND [ColumnValue] IS NULL;

                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                ------------------	 Add for checking Required property------------------------------------
                SET @ProcedureStep = 'Convert datatime';

                --DELETE FROM @ColumnValuePair
                --WHERE  ColumnValue IS NULL
                UPDATE [cp]
                SET [cp].[ColumnValue] = CONVERT(DATE, CAST([cp].[ColumnValue] AS NVARCHAR(100)))
                FROM @ColumnValuePair                         AS [cp]
                    INNER JOIN [INFORMATION_SCHEMA].[COLUMNS] AS [c]
                        ON [c].[COLUMN_NAME] = [cp].[ColunmName]
                WHERE [c].[DATA_TYPE] = 'datetime'
                      AND [cp].[ColumnValue] IS NOT NULL;

                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                --           SELECT @Objid AS [ObjID];
                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                SET @ProcedureStep = 'Creating XML';
                -----------------------------------------------------
                --Generate xml file -- 
                -----------------------------------------------------
                --SELECT *
                --FROM @ColumnValuePair;
                SET @XMLFile =
                (
                    SELECT @ObjectTypeID  AS [Object/@id]
                          ,@SQLID         AS [Object/@sqlID]
                          ,@Objid         AS [Object/@objID]
                          ,@ObjectVersion AS [Object/@objVesrion]
                          ,0              AS [Object/@DisplayID]
                          ,(
                               SELECT
                                   (
                                       SELECT TOP 1
                                              [tmp].[ColumnValue]
                                       FROM @ColumnValuePair             AS [tmp]
                                           INNER JOIN [dbo].[MFProperty] AS [mfp]
                                               ON [mfp].[ColumnName] = [tmp].[ColunmName]
                                       WHERE [mfp].[MFID] = 100
                                   ) AS [class/@id]
                                  ,(
                                       SELECT [mfp].[MFID] AS [property/@id]
                                             ,(
                                                  SELECT [MFTypeID]
                                                  FROM [dbo].[MFDataType]
                                                  WHERE [ID] = [mfp].[MFDataType_ID]
                                              )            AS [property/@dataType]
                                             ,CASE
                                                  WHEN [tmp].[ColumnValue] = 'ZZZ' THEN
                                                      NULL
                                                  ELSE
                                                      [tmp].[ColumnValue]
                                              END          AS 'property' ----Added case statement for checking Required property
                                       FROM @ColumnValuePair             AS [tmp]
                                           INNER JOIN [dbo].[MFProperty] AS [mfp]
                                               ON [mfp].[ColumnName] = [tmp].[ColunmName]
                                       WHERE [mfp].[MFID] <> 100
                                             AND [tmp].[ColumnValue] IS NOT NULL --- excluding duplicate class and [tmp].[ColumnValue] is not null added for task 1103
                                       FOR XML PATH(''), TYPE
                                   ) AS [class]
                               FOR XML PATH(''), TYPE
                           )              AS [Object]
                    FOR XML PATH(''), ROOT('form')
                );
                SET @XMLFile =
                (
                    SELECT @XMLFile.[query]('/form/*')
                );
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

                    SELECT @XMLFile AS [XMLFile];
                END;

                SET @ProcedureStep = 'Prepare XML out';
                SET @Sql = '';
                ;
                /*
                --SELECT @XML = CAST(@XMLOut AS NVARCHAR(MAX));
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                -- PRINT @XML;
				*/
                -------------------------------------------------------------
                -- Set filedata for CLR to null - this is an explorer inpu routine
                -------------------------------------------------------------
                --           DECLARE @Data VARBINARY(MAX);

                --          SELECT @Data = NULL;

                -------------------------------------------------------------------
                --Importing File into M-Files using Connector
                -------------------------------------------------------------------
                SET @ProcedureStep = 'Importing file';

                DECLARE @XMLStr   NVARCHAR(MAX)
                       ,@Result   NVARCHAR(MAX)
                       ,@ErrorMsg NVARCHAR(MAX);

                SET @XMLStr = '<form>' + CAST(@XMLFile AS NVARCHAR(MAX)) + '</form>';
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);

                    SELECT @FileName AS [filename];

                    --              SELECT CAST(@XML AS XML) AS '@XML Length';
                    SELECT @XMLStr AS '@XMLStr';

                    SELECT @FileLocation AS [filelocation];
                END;

                EXEC [dbo].[spMFSynchronizeFileToMFilesInternal] @VaultSettings
                                                                ,@FileName
                                                                ,@XMLStr
                                                                ,@FileLocation
                                                                ,@Result OUT
                                                                ,@ErrorMsg OUT
                                                                ,@IsFileDelete;

                IF @Debug > 0
                BEGIN
                    SELECT CAST(@Result AS XML) AS [Result];

                    SELECT @ErrorMsg AS [errormsg];
                END;

                -------------------------------------------------------------
                -- Set error message
                -------------------------------------------------------------
                IF @ErrorMsg <> ''
                BEGIN
                    SELECT @Start = CHARINDEX(@SearchTerm, @ErrorMsg, 1) + LEN(@SearchTerm);

                    SELECT @End = CHARINDEX(@SearchTerm, @ErrorMsg, @Start);

                    SELECT @length = @End - @Start;

                    SELECT @ErrorMsg = SUBSTRING(@ErrorMsg, @Start, @length);
                END;

                -------------------------------------------------------------
                -- update log
                -------------------------------------------------------------
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Insert result in MFFileImport table';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                DECLARE @ResultXml XML;

                SET @ResultXml = CAST(@Result AS XML);

                CREATE TABLE [#TempFileDetails]
                (
                    [FileName] NVARCHAR(200)
                   ,[FileUniqueRef] VARCHAR(100)
                   ,[MFCreated] DATETIME
                   ,[MFLastModified] DATETIME
                   ,[ObjID] INT
                   ,[ObjVer] INT
                   ,[FileObjectID] INT
                   ,[FileCheckSum] NVARCHAR(MAX)
                   ,[ImportError] NVARCHAR(4000)
                );

                INSERT INTO [#TempFileDetails]
                (
                    [FileName]
                   ,[FileUniqueRef]
                   ,[MFCreated]
                   ,[MFLastModified]
                   ,[ObjID]
                   ,[ObjVer]
                   ,[FileObjectID]
                   ,[FileCheckSum]
                   ,[ImportError]
                )
                SELECT [t].[c].[value]('(@FileName)[1]', 'NVARCHAR(200)')     AS [FileName]
                      ,COALESCE(@FileLocation, NULL)
                      --          ,[t].[c].[value]('(@FileUniqueRef)[1]', 'VARCHAR(100)') AS [FileUniqueRef]
                      ,[t].[c].[value]('(@MFCreated)[1]', 'DATETIME')         AS [MFCreated]
                      ,[t].[c].[value]('(@MFLastModified)[1]', 'DATETIME')    AS [MFLastModified]
                      ,[t].[c].[value]('(@ObjID)[1]', 'INT')                  AS [ObjID]
                      ,[t].[c].[value]('(@ObjVer)[1]', 'INT')                 AS [ObjVer]
                      ,[t].[c].[value]('(@FileObjectID)[1]', 'INT')           AS [FileObjectID]
                      ,[t].[c].[value]('(@FileCheckSum)[1]', 'NVARCHAR(MAX)') AS [FileCheckSum]
                      ,CASE
                           WHEN @ErrorMsg = '' THEN
                               'Success'
                           ELSE
                               @ErrorMsg
                       END                                                    AS [ImportError]
                FROM @ResultXml.[nodes]('/form/Object') AS [t]([c]);

			

				Update #TempFileDetails set ImportError='File Already Exists' where ObjID=0

                IF @Debug > 0
                    SELECT *
                    FROM [#TempFileDetails] AS [tfd]
                    WHERE [tfd].[ObjID] = @Objid;

                IF EXISTS
                (
                    SELECT TOP 1
                           *
                    FROM [dbo].[MFFileImport]
                    WHERE [ObjID] = @Objid
                          AND [TargetClassID] = @TargetClassMFID
                          AND [FileName] = @FileName
                          AND [FileUniqueRef] = @FileLocation
                )
                BEGIN
                    UPDATE [FI]
                    SET [FI].[MFCreated] =case when [FD].[MFCreated] ='1900-01-01 00:00:00.000' then Null else [FD].[MFCreated] end  
                       ,[FI].[MFLastModified] = case when [FD].[MFLastModified] ='1900-01-01 00:00:00.000' then Null else [FD].[MFLastModified] end
                       ,[FI].[ObjID] = [FD].[ObjID]
                       ,[FI].[Version] = [FD].[ObjVer]
                       ,[FI].[FileObjectID] = [FD].[FileObjectID]
                       ,[FI].[FileCheckSum] = [FD].[FileCheckSum]
                       ,[FI].[ImportError] = [FD].[ImportError]
                    FROM [dbo].[MFFileImport]         [FI]
                        INNER JOIN [#TempFileDetails] [FD]
                            ON [FI].[FileUniqueRef] = [FD].[FileUniqueRef]
                               AND [FD].[FileName] = [FI].[FileName];
                END;
                ELSE
                BEGIN
                    INSERT INTO [dbo].[MFFileImport]
                    (
                        [FileName]
                       ,[FileUniqueRef]
                       ,[CreatedOn]
                       ,[SourceName]
                       ,[TargetClassID]
                       ,[MFCreated]
                       ,[MFLastModified]
                       ,[ObjID]
                       ,[Version]
                       ,[FileObjectID]
                       ,[FileCheckSum]
                       ,[ImportError]
                    )
                    SELECT [FileName]
                          ,[FileUniqueRef]
                          ,GETDATE()
                          ,@MFTableName
                          ,@TargetClassMFID
                          ,case when [MFCreated] ='1900-01-01 00:00:00.000' then Null else [MFCreated] end 
                          ,case when [MFLastModified] ='1900-01-01 00:00:00.000' then Null else [MFLastModified] end 
                          ,[ObjID]
                          ,[ObjVer]
                          ,[FileObjectID]
                          ,[FileCheckSum]
                          ,[ImportError]
                    FROM [#TempFileDetails];
                END;

                DROP TABLE [#TempFileDetails];

                IF
                (
                    SELECT OBJECT_ID(@tempTableName)
                ) IS NOT NULL
                    EXEC ('Drop table ' + @TempFile);

                SET @Sql = ' Synchronizing records  from M-files to the target ' + @MFTableName;

                EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                                             ,@LogType = @LogTypeDetail
                                                                             ,@LogText = @LogTextDetail
                                                                             ,@LogStatus = @LogStatusDetail
                                                                             ,@StartTime = @StartTime
                                                                             ,@MFTableName = @MFTableName
                                                                             ,@Validation_ID = @Validation_ID
                                                                             ,@ColumnName = @LogColumnName
                                                                             ,@ColumnValue = @LogColumnValue
                                                                             ,@Update_ID = @Update_ID
                                                                             ,@LogProcedureName = @ProcedureName
                                                                             ,@LogProcedureStep = @ProcedureStep
                                                                             ,@debug = 0;

                -------------------------------------------------------------------
                --Synchronizing target table from M-Files
                -------------------------------------------------------------------
                SET @DebugText = '';
                SET @DebugText = @DefaultDebugText + @DebugText;
                SET @ProcedureStep = 'Synchronizing target table from M-Files';

                IF @Debug > 0
                BEGIN
                    RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                END;

                --SET @Sql
                --    = 'Update ' + @MFTableName + ' set Process_ID=0 where Process_ID= '
                --      + CAST(@Process_ID AS VARCHAR(5));;

                ----           PRINT @Sql;
                --EXEC (@Sql);
                DECLARE @Return_LastModified DATETIME;

                EXEC [dbo].[spMFUpdateTableWithLastModifiedDate] @UpdateMethod = 1                                  -- int
                                                                ,@Return_LastModified = @Return_LastModified OUTPUT -- datetime
                                                                ,@TableName = @MFTableName                          -- sysname
                                                                ,@Update_IDOut = @Update_IDOut OUTPUT               -- int
                                                                ,@ProcessBatch_ID = @ProcessBatch_id                -- int
                                                                ,@debug = 0;                                        -- smallint
            END;
        END;
        ELSE
        BEGIN
            SET @DebugText = 'Target Table ' + @MFTableName + ' does not belong to MFClass table';
            SET @DebugText = @DefaultDebugText + @DebugText;

            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
        END;
    END TRY
    BEGIN CATCH
        SET @StartTime = GETUTCDATE();
        SET @LogStatus = 'Failed w/SQL Error';
        SET @LogTextDetail = ERROR_MESSAGE();
		SET @ErrorMsg = ERROR_MESSAGE();

		         -------------------------------------------------------------
                -- Set error message
                -------------------------------------------------------------
                IF @ErrorMsg <> ''
                BEGIN
                    SELECT @Start = CHARINDEX(@SearchTerm, @ErrorMsg, 1) + LEN(@SearchTerm);

                    SELECT @End = CHARINDEX(@SearchTerm, @ErrorMsg, @Start);

                    SELECT @length = @End - @Start;

                    SELECT @ErrorMsg = SUBSTRING(@ErrorMsg, @Start, @length);
                END;

        -------------------------------------------------------------
        -- update error in table
        -------------------------------------------------------------
        IF EXISTS
        (
            SELECT TOP 1
                   *
            FROM [dbo].[MFFileImport]
            WHERE [FileUniqueRef] = @FileID
                  AND [TargetClassID] = @TargetClassMFID
        )
        BEGIN
            UPDATE [FI]
            SET [FI].[FileName] = @FileName
               ,[FI].[FileUniqueRef] = @FileLocation
               ,[FI].[MFCreated] = [FI].[MFCreated]
               ,[FI].[MFLastModified] = GETDATE()
               ,[FI].[ObjID] = @Objid
               ,[FI].[Version] = @ObjectVersion
               ,[FI].[FileObjectID] = NULL
               ,[FI].[FileCheckSum] = NULL
               ,[FI].[ImportError] =  @ErrorMsg
            FROM [dbo].[MFFileImport] [FI]
            WHERE [FI].[ObjID] = @Objid
                  AND [FI].[FileName] = @FileName
				  AND [FI].[FileUniqueRef] = @FileLocation;
        --INNER JOIN [#TempFileDetails] [FD]
        --    ON [FI].[FileUniqueRef] = [FD].[FileUniqueRef];
        END;
        ELSE
        BEGIN
            INSERT INTO [dbo].[MFFileImport]
            (
                [FileName]
               ,[FileUniqueRef]
               ,[CreatedOn]
               ,[SourceName]
               ,[TargetClassID]
               ,[MFCreated]
               ,[MFLastModified]
               ,[ObjID]
               ,[ImportError]
            )
            VALUES
            (@FileName, @FileLocation, GETDATE(), @MFTableName, @TargetClassMFID, NULL, NULL, @Objid
            ,@ErrorMsg);
        END;
/*
        --------------------------------------------------
        -- INSERTING ERROR DETAILS INTO LOG TABLE
        --------------------------------------------------
        INSERT INTO [dbo].[MFLog]
        (
            [SPName]
           ,[ErrorNumber]
           ,[ErrorMessage]
           ,[ErrorProcedure]
           ,[ErrorState]
           ,[ErrorSeverity]
           ,[ErrorLine]
           ,[ProcedureStep]
        )
        VALUES
        (@ProcedureName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_STATE(), ERROR_SEVERITY()
        ,ERROR_LINE(), @ProcedureStep);

        SET @ProcedureStep = 'Catch Error';

        -------------------------------------------------------------
        -- Log Error
        -------------------------------------------------------------   
        EXEC [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_id OUTPUT
                                            ,@ProcessType = @ProcessType
                                            ,@LogType = N'Error'
                                            ,@LogText = @LogTextDetail
                                            ,@LogStatus = @LogStatus
                                            ,@debug = 0;

        SET @StartTime = GETUTCDATE();

        EXEC [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_id
                                                  ,@LogType = N'Error'
                                                  ,@LogText = @LogTextDetail
                                                  ,@LogStatus = @LogStatus
                                                  ,@StartTime = @StartTime
                                                  ,@MFTableName = @MFTableName
                                                  ,@Validation_ID = @Validation_ID
                                                  ,@ColumnName = NULL
                                                  ,@ColumnValue = NULL
                                                  ,@Update_ID = @Update_ID
                                                  ,@LogProcedureName = @ProcedureName
                                                  ,@LogProcedureStep = @ProcedureStep
                                                  ,@debug = 0;
*/
        RETURN -1;
    END CATCH;
END;

GO
 
PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[spMFSynchronizeUnManagedObject]';
GO

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFSynchronizeUnManagedObject'
                                    -- nvarchar(100)
                                    ,@Object_Release = '4.2.8.47'
                                    -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

/*
 ********************************************************************************
  ** Change History
  ********************************************************************************
  ** Date        Author     Description
  ** ----------  ---------  -----------------------------------------------------
 

  ********************************************************************************
*/

IF EXISTS
(
    SELECT 1
    FROM [INFORMATION_SCHEMA].[ROUTINES]
    WHERE [ROUTINE_NAME] = 'spMFSynchronizeUnManagedObject' --name of procedure
          AND [ROUTINE_TYPE] = 'PROCEDURE' --for a function --'FUNCTION'
          AND [ROUTINE_SCHEMA] = 'dbo'
)
BEGIN
    PRINT SPACE(10) + '...Stored Procedure: update';

    SET NOEXEC ON;
END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO

-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFSynchronizeUnManagedObject]
AS
SELECT 'created, but not implemented yet.';
--just anything will do
GO

-- the following section will be always executed
SET NOEXEC OFF;
GO


Alter Procedure spMFSynchronizeUnManagedObject
(
   @ExternalRepositoryObjectIDs NVARCHAR(MAX) 
  ,@TableName NVARCHAR(100)='MFUnmanagedObject'
  ,@Debug SMALLINT = 0
  ,@ProcessBatch_ID INT = NULL OUTPUT
) as /*******************************************************************************
  ** Desc:  

  
  ** Date:				27-03-2015
  ********************************************************************************
 
  ******************************************************************************/
Begin
  DECLARE @Update_ID    INT
  ,@return_value INT = 1;
	 --BEGIN TRANSACTION
BEGIN TRY
    SET NOCOUNT ON;

    SET XACT_ABORT ON

	DECLARE 
            @SynchErrorObj      NVARCHAR(MAX) --Declared new paramater
           ,@DeletedObjects     NVARCHAR(MAX) --Declared new paramater
           ,@ProcedureName      sysname        = 'spMFSynchronizeUnManagedObject'
           ,@ProcedureStep      sysname        = 'Start'
           ,@ObjectId           INT
           ,@ClassId            INT
           ,@Table_ID           INT
           ,@ErrorInfo          NVARCHAR(MAX)
           ,@Params             NVARCHAR(MAX)
           ,@SynchErrCount      INT
           ,@ErrorInfoCount     INT
           ,@MFErrorUpdateQuery NVARCHAR(1500)
		   ,@VaultSettings      NVARCHAR(4000)
          


	DECLARE @Idoc INT
				DECLARE @Result NVARCHAR(max)
				DECLARE @Query NVARCHAR(max)
				DECLARE @TempObjectList VARCHAR(100)
				DECLARE @TempExistingObjects VARCHAR(100)
				DECLARE @TempNewObjects VARCHAR(100)
				DECLARE @TempIsTemplatelist VARCHAR(100)
				DECLARE @Name_or_Title NVARCHAR(100)
				DECLARE @InsertQuery AS NVARCHAR(MAX)
				DECLARE @TempUpdateQuery AS NVARCHAR(MAX)
				DECLARE @XML xml
				DECLARE @TempInsertQuery NVARCHAR(max)
				DECLARE @UpdateQuery NVARCHAR(MAX)
				DECLARE @DefaultDebugText AS NVARCHAR(256) = 'Proc: %s Step: %s';
			    DECLARE @DebugText AS NVARCHAR(256) = '';
				DECLARE @LogTextDetail AS NVARCHAR(MAX) = '';
			    DECLARE @LogTextAccumulated AS NVARCHAR(MAX) = '';
				DECLARE @LogStatusDetail AS NVARCHAR(50) = NULL;
				DECLARE @LogTypeDetail AS NVARCHAR(50) = NULL;
				DECLARE @LogColumnName AS NVARCHAR(128) = NULL;
				DECLARE @LogColumnValue AS NVARCHAR(256) = NULL;
				DECLARE @ProcessType NVARCHAR(50);
				DECLARE @LogType AS NVARCHAR(50) = 'Status';
				DECLARE @LogText AS NVARCHAR(4000) = '';
				DECLARE @LogStatus AS NVARCHAR(50) = 'Started';
				DECLARE @Status AS NVARCHAR(128) = NULL;
				DECLARE @Validation_ID INT = NULL;
				DECLARE @StartTime AS DATETIME;
				DECLARE @RunTime AS DECIMAL(18, 4) = 0;
				DECLARE @Columns AS NVARCHAR(MAX)
			    DECLARE @ColumnNames NVARCHAR(MAX)
		        DECLARE @ColumnForInsert NVARCHAR(MAX)
				DECLARE @UpdateColumns NVARCHAR(MAX)
				DECLARE @ReturnVariable INT = 1

				SELECT @TempObjectList = [dbo].[fnMFVariableTableName]('##ObjectList', DEFAULT);
				SELECT @TempExistingObjects = [dbo].[fnMFVariableTableName]('##ExistingObjects', DEFAULT);
				SELECT @TempNewObjects = [dbo].[fnMFVariableTableName]('##TempNewObjects', DEFAULT);
				SELECT @TempIsTemplatelist = [dbo].[fnMFVariableTableName]('##IsTemplateList', DEFAULT);

				----------------------------------------------------
				--GET LOGIN CREDENTIALS
				-----------------------------------------------------
				SET @ProcedureStep = 'Get Security Variables';

				DECLARE @Username NVARCHAR(2000);
				DECLARE @VaultName NVARCHAR(2000);

				SELECT TOP 1
						@Username  = [Username]
						 ,@VaultName = [VaultName]
				FROM [dbo].[MFVaultSettings];

				SELECT @VaultSettings = [dbo].[FnMFVaultSettings]();


				-------------------------------------------------------------
				-- Set process type
				-------------------------------------------------------------
				SELECT @ProcessType = 'UpdateSQL'

						-------------------------------------------------------------
				--	Create Update_id for process start 
				-------------------------------------------------------------
				SET @ProcedureStep = 'set Update_ID';
				SET @StartTime = GETUTCDATE();

				INSERT INTO [dbo].[MFUpdateHistory]
				(
					[Username]
				   ,[VaultName]
				   ,[UpdateMethod]
				)
				VALUES
				(@Username, @VaultName, 1);

				SELECT @Update_ID = @@Identity;


				
				SET @ProcedureStep = 'Start ';
				SET @StartTime = GETUTCDATE();
				SET @ProcessType = @ProcedureName;
				SET @LogType = 'Status';
				SET @LogStatus = 'Initiate';
				SET @LogText = 'Getting Unmanage object Details for ID''s From M-Files: ' + CAST(@ExternalRepositoryObjectIDs AS VARCHAR(200));

				IF @Debug > 0
				BEGIN
					RAISERROR(@DefaultDebugText, 10, 1, @ProcedureName, @ProcedureStep);
				END;

				EXECUTE @return_value = [dbo].[spMFProcessBatch_Upsert] @ProcessBatch_ID = @ProcessBatch_ID OUTPUT
																	   ,@ProcessType = @ProcessType
																	   ,@LogType = @LogType
																	   ,@LogText = @LogText
																	   ,@LogStatus = @LogStatus
																	   ,@debug = @Debug;
              -- SELECT @Update_IDOut = @Update_ID;

			   
						-----------------------------------------------------------------
						-- Checking module access for CLR procdure  spMFCreateObjectInternal
						------------------------------------------------------------------
						--EXEC [dbo].[spMFCheckLicenseStatus] 'spMFCreateObjectInternal'
						--					,@ProcedureName
						--					,@ProcedureStep;

						SET @ProcedureStep = 'Prepare Table ';
        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'Debug';
        SET @LogTextDetail = 'Creating Property temp temp table from xML';
        SET @LogColumnName = '';
        SET @LogColumnValue = '';

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @TableName
                                                                     ,@Validation_ID = NULL
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;


						exec spMFGetUnManagedObjectDetails 
						                           @ExternalRepositoryObjectIDs,
												   @VaultSettings,
												-- 'test,00Q184mbRi8=,localhost,Sample Vault,ncacn_ip_tcp,2266,3,',
												   @Result out

		
		   
				
		

				select @Xml=cast(@Result as xml)

				Create table #TemProp
				(
					[objId] INT,
					Properties_ID INT,
					Name NVARCHAR(250),
					DisplayValue NVARCHAR(1000),
					DataType NVARCHAR(100)
				)
			   EXEC [sys].[sp_xml_preparedocument] @Idoc OUTPUT, @Xml;
				
						
				SELECT @ProcedureStep = 'Inserting Values into #TemProp from XML';

				IF @Debug > 0
				RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);


				----------------------------------------
				--Insert XML data into Temp Table
				----------------------------------------


							
				 INSERT into #TemProp
				 (
				    [objId],
				    [Properties_ID],
					[Name],
					[DisplayValue],
					[DataType]
				 ) 
				   SELECT  
				   [objId],
				   Properties_ID,
				   Name,
				   DisplayValue,
				   DataType
				   FROM    
				    OPENXML(@Idoc, '/Form/Object/Properties', 1)
				            WITH
				            (
				                [objId] INT '../@objectId',
				                [Properties_ID] INT '@ID',
				                [Name] NVARCHAR(4000) '@Name',
				                [DisplayValue] NVARCHAR(1000) '@DisplayValue',
								[DataType] NVARCHAR(100) '@DataType'
				            );

							SELECT @ProcedureStep = 'Updating Table column Name';
						
							IF @Debug > 0
							BEGIN
							  SELECT 'List of properties from MF' AS [Properties],
							*
							FROM [#TemProp];
							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							END;


							-------------------------------------------------------------
							-- localisation of date time for finish time
							-------------------------------------------------------------
							UPDATE [p]
							SET [p].[DisplayValue] = REPLACE([p].[DisplayValue], '.', ':')
							FROM [#TemProp] AS [p]
							WHERE [p].[dataType] IN ( 'MFDataTypeTimestamp', 'MFDataTypeDate' );

							----------------------------------------------------------------
							--Update property name with column name from MFProperty Tbale
							----------------------------------------------------------------

							UPDATE [#TemProp]
							SET [Name] =
							(
								SELECT [ColumnName]
								FROM [dbo].[MFProperty]
								WHERE [MFID] = [#TemProp].[Properties_ID] 
							);

							SELECT @ProcedureStep = 'Adding columns from MFTable which are not exists in #Properties';
							IF @Debug > 0
							BEGIN
								RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							END;


							------------------------------------------------
							--Select the existing columns from MFTable
							-------------------------------------------------
							INSERT INTO [#TemProp]
							(
								[Name]
							)
							SELECT *
							FROM
							(
								SELECT [COLUMN_NAME]
								FROM [INFORMATION_SCHEMA].[COLUMNS]
								WHERE [TABLE_NAME] = @TableName
										AND [COLUMN_NAME] NOT LIKE 'ID'
										AND [COLUMN_NAME] NOT LIKE 'LastModified'
										AND [COLUMN_NAME] NOT LIKE 'Process_ID'
										AND [COLUMN_NAME] NOT LIKE 'Deleted'
										AND [COLUMN_NAME] NOT LIKE 'ObjID'
										AND [COLUMN_NAME] NOT LIKE 'MFVersion'
										AND [COLUMN_NAME] NOT LIKE 'MX_'
										AND [COLUMN_NAME] NOT LIKE 'GUID'
										AND [COLUMN_NAME] NOT LIKE 'ExternalID'
										AND [COLUMN_NAME] NOT LIKE 'FileCount' --Added For Task 106
										AND [COLUMN_NAME] NOT LIKE 'Update_ID'
								EXCEPT
								SELECT DISTINCT
										([Name])
								FROM [#TemProp]
							) [m];


							SELECT @ProcedureStep = 'PIVOT';

							IF @Debug > 0
							BEGIN
							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							END;


		
							-------------------------------------------------------------------------------
								--Selecting The Distinct PropertyName to Create The Columns
							--------------------------------------------------------------------------------

		

							SELECT @Columns = STUFF(
							(
								SELECT ',' + QUOTENAME([ppt].[Name])
								FROM [#TemProp] [ppt]
								GROUP BY [ppt].[Name]
								ORDER BY [ppt].[Name]
								FOR XML PATH(''), TYPE
							).[value]('.', 'NVARCHAR(MAX)'),
							1   ,
							1   ,
							''
													);

							  
							SELECT @ColumnNames = '';


							SELECT @ProcedureStep = 'Select All column names from MFTable';

							IF @Debug > 0
							BEGIN
							SELECT @Columns AS 'Distinct Properties';
							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							END;


							--------------------------------------------------------------------------------
							--Select Column Name Except 'ID','LastModified','Process_ID'
							--------------------------------------------------------------------------------
							SELECT 
								@ColumnNames = @ColumnNames + QUOTENAME([COLUMN_NAME]) + ','
							FROM 
								[INFORMATION_SCHEMA].[COLUMNS]
							WHERE 
								[TABLE_NAME] = @TableName
								AND [COLUMN_NAME] NOT LIKE 'ID'
								AND [COLUMN_NAME] NOT LIKE 'LastModified'
								AND [COLUMN_NAME] NOT LIKE 'Process_ID'
								AND [COLUMN_NAME] NOT LIKE 'Deleted'
								AND [COLUMN_NAME] NOT LIKE 'MX_%'
								AND [COLUMN_NAME] NOT LIKE 'Update_ID'
								AND [COLUMN_NAME] NOT LIKE 'External_ObjectID%';

							SELECT @ColumnNames = SUBSTRING(@ColumnNames, 0, LEN(@ColumnNames));

							 SELECT @ProcedureStep = 'Inserting PIVOT Data into  @TempObjectList';

							------------------------------------------------------------------------------------------------------------------------
							--Dynamic Query to Converting row into columns and inserting into [dbo].[tempobjectlist] USING PIVOT
							------------------------------------------------------------------------------------------------------------------------
							SELECT @Query
								= 'SELECT *
											INTO ' + @TempObjectList
									+ '
											FROM (
													select
													objId,' + @Columns
									+ '
												FROM (
														SELECT
														objId, 
														Name new_col
														,value
													FROM 
														#TemProp
													UNPIVOT(value FOR col IN (DisplayValue)) as un
													) as src
												PIVOT(MAX(value) FOR new_col IN (' + @Columns + ')) p
												) PVT';

							--    print @Query
							EXECUTE [sys].[sp_executesql] @Query;


								IF @Debug > 0
								BEGIN
								RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
								END;

							---------------------------------------------------------
								--Add additional columns to Class Table
							-------------------------------------------------
							   SELECT @ProcedureStep = 'Add Additional columns to class table ';

							CREATE TABLE [#Columns]
							(
								[propertyName] [NVARCHAR](100) NULL,
								[dataType] [NVARCHAR](100) NULL
							);

							SET @Query
								= N'
									INSERT INTO #Columns (PropertyName) SELECT * FROM (
									SELECT Name AS PropertyName FROM tempdb.sys.columns 
									WHERE object_id = Object_id(''tempdb..' + @TempObjectList
									+ ''')
							EXCEPT
								SELECT COLUMN_NAME AS name
								FROM INFORMATION_SCHEMA.COLUMNS
								WHERE TABLE_NAME = ''' + @TableName + ''') v';

							EXEC [sys].[sp_executesql] @Query;

							IF @Debug > 0
							BEGIN

							RAISERROR('Proc: %s Step: %s Delete Template', 10, 1, @ProcedureName, @ProcedureStep);
							END;

							-------------------------------------------------
							--Updating property datatype
							-------------------------------------------------
							UPDATE [#Columns]
							SET [dataType] =
								(
									SELECT [SQLDataType]
									FROM [dbo].[MFDataType]
									WHERE [ID] IN (
														SELECT [MFDataType_ID]
														FROM [dbo].[MFProperty]
														WHERE [ColumnName] = [#Columns].[propertyName]
													)
								);

							-------------------------------------------------------------------------
							----Set dataype = NVARCHAR(100) for lookup and multiselect lookup values
							-------------------------------------------------------------------------
							UPDATE [#Columns]
							SET [dataType] = ISNULL([dataType], 'NVARCHAR(100)');

							DECLARE @AlterQuery NVARCHAR(MAX)
							SELECT @AlterQuery = '';

							---------------------------------------------
							--Add new columns into MFTable
							---------------------------------------------
							SELECT @AlterQuery
								= @AlterQuery + 'ALTER TABLE [' + @TableName + '] Add [' + [propertyName] + '] ' + [dataType] + '  '
							FROM [#Columns];

							IF @Debug > 0
							BEGIN
							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);

							END;

							EXEC [sys].[sp_executesql] @AlterQuery;

							--------------------------------------------------------------------------------
							--Get datatype of column for Insertion
							--------------------------------------------------------------------------------
							SELECT @ColumnForInsert = '';
							 SELECT @ProcedureStep = 'Get datatype of column';

							SELECT @ColumnForInsert
								= @ColumnForInsert
									+ CASE
										WHEN [DATA_TYPE] = 'DATE' THEN
											' CONVERT(DATETIME, NULLIF(' + REPLACE(QUOTENAME([COLUMN_NAME]), '.', ':') + ',''''),105) AS '
											+ QUOTENAME([COLUMN_NAME]) + ','
										WHEN [DATA_TYPE] = 'DATETIME' THEN
											' DATEADD(MINUTE,DATEDIFF(MINUTE,getUTCDATE(),Getdate()),CONVERT(DATETIME, NULLIF('
											+ REPLACE(QUOTENAME([COLUMN_NAME]), '.', ':') + ',''''),105 )) AS ' + QUOTENAME([COLUMN_NAME])
											+ ','
										WHEN [DATA_TYPE] = 'BIT' THEN
											'CASE WHEN ' + QUOTENAME([COLUMN_NAME]) + ' = ''1'' THEN  CAST(''1'' AS BIT) WHEN '
											+ QUOTENAME([COLUMN_NAME]) + ' = ''0'' THEN CAST(''0'' AS BIT)  ELSE 
											null END AS ' + QUOTENAME([COLUMN_NAME]) + ','
									--      + QUOTENAME([COLUMN_NAME]) + ' END AS ' + QUOTENAME([COLUMN_NAME]) + ','
										WHEN [DATA_TYPE] = 'NVARCHAR' THEN
											' CAST(NULLIF(' + QUOTENAME([COLUMN_NAME]) + ','''') AS ' + [DATA_TYPE] + '('
											+ CASE
													WHEN [CHARACTER_MAXIMUM_LENGTH] = -1 THEN
														'MAX)) AS ' + QUOTENAME([COLUMN_NAME]) + ','
													ELSE
														CAST(NULLIF([CHARACTER_MAXIMUM_LENGTH], '') AS NVARCHAR) + ')) AS '
														+ QUOTENAME([COLUMN_NAME]) + ','
												END
										WHEN [DATA_TYPE] = 'FLOAT' THEN
											' CAST(NULLIF(REPLACE(' + QUOTENAME([COLUMN_NAME]) + ','','',''.''),'''') AS float) AS '
											+ QUOTENAME([COLUMN_NAME]) + ','
										ELSE
											' CAST(NULLIF(' + QUOTENAME([COLUMN_NAME]) + ','''') AS ' + [DATA_TYPE] + ') AS '
											+ QUOTENAME([COLUMN_NAME]) + ','
									END
							FROM 
								[INFORMATION_SCHEMA].[COLUMNS]
							WHERE 
							[TABLE_NAME] = @TableName
									AND [COLUMN_NAME] NOT LIKE 'ID'
									AND [COLUMN_NAME] NOT LIKE 'LastModified'
									AND [COLUMN_NAME] NOT LIKE 'Process_ID'
									AND [COLUMN_NAME] NOT LIKE 'Deleted'
									AND [COLUMN_NAME] NOT LIKE 'MX_%'
									AND [COLUMN_NAME] NOT LIKE 'Update_ID'
									AND [COLUMN_NAME] NOT LIKE 'External_ObjectID%';



 


						----------------------------------------
						--Remove the Last ','
						----------------------------------------
								SELECT @ColumnForInsert = SUBSTRING(@ColumnForInsert, 0, LEN(@ColumnForInsert));


								IF @Debug > 0
								BEGIN
								--          SELECT  @ColumnForInsert AS '@ColumnForInsert';
								RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
								END;

						----------------------------------------
						--Add column values to data type
						----------------------------------------

						set @UpdateColumns=''
						SELECT @UpdateColumns
							= @UpdateColumns
								+ CASE
									WHEN [DATA_TYPE] = 'DATE' THEN
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME]) + ' = CONVERT(DATETIME, NULLIF(t.'
										+ REPLACE(QUOTENAME([COLUMN_NAME]), '.', ':') + ',''''),105 ) ,'
									WHEN [DATA_TYPE] = 'DATETIME' THEN
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME])
										+ ' = DATEADD(MINUTE,DATEDIFF(MINUTE,getUTCDATE(),Getdate()), CONVERT(DATETIME,NULLIF(t.'
										+ REPLACE(QUOTENAME([COLUMN_NAME]), '.', ':') + ',''''),105 )),'
									WHEN [DATA_TYPE] = 'BIT' THEN
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME]) + ' =(CASE WHEN ' + 't.'
										+ QUOTENAME([COLUMN_NAME]) + ' = 1 THEN  CAST(1 AS BIT)  WHEN t.'
										+ QUOTENAME([COLUMN_NAME]) + ' = 0 THEN CAST(0 AS BIT)  
										ELSE NULL END ),'
										--WHEN t.'
						--                  + QUOTENAME([COLUMN_NAME]) + ' = ''""'' THEN CAST(''NULL'' AS BIT)  END )  ,'
									WHEN [DATA_TYPE] = 'NVARCHAR' THEN
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME]) + '=  CAST(NULLIF(t.'
										+ QUOTENAME([COLUMN_NAME]) + ','''') AS ' + [DATA_TYPE] + '('
										+ CASE
												WHEN [CHARACTER_MAXIMUM_LENGTH] = -1 THEN
													CAST('MAX' AS NVARCHAR)
												ELSE
													CAST([CHARACTER_MAXIMUM_LENGTH] AS NVARCHAR)
											END + ')) ,'
									WHEN [DATA_TYPE] = 'Float' THEN
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME]) + '=  CAST(NULLIF(REPLACE(t.'
										+ QUOTENAME([COLUMN_NAME]) + ','','',''.'')' + ','''') AS ' + [DATA_TYPE] + ') ,'
									ELSE
										'' + QUOTENAME(@TableName) + '.' + QUOTENAME([COLUMN_NAME]) + '=  CAST(NULLIF(t.'
										+ QUOTENAME([COLUMN_NAME]) + ','''') AS ' + [DATA_TYPE] + ') ,'
								END
						FROM [INFORMATION_SCHEMA].[COLUMNS]
						WHERE [TABLE_NAME] = @TableName
								AND [COLUMN_NAME] NOT LIKE 'ID'
								AND [COLUMN_NAME] NOT LIKE 'LastModified'
								AND [COLUMN_NAME] NOT LIKE 'Process_ID'
								AND [COLUMN_NAME] NOT LIKE 'Deleted'
								AND [COLUMN_NAME] NOT LIKE 'MX_%'
								AND [COLUMN_NAME] NOT LIKE 'Update_ID'
								AND [COLUMN_NAME] NOT LIKE 'External_ObjectID%';

			
						----------------------------------------
							--Remove the last ','
						----------------------------------------
						SELECT @UpdateColumns = SUBSTRING(@UpdateColumns, 0, LEN(@UpdateColumns));



							SELECT @ProcedureStep = 'Create object columns';

							IF @Debug > 0
							BEGIN

							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							IF @Debug > 0
							BEGIN
							SELECT @UpdateColumns AS '@UpdateColumns';
							SET @Query = N'	
							SELECT ''tempobjectlist'' as [TempObjectList],* FROM ' + @TempObjectList + '';
							EXEC (@Query);
							END;
							END;
		

						----------------------------------------
						--prepare temp table for existing object
						----------------------------------------
						SELECT @TempUpdateQuery
						= 'SELECT *
											INTO ' + @TempExistingObjects + '
											FROM ' + @TempObjectList + '
											WHERE ' + @TempObjectList
							+ '.[ObjID]  IN (
													SELECT [External_ObjectID]
													FROM [' + @TableName + ']
									   
													)';

						EXECUTE [sys].[sp_executesql] @TempUpdateQuery;


						SELECT @ProcedureStep = 'Update existing objects';

						IF @Debug > 0
						BEGIN

							RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
						IF @Debug > 0
						BEGIN
							SET @Query = N'	
							SELECT ''tempExistingobjects'' as [tempExistingobjects],* FROM ' + @TempExistingObjects + '';
							EXEC (@Query);
						END;
						END;


      --------------------------------------------------------------------------------------------
        --Update existing records in Class Table and log the details of records which failed to update
        --------------------------------------------------------------------------------------------
        SELECT @ProcedureStep = 'Determine count of records to Update';

		SET @Params = N'@Count int output';
        SET @Query = N'SELECT @count = count(*)
		FROM  ' + @TempExistingObjects + '';

        EXEC [sys].[sp_executesql] @stmt = @Query,
                                   @param = @Params,
                                   @Count = @ReturnVariable OUTPUT;

        IF @Debug > 0
        BEGIN
            RAISERROR('Proc: %s Step: %s : %i', 10, 1, @ProcedureName, @ProcedureStep, @ReturnVariable);
        END;

		SET @ProcedureStep = @ProcedureStep;
        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'Update';
        SET @LogTextDetail = 'UPdating existing records';
        SET @LogColumnName = '';
        SET @LogColumnValue = '';

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @TableName
                                                                     ,@Validation_ID = NULL
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;

						SELECT @UpdateQuery
							= '
										UPDATE [' + @TableName + ']
											SET ' + @UpdateColumns + ' ,External_ObjectID= t.[ObjID] 
											FROM [' + @TableName + '] INNER JOIN ' + @TempExistingObjects
								+ ' as t
											ON [' + @TableName + '].External_ObjectID = 
										t.[ObjID]  ; '



		     ----------------------------------------
            --Executing Dynamic Query
            ----------------------------------------

			EXEC [sys].[sp_executesql] @stmt = @UpdateQuery;

        SELECT @ProcedureStep = 'Setup insert new objects Query';
		SET @ProcedureStep = @ProcedureStep;
        SET @LogTypeDetail = 'Status';
        SET @LogStatusDetail = 'Insert';
        SET @LogTextDetail = 'Inserting new records into the MFUnManagedObject table';
        SET @LogColumnName = '';
        SET @LogColumnValue = '';

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @TableName
                                                                     ,@Validation_ID = NULL
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;




							SELECT @TempInsertQuery
							= N'Select ' + @TempObjectList + '.* INTO ' + @TempNewObjects + '
							from ' + @TempObjectList+' where ' + @TempObjectList +'.ObjID NOT IN (SELECT External_ObjectID from '+@TableName+')'

							IF @Debug > 0
							BEGIN
								SELECT  @TempInsertQuery AS '@TempInsertQuery';
								RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
							END;


								EXECUTE [sys].[sp_executesql] @TempInsertQuery;

								SELECT @ProcedureStep = 'Insert validated records';

							SELECT @InsertQuery
								= 'INSERT INTO [' + @TableName + ' ] (' + @ColumnNames
									+ ',Process_ID,External_ObjectID
										   
															)
															SELECT *
															FROM (
																SELECT ' + @ColumnForInsert+ ',0 as Process_ID,'+@TempNewObjects+'.[ObjID] as External_ObjectID
																											FROM ' + @TempNewObjects + ') t';
	
							IF @Debug > 0
							BEGIN
									RAISERROR('Proc: %s Step: %s ', 10, 1, @ProcedureName, @ProcedureStep);
									SELECT @InsertQuery AS '@InsertQuery';
							END;
							
							 SELECT @ProcedureStep = 'Inserted Records';	
							EXECUTE [sys].[sp_executesql] @InsertQuery;
     
							IF @Debug > 0
							BEGIN
									SET @Query
									= N'	
									SELECT ''Inserted'' as inserted ,* FROM ' + QUOTENAME(@TableName) + ' ClassT INNER JOIN '
									+ @TempNewObjects + ' UpdT  on ClassT.objid = UpdT.Objid';

									EXEC [sys].[sp_executesql] @Query;

									RAISERROR('Proc: %s Step: %s', 10, 1, @ProcedureName, @ProcedureStep);
							END;

	 
							  SELECT @ProcedureStep = 'Setup insert new objects Query';
							  SET @ProcedureStep = @ProcedureStep;
							  SET @LogTypeDetail = 'Status';
							  SET @LogStatusDetail = 'Completed';
							  SET @LogTextDetail = 'Completed Process';
							  SET @LogColumnName = '';
							  SET @LogColumnValue = '';

        EXECUTE @return_value = [dbo].[spMFProcessBatchDetail_Insert] @ProcessBatch_ID = @ProcessBatch_ID
                                                                     ,@LogType = @LogTypeDetail
                                                                     ,@LogText = @LogTextDetail
                                                                     ,@LogStatus = @LogStatusDetail
                                                                     ,@StartTime = @StartTime
                                                                     ,@MFTableName = @TableName
                                                                     ,@Validation_ID = NULL
                                                                     ,@ColumnName = @LogColumnName
                                                                     ,@ColumnValue = @LogColumnValue
                                                                     ,@Update_ID = @Update_ID
                                                                     ,@LogProcedureName = @ProcedureName
                                                                     ,@LogProcedureStep = @ProcedureStep
                                                                     ,@debug = @Debug;


							drop table #TemProp

							drop table #Columns 
END TRY
Begin CATCH
     IF @@TranCount <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;


	print 'testing'
    SET NOCOUNT ON;
	 UPDATE [dbo].[MFUpdateHistory]
    SET [UpdateStatus] = 'failed'
    WHERE [Id] = @Update_ID;

    INSERT INTO [dbo].[MFLog]
    (
        [SPName]
       ,[ErrorNumber]
       ,[ErrorMessage]
       ,[ErrorProcedure]
       ,[ProcedureStep]
       ,[ErrorState]
       ,[ErrorSeverity]
       ,[Update_ID]
       ,[ErrorLine]
    )
    VALUES
    (@TableName, ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_PROCEDURE(), @ProcedureStep, ERROR_STATE()
    ,ERROR_SEVERITY(), @Update_ID, ERROR_LINE());

    IF @Debug > 0
    BEGIN
        SELECT ERROR_NUMBER()    AS [ErrorNumber]
              ,ERROR_MESSAGE()   AS [ErrorMessage]
              ,ERROR_PROCEDURE() AS [ErrorProcedure]
              ,@ProcedureStep    AS [ProcedureStep]
              ,ERROR_STATE()     AS [ErrorState]
              ,ERROR_SEVERITY()  AS [ErrorSeverity]
              ,ERROR_LINE()      AS [ErrorLine];
    END;

    SET NOCOUNT OFF;

    RETURN -1

END CATCH
End	







/*
Update history

2019-08-01	LC	fic bug to set name of agent to include DB.  Note that the old agent must be removed manually

*/

SET NOCOUNT ON;
	
DECLARE @rc INT
      , @msg AS VARCHAR(250)
      , @DBName VARCHAR(100)
	  ,@JobName VARCHAR(100) 


SET @msg = SPACE(5) + DB_NAME() + ': Create Job to Delete History Records';
RAISERROR('%s',10,1,@msg); 

SELECT  @DBName = CAST([MFSettings].[Value] AS VARCHAR(100))
FROM    [dbo].[MFSettings]
WHERE   [MFSettings].[Name] = 'App_Database';

SET @JobName = N'MFSQL Delete History for ' + @DBName

IF DB_NAME() = @DBName 
   BEGIN	

DECLARE @JobID BINARY(16)   
DECLARE @ReturnCode INT  
SELECT @ReturnCode = 0  
-- Delete the job with the same name (if it exists)  
SELECT @JobID = job_id   
FROM  msdb.dbo.sysjobs  
WHERE (name = @JobName)   
IF (@JobID IS NOT NULL)  
BEGIN
IF (EXISTS (SELECT *   
FROM msdb.dbo.sysjobservers   
WHERE (job_id = @JobID) AND (server_id = 0)))   
-- Delete the [local] job   
EXECUTE msdb.dbo.sp_delete_job @job_name = @JobName
SELECT @JobID = NULL 
END


/****** Object:  Job [Delete History]    Script Date: 12/12/2016 16:35:56 ******/
         BEGIN TRANSACTION

         SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/12/2016 16:35:56 ******/
         IF NOT EXISTS ( SELECT [syscategories].[name]
                         FROM   [msdb].[dbo].[syscategories]
                         WHERE  [syscategories].[name] = N'Database Maintenance'
                                AND [syscategories].[category_class] = 1 )
            BEGIN
                  EXEC @ReturnCode = [msdb].[dbo].[sp_add_category]
                    @class = N'JOB'
                  , @type = N'LOCAL'
                  , @name = N'Database Maintenance'
                  IF ( @@ERROR <> 0
                       OR @ReturnCode <> 0
                     )
                     GOTO QuitWithRollback

            END



         EXEC @ReturnCode = [msdb].[dbo].[sp_add_job]
            @job_name = @JobName
          , @enabled = 1
          , @notify_level_eventlog = 0
          , @notify_level_email = 0
          , @notify_level_netsend = 0
          , @notify_level_page = 0
          , @delete_level = 0
          , @description = N'Delete MFSQL Connector history records'
          , @category_name = N'Database Maintenance'
          , @owner_login_name = N'MFSQLConnect'
          , @job_id = @jobId OUTPUT
         IF ( @@ERROR <> 0
              OR @ReturnCode <> 0
            )
            GOTO QuitWithRollback
/****** Object:  Step [Delete older than 90 days]    Script Date: 12/12/2016 16:35:56 ******/
         EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobstep]
            @job_id = @jobId
          , @step_name = N'Delete older than 90 days'
          , @step_id = 1
          , @cmdexec_success_code = 0
          , @on_success_action = 1
          , @on_success_step_id = 0
          , @on_fail_action = 2
          , @on_fail_step_id = 0
          , @retry_attempts = 0
          , @retry_interval = 0
          , @os_run_priority = 0
          , @subsystem = N'TSQL'
          , @command = N'DECLARE @date DATETIME
SET @date =  DATEADD(mm,-3,GETDATE())
EXEC [dbo].[spMFDeleteHistory] @DeleteBeforeDate = @date -- datetime'
          , @database_name = @DBName
          , @flags = 0
         IF ( @@ERROR <> 0
              OR @ReturnCode <> 0
            )
            GOTO QuitWithRollback
         EXEC @ReturnCode = [msdb].[dbo].[sp_update_job]
            @job_id = @jobId
          , @start_step_id = 1
         IF ( @@ERROR <> 0
              OR @ReturnCode <> 0
            )
            GOTO QuitWithRollback
         EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobschedule]
            @job_id = @jobId
          , @name = N'Monthly schedule'
          , @enabled = 0
          , @freq_type = 32
          , @freq_interval = 1
          , @freq_subday_type = 1
          , @freq_subday_interval = 0
          , @freq_relative_interval = 1
          , @freq_recurrence_factor = 1
          , @active_start_date = 20161022
          , @active_end_date = 99991231
          , @active_start_time = 220000
          , @active_end_time = 235959
          , @schedule_uid = N'ddde2312-6c0c-4d31-aa7c-3f8301e65940'
         IF ( @@ERROR <> 0
              OR @ReturnCode <> 0
            )
            GOTO QuitWithRollback
         EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobserver]
            @job_id = @jobId
          , @server_name = N'(local)'
         IF ( @@ERROR <> 0
              OR @ReturnCode <> 0
            )
            GOTO QuitWithRollback
         COMMIT TRANSACTION
         GOTO EndSave
         QuitWithRollback:
         IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION
         EndSave:
   END

GO



/*
Create agent to check MFiles version on a daily basis and update if changed
*/

SET NOCOUNT ON;

DECLARE @rc          INT
       ,@msg         AS VARCHAR(250)
       ,@DBName      VARCHAR(100)
       ,@JobName     VARCHAR(100) 
       ,@Description VARCHAR(100) = 'validate M-Files version and update Assemblies when changed';

SET @msg = SPACE(5) + DB_NAME() + ': Create Job to ' + @Description;

RAISERROR('%s', 10, 1, @msg);

SELECT @DBName = CAST([Value] AS VARCHAR(100))
FROM [dbo].[MFSettings]
WHERE [Name] = 'App_Database';

SET @JobName = N'MFSQL Validate ' + @DBName + ' M-Files Version'

IF DB_NAME() = @DBName
BEGIN
    DECLARE @JobID BINARY(16);
    DECLARE @ReturnCode INT;

    SELECT @ReturnCode = 0;

    -- Delete the job with the same name (if it exists)  
    SELECT @JobID = [job_id]
    FROM [msdb].[dbo].[sysjobs]
    WHERE ([name] = @JobName);

	  --SELECT [job_id],*
   -- FROM [msdb].[dbo].[sysjobs]
   -- WHERE ([name] = @JobName);

    IF (@JobID IS NOT NULL)
    BEGIN
        IF (EXISTS
        (
            SELECT *
            FROM [msdb].[dbo].[sysjobservers]
            WHERE ([job_id] = @JobID)
                  AND ([server_id] = 0)
        )
           )
            -- Delete the [local] job   
            EXECUTE [msdb].[dbo].[sp_delete_job] @job_name = @JobName;

        SELECT @JobID = NULL;
    END;

    /****** Object:  Job [Delete History]    Script Date: 12/12/2016 16:35:56 ******/
    BEGIN TRANSACTION;

    SELECT @ReturnCode = 0;

    /****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/12/2016 16:35:56 ******/
    IF NOT EXISTS
    (
        SELECT [syscategories].[name]
        FROM [msdb].[dbo].[syscategories]
        WHERE [syscategories].[name] = N'Database Maintenance'
              AND [syscategories].[category_class] = 1
    )
    BEGIN
        EXEC @ReturnCode = [msdb].[dbo].[sp_add_category] @class = N'JOB'
                                                         ,@type = N'LOCAL'
                                                         ,@name = N'Database Maintenance';

        RAISERROR('Install Database Maintenance Category: ReturnCode %i', 10, 1, @ReturnCode);

        IF (@@Error <> 0 OR @ReturnCode <> 0)
            GOTO QuitWithRollback;
    END;

    EXEC @ReturnCode = [msdb].[dbo].[sp_add_job] @job_name = @JobName
                                                ,@enabled = 1
                                                ,@notify_level_eventlog = 0
                                                ,@notify_level_email = 0
                                                ,@notify_level_netsend = 0
                                                ,@notify_level_page = 0
                                                ,@delete_level = 0
                                                ,@description = @Description
                                                ,@category_name = N'Database Maintenance'
                                                ,@owner_login_name = N'MFSQLConnect'
                                                ,@job_id = @JobID OUTPUT;

    RAISERROR('Add job: ReturnCode %i', 10, 1, @ReturnCode);

    IF (@@Error <> 0 OR @ReturnCode <> 0)
        GOTO QuitWithRollback;

    /****** Object:  Step [Delete older than 90 days]    Script Date: 12/12/2016 16:35:56 ******/
    EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobstep] @job_id = @JobID
                                                    ,@step_name = N'Validate MFVersion'
                                                    ,@step_id = 1
                                                    ,@cmdexec_success_code = 0
                                                    ,@on_success_action = 1
                                                    ,@on_success_step_id = 0
                                                    ,@on_fail_action = 2
                                                    ,@on_fail_step_id = 0
                                                    ,@retry_attempts = 0
                                                    ,@retry_interval = 0
                                                    ,@os_run_priority = 0
                                                    ,@subsystem = N'TSQL'
                                                    ,@command = N'EXEC [dbo].[spMFCheckAndUpdateAssemblyVersion] '
                                                    ,@database_name = @DBName
                                                    ,@flags = 0;

    RAISERROR('Add Step: ReturnCode %i', 10, 1, @ReturnCode);

    IF (@@Error <> 0 OR @ReturnCode <> 0)
        GOTO QuitWithRollback;

    EXEC @ReturnCode = [msdb].[dbo].[sp_update_job] @job_id = @JobID
                                                   ,@start_step_id = 1;

    RAISERROR('Set Start step: ReturnCode %i', 10, 1, @ReturnCode);

    IF (@@Error <> 0 OR @ReturnCode <> 0)
        GOTO QuitWithRollback;

    EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobschedule] @job_id = @JobID
                                                        ,@name = N'MFSQL MFVersion Daily schedule'
                                                        ,@enabled = 1
                                                        ,@freq_type = 4
                                                        ,@freq_interval = 1
                                                        ,@freq_subday_type = 1
                                                        ,@freq_subday_interval = 0
                                                        ,@freq_relative_interval = 0
                                                        ,@freq_recurrence_factor = 1
                                                        ,@active_start_date = 20190326
                                                        ,@active_end_date = 99991231
                                                        ,@active_start_time = 63000;

    RAISERROR('Add Schedule: ReturnCode %i', 10, 1, @ReturnCode);

    IF (@@Error <> 0 OR @ReturnCode <> 0)
        GOTO QuitWithRollback;

    EXEC @ReturnCode = [msdb].[dbo].[sp_add_jobserver] @job_id = @JobID
                                                      ,@server_name = N'(local)';

    RAISERROR('Set Server: ReturnCode %i', 10, 1, @ReturnCode);

    IF (@@Error <> 0 OR @ReturnCode <> 0)
        GOTO QuitWithRollback;

    COMMIT TRANSACTION;

    GOTO EndSave;

    QuitWithRollback:
    RAISERROR('Unable to create Validate MFVersion agent', 10, 1);

    IF (@@TranCount > 0)
        ROLLBACK TRANSACTION;

    EndSave:
END;
GO
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[vwMFUserGroup]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwUserGroup', -- nvarchar(100)
    @Object_Release = '3.3.1.37', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

/*
MODIFICATIONS
2017-06-21	LC	change name to standard naming for views

*/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwUserGroup'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW [dbo].[MFvwUserGroup]
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
	
ALTER  VIEW MFvwUserGroup
AS

SELECT CAST(mvli.MFid AS INT) AS UserGroupID, mvli.Name FROM dbo.MFValueListItems AS MVLI
INNER JOIN dbo.MFValueList AS MVL
ON mvli.MFValueListID = mvl.ID
WHERE mvl.name = 'User Group'

GO 

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFGetContextMenu]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMFGetContextMenu', -- nvarchar(100)
    @Object_Release = '3.2.1.32', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFGetContextMenu'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMFGetContextMenu]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

alter PROCEDURE [dbo].[spMFGetContextMenu]
AS

BEGIN
 
			select 
				IDENTITY(bigint,1,1) AS ROWID,
				CAST([ID] AS BIGINT) [ID],
				ActionName,
				Action,
				ActionType,
				Message,
				SortOrder,
				ParentID,
				0 as IsHeader,
				0 as ParentSortOrder,
				ISAsync,
				UserGroupID
				into 
				#Temp
			from 
				MFContextMenu 
			where 
				1=2

			insert into  #Temp 
			select 
				ID,
				ActionName,
				Action,
				ActionType,
				Message,
				SortOrder,
				ParentID,
				1,
				SortOrder as ParentSortOrder,
				isnull(ISAsync,0) as ISAsync,
				UserGroupID
			from 
				MFContextMenu 
			where 
				ParentID=0 and ActionType not in (4,5)
			order by 
				SortOrder


			insert into  #Temp 
			select 
				MFCM.ID,
				MFCM.ActionName,
				MFCM.Action,
				MFCM.ActionType,
				MFCM.Message,
				MFCM.SortOrder,
				MFCM.ParentID,
				0,
				T.ParentSortOrder,
				isnull(MFCM.ISAsync,0) as ISAsynch,
				MFCM.UserGroupID
			from 
				MFContextMenu MFCM inner join #Temp T on T.ID=MFCM.parentID


			select 
				ID
				,ActionName
				,Action
				,ActionType
				,Message
				,IsHeader
				, ISAsync
				,isnull(UserGroupID,0) as UserGroupID
			from 
				#Temp 
			order by 
				ParentSortOrder,
				IsHeader desc,
				sortorder
 
			 drop table #Temp


END

GO




PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spmfGetAction]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spmfGetAction', -- nvarchar(100)
    @Object_Release = '3.2.1.30', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spmfGetAction'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spmfGetAction]
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER Procedure dbo.spmfGetAction
@ActionType int,
@ActionName varchar(100),
@Action varchar(100) Output

as 
Begin
Select @Action=Action from MFContextMenu where ActionType=@ActionType  and ActionName=@ActionName
End

GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMfGetProcessStatus]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMfGetProcessStatus', -- nvarchar(100)
    @Object_Release = '3.2.1.30', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMfGetProcessStatus'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE [dbo].[spMfGetProcessStatus]
as
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

alter procedure dbo.spMfGetProcessStatus
@ID int,
@ProcessStatus Bit Output
as 
Begin

   Select @ProcessStatus=isnull(IsProcessRunning,0) from MFContextMenu where  ID=@ID

End


GO



PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFUpdateCurrentUserIDForAction]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMFUpdateCurrentUserIDForAction', -- nvarchar(100)
    @Object_Release = '3.2.1.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFUpdateCurrentUserIDForAction'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE dbo.spMFUpdateCurrentUserIDForAction
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER PROCEDURE dbo.spMFUpdateCurrentUserIDForAction
@UserID int,
@Action varchar(150)
as 
Begin

    Update MFContextMenu set ActionUser_ID=@UserID where Action=@Action
END

GO




PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFUpdateLastExecutedBy]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMFUpdateLastExecutedBy', -- nvarchar(100)
    @Object_Release = '3.2.1.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFUpdateLastExecutedBy'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE dbo.spMFUpdateLastExecutedBy
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER Procedure spMFUpdateLastExecutedBy
@ID int,
@UserID int 
as 
Begin
    UPdate MFContextMenu set Last_Executed_By=@UserID, Last_Executed_Date=getdate() where ID=@ID
End




PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMfGetProcessStatus]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMfGetProcessStatus', -- nvarchar(100)
    @Object_Release = '3.2.1.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMfGetProcessStatus'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE dbo.spMfGetProcessStatus
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER  procedure dbo.spMfGetProcessStatus
@ID int,
@ProcessStatus Bit Output,
@Username varchar(250) OUTput
as 
Begin

   Select @ProcessStatus=isnull(IsProcessRunning,0) from MFContextMenu where  ID=@ID
   select @Username=isnull(LA.AccountName,'') from MFContextMenu CM left join MFLoginAccount LA on CM.Last_Executed_By=LA.MFID  where CM.ID=@ID

End



PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[spMFGetContextMenuID]';
GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo',   @ObjectName = N'spMFGetContextMenuID', -- nvarchar(100)
    @Object_Release = '3.2.1.38', -- varchar(50)
    @UpdateFlag = 2 -- smallint

GO

IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   ROUTINE_NAME = 'spMFGetContextMenuID'--name of procedure
                    AND ROUTINE_TYPE = 'PROCEDURE'--for a function --'FUNCTION'
                    AND ROUTINE_SCHEMA = 'dbo' )
    BEGIN
        PRINT SPACE(10) + '...Stored Procedure: update';
        SET NOEXEC ON;
    END;
ELSE
    PRINT SPACE(10) + '...Stored Procedure: create';
GO
	
-- if the routine exists this stub creation stem is parsed but not executed
CREATE PROCEDURE dbo.spMFGetContextMenuID
AS
    SELECT  'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO

ALTER  Procedure spMFGetContextMenuID
@ActionType int,
@ActionName varchar(100),
@ID int Output

as 
Begin
Select @ID=ID from MFContextMenu where ActionType=@ActionType  
and ActionName=@ActionName
End


GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[vwMFUserGroup]';

GO
SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFvwUserGroup', -- nvarchar(100)
    @Object_Release = '3.3.1.37', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO

/*
MODIFICATIONS
2017-06-21	LC	change name to standard naming for views

*/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.[VIEWS]
            WHERE   [VIEWS].[TABLE_NAME] = 'MFvwUserGroup'
                    AND [VIEWS].[TABLE_SCHEMA] = 'dbo' )
 BEGIN
    SET NOEXEC ON;
 END
GO
CREATE VIEW [dbo].[MFvwUserGroup]
AS


       SELECT   [Column1] = 'UNDER CONSTRUCTION';
	GO
SET NOEXEC OFF;
	GO	
	
ALTER  VIEW MFvwUserGroup
AS

SELECT CAST(mvli.MFid AS INT) AS UserGroupID, mvli.Name FROM dbo.MFValueListItems AS MVLI
INNER JOIN dbo.MFValueList AS MVL
ON mvli.MFValueListID = mvl.ID
WHERE mvl.name = 'User Group'

GO 