import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localization.dart';

String getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context).getTranslatedStr(key);
}

const String ENGLISH = 'en';
const String VIETNAM = 'vi';

const LANG_CODE = 'languageCode';

Future<Locale> saveLocale(String languageCode) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  await _pref.setString(LANG_CODE, languageCode);
  print('Save language $languageCode');
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(LANG_CODE) ?? VIETNAM;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _tempLocal = Locale(ENGLISH, 'US');
  switch (languageCode) {
    case ENGLISH:
      _tempLocal = Locale(languageCode, 'US');
      break;
    case VIETNAM:
      _tempLocal = Locale(languageCode, 'VN');
      break;
    default:
      _tempLocal = Locale(ENGLISH, 'US');
  }
  return _tempLocal;
}
