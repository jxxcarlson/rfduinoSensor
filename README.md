
rfduinoSensor
-------------

Purpose: read data from any analogue sensor using
RFDuino, display that data on iPhone.  Communicaton
is by bluetooth.  

The iPhone app allows the user to set the minimum 
and maximum sensor values and the minimum and maximum
scale values.  For example, suppose that the minimum and
maximum sensor value are set to 0 and 760, and the 
minimum and maximum scale values are set to 0 and 100,
the sensor reading of 380 will be displayed as a
scale reading of 50.  (See note on scale calibration
below).

The rightmost blue button, with text "Normal"
or "Reversed" is used to toggle the scale direction.
For example, in normal mode, 760 gives a scale
reading of 100, while in reversed mode, it gives
a scale reading of 0. 

This project consists of four parts:

1.  The rfduino board (see http://www.rfduino.com)
connected to an analogue sensor circut and to a power
supply -- five volts is best, but 3v works and so 
should 1.5v, although I have not tested that.

2. A circuit connected to the rfduiono board.
The basic circuit: GPIO pin 1 to sensor to resistor to GND.
Optional: GPIO pin 2 to LED to resistor to GND -- blinks
to show that circuit is operational.  Note that when
using a light sensor at low light levels, the blinking LED
affects the light readings.

3. A arduino sketch (Folder = Sensor_RFDuino) that you upload
to the RFDuino.

4. An iPhone app that displays the sensor data.  Communication
with the rfduino is by Bluetooth.

SCALE CALIBRATION: I used a cadmium sulfide photoresistor for this
project with a 9.7 KOhm resistor.  The circuit was GPIO pin 1 on
RFDuino to photoresistor to resistor to GND.  To calibrate, I first
removed the photoresistor.  This gave me the maximum sensor reading of
748.  Then I attached a jumper to the pins where the photoresistor
normally goes to short this part of the circuit.  This gave me a
minimum sensor reading of 66.  I entered these values into the two
"Sensor" fields on the app and pressed "Set".  Next, I set the scale
mode to "Reversed".  This was so that bright light would read high on
the scale, low light low.

NOTES: (1) at the moment, you need to put the folders containing the 
iphone code in the folder RFDuino/iPhone\ Apps so that it will
see the rfduino library -- RFDuino.h, etc.  I will remedy this
at a later date.  For now, see https://github.com/RFduino/RFduino
for the code needed.

(2) The code for this project is derived from Arduino sketch
and iPhone code for the rfduinoTemperature project at
https://github.com/RFduino/RFduino.