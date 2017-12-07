usage: sudo DataLink [option]
usage: sudo DataLink [workdir]
usage: sudo DataLink [workdir] [port]
usage: sudo DataLink [workdir] [port] [baudrate]
usage: sudo DataLink [workdir] [port] [baudrate] [option] [argument] [option]
[argument]

Allows your program to send and receive data easily between an Arduino and a
linux PC outside the arduino IDE.

Options:
  -s                          starts by sending request to arduino
  -e                          exit on over signal
      --help                  display help message and exit
      --version               display version and license information and exit

Examples:
  sudo DataLink /dev/ttyUSB0 -s SendIt -e Over
Where the work dir and baud rate are default, port is /drv/ttyUSB0, request
signal is "SendIt" over signal is "Over"

- The port and baudrate must either be passed to the scrip as a parameter, or
it should be specified in a "Config" file, in the work directory before
launching DtataLink!
- The work directory defaults to pwd if not specified.
- baudrate defaults to 9600 if not specified.
- Port and baudrate order must be kept.

On the fly control functionality:
In the work directoy 4 files will be created, and an additional "Config" file
CAN be created.
By editing the "Controls" file you can get give commands to the script:
  Read                        start reading the specified port
  Stop                        stop reading specified port (lower CPU usage
while staying configured, and sending data to the arduino still works)
  Exit                        end program
  Clear                       clears the "Input" file
  Reconfigure                 load Congif file, and reconfigur stty
By editign the "Output" file you can send data to the arduino.
By creating and editing the "Config" file, then giving "Reconfigure" command
via the Controls file you can set ports and baudrates.
Config file should contain:
Port: [port]
BaudRate: [baudrate]
