#include <LinearAlgebra.h>
#include <SPI.h> // Included for SFE_LSM9DS0 library
#include <Wire.h>
#include <SFE_LSM9DS0.h>
#include <SimbleeGZLL.h>
//#include <RFduinoGZLL.h>
#include "myStruct.h"

#define LSM9DS0_XM  0x1D // Would be 0x1E if SDO_XM is LOW
#define LSM9DS0_G   0x6B // Would be 0x6A if SDO_G is LOW

LSM9DS0 dof(MODE_I2C, LSM9DS0_G, LSM9DS0_XM);

#define PRINT_CALCULATED


double accX, accY, accZ;
double gyroX, gyroY, gyroZ;
double roll, pitch;
/* This instance will be sent over GZLL */
static my_struct_t  theStruct;

/* And this variable is for timing */
static long PrevTime;

/* It would be nice to know if the host received the packet */
static bool   Acked;
static int    AckedCount;

uint32_t dt;
uint32_t timer;

const int VDD = 2;
const int GND = 4;

//Model Variables
mat X(6, 1); //[phi, phi_dot, phi_er; theta, theta_dot, theta_er]
mat A(6, 6);

//Measurement Valraible
mat Z(4, 1); //[phi; phi_dot; theta; theta_dot]

//Filter Variables
mat P(6, 6);
mat R(4, 4);
mat Q(6, 6);


double q1, q2, q3, q4, q5, q6; //model noise - members of Q
double r1, r2, r3, r4; // measurement noise - members of R

//Ouput Variables

mat C(4, 6);

void setup() {

  P = mat::identity(6);

  X.data[0][0] = 0;
  X.data[1][0] = 0;
  X.data[2][0] = 0;
  X.data[3][0] = 0;
  X.data[4][0] = 0;
  X.data[5][0] = 0;

  timer = millis(); //time used for the first dt value


  pinMode(VDD, OUTPUT);
  pinMode(GND, OUTPUT);

  digitalWrite(VDD, HIGH);
  digitalWrite(GND, LOW);

  uint16_t status = dof.begin();

  Serial.begin( 9600 );

  // start the GZLL stack;
  Serial.print( F("GZLL init...") );
  //Serial.println( RFduinoGZLL.begin( DEVICE0 ) );
  SimbleeGZLL.begin(DEVICE0);

  Serial.println( F("Running") );

  /* Force the first xmit */
  PrevTime = millis() - 1001;
  Acked = false;



}

void loop() {


  double dt = (double)(millis() - timer)/1000;
  timer = millis();

  getAmat();
  getCmat();
  getQmat();
  getRmat();

  readSensors();

  mat Xp(6,6);
  Xp = A * X;
  mat Ey(4,1);
  Ey = Z - C * Xp;
  P = A * P * A.t() + Q;
  mat S(4,4);
  S = C * P * C.t() + R;

  mat K(6,4);
  K = P * C.t() * S.inv();

  P = (mat::identity(6) - K * C) * P;
  X = Xp + K * Ey;
  mat Yout(4,1);
  Yout = C * X;



  theStruct.accXData = accX;
  theStruct.accYData = accY;
  theStruct.accZData = accZ;

  theStruct.GVector[1] = -sin(pitch * DEG_TO_RAD);
  theStruct.GVector[2] = cos(pitch * DEG_TO_RAD) * cos(roll * DEG_TO_RAD);
  theStruct.GVector[0] = cos(pitch * DEG_TO_RAD) * sin(roll * DEG_TO_RAD);

  theStruct.pitchData = Yout.data[0][0];
  theStruct.rollData = Yout.data[2][0];
  
  //RFduinoGZLL.sendToHost( (char*)&theStruct, sizeof(theStruct) );
SimbleeGZLL.sendToHost( (char*)&theStruct, sizeof(theStruct) );

  long  Now;

  Now = millis();
  Serial.print(Z.data[0][0]);
  Serial.print("    ");
  Serial.print(Yout.data[0][0]);
  Serial.print("    ");
  Serial.print(Z.data[2][0]);
  Serial.print("    ");
  Serial.println(Yout.data[2][0]);
  Serial.print("    ");

}

void SimbleeGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
}

/*void RFduinoGZLL_onReceive(device_t device, int rssi, char *data, int len)
{
}*/

