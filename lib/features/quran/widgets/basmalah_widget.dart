import 'package:flutter/material.dart';

import '../domain/models/quran.dart';

class BasmalahWidget extends StatelessWidget {
  const BasmalahWidget({
    super.key,
    required this.maxHieght,
    required this.isBaqarahBasmalah,
  });
  final double maxHieght;
  final bool isBaqarahBasmalah;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHieght,
      width: double.infinity,
      child: FittedBox(
        // fit: BoxFit.fill,
        child: Text(
          BasmalehLine.basmaleh,
          style: TextStyle(
            fontFamily: 'basmaleh',
            fontSize: 20,
            height: isBaqarahBasmalah ? 2.5 : 2,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
