import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:covid_invasion/admob/admob_service.dart';
import 'package:covid_invasion/covid-update/custom_widgets/fade_in.dart';
import 'package:covid_invasion/covid-update/custom_widgets/statistic_card.dart';
import 'package:covid_invasion/covid-update/network_covid/connectivity_check.dart';
import 'package:covid_invasion/localization/lang_constant.dart';
import 'package:covid_invasion/routes/route_name_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

import 'game-components/bgm.dart';
import 'game-controller.dart';

import '../covid-update/network_covid/covid_data.dart';

class GameUI extends StatefulWidget {
  GameUI({Key key}) : super(key: key);

  final gameState = GameUIState();

  @override
  GameUIState createState() => gameState;
}

enum _AniProps { opacity, translateY }

class GameUIState extends State<GameUI> with WidgetsBindingObserver {
  UIScreen currentScreen = UIScreen.playing; // for dev game, go directly to game
  GameController game;

  int score = 0;
  int highScore = 0;

  double weaponBarWidth;
  double weaponBarHeight;
  bool isRewarded = false;

  bool isBGMEnabled = true;
  bool isSFXEnabled = true;
  bool _isInit = true;
  bool _isInternetAvailable = false;
  SharedPreferences storage;

  //NOTE: for admob_flutter
  final ams = AdMobService();
  AdmobBannerSize bannerSize;
  // AdmobInterstitial interstitialAd;
  // AdmobReward rewardAd;

  // NOTE: for animation the reward point
  MultiTween<_AniProps> tween = MultiTween<_AniProps>()
    ..add(
      _AniProps.opacity,
      Tween<double>(begin: 1.0, end: 0.0),
    )
    ..add(
      _AniProps.translateY,
      Tween<double>(begin: 0.0, end: -10),
    );

  void setupAdMob() {
    bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  void initState() {
    print('Init GameUI');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setupAdMob();
  }

  @override
  void didChangeDependencies() {
    final connectivity = Provider.of<ConnectivityCheck>(context, listen: false);

    print('Changed dependencies');
    super.didChangeDependencies();
    if (_isInit) {
      game.resize(WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio);

      _isInternetAvailable = connectivity.isInternetAvailable;
    }
    _isInit = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (BGM.isPlaying) {
        if (isBGMEnabled) {
          BGM.resume();
        } else {
          BGM.pause();
        }
      }
    } else if (BGM.isPlaying) {
      BGM.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  void update() {
    setState(() {});
  }

  void didChangeMetrics() {
    print('D/Changed metrics');
    game.resize(WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          topControls(),
          scoreDisplay(),
          Expanded(
            child: IndexedStack(
              sizing: StackFit.expand,
              children: <Widget>[
                buildScreenPlaying(),
                buildScreenLost(),
              ],
              index: currentScreen.index,
            ),
          ),
        ],
      ),
    );
  }

  Widget spacer({int size}) {
    return Expanded(
      flex: size ?? 100,
      child: Center(),
    );
  }

  Widget buildScreenPlaying() {
    return Positioned.fill(
      child: Row(
        children: <Widget>[
          SizedBox(height: 4),
          weaponBarDisplay(),
        ],
      ),
    );
  }

