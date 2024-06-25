import 'package:flutter/material.dart';
import 'features/quran/domain/provider/quran_provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'device/dependecy_injection.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'app/mosque_system.dart';
import 'dart:io';

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

late QuranProvider quranProvider;

final bool isWin = foundation.defaultTargetPlatform != TargetPlatform.android;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  quranProvider = QuranProvider();
  HttpOverrides.global = MyHttpOverride();

  if (!isWin && !foundation.kIsWeb) {
    await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  }

  await quranProvider.init();
  await initInjections();
  runApp(const MyApp());
}
