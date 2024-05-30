import 'package:al_khalil/app/mosque_system.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' as foundation;

class CustomToast {
  static const String noPermissionError = "لاتملك الصلاحيات الكافية";

  static showToast(String content) {
    if (foundation.defaultTargetPlatform == TargetPlatform.windows ||
        foundation.kDebugMode) {
      ScaffoldMessenger.of(MyApp.navigatorKey.currentState!.context)
          .clearSnackBars();
      ScaffoldMessenger.of(MyApp.navigatorKey.currentState!.context)
          .showSnackBar(
        SnackBar(
          content: Text(content),
          action: SnackBarAction(
            label: "نسخ",
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content));
            },
          ),
        ),
      );
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  static handleError(Failure failure) {
    if (failure is UpdateFailure) {
      showToast("يرجى تحديث التطبيق");
      if (!isWin) {
        MyApp.navigatorKey.currentState?.context.myPush(
          MyHomePage(
            downloadItem: DownloadItem(
              name: 'الخليل ${failure.message}',
              url: 'https://alkhalil-mosque.com/${failure.message}.apk',
            ),
          ),
        );
      }
    } else {
      showToast(failure.message);
    }
  }
}
