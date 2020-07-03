import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

class NetworkCalls {
  Future<String> get(String rUrl) async {
    final response = await client.get(rUrl);

    checkAndThrowError(response);
    return response.body;
  }

  static void checkAndThrowError(Response rResp) {
    if (rResp.statusCode != HttpStatus.ok) {
      throw Exception(rResp.body);
    }
  }
}

final client = Client();
final networkCalls = NetworkCalls();
final RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
final Function mathFunc = (Match match) => '${match[1]},';

abstract class UrlConstants {
  static const String baseUrl = 'https://corona.lmao.ninja/v2';

  static const String globalInfo = '$baseUrl/all';
  static const String allCountries = '$baseUrl/countries';

  static const String jhucsse = 'https://disease.sh/v2/jhucsse';
  static const String jhucsseHistorical = 'https://disease.sh/v2/historical';
}
