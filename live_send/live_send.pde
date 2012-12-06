//CODE FOR UPLOADING LIVE DATA FROM YAHOO'S WEATHER API TO COSM
// By KJ Chabra, Wesley Chan, Felipe Scarpelli, Maria Enache

//Import Libraries
import cosm.*; //cosm library
import processing.net.* ; //processing net library
import com.onformative.yahooweather.*; //yahooweather library

//yahoo weather variable 
YahooWeather weather;

//time millis for updating yahoo
int intervalTimeMillis = 30000;

//variable for wather condition
String WeatherCondition;

//intervals for updating feed on cosm
int interval = 5; //5 seconds
int timeStamp;

//variable for recording temperature from yahoo feed
float Temperature;
float degreesC;
float mappedData;

//Declare cosm variable
DataOut feed;
String apiKey = "LV0PdJ76vmRUPe8mmHQHHjv20NySAKx1VjF2aTFOemp2OD0g"; //cosm api key
String feedID = "89986"; //cosm feed ID

//variable used in millis for updating every 5 seconds
float lastUpdate;

//declare setup
void setup() {
  size(100, 100);
  
  //call out yahoo variable to connect to internet
  weather = new YahooWeather(this, 4118, "Toronto", intervalTimeMillis); //WOEID (4118) = Toronto
  
  //call out cosm variable and the feed id to put data on
  feed = new DataOut(this, apiKey, feedID); //api key used to connect and put data onto cosm
  
  //boolean optional variable processed for cosm
  feed.setVerbose(true);
  
}

//declare draw
void draw() {
  //create millis for seconds
  int currSeconds = millis()/1000;
  
  //declare if loop for updating every 5 seconds
  if (currSeconds - timeStamp > interval) {
    
    //get yahoo weather update
    weather.update();
    
    //time stamp becomes the current time
    timeStamp = currSeconds;
    
    //get weather temperature from yahoo feed
    Temperature = weather.getTemperature();
    
    //conver temperature to defrees
    degreesC = ((Temperature - 32) * (0.56));
    
    //map out data for the machine to draw 
    mappedData = map(degreesC, -32, 40, 80, 110); //-32 the coldest temperature recorded and 40 the highest temperature recorded
    println(mappedData);
    
    //write onto the cosm feed
    feed.setStream("Temperature", mappedData); //send request (datastream id, new value)

    //always get data from the Toronto where on earth id
    weather.setWOEID(4118);

  }
}

