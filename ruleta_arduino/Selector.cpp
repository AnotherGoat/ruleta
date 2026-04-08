#include "Selector.h"

State currentState = IDLE;

int ledPins[MAX_LEDS] = { 2, 3, 4, 5 };
int buttonPin = 6;
int currentLedIndex = 0;

int availableLeds[MAX_LEDS];
int availableLedCount = 0;
int selectedLedIndex = 0;

String serialBuffer = "";

void initializeHardware(int pins[], int count, int button) {
  for (int i = 0; i < count; i++) {
    pinMode(pins[i], OUTPUT);
    digitalWrite(pins[i], LOW);
  }

  pinMode(button, INPUT_PULLUP);
  pinMode(A0, INPUT);
}

bool isButtonPressed(int pin) {
  static bool lastState = HIGH;
  bool currentButtonState = digitalRead(pin);

  if (lastState == HIGH && currentButtonState == LOW) {
    lastState = currentButtonState;
    return true;
  }

  lastState = currentButtonState;
  return false;
}

void turnOffAllLeds(int pins[], int count) {
  for (int i = 0; i < count; i++) {
    digitalWrite(pins[i], LOW);
  }
}

void turnOnLed(int pins[], int index) {
  turnOffAllLeds(pins, MAX_LEDS);
  digitalWrite(pins[index], HIGH);
}

void blinkLed(int pins[], int index, int times, int blinkInterval) {
  for (int i = 0; i < times; i++) {
    digitalWrite(pins[index], LOW);
    delay(blinkInterval);
    digitalWrite(pins[index], HIGH);
    delay(blinkInterval);
  }

  digitalWrite(pins[index], LOW);
}

int selectLed(int hardwarePins[], int allowedLeds[], int &selectedIndex, int allowedCount) {
  if (allowedCount == 0) {
    return -1;
  }

  if (selectedIndex >= allowedCount) {
    selectedIndex = 0;
  }

  int joystickValue = analogRead(A0);

  if (joystickValue < JOYSTICK_LOW) {
    selectedIndex = (selectedIndex + 1) % allowedCount;
    turnOnLed(hardwarePins, allowedLeds[selectedIndex]);
    delay(INPUT_DELAY);
  } else if (joystickValue > JOYSTICK_HIGH) {
    selectedIndex = (selectedIndex - 1 + allowedCount) % allowedCount;
    turnOnLed(hardwarePins, allowedLeds[selectedIndex]);
    delay(INPUT_DELAY);
  }

  if (selectedIndex < 0 || selectedIndex >= allowedCount) {
    return -1;
  }

  return allowedLeds[selectedIndex];
}

int spinRoulette(int hardwarePins[], int hardwareCount, int allowedLeds[], int allowedCount) {
  if (allowedCount == 0) {
    return -1;
  }

  int winner = allowedLeds[random(allowedCount)];
  int position = 0;
  int delayTime = 50;

  for (int i = 0; i < random(25, 35); i++) {
    turnOnLed(hardwarePins, position);
    delay(delayTime);

    position = (position + 1) % hardwareCount;
    delayTime *= 1.1;
  }

  while (position != winner) {
    turnOnLed(hardwarePins, position);
    delay(delayTime);

    position = (position + 1) % hardwareCount;
    delayTime *= 1.2;
  }

  return winner;
}

void showWinner(int pins[], int count, int winner) {
  turnOnLed(pins, winner);

  delay(WINNER_DISPLAY_TIME);
  turnOffAllLeds(pins, count);
}

void parseLedList(String request) {
  availableLedCount = 0;

  int equalsIndex = request.indexOf('=');

  if (equalsIndex == -1) {
    return;
  }

  String list = request.substring(equalsIndex + 1);
  list.trim();

  int start = 0;

  while (start < list.length()) {
    int commaIndex = list.indexOf(',', start);
    String token;

    if (commaIndex == -1) {
      token = list.substring(start);
      start = list.length();
    } else {
      token = list.substring(start, commaIndex);
      start = commaIndex + 1;
    }

    token.trim();
    int value = token.toInt();

    if (value >= 0 && value < MAX_LEDS && availableLedCount < MAX_LEDS) {
      availableLeds[availableLedCount++] = value;
    }
  }
}

void highlightSelectedLed() {
  if (availableLedCount > 0) {
    turnOnLed(ledPins, availableLeds[selectedLedIndex]);
  }
}

void processCommand(String request) {
  request.trim();

  if (request.length() == 0) return;

  if (request.startsWith("/choose_from=")) {
    parseLedList(request);

    selectedLedIndex = 0;
    turnOffAllLeds(ledPins, MAX_LEDS);
    highlightSelectedLed();

    currentState = LED_CHOICE;
  } 
  else if (request.startsWith("/spin=")) {
    parseLedList(request);
    currentState = SPIN;
  }
}

void handleSerial() {
  if (!Serial.available()) {
    return;
  }

  char character = Serial.read();

  if (character == '\n') {
    processCommand(serialBuffer);
    serialBuffer = "";
  } else {
    serialBuffer += character;
  }
}
