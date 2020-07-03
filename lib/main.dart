import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admob_flutter/admob_flutter.dart';
// App files
import 'game/game-components/bullet.dart';
import 'game/game-components/load-assets.dart';
import 'screen/covid-invasion-app.dart';
import 'admob/admob_service.dart';

bool gameOver = false;
const BULLETSPEED = 60.0;
const DRAGON_SIZE = 40.0;
const BULLET_SIZE = 20.0;

double touchPositionDx = 0.0;
double touchPositionDy = 0.0;
Bullet bullet;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  // Admob.initialize();
  // Or add a list of test ids.
  print('Initializing admob...');
  Admob.initialize(testDeviceIds: [danIphone, androidDevice, phuongIphone]);
  print('Initialized admob: done');

  Util flameUtils = Util();
  await flameUtils.fullScreen();
  await flameUtils.setOrientation(DeviceOrientation.portraitUp);

  Flame.audio.disableLog();

  await LoadAssets.loadAllImages();
  await LoadAssets.loadAllSounds();

  runApp(
    CovidInvasionApp(),
  );
}
