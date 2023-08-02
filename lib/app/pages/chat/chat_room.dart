import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/chat_input_area.dart';
import '../../components/message_box.dart';
import '../../components/user_profile_appbar.dart';
import '../../components/waiting_animation.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          onTap: () async {
            //await MyRouter.navigateToPerson(context, 1);
          },
          leading: const UserDP(
            fullName: "برنامج الخليل",
            id: 1,
          ),
          trailing: context.watch<PersonProvider>().isLoadingPerson != null
              ? const MyWaitingAnimation()
              : null,
          title: Text(
            "برنامج الخليل",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onError, fontSize: 16),
          ),
          subtitle: Text(
            "مسودة",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onError, fontSize: 14),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: OverflowBox(
              maxHeight: MediaQuery.of(context).size.height,
              alignment: Alignment.topLeft,
              child: Image.asset(
                theme.brightness == Brightness.dark
                    ? 'assets/images/chat_room_background_image_dark.png'
                    : 'assets/images/chat_room_background_image_light.jpg',
                repeat: ImageRepeat.repeat,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (__, value, _) => ListView.builder(
                    itemBuilder: (context, index) {
                      List<Message> mesages = value.messages.reversed.toList();
                      return MessageBox(message: mesages[index]);
                    },
                    itemCount: value.messages.length,
                    reverse: true,
                  ),
                ),
              ),
              const ChatInputArea(),
            ],
          ),
        ],
      ),
    );
  }
}

class Message extends Equatable {
  final DateTime? time;
  final String? userFullName;
  final int? userId;
  final String? text;
  const Message({
    this.userFullName,
    this.userId,
    this.time,
    this.text,
  });

  @override
  List<Object?> get props => [
        time,
        userFullName,
        userId,
        text,
      ];
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userId: json['userId'],
      userFullName: json['userFullName'],
      time: DateTime.parse(json['time']),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userFullName'] = userFullName;
    data['time'] = time?.toIso8601String();
    data['text'] = text;
    return data;
  }

  Message copy() {
    return Message(
      text: text,
      time: time,
      userFullName: userFullName,
      userId: userId,
    );
  }
}
