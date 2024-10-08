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
    BuildContext context,
    String content,
  ) async {
    return await showTowOptionDialog(
          context: context,
          content: content,
          agreeText: "نعم",
          refuseText: "لا",
        ) ??
        false;
  }

  static Future<T?> showDialoug<T>(
      BuildContext context, Widget widget, String title) async {
    return await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(title: Text(title), content: widget),
    );
  }

  static Future<bool?> showTowOptionDialog({
    required BuildContext context,
    String? title,
    bool isDangerous = false,
    required String content,
    required String agreeText,
    required String refuseText,
  }) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title == null ? null : Text(title),
          content: Text(content),
          actions: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                refuseText,
                style: TextStyle(color: Theme.of(context).indicatorColor),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                agreeText,
                style: TextStyle(color: isDangerous ? Colors.red : null),
              ),
            ),
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
    TextEditingController controller = TextEditingController(text: initial);
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: title == null ? null : Text(title),
          content: MyTextFormField(
            labelText: label,
            maximum: 2560,
            textEditingController: controller,
          ),
          actions: [
            CustomTextButton(
              text: "حفظ",
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
