import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import '../pages/chat/chat_room.dart';
import 'message_status_icon.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    this.showArrow = false,
    required this.isSelected,
  }) : super(key: key);
  final bool isSelected;
  final Message message;

  /// Whether to show an arrow in message bubble
  /// that pointing to message author.
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final messageTextStyle = textTheme.bodyMedium!.copyWith(
      fontSize: 14,
    );
    final isUserMessage =
        message.userId == context.read<CoreProvider>().myAccount!.id;
    final timeTextStyle = textTheme.bodySmall!.copyWith(
      color: isUserMessage && theme.brightness == Brightness.dark
          ? const Color(0xFF99BEB7)
          : const Color(0xFF99BEB7),
    );

    final messageText = message.text;
    final timeText = DateFormat(DateFormat.HOUR_MINUTE).format(message.time!);
    // Read message check mark icon

    // Adding extra white spaces at the end of text to
    // wrap the line before overlapping the time text.
    // And the unicode character at the end is for prevent text trimming.

    // Calculate timeText width
    // eg: width of "1:11" and "12:44" is different or
    // width of "4:44" and "1:11" is different in non-monospace fonts
    final timeTextWidth =
        textWidth(timeText, timeTextStyle) + (isUserMessage ? 18 : 0);
    final messageTextWidth = textWidth(messageText!, messageTextStyle);
    final whiteSpaceWidth = textWidth(' ', messageTextStyle);
    // More space on desktop (+8)
    final extraSpaceCount = ((timeTextWidth / whiteSpaceWidth).round()) + (2);
    final extraSpace = '${' ' * extraSpaceCount}\u202f';
    final extraSpaceWidth = textWidth(extraSpace, messageTextStyle);

    // Padding outside message bubble
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1.2),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurStyle: BlurStyle.outer,
                blurRadius: 1)
          ],
          color: (isUserMessage
                  ? Theme.of(context).brightness == Brightness.dark
                      ? theme.primaryColor
                      : const Color.fromARGB(255, 231, 255, 219)
                  : theme.appBarTheme.backgroundColor!)
              .withAlpha(isSelected ? 125 : 255),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
            topLeft: Radius.circular(isUserMessage ? 15 : 0),
            topRight: Radius.circular(isUserMessage ? 0 : 15),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constrains) {
            const padding = 8.0; // Padding for the message text
            final maxWidth = constrains.maxWidth - (padding * 2);

            // Deciding the placement of time text.

            //                                      maxWidth
            //                                         |
            // Short message                           v
            // |---------------|
            // | MESSAGE  time |
            // |---------------|

            // text + extraSpace < maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MESSAGE.MESSAGE  time |
            // |---------------------------------------|

            // text < maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MSGS..MESSAGE.MESSAGE |
            // |                                  time |
            // |---------------------------------------|

            // text > maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MSGS..MESSAGE.MESSAGE |
            // | MESSAGE.MESSAGE.MESSAGE          time |
            // |---------------------------------------|
            final isTimeInSameLine =
                messageTextWidth + extraSpaceWidth < maxWidth ||
                    messageTextWidth > maxWidth;

            // Using Stack to show message time in bottom right corner.
            return Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                if (!isUserMessage)
                  Padding(
                    padding: isUserMessage
                        ? const EdgeInsets.only(right: 5)
                        : const EdgeInsets.only(left: 5),
                    child: InkWell(
                      child: Text(
                        message.userFullName!,
                        style: TextStyle(
                            color: isUserMessage
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.onSecondary),
                      ),
                      onTap: () async {
                        await MyRouter.navigateToPerson(
                            context, message.userId!);
                      },
                    ),
                  ),
                Stack(
                  children: [
                    // Message text
                    Padding(
                      padding: const EdgeInsets.all(padding).copyWith(
                        bottom: isTimeInSameLine ? padding : 25,
                      ),
                      child: Text(
                        '$messageText   '
                        '${isTimeInSameLine ? extraSpace : ''}',
                        style: messageTextStyle,
                      ),
                    ),

                    // Message time
                    Positioned(
                      bottom: 5,
                      left: 7,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeText,
                            style: timeTextStyle,
                          ),
                          // Message status icon
                          if (isUserMessage)
                            MessageStatusIcon(
                              status: MessageStatus.sended,
                              color: timeTextStyle.color!,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Returns the width of given `text` using TextPainter
  double textWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}
