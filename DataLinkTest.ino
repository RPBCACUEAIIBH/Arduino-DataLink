/*
This is an example sketch for testing the DataLink, outside the arduino IDE.

Version 1.0
Written by: Tibor Áser Veres
Source: https://github.com/RPBCACUEAIIBH/Arduino-DataLink
License: BSD License 2.0 (see LICENSE.md file)
*/


// Pins
int LED = 13;
int BUTTON = 12;

// Constants
const char Over[] = "Over"; //End of data burst (EoF)(Sent by Arduino. No space required...)
const char Request[] = "SendIt "; //Data request command (Received by Arduino, mind the space at the end!)
const char ChBL[] = "ChangeBL "; //Change burst length command (Received by Arduino, mind the space at the end!)
const char ChBR[] = "ChangeBR "; //Change baud rate command (Received by Arduino, mind the space at the end!)

// Variables
unsigned long BurstLength = 100;
unsigned long BaudRate = 9600; // It can be changed temporarily by the ChangeBR command. (defaults to 9600 if the received value is not standard...)
int i = 0;
boolean Send = false;
boolean Button[2] = {HIGH, HIGH};
boolean NewString = false;
unsigned int StringMaxLength = 20; // Argument should be numeric unsigned integer

void setup()
{
  pinMode (LED, OUTPUT);
  pinMode (BUTTON, INPUT_PULLUP);
  Serial.begin (BaudRate);
}

boolean CompareString(const char Reference[], char Incoming[])
{
  int Match = true;
  i = 0;
  while (Match == true)
  {
    
    if (Incoming[i] == ' ' && Reference[i] == ' ') break; // Only check before space... This is the reason for spaces at the end of the definition... Spaces must match as well!
    if (Reference[i] != Incoming[i]) Match = false;
    i = i + 1;
  }
  return Match;
}

void StopCondition()
{
  Button[1] = Button[0];
  Button[0] = digitalRead (BUTTON);
  if (Button[0] != Button[1])
  {
    delay (7);
    Button[0] = digitalRead (BUTTON);
  }
}

void Stream()
{
  while (Send == true)
  {
    int Data = analogRead (A0);
    Serial.println (Data);
    
    // Checking stop condition (Button press)
    StopCondition ();
    if (Button[0] == LOW)
    {
      Send = false;
      Serial.print ("Arduino: ");
      Serial.println (Over);
    }
  }
}

void Burst()
{
  for (i = 0; i <= BurstLength; i++)
  {
    if (i == BurstLength)
    {
      Send = false;
      Serial.print ("Arduino: ");
      Serial.println (Over);
    }
    else
    {
      int Data = analogRead (A0);
      Serial.println (Data);
    }
  }
}

unsigned long GetArgument (char Incoming[], unsigned int MaxArgLength, unsigned long DefaultValue)
{
  // Find argument after 1 or more a space
  unsigned int ArgStarts = 0;
  boolean Trigger = false;
  for (i = 0; i < StringMaxLength; i++)
  {
    if (Incoming[i] == ' ') Trigger = true;
    if (Trigger == true && Incoming[i] != ' ')
    {
      ArgStarts = i;
      break;
    }
  }
  
  // Converting numeric string to number
  unsigned long Argument = DefaultValue;
  unsigned int Number[MaxArgLength];
  boolean Discard = false;
  for (i = ArgStarts; i <= ArgStarts + MaxArgLength - 1; i++)
  {
    boolean Exit = false;
    switch (Incoming[i])
    {
      case '0': Number[i - ArgStarts] = 0;
      break;
      case '1': Number[i - ArgStarts] = 1;
      break;
      case '2': Number[i - ArgStarts] = 2;
      break;
      case '3': Number[i - ArgStarts] = 3;
      break;
      case '4': Number[i - ArgStarts] = 4;
      break;
      case '5': Number[i - ArgStarts] = 5;
      break;
      case '6': Number[i - ArgStarts] = 6;
      break;
      case '7': Number[i - ArgStarts] = 7;
      break;
      case '8': Number[i - ArgStarts] = 8;
      break;
      case '9': Number[i - ArgStarts] = 9;
      break;
      default: Exit = true;
               if (i == ArgStarts) Discard = true; // Numeric value expected...
      break;
    }
    if (Exit == true)
    {
      break;
    }
  }
  i = i - 1;
  unsigned long OrderOfMagnitude = 1;
  for (i; i > ArgStarts; i--)
  {
    OrderOfMagnitude = OrderOfMagnitude * 10;
  }
  if (Discard != true)
  {
    Argument = 0;
    for (i; i <= ArgStarts + MaxArgLength - 1; i++)
    {
      const unsigned int Digit = Number[i - ArgStarts];
      Argument = Argument + Digit * OrderOfMagnitude;
      OrderOfMagnitude = OrderOfMagnitude / 10;
    }
  }
  return Argument;
}

unsigned long CheckBR(unsigned long Number)
{
  switch (Number)
  {
    case 300: delayMicroseconds (1);
    break;
    case 600: delayMicroseconds (1);
    break;
    case 1200: delayMicroseconds (1);
    break;
    case 2400: delayMicroseconds (1);
    break;
    case 4800: delayMicroseconds (1);
    break;
    case 9600: delayMicroseconds (1);
    break;
    case 14400: delayMicroseconds (1);
    break;
    case 19200: delayMicroseconds (1);
    break;
    case 28800: delayMicroseconds (1);
    break;
    case 38400: delayMicroseconds (1);
    break;
    case 57600: delayMicroseconds (1);
    break;
    case 115200: delayMicroseconds (1);
    break;
    default: Number = 9600;
    break;
  }
  return Number;
}

void loop()
{
  digitalWrite (LED, HIGH);
  delay (250);
  digitalWrite (LED, LOW);
  delay (250);
  
  char Value[StringMaxLength];
  i = 0;
  while (Serial.available () > 0)
  {
    Value[i] = Serial.read ();
    i = i + 1;
    i = i % StringMaxLength; //Just a precaution not to overwrite memory locations outside the array...
    NewString = true;
  }

  for (i; i < StringMaxLength; i++) Value[i] = ' '; // Filling unused characters with spaces...

  if (NewString == true)
  {
    // Commands //
    // Request
    Send = CompareString (Request, Value);
    // ChBL
    boolean ChangeBL = CompareString (ChBL, Value);
    if (ChangeBL == true)
    {
      BurstLength = GetArgument (Value, 5, 1);
      Serial.print ("BurstLength set to: ");
      Serial.println (BurstLength);
    }
    // ChBR
    boolean ChangeBR = CompareString (ChBR, Value);
    if (ChangeBR == true)
    {
      BaudRate = CheckBR (GetArgument (Value, 6, 9600));
      Serial.print ("BaudRate set to: ");
      Serial.println (BaudRate);
      Serial.flush ();
      Serial.begin (BaudRate);
    }
    // Ending
    NewString = false;
  }
  
  
  if (Send == true) 
  {
    if (BurstLength == 0) Stream (); // Sends an indefinite stream of data stopped by an event(button press)
    else Burst (); // Sends a BurstLength amount of data.
  }
}
