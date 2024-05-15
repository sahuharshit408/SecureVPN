import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';

import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      appBar: AppBar(
          leading : Icon(
              CupertinoIcons.home
          ),
          title: Text('Secure VPN'),
        actions: [
          IconButton(onPressed: () {
            Get.changeThemeMode(
              Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            Pref.isDarkMode = !Pref.isDarkMode;
          },
                icon: Icon(
                  Icons.brightness_medium,
                  size: 26,
                )
          ),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () => Get.to(() => NetworkTestScreen()),
              icon: Icon(
                CupertinoIcons.info,
                size: 27,
              )
          )
        ],
      ),
      bottomNavigationBar: _changeLocation(context),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => _vpnButton()),

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                HomeCard(
                    title: _controller.vpn.value.countryLong.isEmpty
                        ? 'Country'
                        : _controller.vpn.value.countryLong,
                    subTitle: 'FREE',
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: _controller.vpn.value.countryLong.isEmpty
                          ? Icon(Icons.vpn_lock_rounded , size: 30 , color: Colors.white)
                          : null,
                      backgroundImage: _controller.vpn.value.countryLong.isEmpty
                          ? null
                          : AssetImage('assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                    ),
                ),
                HomeCard(
                  title:  _controller.vpn.value.countryLong.isEmpty
                      ? '100ms'
                      : '${_controller.vpn.value.ping} ms',
                  subTitle: 'PING',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.speed_rounded ,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              ),
            ),


            StreamBuilder<VpnStatus?>(
              initialData: VpnStatus(),
              stream: VpnEngine.vpnStatusSnapshot(),
              builder: (context, snapshot) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeCard(
                        title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                        subTitle: 'DOWNLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightGreen,
                          child: Icon(Icons.cloud_download_outlined , size: 30),
                        ),
                      ),
                      HomeCard(
                        title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                        subTitle: 'UPLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.upload_outlined ,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
            ),



          ]),
    );
  }



  Widget _vpnButton() => Column(
    children: [
      Semantics(
      button: true,
      child: InkWell(
        onTap: () {
          _controller.connectToVpn();
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              shape: BoxShape.circle ,
              color: _controller.getButtonColor.withOpacity(.1)
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.circle ,
                color: _controller.getButtonColor.withOpacity(.3)
            ),
            child: Container(
              width: mq.height * .14,
              height: mq.height * .14,
              decoration: BoxDecoration(
                  shape: BoxShape.circle ,
                  color: _controller.getButtonColor
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4),
                  Text(
                    _controller.getButtonText,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
      Container(
        margin: EdgeInsets.only(top: mq.height * .015 , bottom: mq.height * .02),
        padding: EdgeInsets.symmetric(vertical: 6 , horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(
          _controller.vpnState.value == VpnEngine.vpnDisconnected
              ? 'Not Connected'
              : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white,
          ),
        ),
      ),
      Obx(() => CountDownTimer(startTimer: _controller.vpnState.value == VpnEngine.vpnConnected)),
    ],
  );

  Widget _changeLocation(BuildContext context) => SafeArea(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => Get.to(() => LocationScreen()),
          child: Container(
              color: Theme.of(context).bottomNav,
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              height: 60,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Change Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue,
                      size: 26
                    ),
                  )
                ],
              )
          ),
        ),
      )
  );
}

