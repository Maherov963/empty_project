import 'package:flutter/material.dart';

class CustomSheet {
  static Future<T?> showMyBottomSheet<T>(
    BuildContext context,
    Widget widget,
  ) async {
    return await showModalBottomSheet<T>(
      // isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (context) => widget,
    );
  }
}
