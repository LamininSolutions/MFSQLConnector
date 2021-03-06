PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.dbo.spMFContextMenuHeadingItem';
GO
SET NOCOUNT ON;
EXEC setup.spMFSQLObjectsControl @SchemaName = N'dbo',
                                 @ObjectName = N'spMFContextMenuHeadingItem', -- nvarchar(100)
                                 @Object_Release = '4.1.5.42',
                                 @UpdateFlag = 2;

GO
IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_NAME = 'spMFContextMenuHeadingItem' --name of procedure
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
CREATE PROCEDURE dbo.spMFContextMenuHeadingItem
AS
SELECT 'created, but not implemented yet.';
--just anything will do

GO
-- the following section will be always executed
SET NOEXEC OFF;
GO
ALTER PROCEDURE dbo.spMFContextMenuHeadingItem
(

@MenuName NVARCHAR(100) 
, @PriorMenu NVARCHAR(100) = NULL
,@IsObjectContextMenu BIT = 0
,@IsRemove BIT = 0
, @UserGroup NVARCHAR(100) = NULL
,@Debug INT = 0

)
AS
/*rST**************************************************************************

==========================
spMFContextMenuHeadingItem
==========================

Return
  - 1 = Success
  - -1 = Error
Parameters
  @MenuName nvarchar(100)
    The name visible to the user in the context menu
  @PriorMenu nvarchar(100) (optional)
    - Default = NULL
    - This can be used to re-organise the menu
  @IsObjectContextMenu bit (optional)
    - Default = 0
    - 1 = the heading is used for object sensitive actions
  @IsRemove bit (optional)
    - Default = 0
    - 1 = remove the item from the table
  @UserGroup nvarchar(100)
    Restrict the menu item for to the users in the usergroup
  @Debug int (optional)
    - Default = 0
    - 1 = Standard Debug Mode
    - 101 = Advanced Debug Mode

Purpose
=======

This procedure is designed to add a context menu heading item in MFContextMenu

Prerequisites
=============

It is good practice to add the menu heading first, and then to add the actions using spMFContextMenuActionItem

Examples
========

.. code:: sql

    EXEC [dbo].[spMFContextMenuHeadingItem]
         @MenuName = 'Asynchronous Actions',
         @PriorMenu = 'Synchronous Actions',
         @IsObjectContextMenu = 0,
         @IsRemove = 0,
         @UserGroup = 'All internal users'

Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-08-30  JC         Added documentation
2018-07-15  LC         Add ability to change Heading
==========  =========  ========================================================

**rST*************************************************************************/

/*
Procedure to add new line item in MFContextMenu
*/


-------------------------------------------------------------
-- NEW MENU HEADING
-------------------------------------------------------------
BEGIN

DECLARE @ActionName NVARCHAR(100)
DECLARE @Action NVARCHAR(100)
DECLARE @ActionMessage NVARCHAR(100)
DECLARE @ActionType INT

DECLARE @ParentID INT
DECLARE @IsAsync INT
DECLARE @UserGroup_ID INT
DECLARE @SortOrder INT
DECLARE @MaxSortOrder INT
DECLARE @PriorMenu_ID int

IF NOT EXISTS(SELECT 1 FROM [dbo].[MFContextMenu] AS [mcm] WHERE [mcm].[ActionName] = @MenuName)
BEGIN


SET @ActionName = @MenuName
SET @Action = NULL
SET @ActionType = CASE WHEN @IsObjectContextMenu = 1 THEN 3 ELSE 0 end
SET @ActionMessage = NULL
SET @ParentID = 0
SET @IsAsync = NULL

SET @Usergroup_ID = CASE WHEN @usergroup IS NULL THEN 1 ELSE (SELECT [mfug].[UserGroupID] FROM [dbo].[MFvwUserGroup] AS [mfug] WHERE mfug.[Name] = @UserGroup)
END


SELECT @MaxSortOrder = ISNULL(MAX([mcm].[SortOrder]),-1) FROM [dbo].[MFContextMenu] AS [mcm]


SELECT @PriorMenu_ID = CASE WHEN @PriorMenu IS NOT NULL THEN (SELECT id FROM MFContextMenu WHERE ActionName = @PriorMenu)
ELSE @MaxSortOrder
END


SELECT @SortOrder = CASE WHEN @MaxSortOrder  = -1 THEN 1
WHEN @PriorMenu_ID IS NULL THEN @MaxSortOrder + 1
ELSE @PriorMenu_ID + 1
END


	
CREATE TABLE #ReorderList (id INT, sortorder int)
INSERT INTO [#ReorderList]
(
    [id],
    [sortorder]
)
SELECT id, [sortorder] FROM [dbo].[MFContextMenu] AS [mcm] WHERE [sortorder] >= @SortOrder

UPDATE cm
SET [sortorder] = cm.[sortorder] + 1
FROM MFContextMenu cm
INNER JOIN [#ReorderList] AS [rl]
ON cm.id = rl.[id]
WHERE cm.id = rl.[id]

      Merge INTO [dbo].[MFContextMenu] cm
       
        
		USING 
		 (SELECT @ActionName AS [Actionname],
               @Action AS [Action],
               @ActionType AS [ActionType],
               @ActionMessage AS [ActionMessage],
               @SortOrder AS [SortOrder],
               @ParentID AS [ParentID],
               @IsAsync AS [ISAsync],
               @UserGroup_ID AS [UserGroupID] ) S 
			   ON cm.[ActionName] = s.[Actionname]
			   WHEN NOT MATCHED THEN INSERT
               (
            [ActionName],
            [Action],
            [ActionType],
            [Message],
            [SortOrder],
            [ParentID],
            [ISAsync],
            [UserGroupID]
			)
			VALUES
             (s.[ActionName],
            s.[Action],
            s.[ActionType],
            s.[ActionMessage],
            s.[SortOrder],
            s.[ParentID],
            s.[ISAsync],
            s.[UserGroupID])
			WHEN MATCHED AND @IsRemove = 0 THEN UPDATE SET
            [Action] = s.[Action] ,
            [ActionType] = s.[ActionType],
            [Message] = s.[ActionMessage],
            [SortOrder] = s.[SortOrder],
            [ParentID] = s.[ParentID],
            [ISAsync] = s.[ISAsync],
            [UserGroupID] = s.[UserGroupID];


        DROP TABLE [#ReorderList];

IF @IsRemove = 1
            DELETE FROM [dbo].[MFContextMenu]
            WHERE [ActionName] = @ActionName;
    END;
	END


IF @Debug > 0
SELECT * FROM [dbo].[MFContextMenu] AS [mcm]

GO

 