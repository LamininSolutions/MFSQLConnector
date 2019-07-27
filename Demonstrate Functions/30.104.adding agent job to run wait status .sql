USE [msdb]
GO

/*
Use this script to create a agent job for use with the agent job to prevent running an update if it is already in progress.
see also 70.104.Example-StartJobWait-Agent
*/
SET NOCOUNT ON 


DECLARE @jobId BINARY(16)
DECLARE @JobName NVARCHAR(100) = N'MFSQL_WaitStatus_Jobs'
DECLARE @JobDescription NVARCHAR(100) = N'Scheduled job to run wait status jobs every hour during day time'
DECLARE @RunAsLogin NVARCHAR(100) = N'LSUSA\LeRouxC'
DECLARE @ServerName NVARCHAR(100) = N'LSUK-SQL03\UKDEV03'
DECLARE @StepName NVARCHAR(100) = N'UpdateReportData'
DECLARE @DatabaseName NVARCHAR(100) = N'MFSQL_Test45_b'
DECLARE @Command NVARCHAR(Max) = N'
DECLARE @RetStatus int
exec dbo.spMFStart_job_wait ''MFSQL_DoUpdateReportingData_OnDemand'',''00:00:10''
'

IF NOT EXISTS (SELECT * FROM [dbo].[sysjobs] AS [s] WHERE name = @JobName)
Begin
EXEC  msdb.dbo.sp_add_job @job_name=@JobName, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description= @JobDescription, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@RunAsLogin, @job_id = @jobId OUTPUT,
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
select @jobId ; 

EXEC msdb.dbo.sp_add_jobserver @job_name=@JobName, @server_name = @ServerName


EXEC msdb.dbo.sp_add_jobstep @job_name=@JobName, @step_name= @StepName, 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@Command
		, 
		@database_name=@DatabaseName, 
		@flags=0

DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=@JobName, @name=N'Run on hourly interval', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20181119, 
		@active_end_date=99991231, 
		@active_start_time=700, 
		@active_end_time=180000, @schedule_id = @schedule_id OUTPUT
select @schedule_id

END
ELSE
PRINT @JobName + ' job already exists'
SELECT [s].[job_id] FROM [dbo].[sysjobs] AS [s] WHERE name = @JobName
GO
