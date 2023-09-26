import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color color1 = const Color.fromARGB(255, 38, 115, 101);
// Color color2 = const Color.fromARGB(255, 242, 203, 5);
// Color color3 = const Color.fromARGB(255, 242, 159, 5);
// Color color4 = const Color.fromARGB(255, 242, 135, 5);
// Color color5 = const Color.fromARGB(255, 242, 48, 48);
// Color color6 = const Color.fromARGB(255, 9, 52, 44);
// Color lightColor = const Color.fromARGB(255, 132, 241, 221);
Color color1 = const Color.fromARGB(255, 18, 27, 34);
Color color2 = const Color.fromARGB(255, 0, 93, 74);
Color color3 = const Color.fromARGB(255, 18, 140, 126);
Color color4 = const Color.fromARGB(255, 30, 190, 165);
Color color5 = const Color.fromARGB(255, 119, 215, 200);
Color color6 = const Color.fromARGB(255, 208, 233, 234);
Color color7 = const Color.fromARGB(255, 237, 248, 245);
Color color8 = const Color.fromARGB(255, 52, 183, 241);
Color color9 = const Color.fromARGB(255, 30, 43, 51);
Color color10 = const Color.fromARGB(255, 240, 92, 108);
Color color11 = const Color.fromARGB(255, 133, 150, 160);
Color color12 = const Color.fromARGB(255, 253, 189, 53);

ThemeData myDarkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(color: color4),
  scaffoldBackgroundColor: color1,
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: color3,
      selectionHandleColor: color2,
      cursorColor: color4),
  sliderTheme: SliderThemeData(
    inactiveTrackColor: color11,
    activeTrackColor: color4,
    activeTickMarkColor: color4,
    thumbColor: color4,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(color7),
        overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.2))),
  ),
  primaryColor: color2,
  dialogBackgroundColor: color1,
  appBarTheme: AppBarTheme(backgroundColor: color9, foregroundColor: color11),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primaryContainer: color6,
    primary: color1,
    onPrimary: color11,
    secondary: color3,
    onSecondary: color4,
    error: color10,
    onError: color6,
    background: color6,
    onBackground: color7,
    surface: color1,
    tertiary: color8,
    onSurface: color6,
  ),
  cardColor: color9,
  // buttonTheme: ButtonThemeData(hoverColor: Colors.white),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(color2.withOpacity(0.6)),
      foregroundColor: MaterialStatePropertyAll(color6),
    ),
  ),
  navigationBarTheme:
      NavigationBarThemeData(indicatorColor: color1, backgroundColor: color9),
  textTheme: GoogleFonts.latoTextTheme(Typography.whiteCupertino),
  dividerTheme: DividerThemeData(
      color: color11, thickness: 0.5, endIndent: 10, indent: 10),
  primaryTextTheme: GoogleFonts.latoTextTheme(Typography.whiteCupertino),
  tabBarTheme: TabBarTheme(
    overlayColor: MaterialStatePropertyAll(color11.withOpacity(0.5)),
    // dividerColor: color3,
    labelColor: color7,
    indicatorColor: color4,
    unselectedLabelColor: color11,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color4, foregroundColor: color7),
);
