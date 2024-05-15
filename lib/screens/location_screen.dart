import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';

import '../apis/apis.dart';
import '../main.dart';
import '../widgets/vpn_card.dart';

class LocationScreen  extends StatelessWidget {
  LocationScreen({super.key});
  final _controller = LocationController();

  @override
  Widget build(BuildContext context){

    if(_controller.vpnList.isEmpty)  _controller.getVpnData();

    return Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Text('VPN Locations(${_controller.vpnList.length})'),
          ),

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