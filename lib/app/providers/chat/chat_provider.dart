import 'dart:convert';

import 'package:al_khalil/app/pages/chat/chat_room.dart';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool isTextEmpty = true;
  int lineCount = 1;
  List<Message> messages = [];
  changeTextState(String text, int count) {
    lineCount = count.clamp(1, 6);
    if (text.trim().isEmpty) {
      isTextEmpty = true;
    } else {
      isTextEmpty = false;
    }
    notifyListeners();
  }

  addMessage(Message message) async {
    lineCount = 1;
    isTextEmpty = true;
    messages.add(message);
    await LocalDataSourceImpl.sharedPreferences.setStringList(
        "messages", messages.map((e) => jsonEncode(e.toJson())).toList());
    notifyListeners();
  }

  deleteMessage(Message message) async {
    messages.remove(message);
    await LocalDataSourceImpl.sharedPreferences.setStringList(
        "messages", messages.map((e) => jsonEncode(e.toJson())).toList());
    notifyListeners();
  }

  getMessages() async {
    final jsonString =
        LocalDataSourceImpl.sharedPreferences.getStringList("messages");
    if (jsonString != null) {
      messages =
          jsonString.map((e) => Message.fromJson(jsonDecode(e))).toList();
    }
  }
}
