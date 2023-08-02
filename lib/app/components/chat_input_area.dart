import 'package:al_khalil/app/pages/chat/chat_room.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/management/person.dart';
import '../providers/chat/chat_provider.dart';
import 'chat_text_field.dart';

class ChatInputArea extends StatelessWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChatInputAreaMobile();
  }
}

class _ChatInputAreaMobile extends StatefulWidget {
  const _ChatInputAreaMobile({
    Key? key,
  }) : super(key: key);

  @override
  State<_ChatInputAreaMobile> createState() => _ChatInputAreaMobileState();
}

class _ChatInputAreaMobileState extends State<_ChatInputAreaMobile> {
  final TextEditingController controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final orientation = MediaQuery.of(context).orientation;
    Person myAccount = context.read<CoreProvider>().myAccount!;
    final customColors = Theme.of(context);
    // Decoration (shadow) for TextInput and send button
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 1,
          offset: Offset(0, 0.5),
        )
      ],
    );
    return SizedBox(
      // height: context.watch<ChatProvider>().lineCount == 1 ||
      //         orientation == Orientation.landscape
      //     ? kBottomNavigationBarHeight
      //     : (18 * context.watch<ChatProvider>().lineCount) + 10 + 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5)
            .copyWith(top: 4, bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: boxDecoration, // Shadow
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(kBottomNavigationBarHeight / 2),
                  child: ColoredBox(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : customColors.appBarTheme.backgroundColor!,
                    child: IconTheme(
                      data: IconThemeData(
                        color: customColors.colorScheme.onError,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Emoji button
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.emoji_emotions_rounded,
                              color: Colors.grey,
                            ),
                          ),

                          // TextField
                          Expanded(
                              child: ChatTextField(
                            textEditingController: controler,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: kBottomNavigationBarHeight - 10, // 10 => padding 5 + 5
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: DecoratedBox(
                  decoration: boxDecoration, // Shadow
                  child: ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        if (controler.text.trim().isNotEmpty) {
                          context.read<ChatProvider>().addMessage(
                                Message(
                                  time: DateTime.now(),
                                  text: controler.text.trim(),
                                  userFullName: myAccount.getFullName(),
                                  userId: myAccount.id!,
                                ),
                              );
                          controler.clear();
                        }
                      },
                      child: ColoredBox(
                          color: customColors.primaryColor,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: context.watch<ChatProvider>().isTextEmpty
                                ? const Icon(
                                    Icons.mic,
                                    key: Key('mic_icon'),
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.send,
                                    key: Key('send_icon'),
                                    color: Colors.white,
                                  ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
