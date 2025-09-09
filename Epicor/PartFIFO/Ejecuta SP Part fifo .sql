exec RVF_PRC_FIX_UPD_PART_FIFO_COST 'L65P8M'
'5102B-BALCAR11'
'L42S6500-B'
'ZTE BLADE A3 PLUS'
SELECT				*
FROM	[CORPEPISSRS01].[RVF_Local].dbo.[FIX_FIFO_Control] 

select top 100 * from erp.Part
where
--PartDescription like '%ZTE BLADE A3 PLUS%' AND
 PartNum like 'L42S6500-B'