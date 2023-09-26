import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/messages/message.dart';
import 'message_status_icon.dart';
import 'package:intl/intl.dart' hide TextDirection;

class VoiceMessageBubble extends StatefulWidget {
  const VoiceMessageBubble({
    super.key,
    required this.message,
    this.onDismissed,
    this.onTap,
    required this.isMine,
  });
  final Message message;
  final void Function()? onDismissed;
  final void Function()? onTap;
  final bool isMine;
  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble>
    with AutomaticKeepAliveClientMixin {
  late final theme = Theme.of(context);
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        color: context.watch<ChatProvider>().replyId == widget.message.messageId
            ? theme.colorScheme.secondary
                .withOpacity(context.watch<ChatProvider>().opacity / 1000)
            : null,
        child: Row(
          mainAxisAlignment:
              widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: widget.onDismissed, icon: const Icon(Icons.reply)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                children: [
                  if (widget.message.reply != null)
                    InkWell(
                      onTap: widget.onTap,
                      child: getReplyWidget(constraint),
                    ),
                  // SizedBox(width: 100, child: Text(widget.message.audio ?? "")),
                  StreamBuilder<AudioPosition>(
                    stream: context.read<ChatProvider>().positionDataStream,
                    builder: (context, snapshot) {
                      final audioPosition = snapshot.data;
                      return Consumer<ChatProvider>(
                        builder: (_, value, __) => Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: IconButton(
                                onPressed: () async {
                                  if (context.read<ChatProvider>().playingId !=
                                      widget.message.audio) {
                                    context
                                        .read<ChatProvider>()
                                        .playAudio(widget.message.audio!);
                                  } else {
                                    if (context
                                        .read<ChatProvider>()
                                        .player
                                        .playing) {
                                      context.read<ChatProvider>().pauseAudio();
                                    } else {
                                      context
                                          .read<ChatProvider>()
                                          .resumrAudio();
                                    }
                                  }
                                },
                                icon: value.playingId == widget.message.audio
                                    ? Icon(
                                        audioPosition?.isPlaying ?? false
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      )
                                    : const Icon(Icons.play_arrow),
                              ),
                            ),
                            SizedBox(
                                width: constraint.maxWidth / 2.3,
                                child: ProgressBar(
                                  thumbColor: Colors.grey,
                                  progressBarColor: Theme.of(context)
                                      .appBarTheme
                                      .foregroundColor,
                                  progress: value.playingId ==
                                          widget.message.audio
                                      ? audioPosition?.position ?? Duration.zero
                                      : Duration.zero,
                                  total: value.playingId == widget.message.audio
                                      ? audioPosition?.duration ?? Duration.zero
                                      : Duration(
                                          seconds:
                                              widget.message.duration ?? 0),
                                  buffered:
                                      value.playingId == widget.message.audio
                                          ? audioPosition?.bufferedPosition ??
                                              Duration.zero
                                          : Duration.zero,
                                  onSeek: value.playingId ==
                                          widget.message.audio
                                      ? context.read<ChatProvider>().player.seek
                                      : null,
                                )),
                            5.getWidthSizedBox(),
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
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget getReplyWidget(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth - 100),
      child: Card(
          color: Theme.of(context).focusColor,
          child: Row(
            children: [
              Container(
                width: 5,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(10)),
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
                        const Icon(Icons.audiotrack_rounded),
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

  @override
  bool get wantKeepAlive => true;
}

class AudioPosition {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  final bool isPlaying;
  AudioPosition({
    required this.isPlaying,
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}
