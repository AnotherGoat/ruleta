class Add extends State {
  void enter() {
  }

  void draw() {
    fill(TEXT_COLOR);
    text("Añadir jugador (ENTER confirmar, ESC cancelar)", WINDOW_MARGIN_X, TITLE_TOP_Y);

    stroke(TEXT_COLOR);
    fill(TEXT_BOX_BACKGROUND);
    rect(WINDOW_MARGIN_X, TEXT_BOX_Y, TEXT_BOX_WIDTH, TEXT_BOX_HEIGHT);

    fill(TEXT_COLOR);
    text(currentInput, WINDOW_MARGIN_X + 5, TEXT_BOX_Y + 22);

    drawError(TEXT_BOX_Y + 60);
  }

  void keyPressed() {
    if (isConfirmPressed()) {
      var name = currentInput.trim();

      if (name.isEmpty()) {
        errorMessage = "El nombre no puede estar vacío";
        return;
      }

      if (isDuplicate(name)) {
        errorMessage = "El nombre ya está en uso";
        return;
      }

      currentInput = "";
      errorMessage = "";
      pendingName = name;
      stateMachine.goTo(new ChooseLed());
      return;
    }

    if (isDeleteCharacterPressed()) {
      if (!currentInput.isEmpty()) {
        currentInput = currentInput.substring(0, currentInput.length() - 1);
      }

      return;
    }

    if (isCancelPressed()) {
      key = 0;
      currentInput = "";
      errorMessage = "";
      stateMachine.goTo(new Menu());
      return;
    }

    if (key != CODED) {
      currentInput += key;
      errorMessage = "";
    }
  }

  boolean isDuplicate(String name) {
    for (var player : players) {
      if (player.name().equalsIgnoreCase(name)) {
        return true;
      }
    }
    return false;
  }
}
