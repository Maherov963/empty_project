import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.text,
      this.color = Colors.purple,
      required this.onPressed});
  final MaterialColor color;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            gradient: LinearGradient(colors: [
              color[100]!,
              color[900]!,
            ]),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                color: color[100]!,
                blurRadius: 16.0,
              ),
              BoxShadow(
                offset: const Offset(0, 0),
                color: color[300]!,
                blurRadius: 16.0,
              ),
            ]),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              backgroundColor:
                  const MaterialStatePropertyAll(Colors.transparent),
              shadowColor: const MaterialStatePropertyAll(Colors.transparent)),
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.0)),
        ));
  }
}
