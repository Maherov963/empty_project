import 'package:al_khalil/app/pages/chat/manage_db_page.dart';
import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../domain/models/messages/message.dart';
import '../../components/chat_input_area.dart';
import '../../components/normal_message_bubble.dart';
import '../../components/user_profile_appbar.dart';
import '../../components/voice_message_bubble.dart';
import '../../components/waiting_animation.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Message? reply;
  final ItemScrollController itemScrollController = ItemScrollController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myAccount = context.read<CoreProvider>().myAccount!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("حذف رسائل الدردشة"),
                onTap: () async {
                  await context.read<ChatProvider>().deleteAllMessage();
                },
              ),
              PopupMenuItem(
                child: const Text("إدارة الذاكرة"),
                onTap: () async {
                  MyRouter.myPush(context, const ManageDbPage());
                },
              ),
            ],
          )
        ],
        title: ListTile(
          onTap: () async {},
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
              Consumer<ChatProvider>(
                builder: (__, val, _) => Expanded(
                  child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemBuilder: (context, pos) {
                      int index = pos == -1 ? 0 : pos;
                      return val.messages[index].audio != null
                          ? VoiceMessageBubble(
                              message: val.messages[index],
                              isMine:
                                  val.messages[index].userId == myAccount.id,
                              onDismissed: () {
                                reply = val.messages[index].copy();
                                focusNode.requestFocus();
                                setState(() {});
                              },
                              onTap: () {
                                context.read<ChatProvider>().setreply(
                                    val.messages[index].reply!.messageId!);
                                itemScrollController.scrollTo(
                                    duration: const Duration(milliseconds: 300),
                                    index: val.messages.indexWhere((element) =>
                                        val.messages[index].reply!.messageId ==
                                        element.messageId));
                              },
                            )
                          : NormalMessageBubble(
                              message: val.messages[index],
                              isMine:
                                  val.messages[index].userId == myAccount.id,
                              onDismissed: () {
                                reply = val.messages[index].copy();
                                focusNode.requestFocus();
                                setState(() {});
                              },
                              onTap: () {
                                context.read<ChatProvider>().setreply(
                                    val.messages[index].reply!.messageId!);
                                itemScrollController.scrollTo(
                                    duration: const Duration(milliseconds: 500),
                                    index: val.messages.indexWhere((element) =>
                                        val.messages[index].reply!.messageId ==
                                        element.messageId));
                              },
                            );
                    },
                    itemCount: val.messages.length,
                    reverse: true,
                  ),
                ),
              ),
              ChatInputArea(
                reply: reply,
                focusNode: focusNode,
                onSend: () {
                  reply = null;
                  itemScrollController.jumpTo(index: 0);
                },
                onCloseReply: () {
                  setState(() {
                    reply = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScreenSizeService {
  final BuildContext context;

  const ScreenSizeService(
    this.context,
  );

  Size get size => MediaQuery.of(context).size;
  double get height => size.height;
  double get width => size.width;
}
