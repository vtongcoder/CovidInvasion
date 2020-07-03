import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'main-home-screen.dart';
import '../localization/app_localization.dart';
import '../localization/lang_constant.dart';

import '../routes/custom_routes.dart';

import '../covid-update/network_covid/covid_data.dart';
import '../covid-update/network_covid/connectivity_check.dart';

class CovidInvasionApp extends StatefulWidget {
  CovidInvasionApp({Key key}) : super(key: key);

  @override
  _CovidInvasionAppState createState() => _CovidInvasionAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _CovidInvasionAppState state = context.findRootAncestorStateOfType<_CovidInvasionAppState>();

    state.setLocale(locale);
  }
}

class _CovidInvasionAppState extends State<CovidInvasionApp> {
  bool _isInit = true;
  Locale _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      getLocale().then((locale) {
        setState(() {
          this._locale = locale;
        });
      });
    }
    _isInit = false;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CovidData>(
          create: (context) => CovidData(),
        ),
        ChangeNotifierProvider<ConnectivityCheck>(
          create: (context) => ConnectivityCheck(),
        ),
      ],
      child: _locale == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Covid Invasion',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),

              //NOTE flutter_localizations
              locale: _locale,
              localizationsDelegates: [
                AppLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'),
                const Locale('vi', 'VN'),
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.countryCode == deviceLocale.countryCode && locale.languageCode == deviceLocale.languageCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              home: MainHomeScreen(),

              //NOTE Router
              onGenerateRoute: CustomRoute.allRoutes,
              // initialRoute: homeRoute,
            ),
    );
  }
}
