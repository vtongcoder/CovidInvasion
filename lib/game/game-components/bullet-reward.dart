import 'package:flutter/painting.dart';

import 'player.dart';

class BulletRewards {
  final Player player;

  int rewardPoints;
  bool isRewarded;
  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Rect rect;
  double displayTimer;

  BulletRewards(this.player) {
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xFFFFFB08),
      fontSize: 20,
    );

    isRewarded = false;
    rewardPoints = 0;
    displayTimer = 5.0;
  }

  void render(Canvas c) {
    // if (isRewarded) {
    tp.paint(c, textOffset);
    // }
  }

  void update(double t) {
    displayTimer -= t;
    // if (displayTimer > 0.0 && isRewarded) {
    rect = Rect.fromLTWH(
      player.playerRect.left,
      player.playerRect.top,
      player.playerRect.width,
      player.playerRect.height,
    );

    tp.text = TextSpan(
      text: rewardPoints.toString(),
      style: textStyle,
    );
    tp.layout();
    textOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.center.dy,
    );
    // }
    if (displayTimer <= 0) {
      isRewarded = false;
    }
  }
}
