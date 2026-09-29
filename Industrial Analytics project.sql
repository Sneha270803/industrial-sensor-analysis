create database IndustrialAnalytics
use IndustrialAnalytics

select * from industrial_sensor_data
select count(*) Total_records from industrial_sensor_data
--Missing Values
select 
count(*) - count(Timestamp) as missing_Timestamp ,
count(*) - count(Machine_ID) as missing_Machine_ID,
count(*) - count(Production_Line) as missing_Line,
count(*) - count(Vibration_mm_s) as missing_Vibration,
count(*) - count(Temperature_C) as missing_temperature,
count(*) - count(Output_units) as missing_output,
count(*) - count(Downtime_Minutes) as missing_downtime
from industrial_sensor_data

--Duplicate records
select
Timestamp,Machine_ID from industrial_sensor_data
group by Timestamp,Machine_id
having  count(*)>1

--Overall KPIs
select
count(*) as Sensor_logs,
count(distinct Machine_ID) as Machine_count,
count(distinct Production_Line) as Production_Lines,
Round(Avg(Vibration_mm_s),2) as avg_vibration,
Round(avg(Temperature_c),2) as Avg_tempertaure,
sum(output_units) as Total_output,
Round(sum(Downtime_Minutes),2) as Total_Downtime
from industrial_sensor_data

--Machine performance Analysis
select
Machine_ID,
count(*) as logs,
round(avg(Vibration_mm_s),2) as Avg_vibration,
round(avg(Temperature_C),2) as Agv_Temperature,
sum(output_units) as Total_Output,
round(sum(Downtime_Minutes),2) as Total_Downtime,
round(Avg(Downtime_Minutes),2) as Avg_Downtime
from industrial_sensor_data
group by Machine_ID
order by Total_Downtime

--Production line Analysis
select 
Production_Line,
count(*) as logs,
sum(Output_units) as Total_output,
round(Avg(Output_units),2) as Avg_Output,
round(Avg(Vibration_mm_s),2) as Avg_vibration,
round(Avg(Temperature_C),2) as Avg_Temperature,
round(sum(Downtime_Minutes),2) as Avg_Downtime
from industrial_sensor_data
group by Production_line
order by Total_output desc

--
select *,
case 
	when Vibration_mm_s>=7 and Temperature_C>=85 then 'Critical'
    when Vibration_mm_s>=5 and Temperature_C>=75 then 'High'
	when Vibration_mm_s>=3 and Temperature_C>=65 then 'Medium'
	else 'Normal'
end as Risk_Level
from industrial_sensor_data
-----where Risk_Level='High'

--Risk Analysis
with classified  as(
select *,
case 
	when Vibration_mm_s>=7 and Temperature_C>=85 then 'Critical'
	when Vibration_mm_s>=5 and Temperature_C>=75 then 'High'
	when Vibration_mm_s>=3 and Temperature_C>=65 then 'Medium'
	else 'Normal'
end as Risk_Level
from industrial_sensor_data)
select Risk_level,
count(*) as Records,
sum(output_units) as Total_output,
ROUND(Avg(Downtime_Minutes),2) as Avg_Downtime
from classified
group by Risk_Level 

--Ranking Machines according to Dwontime
with machine_summary as(
select Machine_ID,
sum(Downtime_minutes) as Total_Downtime,
rank() over(order by sum(Downtime_minutes) desc) as Downtime_rank
from industrial_sensor_data
group by Machine_ID
)
select * from machine_summary

--Unusually High Downtime
select * from industrial_sensor_data
where Downtime_Minutes>(
select avg(Downtime_Minutes)+2* STDEV(Downtime_Minutes)
from industrial_sensor_data
)order by Downtime_Minutes desc

--Machine Performance
create view vw_machine_performance as
select 
Machine_ID,
Production_Line,
count(*) as Sensor_Logs,
round(Avg(Vibration_mm_s),2) as Avg_Vibration,
round(Avg(temperature_C),2) as Avg_Temperature,
sum(Output_units) as Total_Output,
round(avg(Output_units),2) as Avg_Output,
round(sum(Downtime_Minutes),2) as total_DownTime,
round(Avg(Downtime_Minutes),2) as Avg_Downtime
from industrial_sensor_data
group by Machine_id,
Production_Line

select * from vw_machine_performance