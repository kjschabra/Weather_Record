// CODE FOR READING LIVE WEATHER DATA FROM A COSM FEED WE SET UP
// By KJ Chabra, Wesley Chan, Felipe Scarpelli, Maria Enache

//Servo libraries
#include <AFMotor.h>
#include <Servo.h> 

// delcare servos
Servo servoDisc;
Servo servoArm;

// declare moving variables
int rotDisc = 90;
float rotArm;
int variation = 0; // variable for creating patterns according to weather variation

//Cosm, https and ethernet library for arduino
#include <SPI.h>
#include <Ethernet.h>
#include <HttpClient.h>
#include <Cosm.h>

// MAC address of Ethernet shield
byte mac[] = { 
  0x00, 0xA1, 0xB1, 0xC1, 0xD1, 0x03 };

// Cosm key to let you upload data
char cosmKey[] = "LV0PdJ76vmRUPe8mmHQHHjv20NySAKx1VjF2aTFOemp2OD0g";

// Define the string for our datastream ID
char temperatureId[] = "Temperature";

//Array for the data feed coming in
CosmDatastream datastreams[] = {
  CosmDatastream(temperatureId, strlen(temperatureId), DATASTREAM_FLOAT),
};

// Finally, wrap the datastreams into a feed
CosmFeed feed(89986, datastreams, 1 /* number of datastreams */);

//variable to call out the Ethernet library
EthernetClient client;

//variable to call out cosm library
CosmClient cosmclient(client);

void setup(){
  // set up servors on arduino
  servoDisc.attach(6);
  servoArm.attach(5);
  
   // initiate serial
  Serial.begin(9600);

  // set starting point for compass
  servoArm.write(79);
  
  //print strings in serial monitor when setup is initialized
  Serial.println("Reading from Cosm example");
  Serial.println("hello");
  
  //if no connection is available then print out error message
  int FEED = cosmclient.get(feed, cosmKey); 
  while (Ethernet.begin(mac) != 1)
  {
    Serial.println("Error getting IP address via DHCP, trying again...");
  }

}

void loop() {
  
  //variation variable to alter the motor
  if (variation == 0) {
    variation = 1;
  }
  else {
    variation = 0;
  }
  
  //connect to cosm with a key and available feeds from the feed ID
  int ret = cosmclient.get(feed, cosmKey);
  
  //return from cosm exists
  if (ret > 0) {
    //variable to control the motors rotation
    rotArm = feed[0].getFloat();

    //print variation variable in serial monitor  
    Serial.println(variation);
  
    //print out the incoming variable from the feed
    Serial.println(rotArm);
  }
  
  //get the base of the machine spinning
  servoDisc.write(rotDisc);
  
  //get the arm of servo moving with the feed coming in + the value of variation 
  servoArm.write(rotArm + variation);  

}



