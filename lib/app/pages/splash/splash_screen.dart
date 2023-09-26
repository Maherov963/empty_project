// import 'package:al_khalil/app/components/my_snackbar.dart';
// import 'package:al_khalil/app/pages/auth/log_in.dart';
// import 'package:al_khalil/app/providers/core_provider.dart';
// import 'package:al_khalil/app/providers/states/provider_states.dart';
// import 'package:al_khalil/data/errors/failures.dart';
// import 'package:al_khalil/data/extensions/extension.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import '../../components/waiting_animation.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // FlutterNativeSplash.remove();
//     _initial(context);
//     return Scaffold(body: _getLoader());
//   }

//   _initial(BuildContext context) async {
//     if (!kIsWeb) {
//       await Permission.storage.request();
//       await Permission.camera.request();
//     }
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         // This is just a basic example. For real apps, you must show some
//         // friendly dialog box before call the request method.
//         // This is very important to not harm the user experience
//         //fuck the user experience
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//     if (context.mounted) {
//       var accountState = await context.read<CoreProvider>().initialState();
//       if (accountState is ErrorState && context.mounted) {
//         if (accountState.failure.message == const NotLogedInFailure().message ||
//             accountState.failure.message == "Credentials is not correct" ||
//             accountState.failure.message ==
//                 "The user name field is required.") {
//           MySnackBar.showMySnackBar(accountState.failure.message, context,
//               contentType: ContentType.failure, title: "حدث خطأ");
//           Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (context) => const LogIn(),
//               ),
//               (route) => false);
//         } else {
//           MySnackBar.showMySnackBar(accountState.failure.message, context,
//               contentType: ContentType.failure, title: "حدث خطأ");
//           context.goNamed(
//             "home",
//           );
//         }
//       } else if (accountState is PersonState && context.mounted) {
//         context.read<CoreProvider>().myAccount = accountState.person;
//         if (context.mounted) {
//           context.goNamed(
//             "home",
//           );
//         }
//       }
//     }
//   }

//   Widget _getLoader() => Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 "assets/images/logo.png",
//                 width: 300,
//                 height: 300,
//               ),
//               const Text(
//                 'خيركم من تعلم القراّن وعلمه',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//               50.getHightSizedBox(),
//               const MyWaitingAnimation(size: 75),
//               50.getHightSizedBox(),
//             ],
//           ),
//         ),
//       );
// }
