// import 'package:al_khalil/app/mosque_system.dart';
// import 'package:al_khalil/app/pages/person/person_profile.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// class Noti {
//   static init() async {
//     await AwesomeNotifications().initialize(
//         // set the icon to null if you want to use the default app icon
//         null,
//         [
//           NotificationChannel(
//             enableVibration: true,
//             channelGroupKey: 'basic_channel_group',
//             channelKey: 'general_channel',
//             channelName: 'General Notifications',
//             channelDescription: null,
//             defaultColor: Colors.transparent,
//             channelShowBadge: true,
//             importance: NotificationImportance.Max,
//           )
//         ],
//         // Channel groups are only visual and are not required
//         channelGroups: [
//           NotificationChannelGroup(
//             channelGroupKey: 'basic_channel_group',
//             channelGroupName: 'Notification Categeories',
//           ),
//         ],
//         debug: true);
//   }

//   // creatUniqueId(){
//   //   return DateTime.now().millisecondsSinceEpoch.remainder(other)
//   // }

//   /// Use this method to detect when a new notification or a schedule is created
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }

//   /// Use this method to detect every time that a new notification is displayed
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }

//   /// Use this method to detect if the user dismissed a notification
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // Your code goes here
//   }

//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // router.routerDelegate.navigatorKey.currentContext?.goNamed(
//     //   "profile",
//     //   pathParameters: {
//     //     "userID": receivedAction.id.toString(),
//     //   },
//     // );
//     MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
//       builder: (context) => PersonProfile(id: 1),
//     ));

//     // Your code goes here
//     // Navigate into pages, avoiding to open the notification details page over another details page already opened
//   }
// }
