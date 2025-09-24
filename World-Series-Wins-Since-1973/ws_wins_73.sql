WITH games AS (
	SELECT
		gid,
		season,
		wteam, 
		lteam,
		gametype,
		RANK() OVER (PARTITION BY season ORDER BY SUBSTRING(gid, 4, 9) desc) AS rn 
	FROM
		gameinfo
	WHERE
		gametype = 'worldseries'
		AND season >= 1973
)
SELECT 
	FRANCHISE,
	NICKNAME,
	COUNT(FRANCHISE) AS wins
FROM 
	games 
FULL OUTER JOIN
	teams ON games.wteam = teams.TEAM
WHERE 
	rn = 1
	AND FRANCHISE IS NOT NULL
GROUP BY
	FRANCHISE,
	NICKNAME
ORDER BY
	wins desc

	