import 'package:flame/flame.dart';

class LoadAssets {
  static Future<void> loadAllImages() async {
    await Flame.images.loadAll(<String>[
      'water-droplet.png',
      'spaceship.png',
      'bg/galaxy-bg.jpg',
      'branding/title.png',
      'ui/dialog-credits.png',
      'ui/dialog-help.png',
      'ui/icon-credits.png',
      'ui/icon-help.png',
      'ui/start-button.png',
      'ui/icon-music-disabled.png',
      'ui/icon-music-enabled.png',
      'ui/icon-sound-disabled.png',
      'ui/icon-sound-enabled.png',
      'virus/virus-red.png',
      'virus/virus-green.png',
      'virus/virus-blue.png',
      'virus/virus-die.png',
      'sanitizer/sanitizer-bottle-250ml.png',
      'sanitizer/sanitizer-bottle-500ml.png',
    ]);
  }

  static Future<void> loadAllSounds() async {
    Flame.audio.loadAll(<String>[
      'bgm/space_game.mp3',
      'sfx/death.mp3',
      'sfx/game-over.mp3',
      'sfx/pick.mp3',
      'sfx/waterdroplet.mp3',
    ]);
  }

  static void clearAll() {
    Flame.audio.clearAll();
    Flame.bgm.clearAll();
  }
}
