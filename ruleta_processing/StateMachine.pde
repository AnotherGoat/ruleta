class StateMachine {
  State current;

  void goTo(State next) {
    current = next;

    if (current != null) {
      current.enter();
    }
  }

  void draw() {
    if (current != null) {
      current.draw();
    }
  }

  void keyPressed() {
    if (current != null) {
      current.keyPressed();
    }
  }
}
