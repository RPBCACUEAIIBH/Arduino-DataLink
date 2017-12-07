#! /bin/bash

Var=""
while [[ $Var != "Done" ]]
do
  if [[ ! -z $Var ]]
  then
    echo $Var > $1/$2
  fi
  clear
  read -p "$2: " Var
done
