import processing.serial.*;

static final int WINDOW_WIDTH = 1280;
static final int WINDOW_HEIGHT = 720;
static final int TEXT_SIZE = 24;

static final color BACKGROUND = #171717;
static final color TEXT_BOX_BACKGROUND = #333333;
static final color TEXT_COLOR = #ffffff;
static final color DISABLED = #9d9d9d;
static final color SUCCESS = #4edd34;
static final color ERROR = #e94a3f;

static final int WINDOW_MARGIN_X = 25;
static final int TITLE_TOP_Y = 40;
static final int LIST_START_Y = 70;
static final int LINE_HEIGHT = (int)(TEXT_SIZE * 1.4);

static final int OPTIONS_TOP_Y = 400;
static final int TEXT_BOX_Y = 60;
static final int TEXT_BOX_WIDTH = 300;
static final int TEXT_BOX_HEIGHT = TEXT_SIZE + 12;

static final int MAX_PLAYERS = 4;

StateMachine stateMachine = new StateMachine();

Serial serial;
String serialBuffer = "";
boolean serialReady = false;

ArrayList<Player> players = new ArrayList<Player>(MAX_PLAYERS);

String currentInput = "";
String errorMessage = "";

String pendingName = "";
int selectedPlayer = -1;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup() {
  textSize(TEXT_SIZE);

  var serialList = Serial.list();

  if (serialList.length == 0) {
    println("[ERROR] No se encontraron dispositivos seriales");
    exit();
    return;
  }

  serial = new Serial(this, serialList[0], 9600);
  serial.bufferUntil('\n');

  stateMachine.goTo(new Menu());
}

void draw() {
  background(BACKGROUND);
  stateMachine.draw();
}

void keyPressed() {
  stateMachine.keyPressed();
}

void serialEvent(Serial event) {
  serialBuffer = event.readStringUntil('\n');

  if (serialBuffer != null) {
    serialBuffer = trim(serialBuffer);
    serialReady = true;
  }
}

void drawPlayers(int marginTop, int highlight) {
  fill(TEXT_COLOR);
  text("Jugadores (" + players.size() + "/" + MAX_PLAYERS + "):", WINDOW_MARGIN_X, marginTop + TITLE_TOP_Y);

  for (var index = 0; index < players.size(); index++) {
    if (index == highlight) {
      fill(SUCCESS);
    } else {
      fill(TEXT_COLOR);
    }

    text((index + 1) + ". " + players.get(index).name() + " (LED " + players.get(index).ledName() + ")", WINDOW_MARGIN_X, marginTop + LIST_START_Y + index * LINE_HEIGHT);
  }
}

boolean canAdd() {
  return players.size() < MAX_PLAYERS;
}

boolean canRemove() {
  return players.size() > 0;
}

boolean canSpin() {
  return players.size() >= 2;
}

void drawError(int y) {
  if (!errorMessage.isEmpty()) {
    fill(ERROR);
    text(errorMessage, WINDOW_MARGIN_X, y);
  }
}

String joinUsedPins() {
  var usedPins = new StringBuilder();

  for (Player player : players) {
    usedPins.append(player.ledId()).append(",");
  }

  if (!usedPins.isEmpty()) {
    usedPins.deleteCharAt(usedPins.length() - 1);
  }

  return usedPins.toString();
}

String joinAvailablePins() {
  boolean[] used = new boolean[MAX_PLAYERS];

  for (Player player : players) {
    var led = player.ledId();

    if (led >= 0 && led < used.length) {
      used[led] = true;
    }
  }

  var available = new StringBuilder();

  for (var i = 0; i < used.length; i++) {
    if (!used[i]) {
      available.append(i).append(",");
    }
  }

  if (available.length() > 0) {
    available.deleteCharAt(available.length() - 1);
  }

  return available.toString();
}

int parseIntParam(String input, int index) {
  var parts = split(input, '=');

  if (parts.length < 2) {
    return -1;
  }

  var params = split(parts[1], '|');

  if (params.length <= index) {
    return -1;
  }

  return int(params[index]);
}

boolean isConfirmPressed() {
  return key == ENTER || key == RETURN;
}

boolean isCancelPressed() {
  return key == ESC;
}

boolean isDeleteCharacterPressed() {
  return key == BACKSPACE;
}

boolean isNumberPressed() {
  return key >= '0' && key <= '9';
}

boolean isAddPresssed() {
  return key == 'a' || key == 'A';
}

boolean isRemovePressed() {
  return key == 'e' || key == 'E';
}

boolean isSpinPressed() {
  return key == 'g' || key == 'G';
}
