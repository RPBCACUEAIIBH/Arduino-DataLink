#! /bin/bash

# Finding roots
ScriptPath="$(cd "$(dirname "$0")"; pwd -P)"
cd $ScriptPath
Command="/usr/local/bin" # so that you can run as command...
Files="/usr/share/DataLink"

# Root check
if [[ $(whoami) != "root" ]]
then
  echo "This script needs to run as root!"
  exit
fi

# Making DataLink a command
if [[ -e $Command/DataLink ]]
then
  rm -R $Command/DataLink # Remove
else
  cp -f $ScriptPath/DataLink $Command
  chown -R root:root $Command/DataLink
  chmod -R 755 $Command/DataLink
fi

# Important files
if [[ -d /usr/share/DataLink ]]
then
  rm -R $Files # Remove
else
  mkdir $Files
  cp -f $ScriptPath/LICENSE.md $Files
  cp -f $ScriptPath/Help.md $Files
  chown -R root:root $Files
  chmod -R 755 $Files
fi

# Sudoers entry
if [[ -f /etc/sudoers.d/DataLink-sudoers ]]
then
  rm /etc/sudoers.d/DataLink-sudoers # Remove
else
  touch /tmp/DataLink-sudoers
  echo "$SUDO_USER    ALL = (root) NOPASSWD: $Command/DataLink" > /tmp/DataLink-sudoers
  chmod 0440 /tmp/DataLink-sudoers
  cp -a /tmp/DataLink-sudoers /etc/sudoers.d
  rm -f /tmp/DataLink-sudoers
fi
