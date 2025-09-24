WITH WarAgg AS (
	SELECT playername, debut_m, last_m, SUM(WAR) as WAR
	FROM bios LEFT OUTER JOIN advancedstats
	ON bios.playername = advancedstats.player_name
	WHERE debut_m != '' 
	GROUP BY playername, debut_m, last_m
	HAVING SUM(WAR) IS NOT NULL
)
SELECT 
	bios.playername,  
	CAST(SUM(CASE WHEN teamstats.wl = 'w' THEN 1 ELSE 0 END) AS FLOAT) / (SUM(CASE WHEN teamstats.wl = 'l' THEN 1 ELSE 0 END) + SUM(CASE WHEN teamstats.wl = 'w' THEN 1 ELSE 0 END)) AS winningpercentage,
	WarAgg.WAR as WAR
FROM
	teamstats
LEFT OUTER JOIN
	bios
ON 
	bios.id = teamstats.mgr
LEFT OUTER JOIN
	WarAgg
ON
	bios.playername = WarAgg.playername
WHERE
	mgr != '' 
AND
	bios.playername IS NOT NULL
AND 
	WarAgg.WAR IS NOT NULL
GROUP BY 
	bios.playername, WarAgg.WAR
HAVING
	SUM(CASE WHEN teamstats.wl = 'w' THEN 1 ELSE 0 END) + SUM(CASE WHEN teamstats.wl = 'l' THEN 1 ELSE 0 END) > 162
ORDER BY
	WAR desc
