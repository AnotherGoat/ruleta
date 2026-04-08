class Remove extends State {
  void enter() {
  }

  void draw() {
    fill(TEXT_COLOR);
    text("Eliminar jugador por ID (ENTER confirmar, ESC cancelar)", WINDOW_MARGIN_X, TITLE_TOP_Y);

    stroke(TEXT_COLOR);
    fill(TEXT_BOX_BACKGROUND);
    rect(WINDOW_MARGIN_X, TEXT_BOX_Y, TEXT_BOX_WIDTH, TEXT_BOX_HEIGHT);

    fill(TEXT_COLOR);
    text(currentInput, WINDOW_MARGIN_X + 5, TEXT_BOX_Y + 30);

    drawError(TEXT_BOX_Y + 60);
    drawPlayers(150, selectedPlayer);
  }

  void keyPressed() {
    if (isConfirmPressed()) {
      validateSelectedPlayer();

      if (selectedPlayer == -1) {
        return;
      }

      players.remove(selectedPlayer);
      currentInput = "";
      errorMessage = "";
      stateMachine.goTo(new Menu());
      return;
    }

    if (isDeleteCharacterPressed()) {
      if (!currentInput.isEmpty()) {
        currentInput = currentInput.substring(0, currentInput.length() - 1);
      }

      validateSelectedPlayer();
      return;
    }

    if (isCancelPressed()) {
      key = 0;
      currentInput = "";
      errorMessage = "";
      stateMachine.goTo(new Menu());
      return;
    }

    if (isNumberPressed()) {
      currentInput += key;
      validateSelectedPlayer();
    }
  }

  void validateSelectedPlayer() {
    String input = currentInput.trim();

    if (input.isEmpty()) {
      selectedPlayer = -1;
      errorMessage = "Debe ingresar un ID";
      return;
    }

    int id = int(input);

    if (id < 1 || id > players.size()) {
      selectedPlayer = -1;
      errorMessage = "ID fuera de rango";
      return;
    }

    selectedPlayer = id - 1;
    errorMessage = "";
  }
}
