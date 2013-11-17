
rfduinoSensor
-------------

Purpose: read data from any analogue sensor using
RFDuino, display that data on iPhone.  Communicaton
is by bluetooth.

This project consists of three parts:

1.  The rfduiono board (see http://www.rfduino.com)
connected to an analogue sensor circut and to a power
supply -- five volts is best, but 3v works and so 
should 1.5v, although I have not tested that.

The basic circuit: GPIO pin 1 to sensor to resistor to GND.
Optional: GPIO pin 2 to LED to resistor to GND -- blinks
to show that circuit is operational.  Note that when
using a light sensor at low light levels, the blinking LED
affects the light readings.

2. A arduino sketch (Folder = Sensor_RFDuino) that you upload
to the RFDuino.

3. An iPhone app that displays the sensor data.  Communication
with the rfduino is by Bluetooth.

NOTE: at the moment, you need to put the folders containing the 
iphone code in the folder RFDuino/iPhone\ Apps so that it will
see the rfduino library -- RFDuino.h, etc.  I will remedy this
at a later date.  For now, see https://github.com/RFduino/RFduino
for the code needed.