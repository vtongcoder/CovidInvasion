import 'package:flame/flame.dart';

class SFX {
  static Future<void> playPickSound() async {
    Flame.audio.play('sfx/pick.mp3', volume: 0.8);
  }

  static Future<void> playDeathSound() async {
    Flame.audio.play('sfx/death.mp3', volume: 0.7);
  }

  static Future<void> playWaterDropSound() async {
    Flame.audio.play('sfx/waterdroplet.mp3', volume: 0.7);
  }

  static Future<void> playGameOverSound() async {
    Flame.audio.play('sfx/game-over.mp3', volume: 0.8);
  }
}
