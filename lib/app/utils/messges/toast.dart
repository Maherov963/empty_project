import 'package:al_khalil/app/mosque_system.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/features/downloads/pages/home_downloads.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' as foundation;

class CustomToast {
  static const String noPermissionError = "لاتملك الصلاحيات الكافية";
  static const String succesfulMessage = "تمت العملية بنجاح";
  static const String copySuccsed = "تم النسخ إلى الحافظة!";

  static showToast(String content) {
    if (foundation.defaultTargetPlatform == TargetPlatform.windows ||
        foundation.kDebugMode) {
      ScaffoldMessenger.of(MyApp.navigatorKey.currentState!.context)
          .clearSnackBars();
      ScaffoldMessenger.of(MyApp.navigatorKey.currentState!.context)
          .showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(child: Text(content)),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(MyApp.navigatorKey.currentState!.context)
                      .clearSnackBars();
                  Clipboard.setData(ClipboardData(text: content));
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.black,
                ),
              )
            ],
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
          HomeDownloads(
            downloadItem: DownloadItem(
              name: '${failure.message}.apk',
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
