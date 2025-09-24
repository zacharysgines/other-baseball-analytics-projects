SELECT 
	playername,
	SUBSTRING(date, 1, 4) AS year,
	MAX(cast(p_k as float)) as topKs,
	SUM(CAST(p_k as float)) as totalKs,
	FORMAT((MAX(cast(p_k as float))) / (SUM(CAST(p_k as float))), 'N3') as perc
FROM 
	pitching
JOIN 
	bios ON pitching.id = bios.id
WHERE 
	p_ipouts <= 27
	AND gametype = 'regular'
	AND p_k != 0
	AND SUBSTRING(date, 1, 4) >= 1968
GROUP BY
	playername,
	SUBSTRING(date, 1, 4),
	pitching.id
HAVING
	COUNT(*) > 10
AND
	MAX(cast(p_k as INT)) > 0
ORDER BY
	perc desc
