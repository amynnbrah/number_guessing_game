#!/bin/bash

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
SECRET=$(( ( RANDOM % 1000 )  + 1 ))
NUMBER_OF_TRIES=0

echo "Guess the secret number between 1 and 1000:"
echo $SECRET
read PLAYER_GUESS
while [ $PLAYER_GUESS != $SECRET ]
NUMBER_OF_TRIES=$((NUMBER_OF_TRIES+1))
do
if [[ $PLAYER_GUESS -gt $SECRET ]]
then
echo "It's lower than that, guess again:" 
read PLAYER_GUESS
else
echo "It's higher than that, guess again:"
read PLAYER_GUESS
fi
done

if [[ $PLAYER_GUESS == $SECRET ]]
then

echo "You guessed it in $NUMBER_OF_TRIES tries. The secret number was $SECRET. Nice job!"
fi