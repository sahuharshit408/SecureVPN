import 'package:flutter/material.dart';

import '../main.dart';

class HomeCard extends StatelessWidget {
  final String title , subTitle;
  final Widget icon;

  const HomeCard(
      {super.key,
        required this.title,
        required this.subTitle,
        required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width * .45,
      child: Column(children: [
        icon,
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subTitle,
          style: TextStyle(
              color: Theme.of(context).lightText,
              fontSize: 12,
              fontWeight: FontWeight.w500
          ),
        ),
      ],
      ),
    );
  }
}