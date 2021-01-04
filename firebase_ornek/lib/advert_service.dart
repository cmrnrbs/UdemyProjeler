import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_ornek/constraits.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  BannerAd bannerAd;

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo(
        keywords: <String>['flutterio', 'beautiful apps'],
        contentUrl: 'https://flutter.io',
        nonPersonalizedAds: true);
  }

  showBanner() {
    bannerAd = BannerAd(
      adUnitId: BANNER_AD_ID,
      size: AdSize.smartBanner,
      targetingInfo: _targetingInfo,
      listener: (event) {
        print("BannerAd event is $event");
      },
    );

    bannerAd
      ..load()
      ..show(anchorOffset: 0);
  }

  showInterstital() {
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: INTERSTITAL_AD_ID,
      targetingInfo: _targetingInfo,
      listener: (event) {
        print("Interstital event is $event");
      },
    );

    interstitialAd
      ..load()
      ..show();
  }
}
