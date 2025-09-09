SELECT
Schedule.EventType,	
Subscriptions.MatchData,
Schedule.ScheduleID,
Subscriptions.[Description],
Schedule.StartDate,
 Schedule.LastRunTime 
FROM ReportServer.dbo.ReportSchedule ReportSchedule
  INNER JOIN ReportServer.dbo.Schedule Schedule ON Schedule.ScheduleID = ReportSchedule.ScheduleID
   INNER JOIN ReportServer.dbo.Subscriptions Subscriptions ON Subscriptions.SubscriptionID = ReportSchedule.SubscriptionID
WHERE
		--Description LIKE '%Saldo deuda Cuenta Corriente%'
		--AND	
		Schedule.ScheduleID in (
		'8CCCCE37-75DD-4745-A6D4-D2CF09C05792',

		'87EDD01B-B186-4F5F-B24F-E4732D7CD71E',

		'F6941B97-3A00-4332-8C74-1F178C1FA9F4',

		'E62EBB77-BB13-4E49-ACFE-20FCB8D65D94',
		'C27F5609-919D-4B40-BC6C-41AC3FC6337E'
		
		)
		
		AND	Schedule.ScheduleID='E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'

		select * from ReportServer.dbo.Schedule
		where Schedule.ScheduleID='E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'--Aging Clientes - China
		OR	Schedule.ScheduleID='C27F5609-919D-4B40-BC6C-41AC3FC6337E'--Saldo deuda Cuenta Corriente
		select * from dbo.ReportSchedule 
		where ScheduleID='E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'
		begin tran

		update	ReportServer.dbo.Schedule
		SET		NextRunTime ='2022-10-04 10:45:03.620'
		where Schedule.ScheduleID='E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'

		rollback tran
		commit tran


		
select format(cast('08:15:03.620' as datetime),'yyyyMMdd');
SET DATEFORMAT dmy
DECLARE --@DATE AS DAtEtime='2022-10-04 10:45:03.620',
		@upd_date AS INT =FORMAT(cast('2022-10-04 12:18:03.620' as datetime),'yyyyMMdd')
EXEC [msdb].[dbo].[sp_update_schedule]
    --@name = 'Schedule_1',
	@schedule_id='647',
    @active_start_date =@upd_date,
	@enabled = 1;

SET DATEFORMAT dmy
DECLARE 
		@upd_date AS INT =FORMAT(cast('2022-10-04 08:15:03.620' as time),'yyyyMMdd');

EXEC [msdb].[dbo].sp_update_schedule 
    @schedule_id='647',
   -- @new_name = N'Weekly_Sun_4AM',
    @freq_type = 16,
    @freq_interval = 4,
    @freq_recurrence_factor = 1,
    @active_start_date=20220510,
	@active_start_time =08153;


	SELECT dbo.sysjobs.Name AS 'E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'

	EXEC  [msdb].[dbo].sp_help_schedule
	--@schedule_id=16
	@schedule_name = '8CCCCE37-75DD-4745-A6D4-D2CF09C05792';


	select * from ReportSchedule


