WITH playercount AS (
	SELECT
		team,
		SUBSTRING(date, 1, 4) AS year,
		COUNT(DISTINCT id) AS playersaves
	FROM
		pitching
	WHERE
		[save] = 1
		AND stattype = 'value'
		AND gametype = 'regular'
	GROUP BY
		SUBSTRING(date, 1, 4),
		team
),
teamsaves AS (
	SELECT
		team,
		SUBSTRING(date, 1, 4) AS year,
		SUM([save]) as teamsaves
	FROM
		pitching
	WHERE
		[save] = 1
		AND SUBSTRING(date, 1, 4) != '2020'
		AND stattype = 'value'
		AND gametype = 'regular'
	GROUP BY
		SUBSTRING(date, 1, 4),
		team
	HAVING	
		SUM([save]) >= 20
)
SELECT 
	playercount.team,
	playercount.year,
	playersaves,
	teamsaves,
	ROUND((playersaves / teamsaves), 2) AS save_pct
FROM
	playercount
	JOIN
	teamsaves ON playercount.team = teamsaves.team AND playercount.year = teamsaves.year
ORDER BY
	save_pct desc