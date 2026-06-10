


Select * From Players;

Select * From Batting;

Select * From Bowling;

Select * From Matches;

-- 1. Batsmen status based on their strikerate and boundary%
With BatsmenStats AS (
	Select
		PlayerID,
		PlayerName,
		Team,
		Sum(RunsScored) As TotalRuns,
		Sum(BallsFaced) As TotalBalls,
		Count(InningsID) As InningsPlayed,
		ROUND(CAST(SUM(RunsScored) As Float) / NullIf(Count(MatchID), 0), 2) As BattingAverage,
		ROUND((CAST(SUM(RunsScored) As Float) / NullIf(Sum(BallsFaced), 0))*100, 2) As OverAllStrikeRate,
		Cast(Round(((SUM(FoursCount) * 4.0) + (SUM(SixesCount) * 6.0)) / NullIf(SUM(RunsScored), 0)*100, 2) As decimal(10,2)) As BoundaryPercentage
	From Batting
	Group By PlayerID, PlayerName, Team
)
Select
	PlayerId,
	PlayerName,
	Team,
	TotalRuns,
	TotalBalls,
	BattingAverage,
	OverAllStrikeRate,
	BoundaryPercentage,
	CASE
		When OverAllStrikeRate > 130 And BoundaryPercentage > 50 Then 'Power Hitter'
		WHEN OverallStrikeRate > 120 AND BattingAverage > 25 THEN 'Finisher'
        WHEN OverallStrikeRate BETWEEN 80 AND 120 And BattingAverage > 35 THEN 'Anchor'
        ELSE 'Standard Batsman'
	End PlayerRole
From BatsmenStats
Order By TotalRuns DESC;

-- 2. Bowler status based on their wickets, Economy, and Bowling strike rate
WITH BowlerStats AS (
    SELECT 
        PlayerID,
        PlayerName,
        Team,
        SUM(WicketsTaken) AS TotalWickets,
        SUM(OversBowled) AS TotalOvers,
        SUM(RunsConceded) AS TotalRunsConceded,
        ROUND(CAST(SUM(RunsConceded) AS FLOAT) / NULLIF(SUM(OversBowled), 0), 2) AS OverallEconomy,
        ROUND((CAST(SUM(OversBowled) AS FLOAT) * 6) / NULLIF(SUM(WicketsTaken), 0), 2) AS BowlingStrikeRate
    FROM Bowling
    GROUP BY PlayerID, PlayerName, Team
)
SELECT 
    PlayerName,
    Team,
    TotalWickets,
    TotalOvers,
	TotalRunsConceded,
    OverallEconomy,
    BowlingStrikeRate,
    CASE 
        WHEN TotalWickets >= 10 AND BowlingStrikeRate < 25 THEN 'Strike Bowler'
        WHEN OverallEconomy <= 7.0 AND TotalOvers >= 20 THEN 'Economical Bowler'
        ELSE 'Standard Bowler'
    END AS BowlerRole
FROM BowlerStats
ORDER BY TotalWickets DESC;

-- 3. Creating View for Batsmen status based on their strikerate and boundary% 

CREATE VIEW BatsmanPerformance AS
WITH BatsmanStats AS (
    SELECT 
        PlayerID,
        PlayerName,
        Team,
        SUM(RunsScored) AS TotalRuns,
        SUM(BallsFaced) AS TotalBalls,
        COUNT(MatchID) AS InningsPlayed,
        ROUND(CAST(SUM(RunsScored) AS FLOAT) / NULLIF(COUNT(MatchID), 0), 2) AS BattingAverage,
        ROUND((CAST(SUM(RunsScored) AS FLOAT) / NULLIF(SUM(BallsFaced), 0)) * 100, 2) AS OverallStrikeRate,
        ROUND(((SUM(FoursCount) * 4.0) + (SUM(SixesCount) * 6.0)) / NULLIF(SUM(RunsScored), 0) * 100, 2) AS BoundaryPercentage
    FROM Batting
    GROUP BY PlayerID, PlayerName, Team
)
SELECT 
    PlayerID, PlayerName, Team, TotalRuns, BattingAverage, OverallStrikeRate, BoundaryPercentage,
    CASE 
        WHEN OverallStrikeRate > 130 AND BoundaryPercentage > 50 THEN 'Power Hitter'
        WHEN OverallStrikeRate > 120 AND BattingAverage > 25 THEN 'Finisher'
        WHEN BattingAverage > 35 AND OverallStrikeRate BETWEEN 80 AND 120 THEN 'Anchor'
        ELSE 'Standard Batsman'
    END AS ProjectRole
FROM BatsmanStats
WHERE TotalRuns > 150;

-- 4. Creating View for Bowler status based on their wickets, Economy, and Bowling strike rate

CREATE VIEW BowlerPerformance AS
WITH BowlerStats AS (
    SELECT 
        PlayerID,
        PlayerName,
        Team,
        SUM(WicketsTaken) AS TotalWickets,
        SUM(OversBowled) AS TotalOvers,
        SUM(RunsConceded) AS TotalRunsConceded,
        ROUND(CAST(SUM(RunsConceded) AS FLOAT) / NULLIF(SUM(OversBowled), 0), 2) AS OverallEconomy,
        ROUND((CAST(SUM(OversBowled) AS FLOAT) * 6) / NULLIF(SUM(WicketsTaken), 0), 2) AS BowlingStrikeRate
    FROM Bowling
    GROUP BY PlayerID, PlayerName, Team
)
SELECT 
    PlayerID, PlayerName, Team, TotalWickets, TotalOvers, OverallEconomy, BowlingStrikeRate,
    CASE 
        WHEN TotalWickets >= 10 AND BowlingStrikeRate < 25 THEN 'Strike Bowler'
        WHEN OverallEconomy <= 7.0 AND TotalOvers >= 20 THEN 'Economical Bowler'
        ELSE 'Standard Bowler'
    END AS ProjectRole
