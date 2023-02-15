#include <Arduino.h>      
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_SSD1306.h>
#include "user_interface.h"

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define OLED_RESET     1 

#define DISPLAY_POWER_PIN 1 //(TX) high on this pin turns on the display
#define BUTTON_INPUT_PIN 3 //(RX) goes low when button is pressed
#define DISPLAY_ON HIGH //set display power pin to this to turn on display
#define DISPLAY_OFF LOW //set display power pin to this to turn off display

#define MY_SDA 2  //SDA moved
#define MY_SCL 0  //SCL moved

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

static uint8 ballCount=0;

void myDelay(long ms)
  {
  delay(ms);
  }


//We need to save the counter before sleeping and restore
//it when waking up. To keep from killing our flash memory, we'll store it in the RTC
//memory, which is kept alive by the battery or power supply.

void drawCounter(void) 
  {
  display.clearDisplay();

  display.setTextSize(4);             // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE);        // Draw white text
  display.setCursor(0,0);             // Start at top-left corner
  display.println(ballCount);

  display.display();
  }

//returns true if display/reset button is pressed. debounced.
bool displayButtonIsPressed()
  {
  bool pressed1=!digitalRead(BUTTON_INPUT_PIN);
  bool pressed2=!digitalRead(BUTTON_INPUT_PIN);
  bool pressed3=!digitalRead(BUTTON_INPUT_PIN);
  bool pressed=pressed1|pressed2|pressed3;
  return pressed;
  }

void setup() 
  {
  pinMode(BUTTON_INPUT_PIN, FUNCTION_3); //convert the RX pin to GPIO 3
  pinMode(BUTTON_INPUT_PIN, INPUT_PULLUP); //make it an input
  bool displayOnly=displayButtonIsPressed(); //must check quickly after reset

  pinMode(DISPLAY_POWER_PIN, FUNCTION_3); //convert the TX pin to GPIO 0
  pinMode(DISPLAY_POWER_PIN, OUTPUT_OPEN_DRAIN); //convert the TX pin to GPIO 1 (output)
  digitalWrite(DISPLAY_POWER_PIN,DISPLAY_ON); //turn on the display

  Wire.begin(MY_SDA, MY_SCL);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);

  system_rtc_mem_read(65, &ballCount, sizeof(ballCount)); //get the count from last time
  if (!displayOnly)  //if display button not pressed, must have been ball detector
    {
    ballCount++; //add another ball
    system_rtc_mem_write(65, &ballCount, sizeof(ballCount)); //save the count for next wakey
    }

  drawCounter();

  //if the button is held (long press), then reset the counter
  myDelay(2000);
  if (displayButtonIsPressed()) // still pressed?
    {
    ballCount=0;
    system_rtc_mem_write(65, &ballCount, sizeof(ballCount)); //save the new count for next wakey
    drawCounter();
    myDelay(2000);
    }
  digitalWrite(DISPLAY_POWER_PIN,DISPLAY_OFF); //turn off the display


  //sleep for the maximum time (essentially forever without reset mod on esp8266-01s)
  //ESP.deepSleep(std::numeric_limits<uint64_t>::max(), WAKE_RF_DISABLED); 
  ESP.deepSleep(0, WAKE_RF_DISABLED); 
  }
void loop()
{}

