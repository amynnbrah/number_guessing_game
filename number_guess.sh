#!/bin/bash
GUESS=$RANDOM
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME

PLAYER_USERNAME=$($PSQL "select username from players where username ilike "$USERNAME"")
if [[ -z $PLAYER_USERNAME ]]
then
echo "Welcome, "$PLAYER_USERNAME"! It looks like this is your first time here."
fi