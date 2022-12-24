1. Players Strike Rate -> Total Runs divided by matches played
=> select p.name, (SUM(runsScored)/COUNT(*)) * 100 as strikeRate from PlayerPerformances pp
RIGHT JOIN Players on pp.playerId = p.id group by playerId;

2. Players avg. run-rate -> Total Runs divided by overs played
=> select p.name, (SUM(runsScored)/SUM(oversPlayed)) as runRate from PlayerPerformances pp
RIGHT JOIN Players p on pp.playerId = p.id group by playerId;

3. Players Top 3 matches according to strike rate
=> select id, s.name, c.name from
Matches m
RIGHT JOIN Stadium s on m.stadiumId = s.id
RIGHT JOIN Countries c on m.countryId = c.id
where id in (select matchId from PlayerPerformances where id in (select id from PlayerPerformances where playerId = ? order by (SUM(runsScored)/COUNT(*))*100 desc FETCH FIRST 3 ROWS ONLY));

4. Couple of Teams who have played most matches with each other.
=> select name from Countries where id in (SELECT team1, team2
FROM (
    SELECT id
         , MIN(countryId) AS team1
         , MAX(countryId) AS team2
    FROM Matches
    GROUP BY id
) AS x
GROUP BY team1, team2
ORDER BY COUNT(*) DESC);
