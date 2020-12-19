import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  Future<bool> initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("AdMob - BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: (MobileAdEvent event) {
        print("AdMob - InterstitialAd event $event");
      },
    );
  }

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2191548178499350~1691212816";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>"; // no account
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2191548178499350/5239575586";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>"; // no account
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2191548178499350/8973778799";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>"; // no account
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
