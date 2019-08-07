PRINT SPACE(5) + QUOTENAME(@@ServerName) + '.' + QUOTENAME(DB_NAME()) + '.dbo.[spMFUpdateMFilesToMFSQL]';

SET NOCOUNT ON;

EXEC [setup].[spMFSQLObjectsControl] @SchemaName = N'dbo'
                                    ,@ObjectName = N'spMFUpdateMFilesToMFSQL' -- nvarchar(100)
                                    ,@Object_Release = '4.3.10.49'            -- varchar(50)
                                    ,@UpdateFlag = 2;
-- smallint
GO

/*
********************************************************************************
  ** Change History
  ********************************************************************************
  ** Date        Author     Description
  ** ----------  ---------  -----------------------------------------------------
  ** 2017-06-08	acilliers	ProcessBatch_ID not passed into spMFAuditTable
  ** 2017-06-08	acilliers	Incorrect LogTypeDetail value 
  ** 2017-06-29 AC			Change LogStatusDetail to 'Completed' from 'Complete' 	
  **2017-12-25  LC			change BatchProcessDetail log text for lastupdatedate
  **2017-12-28  LC			add routine to reset process_id 3,4 to 0
  **2018-5-10	LC			add error if invalid table name is specified
  ==2018-10-20  LC			fix processing time calculation
  **2018-10-22	LC			align logtext description for reporting, refine ProcessBatch messages
  **2019-4-11	LC			allow for large tables
  ******************************************************************************/

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
   ,@UpdateTypeID TINYINT = 1 -- 0 = full update 1 = incremental
   ,@Update_IDOut INT = NULL OUTPUT
   ,@ProcessBatch_ID INT = NULL OUTPUT
   ,@debug TINYINT = 0        -- 
)
AS
/*******************************************************************************
  ** Desc:  The purpose of this procedure is to syncronize records in the CLGLChart
  **		class Table from Epicor into M-Files.  
  **		Full Table Merge with every execution, INSERT, UPDATE, DELETE
  **  
  ** Version: 1.0.0.0
  **
  ** Processing Steps:

  ** Parameters and acceptable values:
  **			@ProcessBatch_ID:	Optional - If not provided will initialize new, else validate against existing.
				@UpdateTypeID:		0			: Full Recordset comparison	| Update/Insert/Delete based on full compare
									1			: Incremental based on timestamp and/last update date
									2			: Deletes Only
  ** 
   	
  **
  ** Author:          arnie@lamininsolutions.com
  ** Date:            2016-08-11
  */
/*


  */
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
           ,@Class_ID       INT;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [dbo].[MFClass] WHERE [TableName] = @MFTableName)
        BEGIN

            -------------------------------------------------------------
            -- Get/Validate ProcessBatch_ID
            -------------------------------------------------------------
            BEGIN
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
            END;

            /*************************************************************************************
	REFRESH M-FILES --> MFSQL	 (Process Codes: M2E2M | M2E | E2M2E | E2M ) --All Process Codes
*************************************************************************************/

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
            -- Get column for last modified
            -------------------------------------------------------------
			
			         DECLARE @lastModifiedColumn NVARCHAR(100);

                    SELECT @lastModifiedColumn = [mp].[ColumnName]
                    FROM [dbo].[MFProperty] AS [mp]
                    WHERE [mp].[MFID] = 21; --'Last Modified'

			-------------------------------------------------------------
            -- FULL REFRESH
            -------------------------------------------------------------
            BEGIN
                DECLARE @MFAuditHistorySessionID INT = NULL;

                IF @UpdateTypeID = (@UpdateType_0_FullRefresh)
                BEGIN
                    SET @StartTime = GETUTCDATE();

                    -------------------------------------------------------------
                    -- o/s switch to batch when the class table is too large
                    -------------------------------------------------------------  

                    -------------------------------------------------------------
                    -- class table update in batches
                    -------------------------------------------------------------
 --EXEC [dbo].[spMFTableAuditinBatches] @MFTableName = '@MFTableName' -- nvarchar(100)
 --                                         ,@FromObjid = ?   -- int
 --                                         ,@ToObjid = ?     -- int
 --                                         ,@WithStats = ?   -- bit
 --                                         ,@Debug = ?       -- int
        
DECLARE @Toobjid INT 

SET @sqlParam = N' @Toobjid INT output'
SET @sql = N'Select @ToObjid = max(Objid) from ' + QUOTENAME(@MFTableName) + ' ;'
EXEC sp_executeSql @Stmt = @SQL, @Parm = @sqlParam, @ToObjid = @ToObjid OUTPUT

SET @Toobjid = @Toobjid + 500

