import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/ads.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/screens/home.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_admob/firebase_admob.dart';

// Future<void> _initAdMob() {
//   return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // BannerAd _bannerAd;
  // InterstitialAd _interstitialAd;

  // BannerAd createBannerAd() {
  //   return BannerAd(
  //     adUnitId: AdManager.bannerAdUnitId,
  //     size: AdSize.banner,
  //     listener: (MobileAdEvent event) {
  //       print("BannerAd event $event");
  //     },
  //   );
  // }

  // InterstitialAd createInterstitialAd() {
  //   return InterstitialAd(
  //     adUnitId: AdManager.interstitialAdUnitId,
  //     listener: (MobileAdEvent event) {
  //       print("InterstitialAd event $event");
  //     },
  //   );
  // }

  @override
  void initState() {
    // super.initState();
    // _initAdMob();
    // _bannerAd = createBannerAd()
    //   ..load()
    //   ..show(anchorType: AnchorType.bottom);
    // _interstitialAd = createInterstitialAd()..load();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    // _interstitialAd?.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        accentColor: secondaryColor,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
