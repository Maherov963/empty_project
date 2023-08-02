import 'package:al_khalil/test/profile.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app/mosque_system.dart';
import 'device/dependecy_injection.dart';
import 'device/notifications/notifications.dart';
import 'test/home.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Noti.init();
  await initInjections();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyAppT extends StatefulWidget {
  const MyAppT({super.key});

  @override
  State<MyAppT> createState() => _MyAppTState();
}

class _MyAppTState extends State<MyAppT> {
  @override
  void initState() {
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
    return MaterialApp.router(
      theme: ThemeData.dark(useMaterial3: true),
      routerConfig: router,
      debugShowMaterialGrid: false,
      title: "test",
    );
  }
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      name: "home",
      builder: (_, state) {
        return HomePageT(
          key: state.pageKey,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: "userprofile/:userID",
          name: "profile",
          builder: (_, state) {
            return ProfilePage(
              key: state.pageKey,
              id: int.tryParse(state.pathParameters["userID"].toString()),
            );
          },
        ),
      ],
    ),
  ],
);
