import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game-components/bgm.dart';
import 'game-controller.dart';
import 'game-ui.dart';

class GameWrapper extends StatefulWidget {
  const GameWrapper({Key key}) : super(key: key);

  @override
  _GameWrapperState createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  GameUI gameUI = GameUI();
  GameController game;

  @override
  void initState() {
    super.initState();
    game = GameController(gameUI.gameState);
    gameUI.gameState.game = game;
    game.initialize();
    Flame.bgm.initialize();

    SharedPreferences.getInstance().then((storage) {
      gameUI.gameState.storage = storage;
      gameUI.gameState.highScore = storage.getInt('high-score') ?? 0;
      gameUI.gameState.isBGMEnabled = storage.getBool('isBGMEnabled') ?? false;
      gameUI.gameState.isSFXEnabled = storage.getBool('isSFXEnabled') ?? false;
      gameUI.gameState.update();

      if (gameUI.gameState.isBGMEnabled) {
        BGM.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: game.onTapDown,
                onPanUpdate: game.onPanUpdate,
                child: game.widget,
              ),
            ),
            Positioned.fill(
              child: gameUI,
            ),
          ],
        ),
      ),
    );
  }
}
