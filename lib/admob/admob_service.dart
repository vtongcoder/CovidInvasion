import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

const testDevice = 'kGADSimulatorID';
const androidDevice = '001067C56319B2F506D165552870FDA7';
const danIphone = 'd6a9d96ab1f241ae98b4bf61eef93af7';
const phuongIphone = 'c699c5238efd2649d036a67e2928c4f16d6eba5d';

class AdMobService {
  String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5537872768809697~1477807125';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5537872768809697~6730133804';
    }

    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5537872768809697/6259430321';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5537872768809697/9028515154';
    }

    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5537872768809697/4371633580';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5537872768809697/7715433481';
    }
    return null;
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5537872768809697/4180061899';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5537872768809697/5089270143';
    }
    return null;
  }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showEventMessage('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showEventMessage('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showEventMessage('Admob $adType Ad closed!');
        // rewardAd.load();
        break;
      case AdmobAdEvent.failedToLoad:
        showEventMessage('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showEventMessage('Admob $adType rewarded');

        showEventMessage('Rewarded Amount: ${args['amount']}');
        // update();
        break;
      default:
        break;
    }
  }

  void showEventMessage(String content) {
    print('*** D/Admob: $content ***');
  }
}
