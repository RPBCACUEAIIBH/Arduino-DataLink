#! /bin/bash

Var=""
while [[ $Var != "Exited" ]]
do
  clear
  echo -n "DataLink status (read only terminal): "
  Var="$(cat $1/$2)"
  echo "$Var"
done
sleep 3
