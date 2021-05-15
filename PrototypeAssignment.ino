/*
 * 
 * All the resources for this project: https://www.hackster.io/Aritro
 * Modified by Aritro Mukherjee
 * 
 * 
 */
#include <Adafruit_NeoPixel.h> 
#include <SPI.h>
#include <MFRC522.h>
 //LCD
#include <Wire.h>
#include "rgb_lcd.h"
#include "pitches.h" 
 
#define SS_PIN 10
#define RST_PIN 9

#define PIXEL_PIN 3
#define PIXEL_COUNT 60

//arcade button
#define arcade_button 7
#define arcade_button_menu 3
#define arcade_button_back 0
bool button_press = false;
bool button_press_menu = false;
bool button_press_back = false;
bool TimerStart;
Adafruit_NeoPixel strip = Adafruit_NeoPixel(PIXEL_COUNT, PIXEL_PIN, NEO_GRB + NEO_KHZ800);

//LCD
rgb_lcd lcd;
long CurrentTime = 0;
const int colorR = 255;
const int colorG = 0;
const int colorB = 0;
String answerSelected = " ";

//buzzer 
const int buzzer = 8;

//button
bool oldState = LOW;
uint8_t color_pos = 0;
int i=0;
int longpress=2000;
long timecheck;
long Timer;
//getQuestionButton
const int buttonPin = 4;     // the number of the pushbutton pin
const int ledPin =  5;      // the number of the LED pin
const int redLED =  6;      // the number of the LED pin
int buttonState = 0;         // variable for reading the pushbutton status

//arcadeButton
bool buttonGet = true;
bool buttonPressedMenu = true;
bool buttonPressedBack = true;

MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.
bool cardA = false;
bool cardB = false;
bool cardC = false;
bool cardD = false;
 
void setup() 
{

 //buzzer
 pinMode(buzzer, OUTPUT);

  //button

  strip.begin();
  strip.clear();
  strip.show(); // Initialize all pixels to 'off'
  Serial.begin(9600); 

  //arcadeButton
  pinMode(arcade_button, INPUT_PULLUP);
  pinMode(arcade_button_menu, INPUT_PULLUP);
  
  
  //rfid card
  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522

  //getQuestion
  pinMode(ledPin, OUTPUT);
  pinMode(redLED, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);

  //LCD
  lcd.begin(16, 2);
 
   lcd.setRGB(colorR, colorG, colorB);
}

void loop() 
{
  lcd.setCursor(0,0);
  lcd.print("Selected Answer: ");
  lcd.setCursor(0,1);
  lcd.print(answerSelected);
  button();
  getQuestion();
  back();
  getFeedback();
  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent()) 
  {
    return;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) 
  {
    return;
  }
  //Show UID on serial monitor

  String content= "";
  byte letter;
  
  for (byte i = 0; i < mfrc522.uid.size; i++) 
  {
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  content.toUpperCase();
  
  if (content.substring(1) == "04 56 0E 0A D1 62 80" && !cardA){
    Serial.write('0');
    answerSelected = "Answer A";
    cardA = true;
    cardB = false;
    cardC = false;
    cardD = false;
    tone(8,NOTE_C6,100);
   
    
  }else if (content.substring(1) == "02 BF 2F F1 01 23 D0" && !cardB){
    answerSelected = "Answer B";
    Serial.write('1');
    cardA = false;
    cardC = false;
    cardD = false;
    cardB = true;
    tone(8,NOTE_D6,100);
    
  }else if (content.substring(1) == "04 2A 77 2A 48 5A 80" && !cardC){
    answerSelected = "Answer C";
    Serial.write('2');
    cardA = false;
    cardB = false;
    cardD = false;
    cardC = true;
    tone(8,NOTE_E6,100);
    
  }else if (content.substring(1) == "02 B6 72 B1 21 34 70" && !cardD){
    answerSelected = "Answer D";
    Serial.write('3');
    cardA = false;
    cardB = false;
    cardC = false;
    cardD = true;
    tone(8,NOTE_F6,100);
  }
 
}

void button() {
  button_press_menu = digitalRead(arcade_button_menu);   // read the x axis value
  button_press_menu = !button_press_menu; 
 
  //check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (button_press_menu/*buttonState == HIGH*/ && buttonPressedMenu) {
    // turn LED on:
    
    Serial.write('4');
    //digitalWrite(ledPin, HIGH);
    buttonPressedMenu = false;
  } else if (!button_press_menu && !buttonPressedMenu){
    buttonPressedMenu = true;
    // turn LED off:
    //digitalWrite(ledPin, LOW);
  }
  
}

void back() {
  button_press_back = digitalRead(arcade_button_back);   // read the x axis value
  button_press_back = !button_press_back; 
 
  //check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (button_press_back/*buttonState == HIGH*/ && buttonPressedBack) {
    // turn LED on:
    digitalWrite(redLED, HIGH);
    Serial.write('5');
    //digitalWrite(ledPin, HIGH);
    buttonPressedBack = false;
  } else if (!button_press_back && !buttonPressedBack){
    buttonPressedBack = true;
    digitalWrite(redLED, LOW);
    // turn LED off:
    //digitalWrite(ledPin, LOW);
  }
  
}


void getFeedback(){
  if(Serial.available() > 0)
  {
    char STATUS = Serial.read();
    if(STATUS == '7')
    {
      answerSelected = "Correct Answer";

    //      tone(buzzer, 1000); 
    //      delay(1000);
    //      noTone(buzzer);
    tone(8,NOTE_B5,100);
    digitalWrite(ledPin, HIGH);
    delay(100);
    tone(8,NOTE_E6,850);
    delay(800);
    digitalWrite(ledPin, LOW);
    noTone(8);
    cardA = false;
    cardB = false;
    cardC = false;
    cardD = false;
      
    }
    else if (STATUS == '8'){
      answerSelected = "Answer Wrong";
      digitalWrite(redLED, HIGH);
      tone(8,NOTE_G4,35);
      delay(35);
      tone(8,NOTE_G5,35);
      delay(35);
      tone(8,NOTE_G6,35);
      delay(35);
      digitalWrite(redLED, LOW);
      noTone(8);
      cardA = false;
      cardB = false;
      cardC = false;
      cardD = false;
    }
  }
}
void alert(long CurrentTime){
  Timer = millis() - CurrentTime;
  if(Timer >= 11000){
    noTone(8);
    TimerStart = false;
  }
  else if(Timer >= 10300){
    noTone(8);
  }  
  else if(Timer  >= 10000){
    tone(8,NOTE_G6);
  }
  else if(Timer >= 9300){
    noTone(8);
  }  
  else if(Timer >= 9000){
    tone(8,NOTE_G6);
  }  
  else if(Timer >= 8300){
    noTone(8);
  }
  else if(Timer >= 8000){
    tone(8,NOTE_G6);
  }
}

void getQuestion() {
  // read the state of the pushbutton value:
  //buttonState = digitalRead(buttonPin);
  button_press = digitalRead(arcade_button);   // read the x axis value
  button_press = !button_press; 
  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (button_press/*buttonState == HIGH*/ && buttonGet) {
    // turn LED on:
    Serial.write('6');
    digitalWrite(ledPin, HIGH);
    answerSelected = "                    ";
    cardA = false;
    cardB = false;
    cardC = false;
    cardD = false;
    buttonGet = false;
    CurrentTime = millis();
    TimerStart = true;
  } else if (!button_press && !buttonGet){
    buttonGet = true;
    // turn LED off:
    digitalWrite(ledPin, LOW);
  }
  if(TimerStart)
  {
      alert(CurrentTime);
  }
}
