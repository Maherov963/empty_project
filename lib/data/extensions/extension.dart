import 'package:flutter/material.dart';

extension SizedBoxInt on int {
  SizedBox get getWidthSizedBox => SizedBox(
        width: toDouble(),
      );
  SizedBox get getHightSizedBox => SizedBox(
        height: toDouble(),
      );
  int getCeilToThousand() => (toInt() / 20).ceil() * 1000;
}

extension SearshFilter on String {
  String getSearshFilter() => replaceAll("أ", "ا")
      .replaceAll("ة", "ه")
      .replaceAll("إ", "ا")
      .replaceAll(" ", "")
      .toLowerCase();
}

extension MyDateTime on DateTime {
  String getYYYYMMDD() {
    String day = this.day > 9 ? "${this.day}" : "0${this.day}";
    String month = this.month > 9 ? "${this.month}" : "0${this.month}";
    String year = this.year.toString();
    return "$year-$month-$day";
  }
}

extension ListExtension on List {
  addOrDelete(Object object) {
    if (contains(object)) {
      remove(object);
    } else {
      add(object);
    }
  }
}
