#ifndef SELECTOR_H
#define SELECTOR_H

#include <Arduino.h>

#define MAX_LEDS 4

#define JOYSTICK_HIGH 800
#define JOYSTICK_LOW 200

#define BLINK_TIMES 2
#define BLINK_INTERVAL 80

#define INPUT_DELAY 200
#define LOOP_DELAY 25
#define WINNER_DISPLAY_TIME 3000

enum State {
  IDLE,
  LED_CHOICE,
  SPIN
};

extern State currentState;

extern int ledPins[MAX_LEDS];
extern int buttonPin;
extern int currentLedIndex;

extern int availableLeds[MAX_LEDS];
extern int availableLedCount;
extern int selectedLedIndex;

extern String serialBuffer;

void initializeHardware(int pins[], int count, int button);
bool isButtonPressed(int pin);

void turnOffAllLeds(int pins[], int count);
void blinkLed(int pins[], int index, int times, int blinkInterval);

int selectLed(int hardwarePins[], int allowedLeds[], int &selectedIndex, int allowedCount);

int spinRoulette(int hardwarePins[], int hardwareCount, int allowedLeds[], int allowedCount);
void showWinner(int pins[], int count, int winner);

void handleSerial();

#endif
