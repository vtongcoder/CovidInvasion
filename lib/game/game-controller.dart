import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import 'game-components/bullet.dart';
import 'game-components/sanitizer/sanitizer-250ml.dart';
import 'game-components/sanitizer/sanitizer-500ml.dart';
import 'game-components/sanitizer/sanitizer.dart';
import 'game-components/sfx.dart';
import 'game-components/virus/virus-blue.dart';
import 'game-components/virus/virus-green.dart';
import 'game-components/virus/virus-red.dart';
import 'game-components/virus/virus-spawn.dart';
import 'game-components/virus/virus.dart';
import 'game-ui.dart';
import 'game-components/player.dart';

const MAX_BULLETS_IN_WEAPON = 100;
const MAX_SANITIZER_BOTTLE = 1;
const GAME_LEVEL_UP_POINTS = 250;
const MAX_LEVEL = 5;

class GameController extends BaseGame {
  final GameUIState gameUi;
  Random random;
  int gameLevel;
  int remainingBullets;
  Size screenSize;
  double tileSize; // to show widgets independently to screen size

  Player player;

  //NOTE: background
  Sprite _backgroundSprite;
  Rect _backgroundRect;

  // Game components
  // List<Virus> virusList = <Virus>[];
  // List<Bullet> bulletList = <Bullet>[];

  List<Virus> viruses;

  VirusSpawner virusSpawner;

  List<Bullet> bulletList;

  List<Sanitizer> sanitizerList;

  int rewardPoints;

  GameController(this.gameUi) {
    //do init task
  }

  void initialize() async {
    print('Game initializing...');
    remainingBullets = MAX_BULLETS_IN_WEAPON;
    resize(await Flame.util.initialDimensions());
    initBackground();
    random = new Random();
    player = Player(this);
    viruses = List<Virus>();
    bulletList = List<Bullet>();
    virusSpawner = VirusSpawner(this);
    sanitizerList = List<Sanitizer>();

    gameUi.score = 0;
    gameLevel = 1;
    rewardPoints = 0;

    print('Game initialized!');
  }

  void initBackground() {
    _backgroundSprite = Sprite('bg/galaxy-bg.jpg');
    _backgroundRect = Rect.fromLTWH(0, screenSize.height - tileSize * 22, tileSize * 9, tileSize * 22.5);
  }

  @override
  void render(Canvas c) {
    if (screenSize == null) return;
    c.save();
    _backgroundSprite.renderRect(c, _backgroundRect);

    if (gameUi.currentScreen == UIScreen.playing) {
      viruses.forEach((virus) => virus.render(c));
      bulletList.forEach((bullet) => bullet.render(c));
      sanitizerList.forEach((sanitizer) => sanitizer.render(c));
      player.render(c);
    }

    c.restore();
  }

  @override
  void update(double t) {
    if (gameUi.currentScreen == UIScreen.playing) {
      player.update(t);
      virusSpawner.update(t);
      viruses.forEach((virus) => virus.update(t));
      viruses.removeWhere((virus) => virus.isDead);

      bulletList.forEach((bullet) => bullet.update(t));
      bulletList.removeWhere((bullet) => bullet.explode);

      sanitizerList.forEach((sanitizer) => sanitizer.update(t));
      sanitizerList.removeWhere((sanitizer) => (sanitizer.isExplode || sanitizer.didTouch));
    }
  }

  void resize(Size size) {
    print('*** Screen resize');
    super.resize(size);
    screenSize = size;
    tileSize = screenSize.width / 9;
    gameUi.weaponBarWidth = tileSize / 2;
    gameUi.weaponBarHeight = tileSize * 3;
  }

  void onTapDown(TapDownDetails d) {
    player.onTapDown(d);
    touchPositionDx = d.globalPosition.dx;
    touchPositionDy = d.globalPosition.dy;

    //add bullet when tap
    if (gameUi.currentScreen == UIScreen.playing) {
      if (remainingBullets > 0) {
        remainingBullets--;
        bulletList.add(Bullet(this, touchPositionDx, touchPositionDy - player.playerRect.height / 2));

        if (gameUi.isSFXEnabled) {
          SFX.playWaterDropSound();
        }
      }

      if (remainingBullets < (0.8 * MAX_BULLETS_IN_WEAPON).toInt()) {
        //Generate sanitizer everytime the weapon used up x percent, now use 20%
        if (sanitizerList.length < MAX_SANITIZER_BOTTLE) {
          provideSanitizer();
        }
      }
      gameUi.update();
    }
  }

  void onPanUpdate(DragUpdateDetails d) {
    touchPositionDx = d.globalPosition.dx;
    touchPositionDy = d.globalPosition.dy;
    player.onDragUpdate(d);
  }

  void spawnViruses() {
    double x, y;

    x = random.nextDouble() * (screenSize.width - tileSize); // any where along the width of screen
    y = -tileSize;

    switch (random.nextInt(3)) {
      case 0:
        viruses.add(RedVirus(this, x, y));
        break;
      case 1:
        viruses.add(GreenVirus(this, x, y));
        break;
      case 2:
        viruses.add(BlueVirus(this, x, y));
        break;
      default:
        viruses.add(GreenVirus(this, x, y));
    }
  }

  void provideSanitizer() {
    double x, y;
    x = random.nextDouble() * (screenSize.width - tileSize); // any where along the width of screen
    y = -tileSize;

    switch (random.nextInt(2)) {
      case 0:
        sanitizerList.add(Sanitizer250ml(this, x, y));
        // gameUi.remainingBullets += 50;
        break;
      case 1:
        sanitizerList.add(Sanitizer500ml(this, x, y));
        // gameUi.remainingBullets += 100;
        break;
      default:
        sanitizerList.add(Sanitizer250ml(this, x, y));
        // gameUi.remainingBullets += 50;
        break;
    }
  }
}
