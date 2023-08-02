import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color color1 = const Color.fromARGB(255, 18, 27, 34);
Color color2 = const Color.fromARGB(255, 7, 94, 84);
Color color3 = const Color.fromARGB(255, 18, 140, 126);
Color color4 = const Color.fromARGB(255, 30, 190, 165);
Color color5 = const Color.fromARGB(255, 119, 215, 200);
Color color6 = const Color.fromARGB(255, 208, 233, 234);
Color color7 = const Color.fromARGB(255, 238, 242, 241);
Color color8 = const Color.fromARGB(255, 52, 183, 241);
Color color9 = const Color.fromARGB(255, 30, 43, 51);
Color color10 = const Color.fromARGB(255, 240, 92, 108);
Color color11 = const Color.fromARGB(255, 97, 121, 133);
ThemeData myLightTheme = ThemeData.light(useMaterial3: true).copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(color: color4),
  scaffoldBackgroundColor: color7,
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: color3,
      selectionHandleColor: color2,
      cursorColor: color4),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(color1))),
  primaryColor: color4,
  dialogBackgroundColor: color6,
  appBarTheme: AppBarTheme(backgroundColor: color7, foregroundColor: color1),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primaryContainer: color6,
      primary: color4,
      onPrimary: color11,
      secondary: color3,
      onSecondary: color4,
      error: color10,
      onError: color9,
      background: color6,
      onBackground: color7,
      surface: color6,
      tertiary: color8,
      onSurface: color1),
  cardColor: color6,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(color5.withOpacity(0.6)),
      foregroundColor: MaterialStatePropertyAll(color3),
    ),
  ),
  navigationBarTheme:
      NavigationBarThemeData(indicatorColor: color6, backgroundColor: color7),
  primaryTextTheme: GoogleFonts.tajawalTextTheme(Typography.blackCupertino),
  textTheme: GoogleFonts.tajawalTextTheme(Typography.blackCupertino),
  dividerTheme: DividerThemeData(
      color: color11, thickness: 0.5, endIndent: 10, indent: 10),
  tabBarTheme: TabBarTheme(
    // dividerColor: color3,
    labelColor: color9,
    unselectedLabelColor: color11,
  ),
);
