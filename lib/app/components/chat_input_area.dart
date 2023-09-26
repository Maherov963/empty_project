import 'dart:async';
import 'dart:io';
import 'package:al_khalil/app/components/bottom_sheet/attache_sheet.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../domain/models/management/person.dart';
import '../../domain/models/messages/message.dart';
import '../providers/chat/chat_provider.dart';
import 'chat_text_field.dart';
import 'my_snackbar.dart';
import 'package:logger/logger.dart';

class ChatInputArea extends StatefulWidget {
  const ChatInputArea({
    Key? key,
    this.reply,
    this.onCloseReply,
    this.onSend,
    this.focusNode,
  }) : super(key: key);
  final Message? reply;
  final FocusNode? focusNode;

  final void Function()? onCloseReply;
  final void Function()? onSend;
  @override
  State<ChatInputArea> createState() => _ChatInputAreaMobileState();
}

class _ChatInputAreaMobileState extends State<ChatInputArea> {
  final TextEditingController controler = TextEditingController();
  bool isMicon = false;
  Timer? timer;
  int ticks = 0;
  final recorder = FlutterSoundRecorder(logLevel: Level.nothing);
  String? filePath;
  Future record() async {
    filePath = null;
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      recorder.openAudioSession();
      setState(() {
        isMicon = true;
      });
      if (mounted) {
        int id = context.read<ChatProvider>().nextId;
        final mainpath = await getApplicationDocumentsDirectory();
        Directory recordsdirectory = Directory("${mainpath.path}/records");
        await recordsdirectory.create();
        await recorder.startRecorder(
          toFile:
              '${mainpath.path}/records/voice$id-${DateTime.now().getYYYYMMDD()}.aac',
        );
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          ticks++;
          setState(() {});
        });
      }
    } else {
      if (mounted) {
        MySnackBar.showMySnackBar(
          "تعذر تسجيل المقطع لعدم وجود الصلاحيات الكافية",
          context,
        );
      }
    }
  }

  Future stop() async {
    if (timer!.tick < 1) {
      MySnackBar.showMySnackBar("المقطع صغير جدا", context);
      setState(() {
        timer?.cancel();
        isMicon = false;
      });
      await recorder.stopRecorder();
    } else {
      filePath = await recorder.stopRecorder();
      setState(() {
        timer?.cancel();
        isMicon = false;
      });
    }
  }

  cancel() async {
    setState(() {
      timer?.cancel();
      isMicon = false;
    });
    ticks = 0;
    await recorder.stopRecorder();
    await recorder.deleteRecord(fileName: filePath!);
    filePath = null;
  }

  sendMessage(Person myAccount) async {
    final id = context.read<ChatProvider>().nextId;
    await context.read<ChatProvider>().addMessage(
          Message(
            time: DateTime.now(),
            text: controler.text.trim(),
            userFullName: myAccount.getFullName(),
            userId: myAccount.id!,
            messageId: id,
            state: MessageStatus.delivered,
            reply: widget.reply == null
                ? null
                : ReplyMessage(
                    messageId: widget.reply?.messageId,
                    text: widget.reply?.text,
                    userFullName: widget.reply?.userFullName,
                    userId: widget.reply?.userId,
                    audio: widget.reply?.audio,
                    image: widget.reply?.image,
                    duration: widget.reply?.duration,
                  ),
          ),
        );
    controler.clear();
    widget.onCloseReply!();
    widget.onSend!();
    setState(() {});
  }

  sendRecord(Person myAccount) async {
    await stop();
    if (filePath != null && mounted) {
      int id = context.read<ChatProvider>().nextId;
      await context.read<ChatProvider>().addMessage(
            Message(
              messageId: id,
              audio: filePath!,
              state: MessageStatus.sended,
              time: DateTime.now(),
              userFullName: myAccount.getFullName(),
              userId: myAccount.id!,
              duration: ticks,
              reply: widget.reply == null
                  ? null
                  : ReplyMessage(
                      messageId: widget.reply?.messageId,
                      text: widget.reply?.text,
                      userFullName: widget.reply?.userFullName,
                      userId: widget.reply?.userId,
                      audio: widget.reply?.audio,
                      image: widget.reply?.image,
                      duration: widget.reply?.duration,
                    ),
            ),
          );
      ticks = 0;
      widget.onSend!();
      setState(() {});
      widget.onCloseReply!();
    }
  }

  disposeRecord() async {
    if (recorder.isRecording) {
      final path = await recorder.stopRecorder();
      await recorder.deleteRecord(fileName: path!);
    }
  }

  @override
  void dispose() {
    disposeRecord();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
    final customColors = Theme.of(context);

    return SizedBox(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5)
              .copyWith(top: 4, bottom: 6),
          child: isMicon
              ? Card(
                  child: Column(children: [
                    if (widget.reply != null) getReplyWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getTimeString(Duration(seconds: ticks)),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              cancel();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        ClipOval(
                          child: ColoredBox(
                            color: customColors.primaryColor,
                            child: IconButton(
                                onPressed: () async {
                                  await sendRecord(myAccount);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    )
                  ]),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(25),
                          bottomRight: const Radius.circular(25),
                          topLeft:
                              Radius.circular(widget.reply != null ? 10 : 25),
                          topRight:
                              Radius.circular(widget.reply != null ? 10 : 25),
                        ),
                        child: ColoredBox(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : customColors.appBarTheme.backgroundColor!,
                          child: IconTheme(
                            data: IconThemeData(
                              color: customColors.colorScheme.onError,
                            ),
                            child: Column(
                              children: [
                                if (widget.reply != null) getReplyWidget(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.emoji_emotions_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Expanded(
                                        child: ChatTextField(
                                      focusNode: widget.focusNode,
                                      textEditingController: controler,
                                    )),
                                    IconButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        await MySnackBar.showMyBottomSheet(
                                          context,
                                          MyAttacheSheet(
                                            onSend: widget.onSend,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.attach_file_sharp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (context
                                        .watch<ChatProvider>()
                                        .isTextEmpty)
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      height: kBottomNavigationBarHeight -
                          10, // 10 => padding 5 + 5
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: GestureDetector(
                            onTap: () async {
                              if (!context.read<ChatProvider>().isTextEmpty) {
                                await sendMessage(myAccount);
                              } else {
                                await record();
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
                                  child:
                                      context.watch<ChatProvider>().isTextEmpty
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
                  ],
                )),
    );
  }

  Widget getReplyWidget() {
    return Card(
      color: Theme.of(context).focusColor,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.onCloseReply!();
              });
            },
            icon: const Icon(
              Icons.close,
              size: 15,
            ),
          ),
          Row(
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reply?.userFullName ?? "",
                        style: const TextStyle(
                            color: Colors.purpleAccent, fontSize: 12),
                      ),
                      if (widget.reply?.text != null)
                        Text(
                          widget.reply?.text ?? "",
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (widget.reply?.audio != null)
                        Row(
                          children: [
                            const Icon(Icons.mic),
                            Text(
                                "رسالة صوتية (${getTimeString(Duration(seconds: widget.reply!.duration!))})")
                          ],
                        ),
                      if (widget.reply?.image != null) const Icon(Icons.photo),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

String getTimeString(Duration time) {
  final minutes = time.inMinutes.remainder(Duration.minutesPerHour).toString();
  final seconds = time.inSeconds
      .remainder(Duration.secondsPerMinute)
      .toString()
      .padLeft(2, '0');
  return time.inHours > 0
      ? "${time.inHours}:${minutes.padLeft(2, "0")}:$seconds"
      : "$minutes:$seconds";
}
