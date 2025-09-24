WITH savesranking AS (
	SELECT
		id,
		team,
		SUBSTRING(date, 1, 4) AS year,
		SUM([save]) as playersaves,
		RANK() OVER (PARTITION BY team, SUBSTRING(date, 1, 4) ORDER BY SUM([save]) desc) AS rn
	FROM
		pitching
	WHERE
		[save] = 1
		AND stattype = 'value'
		AND gametype = 'regular'
	GROUP BY
		id,
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
		AND stattype = 'value'
		AND gametype = 'regular'
	GROUP BY
		SUBSTRING(date, 1, 4),
		team
	HAVING SUM([save]) >= 20
)
SELECT 
	bios.playername,
	savesranking.team,
	savesranking.year,
	playersaves,
	teamsaves,
	ROUND((playersaves / teamsaves), 2) AS saves_pct
FROM
	savesranking
	JOIN
	teamsaves ON savesranking.team = teamsaves.team AND savesranking.year = teamsaves.year
	LEFT OUTER JOIN
	bios ON savesranking.id = bios.id
WHERE
	rn = 1
ORDER BY
	saves_pct