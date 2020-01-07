/*rST**************************************************************************

===============
MFUpdateHistory
===============

Columns
=======

Id int (primarykey, not null)
  fixme description
Username nvarchar(250) (not null)
  fixme description
VaultName nvarchar(250) (not null)
  fixme description
UpdateMethod smallint (not null)
  fixme description
ObjectDetails xml
  fixme description
ObjectVerDetails xml
  fixme description
NewOrUpdatedObjectVer xml
  fixme description
NewOrUpdatedObjectDetails xml
  fixme description
SynchronizationError xml
  Object version of the record that has error
MFError xml
  Listing of the records with errors
DeletedObjectVer xml
  fixme description
UpdateStatus varchar(25)
  fixme description
CreatedAt datetime
  fixme description

Additional Info
===============

Every update that is processed through spMFUpdateTable is logged in the MFUpdateHistory Table.

As soon as the update is initiated an ID is reserved from MFUpdateHistory and the items related to the update is recorded in the table as XML records. Note that this table potentially could include large XML records and it is not recommended to perform a select statement on this table without any filters. It is also important to ensure that this table is maintained and that old records are regularly deleted. See spMFDeleteHistory.

The significance and nature of the contents of the columns in the MFUpdateHistory table will depend and the parameters of the MFUpdateTable procedure and the outcome of the procedure.


Indexes
=======

idx\_MFUpdateHistory\_id
  - Id

Used By
=======

- MFvwLogTableStats
- spMFAddCommentForObjects
- spMFCheckAndUpdateAssemblyVersion
- spMFDeleteHistory
- spMFGetHistory
- spMFLogError\_EMail
- spMFSynchronizeFilesToMFiles
- spmfSynchronizeLookupColumnChange
- spMFSynchronizeUnManagedObject
- spmfSynchronizeWorkFlowSateColumnChange
- spMFUpdateClassAndProperties
- spMFUpdateExplorerFileToMFiles
- spMFUpdateHistoryShow
- spMFUpdateTable


Changelog
=========

==========  =========  ========================================================
Date        Author     Description
----------  ---------  --------------------------------------------------------
2019-09-07  JC         Added documentation
==========  =========  ========================================================

**rST*************************************************************************/

GO

PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME())
    + '.[dbo].[MFUpdateHistory]';

GO

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'MFUpdateHistory', -- nvarchar(100)
    @Object_Release = '2.0.2.0', -- varchar(50)
    @UpdateFlag = 2 -- smallint
GO
/*------------------------------------------------------------------------------------------------
	Author: leRoux Cilliers, Laminin Solutions
	Create date: 2016-02
	Database: 
	Description: MFUpdate history auto assigns a unique id for each update to and from M-Files	
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
  Select * from MFUpdateHistory
  
-----------------------------------------------------------------------------------------------*/




IF NOT EXISTS ( SELECT  name
                FROM    sys.tables
                WHERE   name = 'MFUpdateHistory'
                        AND SCHEMA_NAME(schema_id) = 'dbo' )
    BEGIN
        CREATE TABLE [dbo].[MFUpdateHistory]
            (
              [Id] INT IDENTITY(1, 1)
                       NOT NULL ,
              [Username] NVARCHAR(250) NOT NULL ,
              [VaultName] NVARCHAR(250) NOT NULL ,
              [UpdateMethod] SMALLINT NOT NULL ,
              [ObjectDetails] XML NULL ,
              [ObjectVerDetails] XML NULL ,
              [NewOrUpdatedObjectVer] XML NULL ,
              [NewOrUpdatedObjectDetails] XML NULL ,
              [SynchronizationError] XML NULL ,
              [MFError] XML NULL ,
              [DeletedObjectVer] XML NULL ,
              [UpdateStatus] VARCHAR(25) NULL ,
              [CreatedAt] DATETIME
                CONSTRAINT [CreatedAt] DEFAULT ( GETDATE() )
                NULL ,
              CONSTRAINT [PK_MFUpdateHistory] PRIMARY KEY CLUSTERED
                ( [Id] ASC )
            );

        PRINT SPACE(10) + '... Table: created';
    END;
ELSE
    PRINT SPACE(10) + '... Table: exists';
	GO

--INDEXES #############################################################################################################################

IF NOT EXISTS ( SELECT  *
                FROM    sys.indexes
                WHERE   object_id = OBJECT_ID('MFUpdateHistory')
                        AND name = N'idx_MFUpdateHistory_id' )
    BEGIN
        PRINT SPACE(10) + '... Index: idx_MFUpdateHistory_id';
        CREATE NONCLUSTERED INDEX idx_MFUpdateHistory_id ON dbo.MFUpdateHistory (Id);
    END;


--SECURITY #########################################################################################################################3#######

IF NOT EXISTS ( SELECT  value
                FROM    sys.[extended_properties] AS [ep]
                WHERE   value = N'output XML contains updated or Created object detials' )
EXECUTE sp_addextendedproperty @name = N'MS_Description',
    @value = N'output XML contains updated or Created object detials',
    @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',
    @level1name = N'MFUpdateHistory', @level2type = N'COLUMN',
    @level2name = N'NewOrUpdatedObjectDetails';


GO
IF NOT EXISTS ( SELECT  value
                FROM    sys.[extended_properties] AS [ep]
                WHERE   value = N'output XML contains updated or created ObjVer details' )
EXECUTE sp_addextendedproperty @name = N'MS_Description',
    @value = N'output XML contains updated or created ObjVer details',
    @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',
    @level1name = N'MFUpdateHistory', @level2type = N'COLUMN',
    @level2name = N'NewOrUpdatedObjectVer';


GO
IF NOT EXISTS ( SELECT  value
                FROM    sys.[extended_properties] AS [ep]
                WHERE   value = N'input XML contains existing ObjVer details' )
EXECUTE sp_addextendedproperty @name = N'MS_Description',
    @value = N'input XML contains existing ObjVer details',
    @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',
    @level1name = N'MFUpdateHistory', @level2type = N'COLUMN',
    @level2name = N'ObjectVerDetails';


GO
IF NOT EXISTS ( SELECT  value
                FROM    sys.[extended_properties] AS [ep]
                WHERE   value = N'input XML contains updated or created object details ' )
EXECUTE sp_addextendedproperty @name = N'MS_Description',
    @value = N'input XML contains updated or created object details ',
    @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE',
    @level1name = N'MFUpdateHistory', @level2type = N'COLUMN',
    @level2name = N'ObjectDetails';

go