FROM BowlerStats
WHERE TotalOvers > 10;

-- 5. Count of the players based on their roles
SELECT 
    Team,
    ProjectRole,
    COUNT(*) AS TotalPlayers
FROM BatsmanPerformance
GROUP BY Team, ProjectRole
ORDER BY Team, TotalPlayers DESC;

Select
	Team,
	ProjectRole,
	Count(*) As TotalPlayers
From BowlerPerformance
GROUP BY Team, ProjectRole
ORDER BY Team, TotalPlayers DESC;

-- 6. All players runs, wickets ni base cheskuni Country wise players ki ranking ivvatam
WITH CombinedPerformance AS (
    -- Step 1: Batting, Bowling data ni oke deggara pettatam (UNION ALL)
    SELECT MatchID, PlayerID, RunsScored AS PerformanceRuns, 0 AS PerformanceWickets FROM Batting
    UNION ALL
    SELECT MatchID, PlayerID, 0 AS PerformanceRuns, WicketsTaken AS PerformanceWickets FROM Bowling
),
MatchLevelMetrics AS (
    -- Step 2: oka match lo player runs and wickets sum
    SELECT MatchID, PlayerID, SUM(PerformanceRuns) AS MatchRuns, SUM(PerformanceWickets) AS MatchWickets
    FROM CombinedPerformance
    GROUP BY MatchID, PlayerID
),
BaseData AS (
    -- Step 3: Players and Matches join chesi winning impact chudali ante
    SELECT 
        p.PlayerID,
        p.PlayerName,
        p.Team,
        p.PlayingRole,
        p.AgeProfile,
        mlm.MatchRuns,
        mlm.MatchWickets,
        CASE 
			WHEN m.MatchWinner = p.Team THEN 1 
			ELSE 0 
		END AS IsMatchWon
    FROM MatchLevelMetrics mlm
    INNER JOIN Players p ON mlm.PlayerID = p.PlayerID
    INNER JOIN Matches m ON mlm.MatchID = m.MatchID
),
ImpactScores AS (
    -- Step 4: Conditional Aggregation
    SELECT 
        PlayerID,
        PlayerName,
        Team,
        PlayingRole,
        AgeProfile,
        SUM(MatchRuns) AS TotalRuns,
        SUM(MatchWickets) AS TotalWickets,
        SUM(CASE 
				WHEN IsMatchWon = 1 THEN (MatchRuns * 1) + (MatchWickets * 25) 
				ELSE 0 
			END) AS WinningImpactPoints
    FROM BaseData
    GROUP BY PlayerID, PlayerName, Team, PlayingRole, AgeProfile
)
-- Step 5: prathi team ki seperate DENSE_RANK() use chesi ranking
SELECT 
    PlayerName,
    Team,
    PlayingRole,
    AgeProfile,
    TotalRuns,
    TotalWickets,
    WinningImpactPoints,
    DENSE_RANK() OVER (PARTITION BY Team ORDER BY WinningImpactPoints DESC) AS CountryRank
FROM ImpactScores
WHERE WinningImpactPoints > 0
ORDER BY Team, CountryRank;

-- 7. Top 3 stadiums based on highest runs
SELECT Top 3
    M.Venue,
    SUM(B.RunsScored) AS TotalRunsScored
FROM Batting B
JOIN Matches M ON B.MatchID = M.MatchID
GROUP BY M.Venue
ORDER BY TotalRunsScored DESC;


-- 8. Filtering players based on their Age by combining View table (BatsmanPerformance)
Select
	B.PlayerName,
	B.Team,
	B.TotalRuns,
	P.AgeProfile As Age
From BatsmanPerformance B
Join Players P On P.PlayerID = B.PlayerID
Where AgeProfile < '25' And TotalRuns > 200
Order By TotalRuns DESC

-- 9. How many times each team won the toss and chose bat
SELECT
    TossWonTeam,
    COUNT(*) AS TimesWon,
    TossDecision
FROM Matches
WHERE TossDecision = 'Bat'
GROUP BY TossWonTeam, TossDecision;

-- 10. Top 5 highest individual scores
Select Top 5
	PlayerName,
	Team,
	RunsScored
From Batting
order By RunsScored DESC;

-- 11. Allrounders scored 30+ and 1 wicket

SELECT
    Ba.MatchID,
    Ba.PlayerID,
    Ba.PlayerName,
    Ba.RunsScored,
    Bo.WicketsTaken
FROM Batting Ba
JOIN Bowling Bo ON Ba.PlayerID = Bo.PlayerID AND Ba.MatchID = Bo.MatchID
WHERE Ba.RunsScored >= 30 AND Bo.WicketsTaken >= 1
ORDER BY Ba.RunsScored DESC;

-- 12. Big win margins > 50 runs and 5 wickets

SELECT
    MatchID,
    MatchWinner,
    WinMargin
FROM Matches
WHERE WinMargin LIKE '%runs%' -- Kevalam runs thoti gelichina matches mathrame filter chesthundhi
  AND CAST(REPLACE(WinMargin, ' runs', '') AS INT) > 50; -- ' runs' text ni remove chesi number ga marchi check chesthundhi

SELECT
    MatchID,
    MatchWinner,
    WinMargin
FROM Matches
Where WinMargin Like '%wickets%' -- Kevalam wickets thoti gelichina matches mathrame filter chesthundhi
And Cast(Replace(Winmargin, ' wickets', '') As Int) > 5;-- ' wickets' text ni remove chesi number ga marchi check chesthundhi







