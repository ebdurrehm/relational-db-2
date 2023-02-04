
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then 
      WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
      echo winner id $WINNER_ID
      OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
      echo OPPONEN id $OPPONENT_ID
      if [[ -z $WINNER_ID ]]
      then 
          echo WINNER inserted to teams table
          INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_RESULT=="INSERT 0 1" ]]
          then 
              echo Inserted into team , $WINNER
          fi
          echo winner selected from teams table
          WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
      else 
          echo winner selected in else condition
          WINNER_TEAM_ID=$WINNER_ID
      fi
   fi 

    if [[ $OPPONENT != "opponent" ]]
      then 
          OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

          if [[ -z $OPPONENT_ID ]]
             then 
                INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
          if [[ $INSERT_OPPONENT_RESULT=="INSERT 0 1" ]]
          then 
              echo Inserted into team , $OPPONENT
          fi

          OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
          else 
              OPPONENT_TEAM_ID=$OPPONENT_ID
    fi
    echo final winner id $WINNER_TEAM_ID, OPPONENT ID $OPPONENT_TEAM_ID
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round)
    values('$WINNER_TEAM_ID', '$OPPONENT_TEAM_ID', '$WINNER_GOALS', '$OPPONENT_GOALS', '$YEAR', '$ROUND')") 

    if [[ $INSERT_GAMES_RESULT=="INSERT 0 1" ]]
    then
       echo inserted into games 
    fi
  fi
done