import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static Future<bool> showDeleteDialig(BuildContext context,
      {String? content}) async {
    return await showTowOptionDialog(
          context: context,
          content: content ?? "هل أنت متأكد من هذا الإجراء؟",
          agreeText: "نعم",
          refuseText: "لا",
          isDangerous: true,
        ) ??
        false;
  }

  static Future<bool> showYesNoDialog(
      BuildContext context, String content) async {
    return await showTowOptionDialog(
          context: context,
          content: content,
          agreeText: "نعم",
          refuseText: "لا",
        ) ??
        false;
  }

  static Future<bool?> showTowOptionDialog({
    required BuildContext context,
    String? title,
    bool isDangerous = false,
    required String content,
    required String agreeText,
    required String refuseText,
  }) async {
    final dialogBackground = Theme.of(context).dialogBackgroundColor;
    return await showDialog(
      context: context,
      barrierColor: dialogBackground.withOpacity(0.1),
      builder: (context) {
        return AlertDialog(
          elevation: 10,
          shadowColor: Theme.of(context).shadowColor,
          backgroundColor: dialogBackground,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: title == null ? null : Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            CustomTextButton(
              showBorder: false,
              text: refuseText,
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            CustomTextButton(
              showBorder: false,
              text: agreeText,
              color: isDangerous
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
