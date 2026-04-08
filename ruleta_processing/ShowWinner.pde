class ShowWinner extends State {
  Player winner;

  ShowWinner(Player winner) {
    this.winner = winner;
  }

  void enter() {
  }

  void draw() {
    background(BACKGROUND);

    fill(SUCCESS);
    textAlign(CENTER, CENTER);
    textSize(80);
    text("GANADOR:", width / 2, height / 2 - 80);

    textSize(64);
    text(winner.name(), width / 2, height / 2);

    textSize(32);
    fill(TEXT_COLOR);
    text("(LED " + winner.ledName() + ")", width / 2, height / 2 + 80);

    fill(DISABLED);
    textSize(20);
    text("Presiona ENTER para continuar", width / 2, height - 60);
  }

  void keyPressed() {
    if (isConfirmPressed()) {
      key = 0;
      stateMachine.goTo(new Menu());
    }
  }
}
