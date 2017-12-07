#! /bin/bash

Var=""
while [[ $Var != "Done" ]]
do
  clear
  echo -n "$2 content: "
  cat $1/$2
done
