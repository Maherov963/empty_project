import 'dart:io';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/components/voice_message_bubble.dart';
import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/messages/message.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioTileCard extends StatefulWidget {
  const AudioTileCard({
    super.key,
    required this.fileSystemEntity,
    required this.id,
    this.onSend,
    this.query,
    this.duration,
    this.artwork,
  });
  final int? duration;
  final int id;
  final OnAudioQuery? query;
  final FileSystemEntity fileSystemEntity;
  final void Function()? onSend;
  final Uint8List? artwork;
  @override
  State<AudioTileCard> createState() => _AudioTileCardState();
}

class _AudioTileCardState extends State<AudioTileCard> {
  Uint8List? pic;
  int? id;
  getlist() async {
    if (id != widget.id) {
      pic = await OnAudioQuery.platform
          .queryArtwork(widget.id, ArtworkType.AUDIO, quality: 2000);
      id = widget.id;
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getlist();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
    getlist();
    return Column(
      children: [
        ListTile(
          leading: pic == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/res_log.png",
                    width: 50,
                    height: 50,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    pic!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
          trailing: IconButton(
              onPressed: () async {
                if (context.read<ChatProvider>().playingId !=
                    widget.fileSystemEntity.path) {
                  context.read<ChatProvider>().playAudio(
                        widget.fileSystemEntity.path,
                        id: widget.id,
                        artwork: pic,
                      );
                } else {
                  if (context.read<ChatProvider>().player.playing) {
                    context.read<ChatProvider>().pauseAudio();
                  } else {
                    context.read<ChatProvider>().resumrAudio();
                  }
                }
              },
              icon: context.watch<ChatProvider>().playingId ==
                      widget.fileSystemEntity.path
                  ? StreamBuilder<AudioPosition>(
                      stream: context.read<ChatProvider>().positionDataStream,
                      builder: (context, snapshot) {
                        final audioPosition = snapshot.data;
                        return Icon(audioPosition?.isPlaying ?? false
                            ? Icons.pause
                            : Icons.play_arrow);
                      },
                    )
                  : const Icon(Icons.play_arrow)),
          title: Text(FileManager.basename(widget.fileSystemEntity)),
          onTap: () async {
            await MySnackBar.showYesNoDialog(
                    context, "هل تود في الارسال بالفعل؟")
                .then((value) async {
              if (value) {
                final id = context.read<ChatProvider>().nextId;
                print(widget.duration);
                await context.read<ChatProvider>().addMessage(
                      Message(
                        messageId: id,
                        audio: widget.fileSystemEntity.path,
                        state: MessageStatus.pending,
                        time: DateTime.now(),
                        userFullName: myAccount.getFullName(),
                        userId: myAccount.id!,
                        duration: ((widget.duration ?? 0) / 1000).round(),
                      ),
                    );
                widget.onSend!();
                if (mounted) {
                  Navigator.pop(context, widget.fileSystemEntity.path);
                }
              }
            });
          },
        ),
        Selector<ChatProvider, String?>(
          selector: (_, p1) => p1.playingId,
          builder: (_, value, __) => value != widget.fileSystemEntity.path
              ? const SizedBox.shrink()
              : StreamBuilder(
                  stream: context.read<ChatProvider>().positionDataStream,
                  builder: (context, snapshot) {
                    final audioPosition = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProgressBar(
                        thumbColor: Colors.grey,
                        progressBarColor:
                            Theme.of(context).appBarTheme.foregroundColor,
                        progress: audioPosition?.position ?? Duration.zero,
                        total: audioPosition?.duration ?? Duration.zero,
                        buffered:
                            audioPosition?.bufferedPosition ?? Duration.zero,
                        onSeek: context.read<ChatProvider>().player.seek,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