EXEC @return_value = [dbo].[spMFUpdateTableinBatches] @MFTableName = @MFTableName   -- nvarchar(100)
                                     ,@UpdateMethod = 1   -- int
                                     ,@WithTableAudit = 1 -- int
                                     ,@FromObjid = 1      -- bigint
                                     ,@ToObjid =  @Toobjid       -- bigint
                                     ,@WithStats =0     -- bit
                                     ,@Debug = 0          -- int
	

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
                    SET @LogTextDetail = ' Return Value: ' + CAST(@return_value AS NVARCHAR(256));
                    SET @LogColumnName = 'MFUpdate_ID ';
                    SET @LogColumnValue = CAST(@Update_IDOut AS NVARCHAR(256));

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
                END;

                --IF @UpdateTypeID = (@UpdateType_0_FullRefresh)

                -------------------------------------------------------------
                -- Incremental update
                -------------------------------------------------------------
                IF (@UpdateTypeID IN ( @UpdateType_1_Incremental, @UpdateType_2_Deletes ))
                BEGIN

                    -------------------------------------------------------------
                    -- Refresh table audit
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
                                                      ISNULL(@MFLastModifiedDate, '2000-01-01')
                                              END;
                    SET @DebugText = 'Filter Date: ' + CAST(@MFLastModifiedDate AS NVARCHAR(100));
                    SET @DebugText = @DefaultDebugText + @DebugText;

                    IF @debug > 0
                    BEGIN
                        RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep);
                    END;

                    SET @ProcedureStep = 'Create list of objids to update with TableAudit';

                    EXEC [dbo].[spMFTableAudit] @MFTableName = @MFTableName                     -- nvarchar(128)
                                               ,@MFModifiedDate = @MFLastModifiedDate           -- datetime
                                               ,@ObjIDs = NULL                                  -- nvarchar(4000)
                                               ,@SessionIDOut = @MFAuditHistorySessionID OUTPUT -- int
                                               ,@NewObjectXml = @NewObjectXml OUTPUT            -- nvarchar(max)
                                               ,@DeletedInSQL = @DeletedInSQL OUTPUT            -- int
                                               ,@UpdateRequired = @UpdateRequired OUTPUT        -- bit
                                               ,@OutofSync = @OutofSync OUTPUT                  -- int
                                               ,@ProcessErrors = @ProcessErrors OUTPUT          -- int
                                               ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT      -- int
                                               ,@Debug = @debug;                                -- smallint       

                    SELECT @rowcount = COUNT(*)
                    FROM [dbo].[MFAuditHistory]
                    WHERE [Class] = @Class_ID
                          AND [StatusFlag] IN ( @StatusFlag_1_MFilesIsNewer, @StatusFlag_5_NotInMFSQL )
                          AND [ObjectType] <> 9;

                    IF @rowcount > 0
                    BEGIN
                        SET @LogColumnName = 'Status flag 1 and 5:  ';
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
                        SET @LogTextDetail = ' Return Value: ' + CAST(@return_value AS NVARCHAR(256));

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

                        SET @ProcedureStep = 'Create Class table objid list';

                        IF OBJECT_ID('tempdb..#ObjIdList') IS NOT NULL
                            DROP TABLE [#ObjIdList];

                        CREATE TABLE [#ObjIdList]
                        (
                            [ObjId] INT PRIMARY KEY
                        );

                        INSERT [#ObjIdList]
                        (
                            [ObjId]
                        )
                        SELECT [ObjID]
                        FROM [dbo].[MFAuditHistory]
                        WHERE [SessionID] = @MFAuditHistorySessionID
                              AND [StatusFlag] IN ( @StatusFlag_1_MFilesIsNewer, @StatusFlag_5_NotInMFSQL );

                        SET @rowcount = @@RowCount;

                        IF @debug > 9
                        BEGIN
                            SET @DebugText = @DefaultDebugText + ' %i Object list record(s) ';

                            RAISERROR(@DebugText, 10, 1, @ProcedureName, @ProcedureStep, @rowcount);
                        END;

                        -------------------------------------------------------------
                        -- if audit table is not used
                        -------------------------------------------------------------	
                        /*
			            IF
                        (
                            SELECT COUNT(*) FROM [dbo].[MFAuditHistory] WHERE [Class] = @Class_ID
                        ) = 0
                        BEGIN
                            SET @sql
                                = N'
						 INSERT [#ObjIdList]
                        (
                            [ObjId]
                        )
                        SELECT [ObjID]
                        FROM MF where [StatusFlag] IN ( @StatusFlag_1_MFilesIsNewer, @StatusFlag_5_NotInMFSQL );;';

                            EXEC (@sql);
                        END;

						*/
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
                END;

                -- IF @UpdateTypeID = @UpdateType_1_Incremental

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
				SET @ProcessType = 'Update Tables'
				SET @LogType = 'Debug'
                SET @LogStatusDetail = CASE
                                           WHEN (@error <> 0) THEN
                                               'Failed'
                                           ELSE
                                               'Completed'
                                       END;
                SET @ProcedureStep = 'finalisation';
                SET @LogTypeDetail = 'Debug';
                SET @LogTextDetail = 'LastUpdate date: ' + CONVERT(VARCHAR(20), @MFLastUpdateDate, 120);
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
													,@Logtype = @Logtype
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