import 'history_data_model.dart';

import 'covid_api.dart';
import 'country_model.dart';
import 'display_data_model.dart';
import 'global_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidData extends ChangeNotifier {
  List<Country> _currentCountriesData = [];
  List<Country> _yesterdayCountriesData = [];
  List<Country> get currentCountriesData => [..._currentCountriesData];
  List<Country> get yesterdayCountriesData => [..._yesterdayCountriesData];

  GlobalInfo _currentGlobalData = GlobalInfo();
  GlobalInfo _yesterdayGlobalData = GlobalInfo();

  GlobalInfo get currentGlobalData => _currentGlobalData;
  GlobalInfo get yesterdayGlobalData => _yesterdayGlobalData;

  Country _currentCountryData = Country();
  Country _yesterdayCountryData = Country();

  Country get currentCountryData => _currentCountryData;
  Country get yesterdayCountryData => _yesterdayCountryData;

  DisplayDataModel _currentCovidData = DisplayDataModel();
  DisplayDataModel _yesterdayCovidData = DisplayDataModel();

  DisplayDataModel get currentCovidData => _currentCovidData;
  DisplayDataModel get yesterdayCovidData => _yesterdayCovidData;

  List<Map<String, String>> _countriesListWithNameAndFlag = [];
  List<Map<String, String>> get countriesListWithNameAndFlag => _countriesListWithNameAndFlag;

  HistoryData _historyData;
  HistoryData get historyData => _historyData;

  String selectedRegion = 'Global';

  final CovidApi _covidApi = CovidApi();

  //NOTE fromTime is int type and value in millisecond
  //TODO: convert to time and date follow the language selected
  String convertToDate(int fromTime) {
    final date = new DateTime.fromMillisecondsSinceEpoch(fromTime);
    final mDate = DateFormat.yMMMMd().add_jms().format(date);
    return mDate;
  }

  void updateDisplayData(bool rIsGlobal) {
    if (rIsGlobal) {
      //NOTE update global data
      _currentCovidData.updatedAt = _currentGlobalData.updatedAt;
      _currentCovidData.cases = _currentGlobalData.cases;
      _currentCovidData.deaths = _currentGlobalData.deaths;
      _currentCovidData.recovered = _currentGlobalData.recovered;
      _currentCovidData.todayCases = _currentGlobalData.todayCases;
      _currentCovidData.todayDeaths = _currentGlobalData.todayDeaths;
      _currentCovidData.active = _currentGlobalData.active;
      _currentCovidData.critical = _currentGlobalData.critical;
      _currentCovidData.tests = _currentGlobalData.tests;
      _currentCovidData.casesPerOneMillion = _currentGlobalData.casesPerOneMillion;
      _currentCovidData.deathsPerOneMillion = _currentGlobalData.deathsPerOneMillion;
      _currentCovidData.testsPerOneMillion = _currentGlobalData.testsPerOneMillion;

      _currentCovidData.country = '';
      _currentCovidData.flagUrl = '';
      _currentCovidData.affectedCountries = _currentGlobalData.affectedCountries;

      _yesterdayCovidData.updatedAt = _yesterdayGlobalData.updatedAt;
      _yesterdayCovidData.cases = _yesterdayGlobalData.cases;
      _yesterdayCovidData.deaths = _yesterdayGlobalData.deaths;
      _yesterdayCovidData.recovered = _yesterdayGlobalData.recovered;
      _yesterdayCovidData.todayCases = _yesterdayGlobalData.todayCases;
      _yesterdayCovidData.todayDeaths = _yesterdayGlobalData.todayDeaths;
      _yesterdayCovidData.active = _yesterdayGlobalData.active;
      _yesterdayCovidData.critical = _yesterdayGlobalData.critical;
      _yesterdayCovidData.tests = _yesterdayGlobalData.tests;
      _yesterdayCovidData.casesPerOneMillion = _yesterdayGlobalData.casesPerOneMillion;
      _yesterdayCovidData.deathsPerOneMillion = _yesterdayGlobalData.deathsPerOneMillion;
      _yesterdayCovidData.testsPerOneMillion = _yesterdayGlobalData.testsPerOneMillion;

      _yesterdayCovidData.affectedCountries = _yesterdayGlobalData.affectedCountries;
      _yesterdayCovidData.country = '';
      _yesterdayCovidData.flagUrl = '';
    } else {
      //NOTE update country data
      _currentCovidData.updatedAt = _currentCountryData.updatedAt;
      _currentCovidData.cases = _currentCountryData.cases;
      _currentCovidData.deaths = _currentCountryData.deaths;
      _currentCovidData.recovered = _currentCountryData.recovered;
      _currentCovidData.todayCases = _currentCountryData.todayCases;
      _currentCovidData.todayDeaths = _currentCountryData.todayDeaths;
      _currentCovidData.active = _currentCountryData.active;
      _currentCovidData.critical = _currentCountryData.critical;
      _currentCovidData.tests = _currentCountryData.tests;
      _currentCovidData.casesPerOneMillion = _currentCountryData.casesPerOneMillion;
      _currentCovidData.deathsPerOneMillion = _currentCountryData.deathsPerOneMillion;
      _currentCovidData.testsPerOneMillion = _currentCountryData.testsPerOneMillion;

      _currentCovidData.country = _currentCountryData.country;
      _currentCovidData.flagUrl = _currentCountryData.flagUrl;
      _currentCovidData.affectedCountries = 0;
      //For yesterday data
      _yesterdayCovidData.updatedAt = _yesterdayCountryData.updatedAt;
      _yesterdayCovidData.cases = _yesterdayCountryData.cases;
      _yesterdayCovidData.deaths = _yesterdayCountryData.deaths;
      _yesterdayCovidData.recovered = _yesterdayCountryData.recovered;
      _yesterdayCovidData.todayCases = _yesterdayCountryData.todayCases;
      _yesterdayCovidData.todayDeaths = _yesterdayCountryData.todayDeaths;
      _yesterdayCovidData.active = _yesterdayCountryData.active;
      _yesterdayCovidData.critical = _yesterdayCountryData.critical;
      _yesterdayCovidData.tests = _yesterdayCountryData.tests;
      _yesterdayCovidData.casesPerOneMillion = _yesterdayCountryData.casesPerOneMillion;
      _yesterdayCovidData.deathsPerOneMillion = _yesterdayCountryData.deathsPerOneMillion;
      _yesterdayCovidData.testsPerOneMillion = _yesterdayCountryData.testsPerOneMillion;

      _yesterdayCovidData.country = _yesterdayCountryData.country;
      _yesterdayCovidData.flagUrl = _yesterdayCountryData.flagUrl;
      _yesterdayCovidData.affectedCountries = 0;
    }

    notifyListeners();
  }

  Country findByName(String rCountryName, bool withYesterday) {
    if (withYesterday) {
      return _yesterdayCountriesData.firstWhere((country) => country.country == rCountryName, orElse: () => throw Exception('Cannot find country'));
    } else
      return _currentCountriesData.firstWhere((country) => country.country == rCountryName, orElse: () => throw Exception('Cannot find country from yesterday'));
  }

  Future<void> fetchGlobalData() async {
    try {
      print('CovidData>>> Fetching global data');
      final _currentData = await _covidApi.getGlobalInfo(false);
      final _yesterdayData = await _covidApi.getGlobalInfo(true);
      if (_currentData.updatedAt != null && _yesterdayData.updatedAt != null) {
        _currentGlobalData = _currentData;
        _yesterdayGlobalData = _yesterdayData;
        // notifyListeners();
        // print('Send notif to listener of global data');
        updateDisplayData(true);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAllCountriesData() async {
    try {
      final _currentData = await _covidApi.getAllCountries(false);
      // final _yesterdayData = await _covidApi.getAllCountries(true);
      if (_currentData.length > 0) {
        _currentCountriesData = _currentData;
        // _yesterdayCountriesData = _yesterdayData;
        notifyListeners();
        print('Send notif to listener of all countries data');
      }
    } on Exception catch (err) {
      throw Exception(err);
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchCountryData(String rCountryName) async {
    try {
      final _currentData = await _covidApi.getCountryInfoByName(rCountryName, false);
      final _yesterdayData = await _covidApi.getCountryInfoByName(rCountryName, true);
      _currentCountryData = _currentData;
      _yesterdayCountryData = _yesterdayData;
      updateDisplayData(false);
    } on Exception catch (err) {
      print('Get country data got error: $err');
      throw Exception('Get country data error!');
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchCountriesNameAndFlag() async {
    if (_countriesListWithNameAndFlag.length > 0) {
      //Skip fetching data
      print('skip fetching data if already have, unless receive comnad refresh data');
      notifyListeners();
    }
    try {
      print('CovidData>>> Fetching countries name and flag data');
      _countriesListWithNameAndFlag.clear();
      _countriesListWithNameAndFlag.add({'country': 'Global', 'flag': 'assets/icons/global.svg'});
      final _currentData = await _covidApi.getCountriesNameAndFlag();
      if (_currentData.length > 0) {
        _currentData.forEach((country) {
          _countriesListWithNameAndFlag.add({
            'country': country.country,
            'flag': country.flagUrl,
          });
        });
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> refreshAllData() async {
    print('CovidData>>> refresh all data');
    _currentGlobalData.updatedAt = 0;
    _countriesListWithNameAndFlag.clear();
    selectedRegion = 'Global';
    try {
      await fetchGlobalData();
      await fetchCountriesNameAndFlag();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getGlobalHistoryData() async {
    try {
      final mHistoryData = await _covidApi.getGlobalHistoryData();
      _historyData = mHistoryData;
      notifyListeners();
      print('D/Get global history data');
    } on Exception catch (err) {
      print('Final catch error: $err');
      throw (err);
    }
  }

  Future<void> getCountryHistoryData(String countryName) async {
    try {
      final mHistoryData = await _covidApi.getCountryHistoryData(countryName);
      _historyData = mHistoryData;
      notifyListeners();
      print('D/Get country $countryName history data');
    } on Exception catch (err) {
      print('Final catch error: $err');
      throw (err);
    }
  }
}
