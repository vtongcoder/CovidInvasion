import '../../game-controller.dart';

class VirusSpawner {
  static const MAX_NUMBER_OF_VIRUS_ON_SCREEN = 10;

  final GameController gameController;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 5;

  int maxVirusOnScreen = 5;
  int currentInterval;
  int nextSpawn;
  static const spawnSpeed = 1.0;
  int currentGameLevel;

  VirusSpawner(this.gameController) {
    start();
  }

  void start() {
    killAll();
    currentInterval = 0; // maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
    // currentGameLevel = gameController.gameLevel;
    // maxVirusOnScreen += currentGameLevel;
  }

  void killAll() {
    gameController.viruses.forEach((virus) {
      virus.isDead = true;
    });
  }

  void update(double t) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (gameController.viruses.length < maxVirusOnScreen && now >= nextSpawn) {
      // if (currentGameLevel < gameController.gameLevel) {
      //   currentGameLevel = gameController.gameLevel;
      if (maxVirusOnScreen < MAX_NUMBER_OF_VIRUS_ON_SCREEN) maxVirusOnScreen += 1;
      // }

      gameController.spawnViruses();

      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * spawnSpeed).toInt();
        nextSpawn = now + currentInterval;
      }
    }
  }
}
