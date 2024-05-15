import 'package:flutter/material.dart';
import 'package:vpn_basic_project/models/network_data.dart';

import '../main.dart';

class NetworkCard extends StatelessWidget {
  final NetworkData data;

  const NetworkCard({super.key , required this.data});

  @override
  Widget build(BuildContext context){

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {

        },
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        
          leading: Icon(data.icon.icon,
              color: data.icon.color,
              size: data.icon.size ?? 28),
        
          title: Text(data.title),
        
          subtitle: Text(data.subtitle),
        ),
      )
    );
  }
}