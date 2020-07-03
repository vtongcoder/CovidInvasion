import 'dart:ui';

import '../../game-controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import '../../game-ui.dart';
import '../sfx.dart';

class Virus {
  final GameController game;
  final double startPosX;
  final double startPosY;
  Rect virusRect;
  bool isDead;

  double get speed => game.tileSize;

  List<Sprite> virusSprites;
  String spriteImageUrl = '';
  Sprite deadSprite;
  double virusSpriteIndex;
  Offset targetLocation;

  int damage;
  int health;
  int virusId = -1;

  Virus(this.game, this.startPosX, this.startPosY) {
    virusSpriteIndex = 0;
    isDead = false;
    health = 1; // Number of tap to kill the virus
    damage = 1; // number of damage health level of player
    // spriteImageUrl = 'virus/virus-green.png';
    // loadSprites();
    setTargetLocation(this.startPosX, game.screenSize.height + game.tileSize);
  }

  void loadSprites(String spriteUrl) async {
    Image _image = await Flame.images.load(spriteUrl);
    int _frames = _image.width ~/ _image.height;
    for (int f = 0; f < _frames; f++) {
      virusSprites.add(
        Sprite.fromImage(
          _image,
          x: _image.height.toDouble() * f,
          width: _image.height.toDouble(),
        ),
      );
    }
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(
        c,
        virusRect.inflate(2),
      );
    } else {
      virusSprites[virusSpriteIndex.toInt()].renderRect(
        c,
        virusRect.inflate(2),
      );
    }
  }

  void update(double t) {
    if (isDead) {
      virusRect = virusRect.deflate(t);
      virusRect = virusRect.translate(0, game.tileSize * 12 * t);
    } else {
      virusSpriteIndex += virusSprites.length * t;
      while ((virusSpriteIndex >= virusSprites.length) && (virusSprites.length > 0)) {
        virusSpriteIndex -= virusSprites.length;
      }
    }
    // move the virus
    double stepDistance = speed * t * game.gameLevel; // speed = speed + 10% speed * (level - 1)

    // to virus

    // To random target make the virus move around
    Offset toTarget = targetLocation - Offset(virusRect.left, virusRect.top);
    //moving to target
    if (stepDistance < toTarget.distance) {
      // Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      // final double toPlayerTargetDistance = toPlayer.distance - game.player.playerRect.size.height * 0.5;

      // if (toPlayerTargetDistance > 0 && (stepDistance >= toPlayerTargetDistance)) {
      //   attack();
      // } else {
      //   virusRect = virusRect.shift(stepToTarget);
      // }
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);

      virusRect = virusRect.shift(stepToTarget);
    } else {
      // reach the target
      virusRect = virusRect.shift(toTarget);
      print('Game Over');
      game.gameUi.currentScreen = UIScreen.lost;
      game.gameUi.update();
      if (game.gameUi.isSFXEnabled) {
        SFX.playGameOverSound();
      }

      // setTargetLocation();
    }

    if (isDead && game.gameUi.isSFXEnabled) {
      SFX.playDeathSound();
    }
  }

  void setTargetLocation(double rStartPosX, rStartPosY) {
    targetLocation = Offset(rStartPosX, rStartPosY);
  }
}
