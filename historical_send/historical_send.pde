// CODE FOR UPLOADING HISTORICAL WEATHER DATA FROM A CSV FILE TO COSM
// By KJ Chabra, Wesley Chan, Felipe Scarpelli, Maria Enache

// IMPORT COSM LIBRARY
import cosm.*;

// CREATE VARIABLES
float startTime;
float weatherPackage;
String[] weather;
int i = 0;
float lastUpdate;
DataOut feed;
String apiKey = "KzBViMNS5ymLqafyr4_IOrkjEYCSAKxFNkxCMHBXcHBFMD0g";
String feedId= "90162";

void setup() {
  // LOAD CSV FILE WITH HISTORICAL WEATHER DATA
  weather = loadStrings("20071204.csv");

  // START COSM FEED
  feed = new DataOut(this, apiKey, feedId);
  feed.setVerbose(true);
}

void draw() {

  startTime = millis();
  // WAIT 25 SECONDS TO START UPLOADING ACTUAL DATA
  // THIS IS NECESSARY BECAUSE OUR READER HAS A 30s WAIT WHEN STARTED
  if (startTime < 25000) {
    feed.setStream("Historical", 79);
  }

  // WHEN TIMER IS OVER 25 SECONDS, START READING/PRINTING TEMPERATURES
  else {
    if (i < 24) {

      // WAIT 10 SECONDS
      delay(10000);

      // MAP VALUE FROM CSV FILE ACCORDING TO TORONTO'S COLDEST AND HOTTEST TEMPERATURE (-32, 40) AND THE LOWEST/HIGHEST ROTATION FOR THE ARM (80, 110) 
      float weatherString = float(weather[i]);
      weatherPackage = map(weatherString, -32, 40, 80, 110);

      //int roundPackage = round(weatherPackage);
      println ("---");
      println (i);
      println (weatherString);
      println (weatherPackage);
      //println (roundPackage);

      // UPDATE STREAM
      feed.setStream("Historical", weatherPackage);

      // INCREASE "I" TO JUMP TO NEXT VALUE
      i++;
    }
  }
}
