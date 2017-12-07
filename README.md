Readme for the Arduino DataLink

A breief story:
  The idea that started this project was to have a tool for easily collect unlimited amount of data from an arduino by just typing in a one liner command into the linux terminal...
  The reason for choosing shell for this project is to have the least amount of unnecessary programs to install.
  The extra on on the fly control functionality idea came from a game I'm working on for fun... :D

Original test conditions:
- arduino ProMini 5V,16MHz ATmega 328 with a USB to serial adaptor(USBasp)
- Ubuntu 16.04 LTS
- USB connection at /dev/ttyUSB0 port
- Button between GND and pin 12... (Touching the floating input with bare finger does just fine for introducing analog signal to A0 pin.)

Feature decription
- One liner syntax: sudo DataLink [DIRECTORY] [PORT] [BAUDRATE] [OPTION] [ARGUMENT] [OPTION] [ARGUMENT]
More specifically: sudo DataLink [work directory(optional) defaults to pwd] [PORT] [BAUDRATE] -s [Request signal that the arduino understands] -e [over sign that the arduino will send when it's done sending data...]
A few thing to note though...
  1. It runs with sudo in front, but without a password! (some systems ignore setuid so addig to sudoers was a more useful alternative, but it doesn't run without sudo... pkexec won't work since it uses $SUDO_USER to determin the username...)
  2. When specifying workdir, port and baudrate, you always specify workdir first, port next, and finally baudrate...
  3. It runs just fine without the arduino IDE installed, so you can add this script to your program, and your customer doesn't need to have the IDE installed for it to work.
- On the run method:
  - Analize the init.sh scipt to understand the method or use the Init.sh script as a template for launching both your program, and DataLink. (it does support running parallel instances of DataLink, so that you can connect multiple arduinos at the same time without interference, assuming that your program is able to run multiple instances as well... it's easy! Use the $RunDir created by the init script as a work directory for your program as well, and it should work, since each instance has it's own uniquely named directory to work with...)

Config file is optional if you specify port and baud rate as arguments, the option file is only a must if you're planning on switching port and or baudrate after launching the DataLink...
Config file content:
Port: /dev/ttyUSB0
BaudRate: 9600

In the Control file you must specify a command only nothing else... It's a 2 way channel... if you say "Read", the script will reply "Reading" if you say "Stop" it will reply "Stopped"... You can edit it to give DataLink a command, and you can read it to determin when it's executed...
Here are the accepted commands:
Read - (default)reads the port and dumps the content into the Input file... on execution the script will reply: Reading
Stop - not listening to port, but able to send commands to the arduino... probably not required for most application, but somewhat reduces CPU load while staying staying configured... on execution the script will reply: Stopped
Reconfigure - changes initial configuration(re-loads config so you must have a config file...), and resumes to a stopped state. replies: Stopped Reconfigured
Clear - Clears Input file. (You should make sure that your program has received, and processed all the data in the Input file, before giving Clear command.) doesn't replies anything... you'll know by rading the input file...
Exit - restores previous stty settings, replies Exited and exits...

The Output file is automatically cleared after sending to the arduino it's content... You can send commands even in stopped state to the arduino... DataLink will not reply anything, you can confirm that it's sent by reading the Output file...

The included arduino file:
it was written for testing purpose, you can upload it, and send commands to the arduino via DataLink by running data link, and editing the Output file while DataLink is running...
Accepted commands:
SendIt - stat sending data...
ChangeBL [unsigned int number] - changes length of data burst... 100 is the default, 0 means continuous data stream stopped by pulling pin 12 to ground.
ChangeBR [unsigned long int number] - changes baud rate... only standard values are accepted! Right after sending this to the arduino you can set the baud rate for DataLink in the config file, and send Reconfigure command via the Controls file, to apply the new baud rate... wait for "Stopped Reconfigured" message in the Controls file then you can resume normal operation at the new baud rate...
The arduino will send back an "Over" sign when it's done talking...
