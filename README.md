Cubesence
=========

Cubesence (pronounced Cu-be-sence) is a course project I completed for ARTV2100. 

Unfortunately the code for the project is pretty specific, but other people might find it useful.

The set up of the LED cube was a 5x5 cube, with a very long daisy chain through SPI. There are two Arduinos, one of which was a ChipKit Uno32 board, of which the code is in Sensors.pde. I separated the two arduinos so I could run the acceleromter, microphone and gyroscope concurrently to the LEDs. The code for the LED cube is in Cubesence.pde. 

You can find the Chipkit Uno32 here: http://www.digilentinc.com/Products/Detail.cfm?NavPath=2,892,893&Prod=CHIPKIT-UNO32 - it runs much faster than the stock Arduino is is great for polling data at short intervals from multiple sources.

The exact LEDs I used can be found on Bliptronics: http://bliptronics.com/item.aspx?ItemID=128

Note that the code also requires the FastSPI library, that can be found here: https://code.google.com/p/fastspi/