import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/adminstrative_note_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/utils/themes/dark_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../device/dependecy_injection.dart';
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
  static const primeColor = Color.fromARGB(255, 0, 93, 74);

  // static const primeColor = Color.fromARGB(255, 17, 0, 255);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<CoreProvider>()
            ..getCashedAccount()
            ..getTheme()
            ..getLocale()
            ..getCashedAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<PersonProvider>(),
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
          create: (_) => sl<AdditionalPointsProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<AdminstrativeNoteProvider>(),
        ),
      ],
      builder: (_, __) {
        return Selector<CoreProvider, String?>(
          selector: (_, p1) => p1.local,
          shouldRebuild: (previous, next) => next != previous,
          builder: (__, local, _) => Selector<CoreProvider, String>(
            selector: (p0, p1) => p1.themeState,
            shouldRebuild: (previous, next) => next != previous,
            builder: (__, theme, _) {
              return MaterialApp(
                navigatorKey: MyApp.navigatorKey,
                debugShowCheckedModeBanner: false,
                themeAnimationCurve: Curves.ease,
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
                // locale: Locale(local ?? getLanguageCode(Platform.localeName)),
                locale: const Locale("ar"),
                title: 'الخليل',
                themeMode: ThemeMode.dark,
                // themeMode: theme == ThemeState.system
                //     ? ThemeMode.system
                //     : theme == ThemeState.dark
                //         ? ThemeMode.dark
                //         : ThemeMode.light,
                darkTheme: ThemeData.from(
                    colorScheme: ColorScheme.fromSeed(
                  seedColor: primeColor,
                  brightness: Brightness.dark,
                  tertiary: color8,
                  error: const Color.fromARGB(255, 240, 92, 108),
                )).copyWith(
                    textTheme: GoogleFonts.notoSansArabicTextTheme(
                        Typography.whiteCupertino),
                    primaryTextTheme: GoogleFonts.notoSansArabicTextTheme(
                        Typography.whiteCupertino),
                    progressIndicatorTheme: const ProgressIndicatorThemeData(
                      circularTrackColor: Colors.green,
                    ),
                    dividerTheme: const DividerThemeData(
                      endIndent: 10,
                      indent: 10,
                    )),
                theme: ThemeData.from(
                    colorScheme: ColorScheme.fromSeed(
                  seedColor: primeColor,
                  tertiary: color8,
                  error: const Color.fromARGB(255, 240, 92, 108),
                )).copyWith(
                    textTheme: GoogleFonts.notoSansArabicTextTheme(
                        Typography.blackCupertino),
                    primaryTextTheme: GoogleFonts.notoSansArabicTextTheme(
                        Typography.blackCupertino),
                    dividerTheme: const DividerThemeData(
                      endIndent: 10,
                      indent: 10,
                    )),
                builder: (_, child) {
                  ErrorWidget.builder = (FlutterErrorDetails errDetails) {
                    return CustomErrorWidget(errDetails: errDetails);
                  };
                  return child ?? const SizedBox.shrink();
                },
                scrollBehavior: AppScrollBehavior(),
                home: Builder(builder: (context) {
                  final myAccount = context.read<CoreProvider>().myAccount;
                  return myAccount == null ? const LogIn() : const HomePage();
                }),
              );
            },
          ),
        );
      },
    );
  }
}

String getLanguageCode(String localeString) {
  // Split the locale string into the language code and the country code.
  List<String> parts = localeString.split('_');

  // Return the language code.
  return parts[0];
}

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errDetails;
  const CustomErrorWidget({super.key, required this.errDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error!!"),
      ),
      body: SelectableText(errDetails.stack.toString()),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
