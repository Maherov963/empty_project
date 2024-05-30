import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';

class MyInfoListButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? classs;
  final IdNameModel? idNameModel;
  final Color? color;
  const MyInfoListButton({
    super.key,
    this.onPressed,
    required this.idNameModel,
    this.classs,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            idNameModel == null
                ? Text(
                    "لا يوجد معلومات",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  )
                : TextButton(
                    onPressed: onPressed,
                    child: onPressed == null
                        ? const MyWaitingAnimation()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${idNameModel!.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              classs == null
                                  ? 0.getWidthSizedBox
                                  : Text(
                                      classs!,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                            ],
                          ),
                  )
          ]),
    );
  }
}
