import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../localization/lang_constant.dart';
import '../localization/language_model.dart';
import 'covid-invasion-app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Language> languageList = Language.languageList();
  Language _selectedLanguage;
  String appVersion = '0.0.0';

  void _getAppVersion() {
    PackageInfo.fromPlatform().then((packageInfo) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      setState(() {
        appVersion = '$version+$buildNumber';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Language tempLang;
    getLocale().then((locale) {
      switch (locale.languageCode) {
        case ENGLISH:
          tempLang = languageList[0];
          break;
        case VIETNAM:
          tempLang = languageList[1];
          break;
        default:
          tempLang = languageList.first;
      }
      setState(() {
        _selectedLanguage = tempLang;
      });
    });
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final _langDropdownMenuOption = languageList
        .map(
          (language) => DropdownMenuItem(
            value: language,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(language.flag),
                SizedBox(
                  width: 20,
                ),
                Text(language.name),
              ],
            ),
          ),
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'settings.title'),
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                    ),
                    //NOTE Theme select
                    Divider(),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Version:'),
                          Text(appVersion),
                        ],
                      ),
                    ),
                    Divider(),
                    //NOTE Language select
                    Container(
                      height: 50,
                      // color: Theme.of(context).backgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(getTranslated(context, 'settings.language-label')),
                          // Icon(Icons.language),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.only(top: 4, left: 18, right: 18, bottom: 4),
                            decoration: BoxDecoration(
                              // color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            child: DropdownButton(
                              underline: SizedBox(), // this will clear the default underline
                              isExpanded: true,
                              value: _selectedLanguage,
                              items: _langDropdownMenuOption,
                              onChanged: (Language selectedLanguage) {
                                _changeLanguage(selectedLanguage);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(Language selectedLang) async {
    Locale _tempLocal = await saveLocale(selectedLang.code);
    CovidInvasionApp.setLocale(context, _tempLocal);

    setState(() {
      _selectedLanguage = selectedLang;
    });
  }
}
