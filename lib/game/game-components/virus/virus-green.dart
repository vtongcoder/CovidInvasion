import 'dart:ui';

import 'virus.dart';
import '../../game-controller.dart';
import 'package:flame/sprite.dart';

class GreenVirus extends Virus {
  static const double speedRatio = 1.1;
  double get speed => game.tileSize * speedRatio;
  GreenVirus(GameController game, double x, double y) : super(game, x, y) {
    virusId = 1;
    final scaleRatio = 0.7;
    virusSprites = List<Sprite>();
    virusRect = Rect.fromLTWH(x, y, game.tileSize * scaleRatio, game.tileSize * scaleRatio);

    deadSprite = Sprite('virus/virus-die.png');
    loadSprites('virus/virus-green.png');
  }
}
