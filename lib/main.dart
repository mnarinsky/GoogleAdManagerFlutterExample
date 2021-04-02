// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'YOUR_DEVICE_ID';

// Your network code is a unique, numeric identifier for your Ad Manager network.
// Network code can be found under Admin > Global settings > Network settings.
String GAMNetworkCode = "/6499";

// The quickest way to enable testing is to use Google-provided test ad units. These ad units are not associated with
// your Ad Manager account, so there's no risk of your account generating invalid traffic when using these ad units.
// Here are sample ad units that point to specific test creatives for each format:
String bannerAdUnit = "/example/banner";
String interstitialAdUnit = "/example/interstitial";
String nativeAdUnit = "/example/native";
String rewardedVideoAdUnit = "/example/rewarded-video";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    /* If you want to do more rigorous testing with production-looking ads,
    you can now configure your device as a test device and use your own ad unit IDs
    that you've created in the Ad Manager UI.
    More info: https://developers.google.com/ad-manager/mobile-ads-sdk/android/test-ads#enable_test_devices */
    testDevices: testDevice != null ? <String>[testDevice] : null,

    /* Key-values let you define custom targeting. They are used in the targeting picker and included in ad tags.
    When an ad request comes in from one of your pages that has key-values in its ad tags,
    line items that target those key-values are eligible to serve for that ad request.

    More info: https://support.google.com/admanager/answer/188092 */
    keywords: <String>['foo', 'bar'],

    /* Content mapping for apps helps ensure better ad placement and improved
    brand safety for you and your advertisers. Content mapping enables contextual
    targeting, which delivers relevant ads to users based on the type of content they consume.
    More info: https://support.google.com/admanager/answer/6270563?hl=en */
    contentUrl: 'http://foo.com/bar.html',

    /* You can mark your ad requests to be treated as child-directed.
    The feature is designed to help facilitate compliance with the Children's Online Privacy Protection Act (COPPA)
    More info: https://support.google.com/admanager/answer/3671211?hl=en */
    childDirected: false,

    /* Tags an ad request as personalized or non-personalized.
    More info: https://support.google.com/admanager/answer/7678538 */
    nonPersonalizedAds: false,
  );

  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;
  BannerAd _inlineBannerAd;
  NativeAd _inlineNativeAd;
  int _coins = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: GAMNetworkCode + bannerAdUnit,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: GAMNetworkCode + interstitialAdUnit,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: GAMNetworkCode + nativeAdUnit,
      factoryId: 'adFactoryExample',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("$NativeAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();

    //initialize method can be skipped for GAM:
    //FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Ad Manager: Example App'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                    child: const Text('SHOW BANNER'),
                    onPressed: () {
                      _bannerAd ??= createBannerAd();
                      _bannerAd
                        ..load()
                        ..show();
                    }),
                RaisedButton(
                    child: const Text('SHOW BANNER WITH OFFSET'),
                    onPressed: () {
                      _bannerAd ??= createBannerAd();
                      _bannerAd
                        ..load()
                        ..show(horizontalCenterOffset: -50, anchorOffset: 100);
                    }),
                RaisedButton(
                    child: const Text('REMOVE BANNER'),
                    onPressed: () {
                      _bannerAd?.dispose();
                      _bannerAd = null;
                    }),
                RaisedButton(
                  child: const Text('SHOW INLINE BANNER'),
                  onPressed: Platform.isIOS
                      ? () {
                          //Currently displaying a [MobileAd] as a Flutter widget is only supported on iOS
                          setState(() {
                            _inlineBannerAd ??= createBannerAd();
                            _inlineBannerAd.load();
                          });
                        }
                      : null,
                ),
                Container(
                  alignment: Alignment.center,
                  child: _inlineBannerAd != null ? AdWidget(ad: _inlineBannerAd) : Container(),
                  width: _inlineBannerAd != null ? _inlineBannerAd.size.width.toDouble() : 0,
                  height: _inlineBannerAd != null ? _inlineBannerAd.size.height.toDouble() : 0,
                ),
                RaisedButton(
                  child: const Text('REMOVE INLINE BANNER'),
                  onPressed: Platform.isIOS
                      ? () {
                          _inlineBannerAd?.dispose();
                          setState(() {
                            _inlineBannerAd = null;
                          });
                        }
                      : null,
                ),
                RaisedButton(
                  child: const Text('LOAD INTERSTITIAL'),
                  onPressed: () {
                    _interstitialAd?.dispose();
                    _interstitialAd = createInterstitialAd()..load();
                  },
                ),
                RaisedButton(
                  child: const Text('SHOW INTERSTITIAL'),
                  onPressed: () {
                    _interstitialAd?.show();
                  },
                ),
                RaisedButton(
                  child: const Text('SHOW NATIVE'),
                  onPressed: () {
                    _nativeAd ??= createNativeAd();
                    _nativeAd
                      ..load()
                      ..show(
                        anchorType: Platform.isAndroid ? AnchorType.bottom : AnchorType.top,
                      );
                  },
                ),
                RaisedButton(
                  child: const Text('REMOVE NATIVE'),
                  onPressed: () {
                    _nativeAd?.dispose();
                    _nativeAd = null;
                  },
                ),
                RaisedButton(
                  child: const Text('SHOW INLINE NATIVE'),
                  onPressed: Platform.isIOS
                      ? () {
                          setState(() {
                            _inlineNativeAd ??= createNativeAd();
                            _inlineNativeAd.load();
                          });
                        }
                      : null,
                ),
                Container(
                  alignment: Alignment.center,
                  child: _inlineNativeAd != null ? AdWidget(ad: _inlineNativeAd) : Container(),
                  width: _inlineNativeAd != null ? 250 : 0,
                  height: _inlineNativeAd != null ? 350 : 0,
                ),
                RaisedButton(
                  child: const Text('REMOVE INLINE NATIVE'),
                  onPressed: Platform.isIOS
                      ? () {
                          _inlineNativeAd?.dispose();
                          setState(() {
                            _inlineNativeAd = null;
                          });
                        }
                      : null,
                ),
                RaisedButton(
                  child: const Text('LOAD REWARDED VIDEO'),
                  onPressed: () {
                    RewardedVideoAd.instance
                        .load(adUnitId: GAMNetworkCode + rewardedVideoAdUnit, targetingInfo: targetingInfo);
                  },
                ),
                RaisedButton(
                  child: const Text('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    RewardedVideoAd.instance.show();
                  },
                ),
                Text("You have $_coins coins."),
              ].map((Widget button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: button,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
