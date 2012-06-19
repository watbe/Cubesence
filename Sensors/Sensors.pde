#define ACCX 8
#define ACCY 7
#define ACCZ 6
#define GYROX 10
#define GYROZ 9
#define MIC 11

#define SIZE 10

int aX, aY, aZ;
int gX, gZ;
int mic;

int index;
int totalAX, totalAY, totalAZ, totalMIC;

int mode, panel;

int readingsAX[SIZE], readingsAY[SIZE], readingsAZ[SIZE], readingsMIC[SIZE];

// sends 255 then MODE then AX, AY, AZ, MIC, GYROX, GYROZ, PANEL. 
// Mode 0 = Do nothing. Wait for commands.

// Mode 1 = Light up the selected panel.
// Mode 2 = React to beats.
void setup() {
  pinMode(ACCZ, INPUT);
  pinMode(ACCY, INPUT);
  pinMode(ACCX, INPUT);
  pinMode(GYROX, INPUT);
  pinMode(GYROZ, INPUT);
  pinMode(MIC, INPUT);
  
  Serial.begin(38400);
  Serial1.begin(9600);
  
  mode = 0;

  index = 0;
  initRead();
}

void loop() {
  readPorts();
  sendSerial();
  debugSerialOut();
}

void sendSerial() {
  Serial1.write(255);
  Serial1.write(mode);
  Serial1.write(mic);
  Serial1.write(getTop());
  delay(10);
}

int getTop() {
  
  int x = 0;
  int y = 0;
  int z = 0;
  
  if (aX < 25) {
    x = -1;
  } else if (aX > 75) {
    
    x = 1;
  } 
  
  if (aY < 25) {
    y = -1;
  } else if (aY > 75) {
    y = 1;
  } 
  
  if (aZ < 25) {
    z = -1;
  } else if (aZ > 75) {
    z = 1;
  } 
  
  if (x == 0 && y == -1 && z == 0) {
    return 5;
  }
  
  if (x == 0 && y == 0 && z == 1) {
    return 3;
  }
  
  if (x == -1 && y == 0 && z == 0) {
    return 4;
  }
  
  if (x == 0 && y == 0 && z == -1) {
    return 1;
  }
  
  if (x == 1 && y == 0 && z == 0) {
    return 2;
  }
  
  if (x == 0 && y == 1 && z == 0) {
    return 0;
  }
   return -1;
}

void readPorts() {

  readingsAX[index] = analogRead(ACCX);
  readingsAY[index] = analogRead(ACCY);
  readingsAZ[index] = analogRead(ACCZ);
  readingsMIC[index] = analogRead(MIC);

  gX = analogRead(GYROX);
  gZ = analogRead(GYROZ);

  index++;

  if(index > SIZE) {
    index = 0;
  }

  totalAX = 0;
  totalAY = 0;
  totalAZ = 0;
  totalMIC = 0;

  for(int i = 0; i < SIZE; i++) {
    totalAX += readingsAX[i];
    totalAY += readingsAY[i];
    totalAZ += readingsAZ[i];
    totalMIC += readingsMIC[i];
  }

  aX = map(totalAX/SIZE, 363, 635, 0, 100);
  aY = map(totalAY/SIZE, 388, 652, 0, 100);
  aZ = map(totalAZ/SIZE, 359, 622, 0, 100);
  mic = map(analogRead(MIC), 12, 1023, 0, 100);
}

void initRead() {
  for (int i = 0; i < 10; i++) {
    readingsAX[i] = analogRead(ACCX);
    readingsAY[i] = analogRead(ACCY);
    readingsAZ[i] = analogRead(ACCZ);
    readingsMIC[i] = analogRead(MIC);
  }
}

void debugSerialOut() {
  Serial.print("aX: ");
  Serial.print(aX);
  Serial.print(" aY: ");
  Serial.print(aY);
  Serial.print(" aZ: ");
  Serial.print(aZ);
  Serial.print(" gX: ");
  Serial.print(gX);
  Serial.print(" gZ: ");
  Serial.print(gZ);
  Serial.print(" Mic: ");
  Serial.println(mic);
}
