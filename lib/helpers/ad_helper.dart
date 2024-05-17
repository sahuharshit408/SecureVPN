import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/helpers/dialogs.dart';

import '../controllers/native_ad_controller.dart';

class AdHelper {
   static Future<void> initAds() async {
    // TODO: Initialize Google Mobile Ads SDK
    await MobileAds.instance.initialize();
  }

   static InterstitialAd? _interstitialAd;
   static bool _interstitialAdLoaded = false;

   static NativeAd? _nativeAd;
   static bool _nativeAdLoaded = false;

   static void precacheInterstitialAd() {

     if(Config.hideAds){
       return;
     }

     log('Interstitial Ad: ${Config.interstitialAd}');

     InterstitialAd.load(
       adUnitId: Config.interstitialAd,
       request: AdRequest(),
       adLoadCallback: InterstitialAdLoadCallback(
         onAdLoaded: (ad) {
           ad.fullScreenContentCallback = FullScreenContentCallback(
               onAdDismissedFullScreenContent: (ad) {
                 _resetInterstitialAd();
                 precacheInterstitialAd();
               }
           );
           _interstitialAd = ad;
           _interstitialAdLoaded = true;
         },
         onAdFailedToLoad: (err) {
           _resetInterstitialAd();
           log('Failed to load an interstitial ad: ${err.message}');
         },
       ),
     );
   }

   static void _resetInterstitialAd(){
     _interstitialAd?.dispose();
     _interstitialAd = null;
     _interstitialAdLoaded = false;
   }

   static void showInterstitialAd({required VoidCallback onComplete}) {

     if(Config.hideAds){
       onComplete();
       return;
     }

     if(_interstitialAdLoaded && _interstitialAd != null){
       _interstitialAd?.show();
       onComplete();
       return;
     }

     Dialogs.showProgress();

     log('Interstitial Ad: ${Config.interstitialAd}');

     InterstitialAd.load(
       adUnitId: Config.interstitialAd,
       request: AdRequest(),
       adLoadCallback: InterstitialAdLoadCallback(
         onAdLoaded: (ad) {
           ad.fullScreenContentCallback = FullScreenContentCallback(
             onAdDismissedFullScreenContent: (ad) {
               onComplete();
               _resetInterstitialAd();
               precacheInterstitialAd();
             }
           );
           Get.back();
           ad.show();
         },
         onAdFailedToLoad: (err) {
           Get.back();
           log('Failed to load an interstitial ad: ${err.message}');
           onComplete();
         },
       ),
     );
   }

   /// Loads a native ad.

   static void precacheNativeAd() {

     if(Config.hideAds) return null;


     log('Native Ad: ${Config.nativeAd}');
     _nativeAd =  NativeAd(
         adUnitId: Config.nativeAd,
         listener: NativeAdListener(
           onAdLoaded: (ad) {
             log('$NativeAd loaded.');
             _nativeAdLoaded = true;
           },
           onAdFailedToLoad: (ad, error) {
             _resetNativeAd();
             log('$NativeAd failed to load: $error');
           },
         ),
         request: const AdRequest(),
         // Styling
         nativeTemplateStyle: NativeTemplateStyle(
           templateType: TemplateType.small,
         ))
       ..load();
   }

   static void _resetNativeAd(){
     _nativeAd?.dispose();
     _nativeAd = null;
     _nativeAdLoaded = false;
   }

   static NativeAd? loadNativeAd({required NativeAdController adController}) {

     if(Config.hideAds){
       return null;
     }

     if(_nativeAdLoaded && _nativeAd != null) {
       adController.adLoaded.value = true;
       return _nativeAd;
     }

       log('Native Ad: ${Config.nativeAd}');
       return NativeAd(
           adUnitId: Config.nativeAd,
           listener: NativeAdListener(
             onAdLoaded: (ad) {
               log('$NativeAd loaded.');
               adController.adLoaded.value = true;
               _resetNativeAd();
               precacheNativeAd();
             },
             onAdFailedToLoad: (ad, error) {
               _resetNativeAd();
               log('$NativeAd failed to load: $error');
             },
           ),
           request: const AdRequest(),
           // Styling
           nativeTemplateStyle: NativeTemplateStyle(
             templateType: TemplateType.small,
           ))
         ..load();
     }

   static void showRewardedAd({required VoidCallback onComplete}) {

     log('Rewarded Ad: ${Config.rewardedAd}');

     if(Config.hideAds){
       onComplete();
       return;
     }

     Dialogs.showProgress();

     RewardedAd.load(
       adUnitId: Config.rewardedAd,
       request: AdRequest(),
       rewardedAdLoadCallback: RewardedAdLoadCallback(
         onAdLoaded: (ad) {

           Get.back();
           ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
             // Reward the user for watching an ad.
             onComplete();
           });
         },
         onAdFailedToLoad: (err) {
           Get.back();
           log('Failed to load an Rewarded ad: ${err.message}');
           onComplete();
         },
       ),
     );
   }
}