import 'dart:ui';

import '../../game-controller.dart';
import 'package:flame/sprite.dart';

class Sanitizer {
  final GameController game;
  final double startPosX;
  final double startPosY;
  Rect sanitizerRect;
  bool isExplode;
  bool didTouch;

  double get speed => game.tileSize * 1.0;

  Sprite sanitizerSprite;
  String spriteImageUrl = '';
  Offset targetLocation;

  int damage;
  int health;

  int sanitizerVolume; // in ml

  Sanitizer(this.game, this.startPosX, this.startPosY) {
    isExplode = false;
    didTouch = false;

    setTargetLocation(this.startPosX, game.screenSize.height + game.tileSize);
  }

  void loadSprites(String spriteUrl) {
    sanitizerSprite = Sprite(spriteUrl);
  }

  void render(Canvas c) {
    sanitizerSprite.renderRect(c, sanitizerRect);
  }

  void update(double t) {
    double stepDistance = speed * t; // speed = speed + 10% speed * (level - 1)

    Offset toTarget = targetLocation - Offset(sanitizerRect.left, sanitizerRect.top);

    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      //moving to target
      sanitizerRect = sanitizerRect.shift(stepToTarget);
    } else {
      // reach the target
      sanitizerRect = sanitizerRect.shift(toTarget);
      isExplode = true;
    }
  }

  void setTargetLocation(double rStartPosX, rStartPosY) {
    targetLocation = Offset(rStartPosX, rStartPosY);
  }
}
