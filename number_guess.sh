#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME

PLAYER_USERNAME=$($PSQL "select username from players where username ilike '$USERNAME'")
if [[ -z $PLAYER_USERNAME ]]
then
echo "Welcome, $USERNAME! It looks like this is your first time here."
INSERT_NEW_PLAYER=$($PSQL "INSERT INTO players(username, games_played) values('$USERNAME', 1)")
else
PLAYER_INFO=$($PSQL "select * from players where username ilike '$USERNAME'")
echo "$PLAYER_INFO" | while IFS="|" read ID USER GAMES BEST 

do
echo "Welcome back, $USER! You have played $GAMES games, and your best game took $BEST guesses."
INCREMENT_GAMES=$((GAMES+1))
INSERT_NEW_GAME=$($PSQL "update players set games_played = $INCREMENT_GAMES where username = '$USERNAME'")
done
fi
SECRET=$(( ( RANDOM % 1000 )  + 1 ))
NUMBER_OF_TRIES=0
ISITNUMBER='^[0-9]+$'

echo "$SECRET"
echo "Guess the secret number between 1 and 1000:"
read PLAYER_GUESS


while [[ $PLAYER_GUESS -ne $SECRET ]]
do
if ! [[ $PLAYER_GUESS =~ $ISITNUMBER ]]
then
echo "That is not an integer, guess again:"
NUMBER_OF_TRIES=$NUMBER_OF_TRIES
read PLAYER_GUESS
fi
NUMBER_OF_TRIES=$((NUMBER_OF_TRIES+1))
if [[ $PLAYER_GUESS -gt $SECRET ]]
then
echo "It's lower than that, guess again:" 
read PLAYER_GUESS
elif [[ $PLAYER_GUESS -lt $SECRET ]]
then
echo "It's higher than that, guess again:"
read PLAYER_GUESS
fi
done

if [[ $PLAYER_GUESS == $SECRET ]]
then
if [[ $NUMBER_OF_TRIES == 0 ]]
then
NUMBER_OF_TRIES=$((NUMBER_OF_TRIES+1))
fi
echo "You guessed it in $NUMBER_OF_TRIES tries. The secret number was $SECRET. Nice job!"
SELECT_BEST_RECORD=$($PSQL "select best_game from players where username ilike '$USERNAME'")
if [[ $SELECT_BEST_RECORD -gt $NUMBER_OF_TRIES ]] || [[ -z $SELECT_BEST_RECORD ]]
then
INSERT_RECORD=$($PSQL "update players set best_game = $NUMBER_OF_TRIES where username ilike '$USERNAME'")
fi
exit
fi
