WITH savesrank AS (
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
teamrank AS (
	SELECT
		team,
		SUBSTRING(date, 1, 4) AS year,
		SUM([save]) as teamsaves,
		RANK() OVER (PARTITION BY SUBSTRING(date, 1, 4) ORDER BY SUM([save]) desc) AS team_saves_rank
	FROM
		pitching
	WHERE
		[save] = 1
		AND stattype = 'value'
		AND gametype = 'regular'
	GROUP BY
		SUBSTRING(date, 1, 4),
		team
)
SELECT
	playername,
	savesrank.team,
	savesrank.year,
	playersaves,
	teamsaves,
	RANK() OVER (PARTITION BY savesrank.year ORDER BY playersaves desc) AS player_save_rank,
	team_saves_rank,
	team_saves_rank - RANK() OVER (PARTITION BY savesrank.year ORDER BY playersaves desc) AS rank_diff
FROM
	savesrank
	JOIN
	teamrank ON savesrank.team = teamrank.team AND savesrank.year = teamrank.year
	LEFT OUTER JOIN
	bios ON savesrank.id = bios.id
WHERE
	rn = 1
ORDER BY
	rank_diff
