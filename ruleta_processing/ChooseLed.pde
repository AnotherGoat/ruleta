class ChooseLed extends State {
  void enter() {
    var request = "/choose_from=" + joinAvailablePins() + "\n";
    print("[INFO] Request " + request);
    serial.write(request);
  }

  void draw() {
    fill(TEXT_COLOR);
    text("Esperando selección de pin en Arduino...", WINDOW_MARGIN_X, WINDOW_HEIGHT / 2);

    if (serialReady) {
      serialReady = false;

      if (!serialBuffer.startsWith("/choice")) {
        println("[DEBUG] Ignorando: " + serialBuffer);
        return;
      }

      println("[INFO] Response " + serialBuffer);
      handleResponse(serialBuffer);
    }
  }

  void handleResponse(String response) {
    var pin = parseIntParam(response, 0);

    if (pin < 0) {
      errorMessage = "Pin inválido";
      stateMachine.goTo(new Menu());
      return;
    }

    players.add(new Player(pendingName, pin));
    pendingName = "";
    currentInput = "";
    errorMessage = "";

    stateMachine.goTo(new Menu());
  }

  void keyPressed() {
    if (isCancelPressed()) {
      key = 0;
      stateMachine.goTo(new Menu());
    }
  }
}
