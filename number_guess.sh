#!/bin/bash
GUESS=$RANDOM
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME

PLAYER_USERNAME=$($PSQL "select username from players where username ilike '$USERNAME'")
if [[ -z $PLAYER_USERNAME ]]
then
echo "Welcome, $USERNAME! It looks like this is your first time here."
else
PLAYER_INFO=$($PSQL "select * from players where username ilike '$USERNAME'")
echo "$PLAYER_INFO" | while IFS="|" read ID USER GAMES BEST 
do
echo "Welcome back, $USER! You have played $GAMES games, and your best game took $BEST guesses."
done
fi
echo "Guess the secret number between 1 and 1000:"
