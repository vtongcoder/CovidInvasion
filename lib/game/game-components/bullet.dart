import 'dart:ui';

import '../game-controller.dart';
import 'package:flame/sprite.dart';

class Bullet {
  final GameController game;
  final double startPositionX;
  final double startPositionY;
  Rect bulletRect;
  bool isDead;
  bool explode = false;

  double get speed => game.tileSize * 5.0;

  // List<Sprite> bulletSprites;
  // String spriteImageUrl = '';
  Sprite bulletSprite;
  // double bulletSpriteIndex;

  Offset targetLocation;

  Bullet(this.game, this.startPositionX, this.startPositionY) {
    final bulletWidth = game.tileSize * 0.5;

    // spriteImageUrl = 'virus/virus-green.png';
    bulletRect = Rect.fromLTWH(
      this.startPositionX - bulletWidth / 2,
      this.startPositionY,
      bulletWidth,
      bulletWidth * 1.66,
    );
    loadSprites();
    setTargetLocation(this.startPositionX, -game.tileSize);
  }

  void loadSprites() async {
    bulletSprite = Sprite('water-droplet.png');
  }

  void render(Canvas c) {
    bulletSprite.renderRect(c, bulletRect);
  }

  void update(double t) {
    double stepDistance = speed * t; // speed = speed + 10% speed * (level - 1)

    game.viruses.forEach((virus) {
      bool remove = this.bulletRect.overlaps(virus.virusRect);
      if (remove) {
        virus.isDead = true;
        this.explode = true;
        game.gameUi.score++;
        if ((game.gameUi.score ~/ (game.gameLevel * GAME_LEVEL_UP_POINTS) > 0) && (game.gameLevel < MAX_LEVEL)) {
          game.gameLevel += 1;
        }

        final currentHightScore = game.gameUi.storage.getInt('high-score') ?? 0;
        if (game.gameUi.score > currentHightScore) {
          game.gameUi.highScore = game.gameUi.score;
          game.gameUi.storage.setInt('high-score', game.gameUi.score);

          game.gameUi.update();
        }
      }
    });

    game.sanitizerList.forEach((sanitizer) {
      bool touch = this.bulletRect.overlaps(sanitizer.sanitizerRect);
      if (touch) {
        sanitizer.isExplode = true;
        this.explode = true;
      }
    });

    Offset toTarget = targetLocation - Offset(bulletRect.left, bulletRect.top);
    //moving to target
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);

      bulletRect = bulletRect.shift(stepToTarget);
    } else {
      // reach the target
      bulletRect = bulletRect.shift(toTarget);
    }
    game.gameUi.update();
  }

  void setTargetLocation(double rStartPositionX, double rStartPositionY) {
    // final x = game.random.nextDouble() * (game.screenSize.width - game.tileSize * 1.35);

    targetLocation = Offset(rStartPositionX, rStartPositionY);
  }
}
