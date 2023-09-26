import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:al_khalil/app/components/voice_message_bubble.dart';
import 'package:al_khalil/app/pages/chat/audio_tile_card.dart';
import 'package:al_khalil/app/providers/chat/chat_provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PickAudioPage extends StatefulWidget {
  const PickAudioPage({super.key, this.onSend});
  final void Function()? onSend;

  @override
  State<PickAudioPage> createState() => _PickAudioPageState();
}

class _PickAudioPageState extends State<PickAudioPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  List<Uint8List?> artwork = [];
  List<SongModel> filtered = [];
  // List<String> parents = [];
  @override
  void initState() {
    getAudioFiles();
    super.initState();
  }

  getAudioFiles() async {
    await _audioQuery.permissionsRequest().then((value) async {
      if (value) {
        songs = await _audioQuery.querySongs(uriType: UriType.EXTERNAL);
        filtered = songs;
        setState(() {});
        // for (var e in songs) {
        //   final x = await _audioQuery.queryArtwork(e.id, ArtworkType.AUDIO);
        //   artwork.add(x);
        // }
        // for (var e in songs) {
        //   String par = FileManager.basename(File(e.data).parent);
        //   if (!parents.contains(par)) {
        //     parents.add(par);
        //   }
        // }
      }
    });
  }

  final PanelController _controller = PanelController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.isPanelClosed) {
          return true;
        } else {
          _controller.close();
          return false;
        }
      },
      child: SlidingUpPanel(
        controller: _controller,
        onPanelSlide: (position) {
          // setState(() {});
        },
        panel: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (context.watch<ChatProvider>().curentArtwork != null)
                Image.memory(context.watch<ChatProvider>().curentArtwork!,
                    fit: BoxFit.cover),
              ClipRRect(
                // Clip it cleanly.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        minHeight: context.watch<ChatProvider>().playingId == null ? 0 : 75,
        maxHeight: MediaQuery.of(context).size.height,
        color: Colors.black,
        header: context.watch<ChatProvider>().playingId == null
            ? null
            : PanelWidget(cntrlr: _controller),
        body: Scaffold(
          appBar: AppBar(
            title: CupertinoSearchTextField(
              style: Theme.of(context).textTheme.bodyLarge,
              backgroundColor: Colors.transparent,
              onChanged: (value) {
                filtered = [];
                for (var e in songs) {
                  if (e.title.toLowerCase().contains(value.toLowerCase())) {
                    filtered.add(e);
                  }
                }
                setState(() {});
              },
            ),
          ),
          body: ListView.builder(
            itemCount: filtered.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AudioTileCard(
                id: filtered[index].id,
                onSend: widget.onSend,
                duration: filtered[index].duration,
                fileSystemEntity: File(filtered[index].data),
                query: _audioQuery,
              );
            },
          ),
        ),
      ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final PanelController cntrlr;
  const PanelWidget({super.key, required this.cntrlr});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  context.watch<ChatProvider>().curentArtwork == null
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
                            context.watch<ChatProvider>().curentArtwork!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                  Expanded(
                      child: Text(
                    FileManager.basename(
                            File(context.watch<ChatProvider>().playingId ?? ""))
                        .replaceAll("\n", ""),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  IconButton(
                      onPressed: () async {
                        if (context.read<ChatProvider>().player.playing) {
                          context.read<ChatProvider>().pauseAudio();
                        } else {
                          context.read<ChatProvider>().resumrAudio();
                        }
                      },
                      icon: StreamBuilder<AudioPosition>(
                        stream: context.read<ChatProvider>().positionDataStream,
                        builder: (context, snapshot) {
                          final audioPosition = snapshot.data;
                          return Icon(audioPosition?.isPlaying ?? false
                              ? Icons.pause
                              : Icons.play_arrow);
                        },
                      )),
                ],
              ),
              Selector<ChatProvider, String?>(
                selector: (_, p1) => p1.playingId,
                builder: (_, value, __) => StreamBuilder(
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
          ),
        ),
      ),
    );
  }
}
