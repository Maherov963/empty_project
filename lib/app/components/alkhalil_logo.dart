import 'package:flutter/material.dart';

class AlkhalilLogo extends StatelessWidget {
  const AlkhalilLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        "assets/images/res_log.png",
        height: 40,
        width: 40,
      ),
    );
  }
}
