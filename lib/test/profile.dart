import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.id});
  final int? id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text:
                        "https://maherovisme.000webhostapp.com/userprofile/$id"));
              },
              icon: const Icon(Icons.copy)),
        ],
        title: Text("user $id"),
      ),
      body: Column(children: [
        TextButton(
            onPressed: () {
              AwesomeNotifications().createNotification(
                actionButtons: [
                  NotificationActionButton(
                    key: "reply",
                    label: "رد",
                    requireInputText: true,
                    color: Colors.red,
                    isDangerousOption: true,
                  )
                ],
                content: NotificationContent(
                  id: id ?? 0,
                  channelKey: 'general_channel',
                  title: 'برنامج الخليل',
                  body: "https://maherovisme.000webhostapp.com/userprofile/$id",
                  wakeUpScreen: true,
                  summary: "adel",
                  notificationLayout: NotificationLayout.Messaging,
                  category: NotificationCategory.Message,
                  // hideLargeIconOnExpand: true,
                  // roundedLargeIcon: true,
                  // largeIcon: "asset://assets/images/logo.png",
                  // bigPicture: "asset://assets/images/logo.png",
                ),
              );
            },
            child:
                Text("https://maherovisme.000webhostapp.com/userprofile/$id"))
      ]),
    );
  }
}
