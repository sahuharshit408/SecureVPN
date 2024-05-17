import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';

import '../main.dart';
import '../widgets/vpn_card.dart';

class LocationScreen  extends StatelessWidget {
  LocationScreen({super.key});
  final _controller = LocationController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context){

    if(_controller.vpnList.isEmpty)  _controller.getVpnData();

    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Text('VPN Locations(${_controller.vpnList.length})'),
          ),

          bottomNavigationBar:
              // Config.hideAds ? null :
              _adController.ad != null && _adController.adLoaded.isTrue
                  ? SafeArea(
                       child: SizedBox(
                           height: 85, child: AdWidget(ad: _adController.ad!)))
                  : null,

          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10 , right: 10),
              child: FloatingActionButton(
                  onPressed: () =>
                    _controller.getVpnData(),
                  child: Icon(CupertinoIcons.refresh)),
          ),

          body: _controller.isLoading.value
              ? _loadingWidget()
              : _controller.vpnList.isEmpty
              ? _noVPNFound()
              : _vpnData(),
        ),
    );
  }

  _vpnData() => ListView.builder(
    itemCount: _controller.vpnList.length,
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.only(
      top: mq.height * .015,
      bottom: mq.height * .1,
      left: mq.width * .02,
      right: mq.width * .02
    ),
    itemBuilder: (ctx , i) => VpnCard(vpn: _controller.vpnList[i])
  );

  _loadingWidget() => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Transform.translate(
      offset: Offset(0, -80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [LottieBuilder.asset('assets/lottie/Animation_Loading.json' , width: mq.width * 0.7,)],
      ),
    ),
  );

  _noVPNFound() => Center(
    child: Text(
      'No network Found!',
      style: TextStyle(
        fontSize: 18,
        color: Colors.black54,
        fontWeight: FontWeight.bold
      ),
    ),
  );
}