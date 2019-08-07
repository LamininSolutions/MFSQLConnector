SET NOCOUNT ON;
GO
PRINT SPACE(5) + QUOTENAME(@@SERVERNAME) + '.' + QUOTENAME(DB_NAME()) + '.[dbo].[fnMFParseDelimitedString]';
PRINT SPACE(10) + '...Function: Create'
GO

SET NOCOUNT ON 
EXEC setup.[spMFSQLObjectsControl] @SchemaName = N'dbo', @ObjectName = N'fnMFParseDelimitedString', -- nvarchar(100)
    @Object_Release = '3.1.4.41', -- varchar(50)
    @UpdateFlag = 2 -- smallint
go

IF EXISTS ( SELECT  1
            FROM    information_schema.[ROUTINES]
            WHERE   [ROUTINES].[ROUTINE_NAME] = 'fnMFParseDelimitedString'--name of procedire
                    AND [ROUTINES].[ROUTINE_TYPE] = 'FUNCTION'
                    AND [ROUTINES].[ROUTINE_SCHEMA] = 'dbo' )
   SET NOEXEC ON
	GO
CREATE FUNCTION [dbo].[fnMFParseDelimitedString] ( )
RETURNS @tblList TABLE
      (
        ID INT IDENTITY(1, 1)
      , ListItem VARCHAR(1000)
      )
       WITH EXECUTE AS CALLER
AS
    BEGIN
		INSERT @tblList( [ListItem] )
		VALUES  ( 'not implemented' )
        RETURN 
    END
	GO
SET NOEXEC OFF
	GO
/*
!~
===============================================================================
OBJECT:        fnParseDelimitedString
===============================================================================
OBJECT TYPE:   Table Valued Function
===============================================================================
PARAMETERS:		@List - Delimited list to convert to key value pair tabl
				@Delimiter - delimiter, i.e. ','
===============================================================================
PURPOSE:    Converts a delimited list into a table
===============================================================================
DESCRIPTION:  
===============================================================================
NOTES:        
        SELECT * FROM dbo.fnParseDelimitedString('A,B,C',',')      
===============================================================================
HISTORY:
      09/13/2014 - Arnie Cilliers - Initial Version - QA
	  17/12/2017	LeRoux			Increase size of listitem to ensure that it will catr for longer names
===============================================================================
~!
*/ 
ALTER FUNCTION [dbo].[fnMFParseDelimitedString]
      (
        @List VARCHAR(MAX)
      , @Delimeter CHAR(1)
      )
RETURNS @tblList TABLE
      (
        ID INT IDENTITY(1, 1)
      , ListItem VARCHAR(1000)
      )
AS
    BEGIN

        DECLARE @ListItem VARCHAR(1000)
        DECLARE @StartPos INT
              , @Length INT
        WHILE LEN(@List) > 0
              BEGIN
                    SET @StartPos = CHARINDEX(@Delimeter, @List)
                    IF @StartPos < 0
                       SET @StartPos = 0
                    SET @Length = LEN(@List) - @StartPos - 1
                    IF @Length < 0
                       SET @Length = 0
                    IF @StartPos > 0
                       BEGIN
                             SET @ListItem = SUBSTRING(@List, 1, @StartPos - 1)
                             SET @List = SUBSTRING(@List, @StartPos + 1, LEN(@List) - @StartPos)
                       END
                    ELSE
                       BEGIN
                             SET @ListItem = @List
                             SET @List = ''
                       END
                    INSERT  @tblList
                            ( ListItem )
                    VALUES  ( @ListItem )
              END

        RETURN 
    END
	go
	