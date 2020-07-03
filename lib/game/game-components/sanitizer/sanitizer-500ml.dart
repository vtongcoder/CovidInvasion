import 'dart:ui';

import 'sanitizer.dart';
import '../../game-controller.dart';

class Sanitizer500ml extends Sanitizer {
  static const double speedRatio = 2;
  double get speed => game.tileSize * speedRatio;
  Sanitizer500ml(GameController game, double x, double y) : super(game, x, y) {
    final scaleRatio = 0.7;
    sanitizerVolume = 100;
    sanitizerRect = Rect.fromLTWH(x, y, game.tileSize * scaleRatio, game.tileSize * scaleRatio * 2.333);

    loadSprites('sanitizer/sanitizer-bottle-500ml.png');
  }
}
