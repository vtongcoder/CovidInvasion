import 'dart:ui';

import 'virus.dart';
import '../../game-controller.dart';
import 'package:flame/sprite.dart';

class BlueVirus extends Virus {
  static const double speedRatio = 1.0;
  double get speed => game.tileSize * (speedRatio);

  BlueVirus(GameController game, double x, double y)
      : super(
          game,
          x,
          y,
        ) {
    final scaleRatio = 0.70;
    virusId = 3;
    virusSprites = List<Sprite>();
    virusRect = Rect.fromLTWH(x, y, game.tileSize * scaleRatio, game.tileSize * scaleRatio);
    loadSprites('virus/virus-blue.png');
    deadSprite = Sprite('virus/virus-die.png');
  }
}
