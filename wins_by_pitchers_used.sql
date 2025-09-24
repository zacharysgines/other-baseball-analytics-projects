WITH usage AS (
	SELECT
		gid,
		team,
		MAX(p_seq) AS pitchers_used,
		wl,
		CASE
			WHEN wl = 'l' THEN 0
			ELSE 1
		END AS wins
	FROM
		pitching
	WHERE
		stattype = 'value'
		AND gametype = 'regular'
		AND SUBSTRING(gid, 4, 4) >= '1973'
	GROUP BY
		gid,
		team,
		wl
	HAVING	
		MAX(p_seq) > 0
)
SELECT
	SUM(wins) AS wins,
	COUNT(wl) AS games,
	FORMAT(CAST(SUM(wins) AS FLOAT)/ COUNT(wl), 'N3') AS w_perc
FROM
	usage
GROUP BY
	pitchers_used
ORDER BY
	pitchers_used