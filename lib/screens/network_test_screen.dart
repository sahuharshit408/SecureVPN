import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

import '../main.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(title: Text('Network Details')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10 , right: 10),
        child: FloatingActionButton(
            onPressed: () {
              ipData.value = IPDetails.fromJson({});
              APIs.getIPDetails(ipData: ipData);
            },
            child: Icon(CupertinoIcons.refresh)),
      ),

      body: Obx(
          () => ListView(physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: mq.width * .04,
              right: mq.width * .04,
              top: mq.height * .01,
              bottom: mq.height * .1
            ),
            children: [
              NetworkCard(
                data: NetworkData(
                    title: 'IP Address',
                    subtitle: ipData.value.query,
                    icon: Icon(Icons.perm_device_info_sharp , color: Colors.blue)
                ),
              ),
        
              NetworkCard(
                data: NetworkData(
                    title: 'Internet Provider',
                    subtitle: ipData.value.isp,
                    icon: Icon(Icons.cell_tower_sharp , color: Colors.orange)
                ),
              ),
        
              NetworkCard(
                data: NetworkData(
                    title: 'Location',
                    subtitle: ipData.value.country.isEmpty
                        ? 'Fetching...'
                        : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                    icon: Icon(CupertinoIcons.location_solid , color: Colors.red)
                ),
              ),
        
              NetworkCard(
                data: NetworkData(
                    title: 'Pin-code',
                    subtitle: ipData.value.zip,
                    icon: Icon(CupertinoIcons.location_solid , color: Colors.cyan)
                ),
              ),
        
              NetworkCard(
                data: NetworkData(
                    title: 'Time Zone',
                    subtitle: ipData.value.timezone,
                    icon: Icon(Icons.access_time_sharp , color: Colors.green)
                ),
              ),
        
        
            ]
        ),
      ),
    );
  }
}