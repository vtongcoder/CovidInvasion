import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityCheck extends ChangeNotifier {
  String _connectionStatus = 'Unknown';
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isInternetAvailable = false;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        _connectionStatus = 'Internet connection is available via wifi';
        isInternetAvailable = true;
        notifyListeners();
        break;
      case ConnectivityResult.mobile:
        _connectionStatus = 'Internet connection is available via mobile';
        isInternetAvailable = true;
        notifyListeners();
        break;
      case ConnectivityResult.none:
        _connectionStatus = 'None internet connection is available';
        isInternetAvailable = false;
        notifyListeners();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        isInternetAvailable = false;
        notifyListeners();
        break;
    }
    print('D/Connectivity: Connection status: $_connectionStatus');
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    print('*** Connectivity dispose');
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
