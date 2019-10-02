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