import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  init(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        context.goNamed("homepage");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