void getAmat() {
  A.data[0][0] = 1;
  A.data[0][1] = dt;
  A.data[0][2] = -dt;
  A.data[0][3] = 0;
  A.data[0][4] = 0;
  A.data[0][5] = 0;

  A.data[1][0] = 0;
  A.data[1][1] = 1;
  A.data[1][2] = 0;
  A.data[1][3] = 0;
  A.data[1][4] = 0;
  A.data[1][5] = 0;

  A.data[2][0] = 0;
  A.data[2][1] = 0;
  A.data[2][2] = 1;
  A.data[2][3] = 0;
  A.data[2][4] = 0;
  A.data[2][5] = 0;

  A.data[3][0] = 0;
  A.data[3][1] = 0;
  A.data[3][2] = 0;
  A.data[3][3] = 1;
  A.data[3][4] = dt;
  A.data[3][5] = -dt;

  A.data[4][0] = 0;
  A.data[4][1] = 0;
  A.data[4][2] = 0;
  A.data[4][3] = 0;
  A.data[4][4] = 1;
  A.data[4][5] = 0;

  A.data[5][0] = 0;
  A.data[5][1] = 0;
  A.data[5][2] = 0;
  A.data[5][3] = 0;
  A.data[5][4] = 0;
  A.data[5][5] = 1;

}

void getQmat() {
  q1 = 3.5;
  q2 = .1;
  q3 = 0;
  q4 = 3.5;
  q5 = .1;
  q6 = 0;
  Q.data[0][0] = q1;
  Q.data[0][1] = 0;
  Q.data[0][2] = 0;
  Q.data[0][3] = 0;
  Q.data[0][4] = 0;
  Q.data[0][5] = 0;

  Q.data[1][0] = 0;
  Q.data[1][1] = q2;
  Q.data[1][2] = 0;
  Q.data[1][3] = 0;
  Q.data[1][4] = 0;
  Q.data[1][5] = 0;

  Q.data[2][0] = 0;
  Q.data[2][1] = 0;
  Q.data[2][2] = q3;
  Q.data[2][3] = 0;
  Q.data[2][4] = 0;
  Q.data[2][5] = 0;

  Q.data[3][0] = 0;
  Q.data[3][1] = 0;
  Q.data[3][2] = 0;
  Q.data[3][3] = q4;
  Q.data[3][4] = 0;
  Q.data[3][5] = 0;

  Q.data[4][0] = 0;
  Q.data[4][1] = 0;
  Q.data[4][2] = 0;
  Q.data[4][3] = 0;
  Q.data[4][4] = q5;
  Q.data[4][5] = 0;

  Q.data[5][0] = 0;
  Q.data[5][1] = 0;
  Q.data[5][2] = 0;
  Q.data[5][3] = 0;
  Q.data[5][4] = 0;
  Q.data[5][5] = q6;
}


void getRmat() {
  r1 = 100;
  r2 = .099;
  r3 = 100;
  r4 = .099;

  R.data[0][0] = r1;
  R.data[0][1] = 0;
  R.data[0][2] = 0;
  R.data[0][3] = 0;

  R.data[1][0] = 0;
  R.data[1][1] = r2;
  R.data[1][2] = 0;
  R.data[1][3] = 0;

  R.data[2][0] = 0;
  R.data[2][1] = 0;
  R.data[2][2] = r3;
  R.data[2][3] = 0;

  R.data[3][0] = 0;
  R.data[3][1] = 0;
  R.data[3][2] = 0;
  R.data[3][3] = r4;

}

void getCmat() {
  C.data[0][0] = 1;
  C.data[0][1] = 0;
  C.data[0][2] = 0;
  C.data[0][3] = 0;
  C.data[0][4] = 0;
  C.data[0][5] = 0;

  C.data[1][0] = 0;
  C.data[1][1] = 1;
  C.data[1][2] = 0;
  C.data[1][3] = 0;
  C.data[1][4] = 0;
  C.data[1][5] = 0;

  C.data[2][0] = 0;
  C.data[2][1] = 0;
  C.data[2][2] = 0;
  C.data[2][3] = 1;
  C.data[2][4] = 0;
  C.data[2][5] = 0;

  C.data[3][0] = 0;
  C.data[3][1] = 0;
  C.data[3][2] = 0;
  C.data[3][3] = 0;
  C.data[3][4] = 1;
  C.data[3][5] = 0;
}

void readSensors() {
  dof.readAccel();
  dof.readGyro();


  accX = dof.calcAccel(dof.ax) / 1.07;
  accY = dof.calcAccel(dof.ay) / .99;
  accZ = dof.calcAccel(dof.az) / .95;

  gyroX = dof.calcGyro(dof.gx) - 1;
  gyroY = dof.calcGyro(dof.gy) - 1.76;
  gyroZ = dof.calcGyro(dof.gz) + 6.75;

  roll  = atan(-accX / accZ) * RAD_TO_DEG;
  pitch = atan(accY / accZ) * RAD_TO_DEG;

  Z.data[0][0] = pitch;
  Z.data[1][0] = gyroX;
  Z.data[2][0] = roll;
  Z.data[3][0] = gyroY;

}


