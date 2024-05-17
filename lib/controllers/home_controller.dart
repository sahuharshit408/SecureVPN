import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/helpers/dialogs.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/widgets/watch_ad_dialog.dart';

import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;

  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() async {
    if(vpn.value.openVPNConfigDataBase64.isEmpty) {
      Dialogs.info(msg: 'Select a location by clicking \'Change Location\'');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {

      // log('\nBefore: ${vpn.value.openVPNConfigDataBase64}');

      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);

      final config = Utf8Decoder().convert(data);

      final vpnConfig = VpnConfig(country: vpn.value.countryLong, username: 'vpn', password: 'vpn', config: config);

      ///Start if stage is disconnected

      if(Config.hideAds){
        await VpnEngine.startVpn(vpnConfig);
        return;
      }

      Get.dialog(WatchAdDialog(onComplete: (){
        AdHelper.showRewardedAd(onComplete: () async {
          await VpnEngine.startVpn(vpnConfig);
        });
      }));
    } else {
      ///Stop if stage is "not" disconnected
      await VpnEngine.stopVpn();
    }
  }

  Color get getButtonColor {
    switch (vpnState.value){
      case VpnEngine.vpnDisconnected:
        return Colors.blue;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  String get getButtonText {
    switch (vpnState.value){
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';

      case VpnEngine.vpnConnected:
        return 'Connected';

      default:
        return 'Connecting...';
    }
  }
}