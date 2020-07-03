import 'dart:ui';

import 'virus.dart';
import '../../game-controller.dart';
import 'package:flame/sprite.dart';

class RedVirus extends Virus {
  static const double speedRatio = 1.2;
  double get speed => game.tileSize * (speedRatio);

  RedVirus(GameController game, double x, double y) : super(game, x, y) {
    final scaleRatio = 0.7;
    virusId = 2;
    virusSprites = List<Sprite>();
    virusRect = Rect.fromLTWH(x, y, game.tileSize * scaleRatio, game.tileSize * scaleRatio);
    loadSprites('virus/virus-red.png');

    deadSprite = Sprite('virus/virus-die.png');
  }
}
