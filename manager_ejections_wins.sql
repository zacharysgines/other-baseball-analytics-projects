select 
	ejections.GAMEID, 
	MIN(ejections.[DATE]) as [Date], 
	MIN(EJECTEENAME) as manager_name, 
	MIN(ejections.TEAM) as team, 
	MIN(wl) as win_loss
from ejections
join teamstats
on ejections.GAMEID = teamstats.gid
where JOB = 'M'
and ejections.TEAM = teamstats.team
group by ejections.GAMEID
order by [Date]