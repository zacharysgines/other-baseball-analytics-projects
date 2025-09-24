WITH ranking AS (
	SELECT
		playername,
		FRANCHISE,
		b_lp,
		SUM(b_ab) AS ab,
		FORMAT((SUM(b_h + b_w + b_hbp) / SUM(NULLIF(b_ab + b_w + b_hbp + COALESCE(b_sf, 0), 0))) + SUM(b_h + b_d + (b_t * 2) + (b_hr * 3)) / SUM(NULLIF(b_ab, 0)), 'N3') AS ops,
		RANK() OVER(PARTITION BY FRANCHISE, b_lp ORDER BY (SUM(b_h + b_w + b_hbp) / SUM(NULLIF(b_ab + b_w + b_hbp + COALESCE(b_sf, 0), 0))) + SUM(b_h + b_d + (b_t * 2) + (b_hr * 3)) / SUM(NULLIF(b_ab, 0)) desc) AS rn
	FROM
		batting
	LEFT OUTER JOIN
		bios ON bios.id = batting.id
	LEFT OUTER JOIN
		teams ON teams.team = batting.team
	WHERE
		stattype = 'value'
		AND gametype = 'regular'
		AND ph != 1
		AND pr != 1
		and b_lp IS NOT NULL
		and b_lp != ''
		AND FRANCHISE IS NOT NULL
	GROUP BY
		playername, 
		FRANCHISE, 
		b_lp
	HAVING 
		SUM(b_ab) > 
		(CASE 
			WHEN b_lp = 1 THEN 1400 
			WHEN b_lp = 2 THEN 1350 
			WHEN b_lp = 3 THEN 1350
			WHEN b_lp = 4 THEN 1300 
			WHEN b_lp = 5 THEN 1100
			WHEN b_lp = 6 THEN 950
			WHEN b_lp = 7 THEN 850
			WHEN b_lp = 8 THEN 1000 
			WHEN b_lp = 9 THEN 550
		END)
)
SELECT 
	playername,
	FRANCHISE,
	b_lp,
	ab,
	ops
FROM
	ranking
WHERE
	rn = 1