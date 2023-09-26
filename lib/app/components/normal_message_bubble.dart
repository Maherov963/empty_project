import 'package:al_khalil/app/components/chat_input_area.dart';
import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/messages/message.dart';
import '../pages/image_viewer/image_viewer_page.dart';
import 'message_status_icon.dart';
import 'package:intl/intl.dart';

class NormalMessageBubble extends StatefulWidget {
  const NormalMessageBubble(
      {super.key,
      required this.message,
      this.onDismissed,
      this.onTap,
      required this.isMine});
  final Message message;
  final void Function()? onDismissed;
  final void Function()? onTap;
  final bool isMine;
  @override
  State<NormalMessageBubble> createState() => _NormalMessageBubbleState();
}

class _NormalMessageBubbleState extends State<NormalMessageBubble> {
  late final theme = Theme.of(context);
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        color: context.watch<ChatProvider>().replyId == widget.message.messageId
            ? Theme.of(context)
                .colorScheme
                .secondary
                .withOpacity(context.watch<ChatProvider>().opacity / 1000)
            : null,
        child: Row(
          mainAxisAlignment:
              widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: widget.onDismissed, icon: const Icon(Icons.reply)),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: (widget.isMine
                        ? Theme.of(context).brightness == Brightness.dark
                            ? theme.primaryColor
                            : const Color.fromARGB(255, 231, 255, 219)
                        : theme.appBarTheme.backgroundColor!)
                    .withAlpha(isSelected ? 125 : 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                  topLeft: Radius.circular(widget.isMine ? 0 : 15),
                  topRight: Radius.circular(widget.isMine ? 15 : 0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.message.reply != null)
                    InkWell(
                      onTap: widget.onTap,
                      child: getReplyWidget(constraint),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          if (widget.message.image != null)
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await context
                                    .pushTransparentRoute(
                                      ImageViewer(
                                        name: widget.message.userFullName,
                                        tag: widget.message.messageId,
                                        link: "",
                                      ),
                                    )
                                    .then((value) {});
                              },
                              child: Hero(
                                tag: widget.message.messageId ?? 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    "assets/images/profile.png",
                                    width: constraint.maxWidth / 2,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.message.text != null) 5.getHightSizedBox(),
                          if (widget.message.text != null)
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    // minWidth: constraint.maxWidth / 2,
                                    maxWidth: constraint.maxWidth / 2),
                                child: Text(widget.message.text!)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat(DateFormat.HOUR_MINUTE)
                                .format(widget.message.time!),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          MessageStatusIcon(
                            status:
                                widget.message.state ?? MessageStatus.failed,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget getReplyWidget(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth - 100),
      child: Container(
          color: Theme.of(context).focusColor,
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message.reply?.userFullName ?? "",
                        style: const TextStyle(
                            color: Colors.purpleAccent, fontSize: 12),
                      ),
                      if (widget.message.reply?.text != null)
                        Text(
                          widget.message.reply?.text ?? "",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (widget.message.reply?.audio != null)
                        Row(
                          children: [
                            const Icon(Icons.mic),
                            Text(
                                "رسالة صوتية (${getTimeString(Duration(seconds: widget.message.reply?.duration ?? 0))})")
                          ],
                        ),
                      if (widget.message.reply?.image != null)
                        const Icon(Icons.photo),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
