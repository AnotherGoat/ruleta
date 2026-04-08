#include "Selector.h"

void setup() {
  Serial.begin(9600);
  initializeHardware(ledPins, MAX_LEDS, buttonPin);
  randomSeed(analogRead(A2));
}

void loop() {
  handleSerial();

  if (currentState == SPIN) {
      turnOffAllLeds(ledPins, MAX_LEDS);

      int winner = spinRoulette(ledPins, MAX_LEDS, availableLeds, availableLedCount);

      Serial.print("/winner=");
      Serial.println(winner);

      showWinner(ledPins, MAX_LEDS, winner);

      currentState = IDLE;
      return;
  }

  if (currentState == LED_CHOICE) {
      int chosenLed = selectLed(ledPins, availableLeds, selectedLedIndex, availableLedCount);

      if (isButtonPressed(buttonPin)) {
        blinkLed(ledPins, chosenLed, BLINK_TIMES, BLINK_INTERVAL);

        Serial.print("/choice=");
        Serial.println(chosenLed);

        turnOffAllLeds(ledPins, MAX_LEDS);
        currentState = IDLE;
      }

      return;
  }

  delay(LOOP_DELAY); 
}
