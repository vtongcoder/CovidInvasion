import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../covid-update/network_covid/connectivity_check.dart';
import '../covid-update/network_covid/covid_data.dart';
import '../routes/route_name_constant.dart';

import '../localization/lang_constant.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  Size _screenSize = Size.zero;
  bool _isInit = true;
  bool isDataAvailable = false;

  @override
  void dispose() {
    final connectivity = Provider.of<ConnectivityCheck>(context, listen: false);
    connectivity.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final connectivity = Provider.of<ConnectivityCheck>(context, listen: false);

    super.didChangeDependencies();

    _screenSize = (WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio);
    if (_isInit) {
      await connectivity.initConnectivity();
      // print('D/Home: Get data first time');
      // await _getData();
    }
    _isInit = false;
  }

  void didChangeMetrics() {
    print('D/Changed metrics');
    _screenSize = (WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConnectivityCheck>(
        builder: (BuildContext context, ConnectivityCheck connectivity, _) {
          if (connectivity.isInternetAvailable & (!isDataAvailable)) {
            _fetchCovidData();
          }
          return HomeView(screenSize: _screenSize, isOnline: (connectivity.isInternetAvailable & isDataAvailable));
        },
      ),
    );
  }

  // Future<void> _getData() async {
  //   final

  //   if (connectivity.isInternetAvailable) {
  //     await _fetchCovidData();
  //   }
  // }

  Future<void> _fetchCovidData() async {
    final covidData = Provider.of<CovidData>(context, listen: false);
    bool mIsDataAvailable = false;
    try {
      await covidData.fetchGlobalData();
    } catch (err) {
      print('Fetch global data got error: $err');
    }

    try {
      await covidData.fetchCountriesNameAndFlag();
      mIsDataAvailable = true;
    } catch (e) {
      print('Get Countries and theirs flag failed');
    }

    try {
      await covidData.getGlobalHistoryData();
    } catch (e) {}
    setState(() {
      isDataAvailable = mIsDataAvailable;
      print('D/Home: Data avaibility status: $isDataAvailable');
    });
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
    this.screenSize,
    this.isOnline,
  }) : super(key: key);
  final Size screenSize;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final _tileSize = screenSize.width / 9;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/bg/covid_wolrd_map.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/branding/title.png',
                    fit: BoxFit.contain,
                  ),
                ),
                RaisedButton(
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        getTranslated(context, 'mainhomescreen.play-game'),
                        // style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_right),
                      Text('Game'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(gameRoute);
                  },
                ),
                SizedBox(height: _tileSize * 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xD306A4FF),
                      textColor: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(getTranslated(context, 'mainhomescreen.covid-update')),
                          Icon(Icons.arrow_right),
                        ],
                      ),
                      shape: StadiumBorder(),
                      onPressed: isOnline
                          ? () {
                              Navigator.pushNamed(context, covidUpdate);
                            }
                          : null,
                    ),
                    isOnline ? SizedBox() : Text(getTranslated(context, 'loading.message')),
                  ],
                ),
                Expanded(
                  child: Center(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Ink(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            color: Colors.pink,
                            icon: Icon(
                              Icons.help_outline,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, helpRoute);
                            },
                          ),
                        ),
                        Text(getTranslated(context, 'mainhomescreen.help-button')),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Ink(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            color: Colors.pink,
                            icon: Icon(
                              Icons.settings,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, settingRoute);
                            },
                          ),
                        ),
                        Text(getTranslated(context, 'mainhomescreen.settings-button')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
