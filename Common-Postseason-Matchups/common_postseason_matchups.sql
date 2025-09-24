SELECT 
    LEAST(team.FRANCHISE, opp.FRANCHISE) AS team1,
    GREATEST(team.FRANCHISE, opp.FRANCHISE) AS team2,
    COUNT(DISTINCT year) AS matchup_count
FROM 
    batting 
JOIN
	teams AS team ON batting.team = team.team
JOIN
	teams AS opp ON batting.opp = opp.team
WHERE 
    gametype NOT IN ('regular', 'exhibition', 'allstar')
GROUP BY 
    LEAST(team.FRANCHISE, opp.FRANCHISE),
    GREATEST(team.FRANCHISE, opp.FRANCHISE)
HAVING
	LEAST(team.FRANCHISE, opp.FRANCHISE) IS NOT NULL
    AND GREATEST(team.FRANCHISE, opp.FRANCHISE) IS NOT NULL
ORDER BY 
    matchup_count DESC;