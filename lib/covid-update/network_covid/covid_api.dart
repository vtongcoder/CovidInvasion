import 'country_model.dart';
import 'global_model.dart';
import 'dart:convert';

import 'history_data_model.dart';
import 'network_call.dart'; // for jsonDecoce

class CovidApi {
  Future<GlobalInfo> getGlobalInfo(bool isYesterday) async {
    try {
      final String response = await networkCalls.get('${UrlConstants.globalInfo}?yesterday=$isYesterday');
      return GlobalInfo.fromJson(jsonDecode(response));
    } catch (err) {
      throw err;
    }
  }

  Future<Country> getCountryInfoByName(String rCountryName, bool withYesterday) async {
    try {
      final String mResp = await networkCalls.get('${UrlConstants.allCountries}/$rCountryName?yesterday=$withYesterday');
      return Country.fromJson(jsonDecode(mResp));
    } catch (e) {
      throw e;
    }
  }

  Future<List<Country>> getAllCountries(bool withYesterday) async {
    try {
      final response = await networkCalls.get('${UrlConstants.allCountries}?yesterday=$withYesterday');
      final list = jsonDecode(response) as List;
      return list.map((item) => Country.fromJson(item)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Country>> getCountriesNameAndFlag() async {
    try {
      final response = await networkCalls.get('${UrlConstants.allCountries}');
      final list = jsonDecode(response) as List;
      return list.map((item) => Country.fromJsonGetNameAndFlag(item)).toList();
    } catch (e) {
      throw e;
    }
  }

  //https://disease.sh/v2/historical/Vietnam?lastdays=30

  Future<HistoryData> getCountryHistoryData(String rCountryName) async {
    try {
      final String mResp = await networkCalls.get('${UrlConstants.jhucsseHistorical}/$rCountryName?lastdays=30');
      return HistoryData.fromJson(jsonDecode(mResp)['timeline']); // get all data from timeline
      // return Country.fromJson(jsonDecode(mResp));
    } catch (e) {
      throw e;
    }
  }

  //https://disease.sh/v2/historical/all?lastdays=30
  Future<HistoryData> getGlobalHistoryData() async {
    try {
      final String mResp = await networkCalls.get('${UrlConstants.jhucsseHistorical}/all?lastdays=30');

      return HistoryData.fromJson(jsonDecode(mResp));
    } catch (e) {
      throw e;
    }
  }
}
