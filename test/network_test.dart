import 'dart:convert';

import 'package:covid_invasion/covid-update/network_covid/history_data_model.dart';
import 'package:flutter/material.dart';

import '../lib/covid-update/network_covid/connectivity_check.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../lib/covid-update/network_covid/covid_data.dart';
import '../lib/covid-update/network_covid/covid_api.dart';

void main() {
  final covidData = CovidData();
  final connectivityChecker = ConnectivityCheck();

  test('Check connectivity', () async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await connectivityChecker.initConnectivity();
    } catch (e) {
      print('Error when check connectivity: $e');
    }
  });
  test('getGlobalInfo Today and yesterday', () async {
    // CovidApi api = CovidApi();

    // GlobalInfo infoToday = await api.getGlobalInfo(false);
    // var date = new DateTime.fromMillisecondsSinceEpoch(infoToday.updatedAt);
    // var mDate = DateFormat.yMMMMd().add_jms().format(date);
    // print(
    //     'Info updated today: $mDate, Cases: ${infoToday.cases} - Recovered: ${infoToday.recovered} - Deaths: ${infoToday.deaths}');

    // final covidData = CovidData();
    try {
      await covidData.fetchGlobalData().then((_) {
        final currentGlobalData = covidData.currentGlobalData;
        print('Global data:\n');
        print('Current: ${currentGlobalData.cases} at ${currentGlobalData.updatedAt} and ${covidData.yesterdayGlobalData.updatedAt}');
        var date = new DateTime.fromMillisecondsSinceEpoch(currentGlobalData.updatedAt);
        var mDate = DateFormat.yMMMMd().add_jms().format(date);
        print('Current updated: $mDate');

        date = new DateTime.fromMillisecondsSinceEpoch(covidData.yesterdayGlobalData.updatedAt);
        mDate = DateFormat.yMMMMd().add_jms().format(date);
        print('Yesterday updated: $mDate');
      });
    } catch (e) {
      print('Error when fetch global data $e');
    }
  });

  test('Get Country info', () async {
    CovidApi api = CovidApi();
    try {
      var info = await api.getCountryInfoByName('Vietnam', false);
      print('Vietnam today: ${info.cases}');

      info = await api.getCountryInfoByName('Vietnam', true);
      print('Vietnam yesterday: ${info.cases}');
    } on Exception catch (err) {
      print('Final catch error: $err');
      final errStr = err.toString();
      final errmsg = errStr.substring(errStr.indexOf('{'));
      final message = jsonDecode(errmsg)['message'];
      print('Error message: $message');
      // throw (err);
    }
  });

  test('Get all countries', () async {
    final covidData = CovidData();
    try {
      final beforeFetch = DateTime.now();
      await covidData.fetchAllCountriesData().then((_) {
        final currentData = covidData.currentCountriesData;
        print('Countries data:\n');
        print('Current: ${currentData.length}');
        final Duration diffTime = DateTime.now().difference(beforeFetch);

        print('Total fetch time: $diffTime');

        // if (currentData.length > 0) {
        //   print('Country list: ');
        //   for (int i = 0; i < currentData.length; i++) {
        //     print(currentData[i].country);
        //   }
        // }
      });
    } on Exception catch (e) {
      print('Error when fetching all countries data $e');
    } catch (e) {
      print('Error when fetch global data $e');
    }
    try {
      final vietnamData = covidData.findByName('Vienam', true);
      print('Vietnam cases: ${vietnamData.cases}');
    } on Exception catch (err) {
      print('Error not found country, $err');
    } catch (e) {}
  });

  test('Get history data', () async {
    CovidApi api = CovidApi();

    try {
      final info = await api.getGlobalHistoryData();
      print('Global total cases history: ${info.cases}, length = ${info.cases.length}');
      info.cases.forEach((key, value) {
        print('Data point: $value @ $key');
      });
    } on Exception catch (err) {
      print('Final catch error: $err');
      throw (err);
    }
  });

  test('Get country history data', () async {
    CovidData covidData = CovidData();
    try {
      await covidData.getCountryHistoryData('Vietnam');
      print('Data: ${covidData.historyData.cases}');
    } catch (e) {
      print('Error: $e');
    }
  });
}
