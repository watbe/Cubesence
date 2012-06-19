#include <FastSPI_LED.h>
#define NUM_LEDS 150

// Sometimes chipsets wire in a backwards sort of way
struct CRGB { 
  unsigned char b; 
  unsigned char g; 
  unsigned char r; 
};
// struct CRGB { unsigned char r; unsigned char g; unsigned char b; };
struct CRGB *leds;

#define PIN 11

//Used for HSL to RGB conversion
const byte dim_curve[] = {
  0,   1,   1,   2,   2,   2,   2,   2,   2,   3,   3,   3,   3,   3,   3,   3,
  3,   3,   3,   3,   3,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4,
  4,   4,   4,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   6,   6,   6,
  6,   6,   6,   6,   6,   7,   7,   7,   7,   7,   7,   7,   8,   8,   8,   8,
  8,   8,   9,   9,   9,   9,   9,   9,   10,  10,  10,  10,  10,  11,  11,  11,
  11,  11,  12,  12,  12,  12,  12,  13,  13,  13,  13,  14,  14,  14,  14,  15,
  15,  15,  16,  16,  16,  16,  17,  17,  17,  18,  18,  18,  19,  19,  19,  20,
  20,  20,  21,  21,  22,  22,  22,  23,  23,  24,  24,  25,  25,  25,  26,  26,
  27,  27,  28,  28,  29,  29,  30,  30,  31,  32,  32,  33,  33,  34,  35,  35,
  36,  36,  37,  38,  38,  39,  40,  40,  41,  42,  43,  43,  44,  45,  46,  47,
  48,  48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,
  63,  64,  65,  66,  68,  69,  70,  71,  73,  74,  75,  76,  78,  79,  81,  82,
  83,  85,  86,  88,  90,  91,  93,  94,  96,  98,  99,  101, 103, 105, 107, 109,
  110, 112, 114, 116, 118, 121, 123, 125, 127, 129, 132, 134, 136, 139, 141, 144,
  146, 149, 151, 154, 157, 159, 162, 165, 168, 171, 174, 177, 180, 183, 186, 190,
  193, 196, 200, 203, 207, 211, 214, 218, 222, 226, 230, 234, 238, 242, 248, 255,
};
int rgb_colour[3]; 

int val = 0;
int audioIn = 0; 
int j = 0;
int data;
int mode;
int face;
int mic;
void setup() {


  Serial.begin(9600);

  FastSPI_LED.setLeds(NUM_LEDS);
  FastSPI_LED.setChipset(CFastSPI_LED::SPI_WS2801);

  FastSPI_LED.setPin(PIN);

  FastSPI_LED.setDataRate(1);
  FastSPI_LED.init();
  FastSPI_LED.start();

  leds = (struct CRGB*)FastSPI_LED.getRGBData(); 

  data = 0;
  mode = 0;
  face = 0;
  mic = 0;
}

void loop() { 
  //Set LEDs
  for(int k = 0 ; k < 256; k++) {
    memset(leds, 0, NUM_LEDS * 3);
    for(int i = 0 ; i < NUM_LEDS; i++ ) {
      leds[i].r = getRGB((k*2+i*255/NUM_LEDS)%255,255,255,0);
      leds[i].g = getRGB((k*2+i*255/NUM_LEDS)%255,255,255,1);
      leds[i].b = getRGB((k*2+i*255/NUM_LEDS)%255,255,255,2);

    }
    
    if (mic > 70 || mic < 30) {
      for(int i = 0 ; i < NUM_LEDS; i++ ) {
        leds[i].r = 255;
        leds[i].g = 255;
        leds[i].b = 255;
      }
      delay(100);
    }
    
    getSerial();
    lightPanel(face,255,255,255);
    //Show LEDs
    FastSPI_LED.show();
  }


  //If pulse is on, pause for a moment other the pulse happens too quickly
  if (j != 0) {
    delay(100);
    j = 0;
  }

} // end void loop()

void getSerial() {
  while(Serial.read() != 255) {
  }
  mode = Serial.read();
  mic = Serial.read();
  face = Serial.read();
  Serial.flush();
}

void setZero() {

}

void lightPanel(int panel, int r, int g, int b) {
  switch(panel) {
  case 0:
    for (int i = 0; i < 25; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    }
    break;
  case 1:
    for (int i = 25; i < 50; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    }
    break;
  case 2:
    for (int i = 50; i < 75; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    } 
    break;
  case 3:
    for (int i = 75; i < 100; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    }
    break;
  case 4:
    for (int i = 100; i < 125; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    }
    break;  
  case 5:
    for (int i = 125; i < 150; i++) {
      leds[i].r = r;
      leds[i].g = g;
      leds[i].b = b;
    }
    break;  
  }
}

int getRGB(int hue, int sat, int val, int rgb) { 

  int colors[3];
  val = dim_curve[val];
  sat = 255-dim_curve[255-sat];
  int r;
  int g;
  int b;
  int base;

  if (sat == 0) { 
    colors[0]=val;
    colors[1]=val;
    colors[2]=val;  
  } 
  else  { 
    base = ((255 - sat) * val)>>8;
    switch(hue/60) {
    case 0:
      r = val;
      g = (((val-base)*hue)/60)+base;
      b = base;
      break;
    case 1:
      r = (((val-base)*(60-(hue%60)))/60)+base;
      g = val;
      b = base;
      break;
    case 2:
      r = base;
      g = val;
      b = (((val-base)*(hue%60))/60)+base;
      break;
    case 3:
      r = base;
      g = (((val-base)*(60-(hue%60)))/60)+base;
      b = val;
      break;
    case 4:
      r = (((val-base)*(hue%60))/60)+base;
      g = base;
      b = val;
      break;
    case 5:
      r = val;
      g = base;
      b = (((val-base)*(60-(hue%60)))/60)+base;
      break;
    }
    colors[0]=r;
    colors[1]=g;
    colors[2]=b; 
  }   
  return colors[rgb];
}