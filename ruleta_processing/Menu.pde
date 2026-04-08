class Menu extends State {
  void enter() {
  }

  void draw() {
    drawPlayers(0, -1);
    fill(TEXT_COLOR);
    text("Opciones:", WINDOW_MARGIN_X, OPTIONS_TOP_Y);

    if (canAdd()) {
      fill(TEXT_COLOR);
      text("[A] Añadir jugador", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 40);
    } else {
      fill(DISABLED);
      text("[A] Añadir jugador (desactivado)", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 40);
    }

    if (canRemove()) {
      fill(TEXT_COLOR);
      text("[E] Eliminar jugador", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 80);
    } else {
      fill(DISABLED);
      text("[E] Eliminar jugador (desactivado)", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 80);
    }

    if (canSpin()) {
      fill(SUCCESS);
      text("[G] Girar ruleta", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 120);
    } else {
      fill(DISABLED);
      text("[G] Girar ruleta (desactivado)", WINDOW_MARGIN_X, OPTIONS_TOP_Y + 120);
    }
  }

  void keyPressed() {
    if (isAddPresssed() && canAdd()) {
      currentInput = "";
      errorMessage = "";
      stateMachine.goTo(new Add());
    }

    if (isRemovePressed() && canRemove()) {
      currentInput = "";
      errorMessage = "";
      selectedPlayer = -1;
      stateMachine.goTo(new Remove());
    }

    if (isSpinPressed() && canSpin()) {
      errorMessage = "";
      stateMachine.goTo(new Spin());
    }
  }
}
