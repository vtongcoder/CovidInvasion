import 'dart:ui';

import 'sanitizer.dart';
import '../../game-controller.dart';

class Sanitizer250ml extends Sanitizer {
  static const double speedRatio = 2.0;
  double get speed => game.tileSize * (speedRatio);

  Sanitizer250ml(GameController game, double x, double y)
      : super(
          game,
          x,
          y,
        ) {
    final scaleRatio = 0.50;
    sanitizerVolume = 50;
    sanitizerRect = Rect.fromLTWH(x, y, game.tileSize * scaleRatio, game.tileSize * scaleRatio * 2.333);
    loadSprites('sanitizer/sanitizer-bottle-250ml.png');
  }
}
