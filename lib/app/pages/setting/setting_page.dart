import 'package:al_khalil/app/pages/person/person_profile.dart';
import 'package:al_khalil/app/pages/setting/change_password.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/device/dependecy_injection.dart';
import 'package:al_khalil/features/downloads/pages/home_downloads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_page.dart';
import 'theme_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final person = context.read<CoreProvider>().myAccount;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "الإعدادات",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              expandedTitleScale: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "ملف شخصي",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: getListTitle("اسم المستخدم"),
                      subtitle: getSubTitle(person?.userName),
                      leading: const Icon(Icons.account_circle),
                      onTap: () {
                        context.myPush(
                          PersonProfile(
                            person: context.read<CoreProvider>().myAccount,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("تغيير كلمة المرور"),
                      subtitle: getSubTitle("********"),
                      leading: const Icon(Icons.password),
                      onTap: () {
                        context.myPush(ChangePasswordPage());
                      },
                    ),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "إعدادات متقدمة",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: getListTitle("المظهر"),
                      leading: const Icon(Icons.dark_mode),
                      onTap: () {
                        context.myPush(const ThemePage());
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("اللغة"),
                      leading: const Icon(Icons.language),
                      onTap: () {
                        context.myPush(const LanguagePage());
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("الإشعارات"),
                      leading: const Icon(Icons.notifications_active),
                      onTap: () {
                        // AwesomeNotifications().showNotificationConfigPage();
                      },
                    ),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "حول",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: getListTitle("إصدار التطبيق"),
                      subtitle: getSubTitle(packageInfo.version),
                      leading: const Icon(Icons.verified_sharp),
                      onTap: () {
                        context.myPush(const HomeDownloads());
                        // context.myPush(const MyHomePage(
                        //   downloadItem: DownloadItem(
                        //       name: "test.apk",
                        //       url: 'https://alkhalil-mosque.com/test.apk'),
                        // ));
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("رقم النسخة"),
                      subtitle: getSubTitle(packageInfo.buildNumber),
                      leading: const Icon(Icons.apps_sharp),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDivider() => const Divider(
        // color: color9,
        thickness: 10,
        endIndent: 0,
        indent: 0,
      );
}

Widget getListTitle(String title) => Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
      ),
    );
Widget getSubTitle(String? title) => Text(
      title ?? "",
      style: const TextStyle(
        fontSize: 12,
      ),
    );
