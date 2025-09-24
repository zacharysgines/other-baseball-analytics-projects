WITH RankedGames AS (
	SELECT
		id,
		team,
		SUBSTRING(date, 1, 4) AS year,
		p_ipouts / 3 AS innings,
		p_er,
		CASE
			WHEN p_ipouts = 0 THEN 999.99
			WHEN p_ipouts = '' THEN 999.99
			WHEN p_ipouts IS NULL THEN 999.99
			ELSE (9 * p_er / (p_ipouts / 3))
		END AS gameERA,
		ROW_NUMBER() OVER 
			(PARTITION BY id, SUBSTRING(date, 1, 4) 
			ORDER BY 	
				CASE
					WHEN p_ipouts = 0 THEN 999.99
					WHEN p_ipouts = '' THEN 999.99
					WHEN p_ipouts IS NULL THEN 999.99
					ELSE (9 * p_er / (p_ipouts / 3))
				END desc
		) AS rn
	FROM
		pitching
	WHERE
		stattype = 'value'
		AND p_gs = 1
		AND gametype = 'regular'
)
SELECT 
	bios.playername,
	RankedGames.team,
	RankedGames.year,
	FORMAT(SUM(RankedGames.innings), 'N1') AS innings,
	FORMAT((9 * SUM(p_er) / SUM(innings)), 'N2') AS ERA
FROM
	RankedGames
	LEFT OUTER JOIN
	bios ON RankedGames.id = bios.id
WHERE
	rn > 3
GROUP BY
	RankedGames.id,
	playername,
	year,
	team
HAVING
	SUM(RankedGames.innings) > 100
ORDER BY
	year DESC,
	ERA