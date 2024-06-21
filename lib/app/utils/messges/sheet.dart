import 'package:al_khalil/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSheet {
  static Future<T?> showMyBottomSheet<T>(
    BuildContext context,
    Widget widget,
  ) async {
    return await showModalBottomSheet<T>(
      enableDrag: true,
      // isScrollControlled: true,
      showDragHandle: true,
      // useSafeArea: true,
      context: context,
      builder: (context) => Visibility(
        visible: !isWin && !kDebugMode,
        replacement: Scaffold(
          body: widget,
          backgroundColor: Colors.transparent,
        ),
        child: widget,
      ),
    );
  }
}
