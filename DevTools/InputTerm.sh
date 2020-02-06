#! /bin/bash

Status=""
Var=""
Help=false
while [[ $Status != "Exited" ]]
do
  if [[ ! -z $Var ]]
  then
    echo $Var > $1/$2
    if [[ ! -z $(echo "$Var" | grep "ChangeBR") ]]
    then
      Replace="$(grep "BaudRate" "$1/Config")"
      Var="BaudRate: $(echo $Var | awk '{ print $2 }')"
      sed -i "s/${Replace}/${Var}/g" "$1/Config"
      sleep 3 # Waiting for the Arduino to confirm new baud rate
      echo "Reconfigure" > $1/Controls
      sleep 1.5 # Waiting for refonfiguration...
      echo "Read" > $1/Controls
    fi
  fi
  clear
  if [[ $Help == true ]]
  then
    if [[ $2 == "Output" ]]
    then
      echo "You can send message to the arduino from this terminal."
      echo ""
      echo "If you're running the example sketch as is then try:"
      echo "SendIt                      Tells the arduino to send back some readings."
      echo "ChangeBL [4 difit number]   Changes burst lenghth. 0 = continuous scream."
      echo "ChangeBR [7 digit number]   Sets baud rate for both arduino and DataLink. Default is 9600"
      echo ""
      echo "Note that:"
      echo "Valid baud rates are:"
      echo "300(This one is fleaky and only recognizes short strings, but it has a nice 1900s terminal effect by being so slowt... :D )"
      echo "600, 1200, 2400, 4800"
      echo "9600(default, try this if arduino fails to set baudrate.)"
      echo "19200, 57600"
      echo "115200(Fastest known to work on Raspberry pi.)"
      echo "500000, 1000000, 2000000"
      echo "Stream can be stopped by pulling pin 12 LOW."
      echo ""
      echo "DataLink will send any message to the arduino that you(or your program) write into the Output file, and you can read anything sent back from the arduino from the Input file. (If you're running the Testrun.sh as is, you find the files in /run/user/[youruserid]/DataLink directory, which is user accessible location in RAM memory.)"
    elif [[ $2 == "Controls" ]]
    then
      echo "Commands:"
      echo "Read                        Start reading."
      echo "Stop                        Stop reading."
      echo "Exit                        Stop reading and exit. (Will no longger accept commands.)"
      echo "Clear                       Clears the Input and Output files."
      echo "Reconfigure                 Reload config file (can change baud rate without exiting.)"
      echo "ChangeBR [7 digit number]   Sets baud rate for only DataLink. Default is 9600"
      echo ""
      echo "Confirmation messages:"
      echo "Reading                     After executing Read command"
      echo "Stopped                     After executing Stop command"
      echo "Stopped Reconfigured        After executing Reconfigure command"
      echo "Exited                      After executing Exit command"
      echo ""
      echo "Same commands can be written by your program into the Controls file to control DataLink. (If you're running the Testrun.sh as is, you find the files in /run/user/[youruserid]/DataLink directory, which is user accessible location in RAM memory.)"
    fi
    echo ""
  fi
  if [[ $2 == "Output" ]]
  then
    read -p "Send to Arduino (try \"help\" for list of commands): " Var
  else
    read -p "DataLink controls (try \"help\" for list of commands): " Var
  fi
  if [[ $Var == "Help" || $Var == "help" ]]
  then
    Help=true
  else
    Help=false
  fi
  Status="$(cat $1/Controls)"
done
