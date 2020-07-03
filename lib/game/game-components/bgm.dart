import 'package:flame/flame.dart';

class BGM {
  static bool isPaused = true;
  static bool isPlaying = false;

  static void play() {
    print('*******  Play background music');
    Flame.bgm.play('bgm/space_game.mp3', volume: 0.8);
    isPlaying = true;
  }

  static void pause() {
    isPaused = true;
    Flame.bgm.pause();
    print('D/pause bgm');
  }

  static void resume() {
    isPaused = false;
    Flame.bgm.resume();
    print('D/resume bgm');
  }

  static void stop() {
    isPaused = false;
    Flame.bgm.stop();
    print('D/stop bgm');
  }

  static void dispose() {
    print('D/dispose bgm');
    Flame.bgm.dispose();
  }
}
