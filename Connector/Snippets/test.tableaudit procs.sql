
/*

*/
--Created on: 2019-06-12 

--DECLARE @Objids NVARCHAR(4000) =
--'623,624,625,626,627,628,629'

--SELECT LEN(@objids)
/*
',630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346'

*/

--DECLARE @MFModifiedDate DATETIME, @NewObjectXML NVARCHAR(MAX)

-- EXEC [dbo].[spMFGetObjectvers] @TableName = 'MFLarge_Volume'         -- nvarchar(max)
--                                      ,@dtModifiedDate = null  -- datetime
--                                      ,@MFIDs = null        -- nvarchar(max)
--                                      ,@outPutXML = @NewObjectXml OUTPUT; -- nvarchar(max)
--SELECT CAST(@NewObjectXML AS xml)

DECLARE @StartTime NVARCHAR(30)
SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('Start %s',10,1) WITH NOWAIT


DECLARE @SessionIDOut    INT
       ,@NewObjectXml    NVARCHAR(MAX)
       ,@DeletedInSQL    INT
       ,@UpdateRequired  BIT
       ,@OutofSync       INT
       ,@ProcessErrors   INT
       ,@ProcessBatch_ID INT;

	   DECLARE 	   @MFModifiedDate DATETIME;
--SELECT  @MFModifiedDate = MAX([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah]
--WHERE class = 94

SELECT @MFModifiedDate = MAX([mlv].[MF_Last_Modified]) FROM [dbo].[MFBasic_singleprop]  AS [mlv]

SELECT @MFModifiedDate

EXEC [dbo].[spMFTableAudit] @MFTableName = 'MFLarge_Volume'    -- nvarchar(128)
                           ,@MFModifiedDate = @MFModifiedDate -- datetime
                       --    ,@ObjIDs = @Objids         -- nvarchar(4000)
                           ,@SessionIDOut = @SessionIDOut OUTPUT                    -- int
                           ,@NewObjectXml = @NewObjectXml OUTPUT                    -- nvarchar(max)
                           ,@DeletedInSQL = @DeletedInSQL OUTPUT                    -- int
                           ,@UpdateRequired = @UpdateRequired OUTPUT                -- bit
                           ,@OutofSync = @OutofSync OUTPUT                          -- int
                           ,@ProcessErrors = @ProcessErrors OUTPUT                  -- int
                           ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT              -- int
                           ,@Debug = 0         -- smallint

						   SELECT CAST(@NewObjectXml AS XML)
						   SELECT @UpdateRequired 

SELECT * FROM [dbo].[MFvwAuditSummary] AS [mfas]

SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('End %s',10,1) WITH NOWAIT

	GO
						  
DECLARE @StartTime NVARCHAR(30)
SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('Start %s',10,1) WITH NOWAIT


DECLARE @SessionIDOut    INT
       ,@NewObjectXml    NVARCHAR(MAX)
       ,@DeletedInSQL    INT
       ,@UpdateRequired  BIT
       ,@OutofSync       INT
       ,@ProcessErrors   INT
       ,@ProcessBatch_ID INT;

	   DECLARE 	   @MFModifiedDate DATETIME;
--SELECT  @MFModifiedDate = MAX([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah]
--WHERE class = 94

SELECT @MFModifiedDate = MAX([mlv].[MF_Last_Modified]) FROM [dbo].[MFBasic_singleprop]  AS [mlv]

SELECT @MFModifiedDate

EXEC [dbo].[spMFTableAudit] @MFTableName = 'MFLarge_Volume'    -- nvarchar(128)
                           ,@MFModifiedDate = @MFModifiedDate -- datetime
                       --    ,@ObjIDs = @Objids         -- nvarchar(4000)
                           ,@SessionIDOut = @SessionIDOut OUTPUT                    -- int
                           ,@NewObjectXml = @NewObjectXml OUTPUT                    -- nvarchar(max)
                           ,@DeletedInSQL = @DeletedInSQL OUTPUT                    -- int
                           ,@UpdateRequired = @UpdateRequired OUTPUT                -- bit
                           ,@OutofSync = @OutofSync OUTPUT                          -- int
                           ,@ProcessErrors = @ProcessErrors OUTPUT                  -- int
                           ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT              -- int
                           ,@Debug = 0         -- smallint

						   SELECT CAST(@NewObjectXml AS XML)
						   SELECT @UpdateRequired 

SELECT * FROM [dbo].[MFvwAuditSummary] AS [mfas]

SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('End %s',10,1) WITH NOWAIT

GO

DECLARE @StartTime NVARCHAR(30)
SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('Start %s',10,1) WITH NOWAIT


DECLARE @SessionIDOut    INT
       ,@NewObjectXml    NVARCHAR(MAX)
       ,@DeletedInSQL    INT
       ,@UpdateRequired  BIT
       ,@OutofSync       INT
       ,@ProcessErrors   INT
       ,@ProcessBatch_ID INT;

	   DECLARE 	   @MFModifiedDate DATETIME;
--SELECT  @MFModifiedDate = MAX([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah]
--WHERE class = 94

SELECT @MFModifiedDate = MAX([mlv].[MF_Last_Modified]) FROM [dbo].[MFBasic_singleprop]  AS [mlv]

SELECT @MFModifiedDate

EXEC [dbo].[spMFTableAudit] @MFTableName = 'MFLarge_Volume'    -- nvarchar(128)
                           ,@MFModifiedDate = @MFModifiedDate -- datetime
                       --    ,@ObjIDs = @Objids         -- nvarchar(4000)
                           ,@SessionIDOut = @SessionIDOut OUTPUT                    -- int
                           ,@NewObjectXml = @NewObjectXml OUTPUT                    -- nvarchar(max)
                           ,@DeletedInSQL = @DeletedInSQL OUTPUT                    -- int
                           ,@UpdateRequired = @UpdateRequired OUTPUT                -- bit
                           ,@OutofSync = @OutofSync OUTPUT                          -- int
                           ,@ProcessErrors = @ProcessErrors OUTPUT                  -- int
                           ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT              -- int
                           ,@Debug = 0         -- smallint

						   SELECT CAST(@NewObjectXml AS XML)
						   SELECT @UpdateRequired 

SELECT * FROM [dbo].[MFvwAuditSummary] AS [mfas]

SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('End %s',10,1) WITH NOWAIT

GO

DECLARE @StartTime NVARCHAR(30)
SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('Start %s',10,1) WITH NOWAIT


DECLARE @SessionIDOut    INT
       ,@NewObjectXml    NVARCHAR(MAX)
       ,@DeletedInSQL    INT
       ,@UpdateRequired  BIT
       ,@OutofSync       INT
       ,@ProcessErrors   INT
       ,@ProcessBatch_ID INT;

	   DECLARE 	   @MFModifiedDate DATETIME;
--SELECT  @MFModifiedDate = MAX([mah].[TranDate]) FROM [dbo].[MFAuditHistory] AS [mah]
--WHERE class = 94

SELECT @MFModifiedDate = MAX([mlv].[MF_Last_Modified]) FROM [dbo].[MFBasic_singleprop]  AS [mlv]

SELECT @MFModifiedDate

EXEC [dbo].[spMFTableAudit] @MFTableName = 'MFLarge_Volume'    -- nvarchar(128)
                           ,@MFModifiedDate = @MFModifiedDate -- datetime
                       --    ,@ObjIDs = @Objids         -- nvarchar(4000)
                           ,@SessionIDOut = @SessionIDOut OUTPUT                    -- int
                           ,@NewObjectXml = @NewObjectXml OUTPUT                    -- nvarchar(max)
                           ,@DeletedInSQL = @DeletedInSQL OUTPUT                    -- int
                           ,@UpdateRequired = @UpdateRequired OUTPUT                -- bit
                           ,@OutofSync = @OutofSync OUTPUT                          -- int
                           ,@ProcessErrors = @ProcessErrors OUTPUT                  -- int
                           ,@ProcessBatch_ID = @ProcessBatch_ID OUTPUT              -- int
                           ,@Debug = 0         -- smallint

						   SELECT CAST(@NewObjectXml AS XML)
						   SELECT @UpdateRequired 

SELECT * FROM [dbo].[MFvwAuditSummary] AS [mfas]

SET @StartTime = CAST(GETDATE() AS NVARCHAR(30))

RAISERROR('End %s',10,1) WITH NOWAIT

GO