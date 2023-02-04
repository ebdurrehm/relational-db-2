#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(opponent_goals) + SUM(winner_goals) as all_goals FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) as avg_goals FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) as avg_goals FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals)+AVG(opponent_goals),16) as avg_goals FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) as MAX_goals FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "select count(winner_id) from games where winner_goals>2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "select name from teams full join games on teams.team_id=games.winner_id WHERE year=2018 and round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo  "$($PSQL "select DISTINCT(name) from teams FULL join games on teams.team_id=games.winner_id OR teams.team_id=games.opponent_id  WHERE year=2014 and round='Eighth-Final' ORDER BY name asc")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "select DISTINCT(name) from teams left join games on teams.team_id=games.winner_id WHERE winner_id is not null ORDER BY name asc")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "select YEAR, name from teams left join games on teams.team_id=games.winner_id WHERE winner_id is not null AND round='Final' ORDER BY name desc")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "select DISTINCT(name) from teams left join games on teams.team_id=games.winner_id OR teams.team_id=games.opponent_id  WHERE name like 'Co%'")"
echo