/*
This sketch demonstrates how to send structured data from a Device
to a Host in a Gazell network.

Written by (VLorz) Victor Lorenzo.

You are free to use this code.
*/

//#include <RFduinoGZLL.h>
#include <SimbleeGZLL.h>
#include "myStruct.h"


/* This instance will be filled with data received over GZLL */
static my_struct_t  theReceivedStruct;

/* It would be nice to know if the host received the packet */
static bool   DataReady;

float netXacc, netYacc, netZacc;


void setup()
{
  Serial.begin( 9600 );
  
  // start the GZLL stack;
  Serial.print( F("GZLL init...") );
  //Serial.println( RFduinoGZLL.begin( HOST ) );
  SimbleeGZLL.begin(HOST);
  Serial.println( F("Running") );
  
  DataReady = false;
}


void loop()
{
  if (DataReady) {
   
    Serial.print("Roll = ");
    Serial.print( theReceivedStruct.rollData);
    Serial.print("   Pitch = ");
    Serial.println( theReceivedStruct.pitchData);
    
    
   
    /*Serial.print( F("accZData=0x") );
    Serial.println( theReceivedStruct.accZData, HEX );
    Serial.print( F("Count=") );
    Serial.println( theReceivedStruct.Count );
    Serial.println( "" );*/
    DataReady = false;
  }
}


//void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
void SimbleeGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
  //
  // IMPORTANT!!! This function runs under interrupt context!!!
  //
  
  if (DataReady) {
    // Do not overwrite our buffer;
    return;
  }
  
  if (len != sizeof(theReceivedStruct)) {
    // Ignore packets with wrong length!!!
    return;
  }
  
  // Copy the data to our structure buffer;
  for (char* lpDest = (char*)&theReceivedStruct; len > 0; len--) {
    *lpDest = *data;
    lpDest++;
    data++;
  }
  
  // ...and signal the application the data is ready
  DataReady = true;
  
//  RFduinoGZLL.sendToDevice( device, theReceivedStruct.Count );
}