  Widget buildScreenLost() {
    List<Widget> children = List<Widget>();
    if (_isInternetAvailable) {
      children.add(
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: AdmobBanner(
              adUnitId: ams.getBannerAdUnitId(),
              adSize: bannerSize,
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                ams.handleEvent(event, args, 'Banner');
              }),
        ),
      );
      children.add(Column(
        children: <Widget>[
          Text(
            getTranslated(context, 'gamelost.globalUpdate'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Consumer<CovidData>(
            builder: (ctx, data, _) => FadeIn(
              1,
              StatisticCard(
                color: Colors.orange,
                text: getTranslated(context, 'covidupdate.cases'),
                icon: Icons.timeline,
                currentData: data.currentCovidData.cases,
                previousData: data.yesterdayCovidData.cases,
              ),
            ),
          ),
          Consumer<CovidData>(
            builder: (ctx, data, _) => FadeIn(
              1.5,
              StatisticCard(
                color: Colors.green,
                text: getTranslated(context, 'covidupdate.recovered'),
                icon: Icons.verified_user,
                currentData: data.currentCovidData.recovered,
                previousData: data.yesterdayCovidData.recovered,
              ),
            ),
          ),
          Consumer<CovidData>(
            builder: (ctx, data, _) => FadeIn(
              2.0,
              StatisticCard(
                color: Colors.red,
                text: getTranslated(context, 'covidupdate.death'),
                icon: Icons.airline_seat_individual_suite,
                currentData: data.currentCovidData.deaths,
                previousData: data.yesterdayCovidData.deaths,
              ),
            ),
          ),
          RaisedButton(
            color: Color(0xff032626),
            child: Text(
              getTranslated(context, 'gamelost.checkDetails'), //getTranslated(context, 'gamelost.play_again'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, covidUpdate);
            },
          ),
          // IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
          Divider(
            height: 4,
            color: Colors.grey,
          ),
        ],
      ));
    }

    children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: <Widget>[
            Text(
              getTranslated(context, 'gamelost.kill_virus_title'),
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFCFCFC),
              ),
            ),
            Text(
              score.toString(),
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFFFCFCFC),
              ),
            ),
            Text(
              getTranslated(context, 'gamelost.virus'),
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 15, bottom: 20),
        child: RaisedButton(
          color: Color(0xff032626),
          child: Text(
            getTranslated(context, 'gamelost.play_again'),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            currentScreen = UIScreen.playing;
            game.initialize();
            update();
          },
        ),
      ),
    );

    return Positioned.fill(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // spacer(),
            SimpleDialog(
              backgroundColor: Color(0x8FBBB8B8),
              children: <Widget>[
                Column(
                  children: children,
                ),
              ],
            ),
            // spacer(),
          ],
        ),
      ),
    );
  }

  Widget scoreDisplay() {
    return currentScreen == UIScreen.playing
        ? Text(
            score.toString(),
            style: TextStyle(
              fontSize: 100,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  color: Color(0x88000000),
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          )
        : Text('');
  }

  Widget weaponBarDisplay() {
    double weaponRemainingLevel = (game.remainingBullets / MAX_BULLETS_IN_WEAPON) * weaponBarHeight - 4;
    weaponRemainingLevel = weaponRemainingLevel < 0 ? 0 : weaponRemainingLevel;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              rewardDisplay(),
            ],
          ),
        ),
        //NOTE: outside
        Container(
          // color: Colors.black45,
          margin: const EdgeInsets.only(left: 10.0),
          width: weaponBarWidth,
          height: weaponBarHeight,
          decoration: BoxDecoration(
            color: Colors.black38,
            boxShadow: [
              BoxShadow(
                color: Color(0x88000000),
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ],
            shape: BoxShape.rectangle,
            // color: Colors.red,
            border: new Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid),
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        //NOTE: inside
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                '${game.remainingBullets}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              AnimatedContainer(
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 2,
                ),
                width: weaponBarWidth - 4,
                height: game.remainingBullets <= MAX_BULLETS_IN_WEAPON ? weaponRemainingLevel : (weaponBarHeight - 4),
                decoration: BoxDecoration(
                  color: Color(0x7A08FF31),
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                duration: const Duration(milliseconds: 500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rewardDisplay() {
    return !isRewarded
        ? SizedBox(
            height: 50,
          )
        : CustomAnimation<MultiTweenValues<_AniProps>>(
            // delay: Duration(milliseconds: 100),
            animationStatusListener: (status) {
              if (status == AnimationStatus.completed) {
                isRewarded = false;
              }
            },
            duration: Duration(milliseconds: 1000),
            tween: tween,
            builder: (context, child, value) => Opacity(
              opacity: value.get(_AniProps.opacity),
              child: Transform.translate(
                offset: Offset(0, value.get(_AniProps.translateY)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '+${game.rewardPoints}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Image.asset(
                      'assets/images/water-droplet.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget bgmControlButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: isBGMEnabled ? Colors.white : Colors.grey,
        icon: Icon(
          isBGMEnabled ? Icons.music_note : Icons.music_video,
        ),
        onPressed: () {
          isBGMEnabled = !isBGMEnabled;
          storage.setBool('isBGMEnabled', isBGMEnabled);
          if (isBGMEnabled) {
            if (!BGM.isPlaying) {
              BGM.play();
            } else if (BGM.isPaused) {
              BGM.resume();
            }
          } else {
            BGM.pause();
          }
          update();
        },
      ),
    );
  }

  Widget sfxControlButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: isSFXEnabled ? Colors.white : Colors.grey,
        icon: Icon(
          isSFXEnabled ? Icons.volume_up : Icons.volume_off,
        ),
        onPressed: () {
          isSFXEnabled = !isSFXEnabled;
          storage.setBool('isSFXEnabled', isSFXEnabled);
          update();
        },
      ),
    );
  }

  Widget backHomeButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.home,
        ),
        onPressed: () {
          BGM.pause();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget highScoreDisplay() {
    Color color;
    FontWeight fontWeight;
    if (score > 0 && score >= highScore) {
      color = Color(0xff032626);
      fontWeight = FontWeight.w800;
    } else {
      color = Colors.white;
      fontWeight = FontWeight.w400;
    }
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/ui/trophee.png',
              width: 50,
              height: 50,
            ),
            Container(
              width: 50,
              height: 50,
              child: Center(
                child: Text(
                  '${game.gameLevel}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: fontWeight,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 4),
        Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/ui/champion-cup.png',
              width: 48,
              height: 48,
            ),
            Container(
              width: 48,
              height: 48,
              child: Center(
                child: Text(
                  highScore.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: fontWeight,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget topControls() {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 5, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          backHomeButton(),
          SizedBox(width: game.tileSize),
          bgmControlButton(),
          sfxControlButton(),
          SizedBox(width: game.tileSize),
          highScoreDisplay(),
        ],
      ),
    );
  }
}

enum UIScreen {
  // home, // StackIndex.index = 0
  playing, // StackIndex.index =
  lost,
  help,
  credits,
}
