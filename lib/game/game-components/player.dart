import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import '../game-controller.dart';
import 'sfx.dart';

class Player {
  final GameController game;

  double playerPositionX;
  double playerPositionY;

  Rect playerRect;
  bool isLoaded = false;

  List<Sprite> playerSprites;
  double spriteIndex;

  Offset targetLocation;

  // BulletRewards bulletReawards;

  Player(this.game) {
    initialize();
  }

  void initialize() async {
    final bottomOffset = game.tileSize * 4;
    final playerHeight = game.tileSize * 2;

    playerRect = Rect.fromLTWH(
      game.screenSize.width / 2 - playerHeight / 2,
      game.screenSize.height - playerHeight / 2 - bottomOffset,
      playerHeight * 0.6,
      playerHeight,
    );
    playerSprites = List<Sprite>();
    spriteIndex = 0;

    // bulletReawards = BulletRewards(this);

    await loadSprites('spaceship.png');
  }

  Future<void> loadSprites(String spriteUrl) async {
    Image image = await Flame.images.load(spriteUrl);
    int _frames = 4;
    for (int f = 0; f < _frames; f++) {
      playerSprites.add(
        Sprite.fromImage(
          image,
          x: image.width.toDouble() / _frames * f,
          width: image.width.toDouble() / _frames,
        ),
      );
    }
    isLoaded = true;

    playerPositionX = (game.screenSize.width - playerRect.width) / 2;
    playerPositionY = game.screenSize.height - playerRect.height / 2 - game.tileSize * 4;

    // isLoaded = true;
    setTargetLocation(this.playerPositionX, this.playerPositionY);
  }

  void render(Canvas c) {
    if (isLoaded) {
      playerSprites[spriteIndex.toInt()].renderRect(
        c,
        playerRect,
      );
      // bulletReawards.render(c);
    }

    // if (game.gameUi.currentScreen == UIScreen.playing) {

    // }
  }

  void update(double t) {
    if (!isLoaded) return;

    spriteIndex += playerSprites.length * t;
    while ((spriteIndex >= playerSprites.length) && (playerSprites.length > 0)) {
      spriteIndex -= playerSprites.length;
    }

    game.sanitizerList.forEach((sanitizer) {
      // final sanitizerBox = sanitizer.sanitizerRect;
      bool touch = this.playerRect.overlaps(sanitizer.sanitizerRect);
      // bool notTouch = this.playerRect.left > sanitizerBox.right || sanitizerBox.left > this.playerRect.right || this.playerRect.top > sanitizerBox.bottom || sanitizerBox.top > this.playerRect.bottom;
      if (touch) {
        sanitizer.didTouch = true;
        game.remainingBullets += sanitizer.sanitizerVolume;
        game.rewardPoints = sanitizer.sanitizerVolume;
        game.gameUi.isRewarded = true;
        if (game.gameUi.isSFXEnabled) {
          SFX.playPickSound();
        }
        game.gameUi.update();
      }
    });

    double stepDistance = game.tileSize * 20 * t;
    Offset toTarget = targetLocation - Offset(playerRect.left, playerRect.top);
    //moving to target
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);

      playerRect = playerRect.shift(stepToTarget);
    } else {
      // reach the target
      playerRect = playerRect.shift(toTarget);
    }

    // if (game.gameUi.currentScreen == UIScreen.playing) {
    // }
  }

  void onTapDown(TapDownDetails d) {
    playerPositionX = d.globalPosition.dx - playerRect.width / 2;
    playerPositionY = d.globalPosition.dy - playerRect.height / 2;
    setTargetLocation(this.playerPositionX, this.playerPositionY);
  }

  void onDragUpdate(DragUpdateDetails d) {
    playerPositionX = d.globalPosition.dx - playerRect.width / 2;
    playerPositionY = d.globalPosition.dy - playerRect.height / 2;
    setTargetLocation(this.playerPositionX, this.playerPositionY);
  }

  void setTargetLocation(double targetPosX, targetPosY) {
    targetLocation = Offset(targetPosX, targetPosY);
  }
}
