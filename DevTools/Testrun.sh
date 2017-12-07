#! /bin/bash

####################################################################
# This is a test script for those who got a new idea...            #
# (Note that this script will may not test every functionality...) #
####################################################################

# Variables
Port=/dev/ttyUSB0
BaudRate=9600

# Finding roots
ScriptPath="$(cd "$(dirname "$0")"; pwd -P)"
cd $ScriptPath/..

# Install
if [[ -e /usr/local/bin/DataLink ]]
then
  sudo ./Install.sh # Removing old one...
fi
sudo ./Install.sh # And this will re-install...

# Using RAM to avoid excessive write of solid state media
RunDir="/run/user/$(id -u $USER)/DataLink" # Only testing with single instance(I only have one arduino, and it should rung in parallel just fine if it passes all tests)...
if [[ ! -d $RunDir ]]
then
  mkdir $RunDir
fi

### One liner test ###
sudo DataLink $RunDir $Port $BaudRate -s SendIt -e Over&

# waiting for DataLink to exit
Ready=false
while [[ $Ready != "Exited" ]]
do
  sleep 0.1
  Ready=$(cat $RunDir/Controls)
done

# Coutinue?
read -p "Continue with on the fly testing?(y/n): " Yy
if [[ $Yy != [Yy]* ]]
then
  exit
fi



### On the fly test ###

# Configuring
touch $RunDir/Config
echo "Port: $Port" > $RunDir/Config
echo "BaudRate: 115200" >> $RunDir/Config

# Launching DataLink
sudo DataLink $RunDir $Port $BaudRate&

# waiting for DataLink to initialize
Ready=false
while [[ $Ready != "Reading" ]]
do
  sleep 0.1
  Ready=$(cat $RunDir/Controls)
done

### Test here ###
# Launching Control and Output terminals for manual testing
gnome-terminal -e "$ScriptPath/InputTerm.sh $RunDir Output"
gnome-terminal -e "$ScriptPath/InputTerm.sh $RunDir Controls"
gnome-terminal -e "$ScriptPath/OutputTerm.sh $RunDir Controls"

# waiting for DataLink to exit
Ready=false
while [[ $Ready != "Exited" ]]
do
  sleep 0.1
  Ready=$(cat $RunDir/Controls)
done
