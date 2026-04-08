class Player {
  private String name;
  private int ledId;

  Player(String name, int ledId) {
    this.name = name;
    this.ledId = ledId;
  }

  String name() {
    return name;
  }

  int ledId() {
    return ledId;
  }

  String ledName() {
    switch (ledId) {
      case 0:
        return "rojo";
      case 1:
        return "verde";
      case 2:
        return "azul";
      case 3:
        return "amarillo";
      default:
        return "desconocido";
    }
  }
}
