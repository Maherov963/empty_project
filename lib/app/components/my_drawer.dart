import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:al_khalil/app/pages/auth/log_in.dart';
import 'package:al_khalil/app/pages/person/person_profile.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/remote_db/links.dart';
import '../pages/chat/chat_room.dart';
import '../components/my_snackbar.dart';
import '../pages/home/home_page.dart';
import '../pages/setting/setting_page.dart';
import '../pages/timer/timer_page.dart';
import '../providers/core_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  double? containerHight = 0;
  late double w;

  @override
  Widget build(BuildContext context) {
    Person? myAccount = context.read<CoreProvider>().myAccount;
    w = MediaQuery.of(context).size.width * 0.7;
    var imageLink = "$imagesfolder${myAccount?.imageLink}";
    return Drawer(
      width: w,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: false,
              children: [
                UserAccountsDrawerHeader(
                  onDetailsPressed: () {
                    setState(() {
                      containerHight == 0
                          ? containerHight =
                              (context.read<CoreProvider>().myAccounts.length +
                                      1) *
                                  60
                          : containerHight = 0;
                    });
                  },
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  accountName: Text("${myAccount?.getFullName()}"),
                  accountEmail: Text("${myAccount?.userName}"),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonProfile(
                                id: myAccount!.id, person: myAccount),
                          ));
                    },
                    child: Hero(
                      tag: 0,
                      child: ClipOval(
                        child: SizedBox.square(
                          dimension: 100,
                          child: imageLink.endsWith("DEFAULT.jpg")
                              ? Image.asset("assets/images/profile.png")
                              : Image.network(
                                  imageLink,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset("assets/images/profile.png"),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                    height: containerHight,
                    duration: const Duration(milliseconds: 100),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: context
                          .watch<CoreProvider>()
                          .myAccounts
                          .map<Widget>(
                            (e) => ListTile(
                              title: Text(
                                e.userName!,
                              ),
                              trailing: context
                                          .watch<CoreProvider>()
                                          .isLoggingIn ==
                                      e.id
                                  ? const MyWaitingAnimation()
                                  : e.id == myAccount?.id
                                      ? Icon(
                                          Icons.done,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.noHeader,
                                              animType: AnimType.rightSlide,
                                              btnOkText: "نعم",
                                              dialogBackgroundColor:
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                              btnCancelText: "لا",
                                              btnOkColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              btnCancelColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              title: 'الخليل',
                                              desc:
                                                  'هل تود تسجيل الخروج من حساب ${e.userName}؟',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await context
                                                    .read<CoreProvider>()
                                                    .removeAccount(e);
                                              },
                                            ).show();
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                              onTap: context
                                          .watch<CoreProvider>()
                                          .isLoggingIn ==
                                      e.id
                                  ? null
                                  : () async {
                                      if (e.id == myAccount?.id) {
                                        Navigator.pop(context);
                                      } else {
                                        ProviderStates logInState =
                                            await context
                                                .read<CoreProvider>()
                                                .logIn(
                                                  User(
                                                      id: e.id,
                                                      passWord: e.password,
                                                      userName: e.userName),
                                                );
                                        if (logInState is PersonState &&
                                            context.mounted) {
                                          context
                                              .read<CoreProvider>()
                                              .myAccount = logInState.person;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const HomePage(),
                                                  ),
                                                  (route) => false);
                                        } else if (logInState is ErrorState &&
                                            context.mounted) {
                                          MySnackBar.showMySnackBar(
                                              logInState.failure.message,
                                              context,
                                              contentType: ContentType.failure,
                                              title: "حدث خطأ");
                                        }
                                      }
                                    },
                            ),
                          )
                          .toList()
                        ..add(ListTile(
                          title: const Text("إضافة حساب جديد"),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogIn(),
                              ),
                            );
                          },
                        ))
                        ..add(const Divider()),
                    )),
                ListTile(
                  title: const Text('إعدادات'),
                  trailing: const Icon(
                    Icons.settings,
                  ),
                  subtitle: const Text(
                    'تغيير الإعدادات',
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingPage(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text('المؤقت'),
                  trailing: const Icon(
                    Icons.timer,
                  ),
                  subtitle: const Text('بدء العداد التنازلي'),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TimerPage(),
                        )).then((value) {
                      if (Provider.of<TimerProvider>(context, listen: false)
                          .isWork) {
                        context.read<TimerProvider>().showOverLay(context);
                      }
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: const Text('ملاحظاتي'),
                  trailing: const Icon(
                    Icons.note_alt_outlined,
                  ),
                  // subtitle: const Text(
                  //   'ا',
                  // ),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatRoomScreen(),
                        ));
                  },
                ),
              ],
            ),
          ),
          // ListTile(
          //   title: const Text('المزيد'),
          //   trailing: const Icon(
          //     Icons.info_outline,
          //   ),
          //   subtitle: const Text('حول التطبيق'),
          //   onTap: () async {
          //     String appName = packageInfo.appName;
          //     String version = packageInfo.version;
          //     AwesomeDialog(
          //       dialogType: DialogType.noHeader,
          //       animType: AnimType.bottomSlide,
          //       context: context,
          //       title: appName,
          //       btnOkColor: Theme.of(context).colorScheme.secondary,
          //       dialogBackgroundColor:
          //           Theme.of(context).scaffoldBackgroundColor,
          //       desc: "الإصدار : $version",
          //       btnOkOnPress: () async {
          //         // Navigator.pop(context);
          //       },
          //       // btnCancel: null,
          //     ).show();
          //     // showAboutDialog(
          //     //     context: context,
          //     //     applicationIcon: FlutterLogo(),
          //     //     applicationName: appName,
          //     //     applicationVersion: version,
          //     //     children: [
          //     //       Text(
          //     //           "قُلْ بِفَضْلِ اللَّهِ وَبِرَحْمَتِهِ فَبِذَٰلِكَ فَلْيَفْرَحُوا هُوَ خَيْرٌ مِّمَّا يَجْمَعُونَ")
          //     //     ],
          //     //     useRootNavigator: false);
          //   },
          // ),

          ListTile(
            title: const Text('sign out'),
            trailing: const Icon(
              Icons.logout,
            ),
            subtitle: const Text('تسجيل الخروج'),
            onTap: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                animType: AnimType.rightSlide,
                btnOkText: "نعم",
                dialogBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                btnCancelText: "لا",
                btnOkColor: Theme.of(context).colorScheme.error,
                btnCancelColor: Theme.of(context).colorScheme.secondary,
                title: 'الخليل',
                desc: 'هل تود تسجيل الخروج؟',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  Navigator.pop(context);
                  var state = await context.read<CoreProvider>().signOut();
                  if (state is MessageState && context.mounted) {
                    MySnackBar.showMySnackBar(state.message, context,
                        contentType: ContentType.success, title: "الخليل");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LogIn(),
                        ),
                        (route) => false);
                  }
                },
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
