/*

The sketch demonstrates how to do accept a Bluetooth Low Energy 4
Advertisement connection with the RFduino, then send sensor
updates once a second.  It is a slight modifaction of the RFDuino
CPU temperature sketch.

It is suppose to be used with the rfduinoSensor iPhone application.
See this repository for the xcode project for the app.  That app is 
modificatoni of the rfduinoTemperature.

*/

#include <RFduinoBLE.h>

int sensor = 1;
int led = 2;
int led_state = 1;

void setup() {
  // this is the data we want to appear in the advertisement
  // (the deviceName length plus the advertisement length must be <= 18 bytes)
  RFduinoBLE.advertisementData = "sensor";

  // start the BLE stack
  RFduinoBLE.begin();
   pinMode(led, OUTPUT);
}

void loop() {
  // sample once per second
  RFduino_ULPDelay( SECONDS(1) );

  // get a cpu temperature sample
  // degrees c (-198.00 to +260.00)
  // degrees f (-128.00 to +127.00)
  // float temp = RFduino_temperature(CELSIUS);
  float temp = analogRead(sensor);

  // send the sample to the iPhone
  RFduinoBLE.sendFloat(temp);
  
  if ( led_state == 1 ) {
     digitalWrite(led, HIGH);  
  } else {
     digitalWrite(led, LOW);   
  }
  
  led_state = 1 - led_state;
  
}
