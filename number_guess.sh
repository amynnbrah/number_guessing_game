#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME #get username

#does player exist in database?
PLAYER_USERNAME=$($PSQL "select username from players where username ilike '$USERNAME'")
if [[ -z $PLAYER_USERNAME ]] #no he doesnt
then
echo "Welcome, $USERNAME! It looks like this is your first time here."
#insert their username and their first game (next time do psql set default 1 instead)
INSERT_NEW_PLAYER=$($PSQL "INSERT INTO players(username, games_played) values('$USERNAME', 1)")
else
#they do exist in this case here
#get their info
PLAYER_INFO=$($PSQL "select * from players where username ilike '$USERNAME'")
echo "$PLAYER_INFO" | while IFS="|" read ID USER GAMES BEST 
do
#hallo user!
echo "Welcome back, $USER! You have played $GAMES games, and your best game took $BEST guesses."
INCREMENT_GAMES=$((GAMES+1)) #variable to check their game record
 #add one game to their record
INSERT_NEW_GAME=$($PSQL "update players set games_played = $INCREMENT_GAMES where username = '$USERNAME'")
done
fi
SECRET=$(( ( RANDOM % 1000 )  + 1 )) #random number 1-1000
NUMBER_OF_TRIES=1 #first try
ISITNUMBER='^[0-9]+$' #input must be integer

echo "Guess the secret number between 1 and 1000:"
read PLAYER_GUESS

#loop to check if input is higher\lower or not an integer
while [[ $PLAYER_GUESS -ne $SECRET ]] #while it's not equal to the result
do
if ! [[ $PLAYER_GUESS =~ $ISITNUMBER ]] #not an integer
then
echo "That is not an integer, guess again:"
NUMBER_OF_TRIES=$((NUMBER_OF_TRIES-1)) #remove the one extra try from wrong input
read PLAYER_GUESS #read again
fi
NUMBER_OF_TRIES=$((NUMBER_OF_TRIES+1)) #add one try as long as they input
if [[ $PLAYER_GUESS -gt $SECRET ]] #greater than the secret number
then
echo "It's lower than that, guess again:" 
read PLAYER_GUESS
elif [[ $PLAYER_GUESS -lt $SECRET ]] #lower than the secret number
then
echo "It's higher than that, guess again:"
read PLAYER_GUESS
fi
done
#while loop is broken out of / player guessed the result

if [[ $PLAYER_GUESS == $SECRET ]] #player gets the result 
then
#you got it in number of tries!
echo "You guessed it in $NUMBER_OF_TRIES tries. The secret number was $SECRET. Nice job!"
#select player's previous record
SELECT_BEST_RECORD=$($PSQL "select best_game from players where username ilike '$USERNAME'")
#previous record is either worse (higher than current record) or doesnt exist
if [[ $SELECT_BEST_RECORD -gt $NUMBER_OF_TRIES ]] || [[ -z $SELECT_BEST_RECORD ]]
then
#insert new record
INSERT_RECORD=$($PSQL "update players set best_game = $NUMBER_OF_TRIES where username ilike '$USERNAME'")
fi
exit #cya
fi
