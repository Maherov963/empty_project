import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'app/mosque_system.dart';
import 'device/dependecy_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    preloadArtwork: true,
  );
  await initInjections();
  runApp(const MyApp());
}
