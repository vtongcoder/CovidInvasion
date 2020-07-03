import 'package:covid_invasion/covid-update/detail_info_screen.dart';
import 'package:covid_invasion/covid-update/covid_update_screen.dart';
import 'package:covid_invasion/game/game-wrapper.dart';
import 'package:flutter/material.dart';

import 'route_name_constant.dart';
import '../screen/main-home-screen.dart';
import '../screen/help-screen.dart';
import '../screen/settings-screen.dart';

class CustomRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
          builder: (context) => MainHomeScreen(),
        );
        break;
      case helpRoute:
        return MaterialPageRoute(
          builder: (context) => HelpScreen(),
        );
        break;
      case settingRoute:
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        );
        break;
      case covidUpdate:
        return MaterialPageRoute(builder: (ctx) => CovidUpdate());
        break;
      case gameRoute:
        return MaterialPageRoute(builder: (ctx) => GameWrapper());
        break;
      case covidDetailsInfo:
        return MaterialPageRoute(builder: (ctx) => DetailInfoScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => MainHomeScreen(),
        );
        break;
    }
  }
}
