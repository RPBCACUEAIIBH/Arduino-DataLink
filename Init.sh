#! /bin/bash

# This is a template for properly launching your own program, and DataLink at once... it also allows running multiple instances at the same time without interfenrence(assuming your program can do that as well) just in case you wanna collect data from multiple arduinos at once...
# This script should be able to run without super user rights...

# Using RAM to avoid excessive write of solid state media
RunDir=/run/user/$(id -u $USER)/DataLink_$RANDOM # It is recommended that the work directory of the DataLink contains a random number, for being able to connect and run 2 or more devices at the same time without interference.
while [[ -d $RunDir ]] # If the directory already exists it will generate another random name, and check again...
do
  RunDir=/run/user/$(id -u $USER)/DataLink_$RANDOM
done
mkdir $RunDir

# Creating config file (Your program must be able to edit it... before DataLink launches.)
touch $RunDir/Config
echo "Port: /dev/ttyUSB0" > $RunDir/Config
echo "BaudRate: 9600" >> $RunDir/Config

# Launching DataLink
sudo DataLink $RunDir& # The & at the end will create a paralel process so that both can run at the same time...

# Your program comes here
/location/YourProgram.anythig $RunDir& # You should be able to read and write everything in the $RunDir so no need for sudo unless your application requires root access... Look for "Reading" in the controls file, to determin that DataLink is ready.

rm -R $RunDir # Takes care of the junk...
