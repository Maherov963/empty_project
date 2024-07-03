import 'package:flutter/material.dart';

class CustomSheet {
  static Future<T?> showMyBottomSheet<T>(
      BuildContext context, Widget Function(ScrollController) builder) async {
    return await showModalBottomSheet<T>(
      enableDrag: true,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Scaffold(
          body: builder(controller),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
