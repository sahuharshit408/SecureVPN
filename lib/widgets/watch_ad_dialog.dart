import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const WatchAdDialog({super.key , required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Connect to VPN'),
      content: Text('Watch an Ad to connect to VPN.'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          textStyle: TextStyle(color: Colors.redAccent),
          child: Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          textStyle: TextStyle(color: Colors.blueAccent),
          child: Text('Watch Ad'),
          onPressed: () {
            Get.back();
            onComplete();
          },
        ),
      ],
    );
  }
}