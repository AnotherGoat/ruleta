class Spin extends State {
  void enter() {
    var request = "/spin=" + joinUsedPins() + "\n";
    print("[INFO] Request " + request);
    serial.write(request);
  }

  void draw() {
    background(BACKGROUND);
    fill(TEXT_COLOR);
    text("Girando la ruleta en Arduino...", WINDOW_MARGIN_X, WINDOW_HEIGHT / 2);

    if (serialReady) {
      serialReady = false;
      
      if (serialBuffer.startsWith("/spinning")) {
        println("[INFO] Arduino está girando...");
        return;
      }
      
      if (!serialBuffer.startsWith("/winner")) {
        println("[DEBUG] Ignorando: " + serialBuffer);
        return;
      }
      
      println("[INFO] Response " + serialBuffer);
      handleResponse(serialBuffer);
    }
  }

  void handleResponse(String response) {
    var winnerLed = parseIntParam(response, 0);

    if (winnerLed < 0) {
      errorMessage = "LED ganador no válido";
      stateMachine.goTo(new Menu());
      return;
    }

    var winner = findPlayerByLed(winnerLed);

    if (winner == null) {
      errorMessage = "Ganador no válido, no existe jugador con el LED " + winnerLed;
      stateMachine.goTo(new Menu());
      return;
    }

    stateMachine.goTo(new ShowWinner(winner));
  }

  Player findPlayerByLed(int led) {
    for (var player : players) {
      if (player.ledId() == led) {
        return player;
      }
    }
    return null;
  }

  void keyPressed() {
    if (isCancelPressed()) {
      key = 0;
      stateMachine.goTo(new Menu());
    }
  }
}
