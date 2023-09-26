import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:audio_service/audio_service.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/models/messages/message.dart';
import '../../components/voice_message_bubble.dart';

class ChatProvider extends ChangeNotifier {
  bool isTextEmpty = true;
  String? playingId;
  int? replyId;
  int opacity = 500;
  Uint8List? curentArtwork;

  setreply(int id) {
    replyId = id;
    opacity = 500;
    notifyListeners();
    Timer.periodic(
      const Duration(milliseconds: 1),
      (timer) {
        if (opacity == 0) {
          timer.cancel();
          replyId = null;
          notifyListeners();
        } else {
          opacity = opacity - 1;
          notifyListeners();
        }
      },
    );
  }

  Stream<AudioPosition> get positionDataStream =>
      Rx.combineLatest4<Duration, Duration, Duration?, bool, AudioPosition>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        player.playingStream,
        (a, b, c, d) => AudioPosition(
          isPlaying: d,
          position: a,
          bufferedPosition: b,
          duration: c ?? Duration.zero,
        ),
      );
  AudioPlayer player = AudioPlayer();
  Future<Uri?> _copyAssetToLocal() async {
    try {
      var content = await rootBundle.load("assets/images/res_log.png");
      final directory = await getApplicationDocumentsDirectory();
      var file = File("${directory.path}/aud.png");
      file.writeAsBytesSync(content.buffer.asUint8List());
      return file.uri;
    } catch (e) {
      return null;
    }
  }

  playAudio(String path, {Uint8List? artwork, int? id}) async {
    String? link;
    if (artwork != null) {
      curentArtwork = artwork;
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${id}image.png').create();
      file.writeAsBytesSync(artwork);
      link = file.path;
    }
    playingId = path;
    final title = FileManager.basename(File(path), showFileExtension: false);
    await player.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.file(
            path,
            tag: MediaItem(
              album: "رسالة صوتية",
              id: id.toString(),
              title: title,
              artUri: link == null ? await _copyAssetToLocal() : Uri.file(link),
            ),
          ),
        ],
      ),
    );
    player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
        await player.stop();
      }
    });
    player.play();
    notifyListeners();
  }

  pauseAudio() {
    player.pause();
    notifyListeners();
  }

  resumrAudio() {
    player.play();
    notifyListeners();
  }

  List<Message> _messages = [];
  List<Message> get messages => _messages.reversed.toList();
  int get nextId {
    return messages.isEmpty ? 0 : (_messages.last.messageId ?? 0) + 1;
  }

  changeTextState(String text) {
    if (text.trim().isEmpty) {
      isTextEmpty = true;
    } else {
      isTextEmpty = false;
    }
    notifyListeners();
  }

  addMessage(Message message) async {
    isTextEmpty = true;
    _messages.add(message);
    await LocalDataSourceImpl.sharedPreferences.setStringList(
        "messages", _messages.map((e) => jsonEncode(e.toJson())).toList());
    notifyListeners();
  }

  deleteMessage(Message message) async {
    _messages.remove(message);
    await LocalDataSourceImpl.sharedPreferences.setStringList(
        "messages", _messages.map((e) => jsonEncode(e.toJson())).toList());
    notifyListeners();
  }

  deleteAllMessage() async {
    _messages = [];
    await LocalDataSourceImpl.sharedPreferences.setStringList("messages", []);
    notifyListeners();
  }

  getMessages() async {
    final jsonString =
        LocalDataSourceImpl.sharedPreferences.getStringList("messages");
    if (jsonString != null) {
      _messages =
          jsonString.map((e) => Message.fromJson(jsonDecode(e))).toList();
    }
  }
}
