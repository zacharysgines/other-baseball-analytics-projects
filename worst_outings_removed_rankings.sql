DECLARE @OutingsToRemove INT;
SET @OutingsToRemove = 3;

WITH RankedGames AS (
	SELECT 
		playername,
		SUBSTRING(date, 1, 4) AS year,
		CAST(p_ipouts AS FLOAT) / 3 AS innings, 
		CAST(p_er AS FLOAT) AS ER, 
		CASE
			WHEN p_ipouts = 0 THEN 9999.99
			ELSE FORMAT((9 * p_er / (CAST(p_ipouts AS FLOAT)/ 3)), 'N2')
		END AS gameERA,
		RANK() 
			OVER
				(PARTITION BY 
					playername, SUBSTRING(date, 1, 4) 
				ORDER BY 
					CASE
						WHEN p_ipouts = 0 THEN 9999.99
						ELSE (9 * p_er / (CAST(p_ipouts AS FLOAT)/ 3))
					END
				DESC) 
		AS RANK
	FROM 
		pitching
	join
		bios
	ON
		pitching.id = bios.id
	WHERE
		gametype = 'regular'
	AND
		p_gs = '1'
	AND
		p_ipouts != ''
	AND
		p_er != ''
),
RankedSum AS (
	SELECT
		playername, 
		year,
		FORMAT(9 * SUM(ER) / SUM(innings), 'N2') AS adjustedERA
	FROM	
		RankedGames
	WHERE
		RANK > @OutingsToRemove
	GROUP BY
		playername, year
),
AllGames AS (
	SELECT 
		playername,
		SUBSTRING(date, 1, 4) AS year,
		FORMAT((9 * SUM(CAST(p_er AS FLOAT))) / (SUM(CAST(p_ipouts AS FLOAT)) / 3), 'N2') AS realERA
	FROM 
		pitching
	JOIN
		bios
	ON
		pitching.id = bios.id
	WHERE
		gametype = 'regular'
	AND
		p_gs = '1'
	AND
		p_ipouts != ''
	AND
		p_er != ''
	GROUP BY
		playername, SUBSTRING(date, 1, 4)
	HAVING 
		(SUM(CAST(p_ipouts AS FLOAT)) / 3) > 100
)
SELECT 
	RankedSum.playername,
	RankedSum.year,
	realERA,
	adjustedERA,
	FORMAT(CAST(realERA AS FLOAT) - CAST(adjustedERA AS FLOAT), 'N2') AS diff
FROM 
	RankedSum
RIGHT OUTER JOIN
	AllGames
ON
	RankedSum.playername = AllGames.playername
AND
	RankedSum.year = AllGames.year
ORDER BY
	year DESC, diff DESC