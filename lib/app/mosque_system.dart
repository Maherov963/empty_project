import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/timer_provider.dart';
import 'package:al_khalil/app/utils/themes/dark_theme.dart';
import 'package:al_khalil/app/utils/themes/light_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../device/dependecy_injection.dart';
import '../device/notifications/notifications.dart';
import '../domain/models/management/person.dart';
import 'pages/auth/log_in.dart';
import 'pages/home/home_page.dart';
import 'providers/managing/person_provider.dart';
import 'utils/locale/locale.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: Noti.onActionReceivedMethod,
      onNotificationCreatedMethod: Noti.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: Noti.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: Noti.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<CoreProvider>()
            ..getCashedAccount()
            ..getTheme()
            ..getCashedAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<PersonProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<TimerProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<GroupProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MemorizationProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<AttendenceProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<ChatProvider>()..getMessages(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<AdditionalPointsProvider>(),
        ),
      ],
      builder: (_, __) {
        return Selector<CoreProvider, String>(
          selector: (_, p1) => p1.themeState,
          shouldRebuild: (previous, next) => next != previous,
          builder: (__, value, _) {
            return MaterialApp(
              navigatorKey: MyApp.navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocale.delegate,
              ],
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              locale: const Locale("ar"),
              title: 'الخليل',
              themeMode: value == ThemeState.system
                  ? ThemeMode.system
                  : value == ThemeState.dark
                      ? ThemeMode.dark
                      : ThemeMode.light,
              darkTheme: myDarkTheme,
              theme: myLightTheme,
              home: Selector<CoreProvider, Person?>(
                builder: (__, value, _) =>
                    value == null ? const LogIn() : const HomePage(),
                selector: (p0, p1) => p1.myAccount,
              ),
            );
          },
        );
      },
    );
  }
}
