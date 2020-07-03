import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonValues = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedValues = json.decode(jsonValues);

    _localizedValues = mappedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedStr(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate = AppLocalizationDelegate();
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    if (locale != null) {
      return ['en', 'vi'].contains(locale.languageCode);
    }
    return false;
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization appLocalizdation = AppLocalization(locale);
    await appLocalizdation.load();
    return appLocalizdation;
  }

  @override
  bool shouldReload(LocalizationsDelegate old) {
    return false;
  }

  // bool _isSupported(Locale locale) {
  //   if (locale != null) {
  //     for (Locale supportedLocale in supportedLocales) {
  //       if (supportedLocale.languageCode == locale.languageCode) {
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }
}
