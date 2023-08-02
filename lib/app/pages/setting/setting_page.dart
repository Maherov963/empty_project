import 'package:al_khalil/app/pages/setting/change_password.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../device/dependecy_injection.dart';
import '../../components/my_info_card_edit.dart';

// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  Group? group;
  SettingPage({super.key, this.group});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "الإعدادات",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).appBarTheme.foregroundColor),
              ),
              expandedTitleScale: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  //color: Colors.grey[800],
                ),
                child: Column(
                  children: [
                    MyInfoCardEdit(
                      child: Column(
                        children: [
                          RadioListTile(
                            selected:
                                context.watch<CoreProvider>().themeState ==
                                    ThemeState.dark,
                            value: ThemeState.dark,
                            groupValue:
                                context.watch<CoreProvider>().themeState,
                            onChanged: (p0) {
                              context.read<CoreProvider>().setTheme(p0!);
                            },
                            title: const Text("الوضع الليلي"),
                          ),
                          RadioListTile(
                            value: ThemeState.light,
                            groupValue:
                                context.watch<CoreProvider>().themeState,
                            onChanged: (p0) {
                              context.read<CoreProvider>().setTheme(p0!);
                            },
                            title: const Text("الوضع النهاري"),
                          ),
                          RadioListTile(
                            selected:
                                context.watch<CoreProvider>().themeState ==
                                    ThemeState.system,
                            value: ThemeState.system,
                            groupValue:
                                context.watch<CoreProvider>().themeState,
                            onChanged: (p0) {
                              context.read<CoreProvider>().setTheme(p0!);
                            },
                            title: const Text("وضع النظام"),
                          ),
                        ],
                      ),
                    ),
                    MyInfoCardEdit(
                      child: ListTile(
                        leading: const Icon(Icons.password),
                        title: const Text("تغيير كلمة المرور"),
                        trailing: const Icon(Icons.arrow_back_ios_new),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordPage(),
                              ));
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("رقم الإصدار"),
                        trailing: Text(packageInfo.version),
                        onTap: () {
                          AwesomeNotifications().createNotification(
                            schedule: NotificationAndroidCrontab.daily(
                                referenceDateTime: DateTime.now().copyWith(
                                    second: DateTime.now().second + 10)),
                            content: NotificationContent(
                              id: 1,
                              channelKey: 'general_channel',
                              title: 'برنامج الخليل',
                              body: "رقم الإصدار : ${packageInfo.version}",
                              wakeUpScreen: true,
                              // notificationLayout: NotificationLayout.BigPicture,
                              // largeIcon: "asset://assets/images/logo.png",
                              //icon: "resource://drawable/res_log",
                              // customSound:
                              //     "resource://audios/BBC Sherlock Theme Song",
                              // bigPicture: "asset://assets/images/logo.png",
                            ),
                          );
                        },
                      ),
                    ),
                    100.getHightSizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
