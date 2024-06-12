import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    // final dialogBackground = Theme.of(context).dialogBackgroundColor;
    return await showCupertinoDialog(
      context: context, barrierDismissible: true,
      // barrierColor: dialogBackground.withOpacity(0.1),
      builder: (context) {
        return CupertinoAlertDialog(
          // elevation: 10,
          // shadowColor: Theme.of(context).shadowColor,
          // backgroundColor: dialogBackground,
          // actionsPadding:
          //     const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: title == null ? null : Text(title),
          content: Text(content),
          // actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            CupertinoButton(
              child: Text(refuseText),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            // CustomTextButton(
            //   showBorder: false,
            //   text: refuseText,
            //   color: Colors.grey,
            //   onPressed: () {
            //     Navigator.pop(context, false);
            //   },
            // ),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                agreeText,
                style: TextStyle(
                  color: isDangerous
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // CustomTextButton(
            //   showBorder: false,
            //   text: agreeText,
            //   color: isDangerous
            //       ? Colors.red
            //       : Theme.of(context).colorScheme.primary,
            //   onPressed: () {
            //     Navigator.pop(context, true);
            //   },
            // ),
          ],
        );
      },
    );
  }

  static Future<bool?> showFieldDialog({
    required BuildContext context,
    required String label,
    String? title,
    String? initial,
    required Function(String) onSave,
  }) async {
    final dialogBackground = Theme.of(context).dialogBackgroundColor;
    TextEditingController controller = TextEditingController(text: initial);
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: dialogBackground.withOpacity(0.1),
      builder: (context) {
        return CupertinoAlertDialog(
          // elevation: 10,
          // shadowColor: Theme.of(context).shadowColor,
          // backgroundColor: dialogBackground,
          // actionsPadding:
          //     const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // actionsAlignment: MainAxisAlignment.spaceAround,

          title: title == null ? null : Text(title),
          content: Material(
            child: MyTextFormField(
              labelText: label,
              maximum: 2560,
              textEditingController: controller,
            ),
          ),
          actions: [
            CupertinoButton(
              child: const Text("حفظ"),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                onSave.call(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}
