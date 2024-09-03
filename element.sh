#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # if arg is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_CHOICE=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  else
    # arg is varchar
    ATOMIC_CHOICE=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
  fi
  # if choice not exist
  if [[ -z $ATOMIC_CHOICE ]]
  then
    echo "I could not find that element in the database."
  else
    # if choice exist query and return
    IFS="|" read NUMBER SYMBOL NAME TYPE MASS MELT BOIL <<< "$ATOMIC_CHOICE"
    echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi