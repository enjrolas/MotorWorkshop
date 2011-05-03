#include <Servo.h>

//pin definitions
#define motorPin 2
#define servoPin 7

//stepper motor variables
char index=0;
int num;
byte stepPattern[]={
   0b0001,
   0b0101,
   0b0100,
   0b0110,
   0b0010,
   0b1010,
   0b1000,
   0b1001};

//servo variables
Servo myServo;
unsigned char pos;

int motorSpeed;

void setup()
{
  Serial.begin(115200);
  pinMode(3,OUTPUT);
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(motorPin, OUTPUT);
  myServo.attach(servoPin);
}

void loop()
{
//  analogWrite(motorPin, 500);
  
  for(pos=0;pos<180;pos++)
  {
    myServo.write(pos);
    delay(15);
  }
  for(pos=180;pos>0;pos--)
  {
    myServo.write(pos);
    delay(15);
  }
  
  for(motorSpeed=0;motorSpeed<1023;motorSpeed++)
  {
    analogWrite(motorPin, motorSpeed);
    delay(1);
  }
  for(motorSpeed=1023;motorSpeed>0;motorSpeed--)
  {
    analogWrite(motorPin, motorSpeed);
    delay(1);
  }
    
  moveStepper(100,0,10);
  moveStepper(-100,0,10);
  moveStepper(100,1,5);
  moveStepper(-100,1,5);
}
   
//halfStepping:  0=full stepping, 1=half stepping
void moveStepper(int steps, byte halfStepping, int time)
{
  char inc;
  
  if(halfStepping)
  {
    inc=1;
    steps*=2;
  }
  else
    inc=2;
  if(steps<0)
    inc*=-1;
  
  int count;  
  for(count=0;count<abs(steps);count++)
  {
   index+=inc;
   if(index<0)
     index+=8;
   if(index>7)
     index-=8;
   PORTD=(PORTD&0b10000111)|(stepPattern[index]<<3);
   delay(time);
  }
  PORTD=(PORTD&0b10000111);  //turn off all stepper outputs
}

void runMotor(int motorSpeed)
{
}
