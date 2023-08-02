import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/timer_provider.dart';

class TimerPage extends StatefulWidget {
  static const String routeName = 'timerPage';
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final CountDownController _countDownController = CountDownController();
  int duration = 0;
  late final AnimationController _animationController;
  late final prov = context.read<TimerProvider>();
  late final bool fromPause;
  @override
  initState() {
    fromPause = context.read<TimerProvider>().isPause;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   prov.closeOverLay();
    // });
    if (prov.entry != null) {
      prov.closeOverLay();
    }
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  s(double x) {
    return (x + 20) ~/ 40;
  }

  play() async {
    int second = s(_scrollController.offset);
    int minute = s(_scrollController2.offset);
    duration = minute * 60 + second;
    if (duration > 0) {
      _countDownController.restart(duration: duration);
      Provider.of<TimerProvider>(context, listen: false).start(duration);
    }
  }

  int converter(String? time) {
    try {
      int m = int.parse(time!.split(':')[0]);
      int s = int.parse(time.split(':')[1]);
      return m * 60 + s;
    } catch (e) {
      return int.parse(time!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
        appBar: AppBar(title: const Text('المؤقت الزمني')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              getCircular(primaryColor),
              Divider(
                height: 40,
                color: primaryColor,
                indent: 40,
                endIndent: 40,
              ),
              Center(
                child: getTimer(primaryColor),
              ),
              Divider(
                height: 40,
                color: primaryColor,
                indent: 40,
                endIndent: 40,
              ),
              !context.watch<TimerProvider>().isWork
                  ? ElevatedButton(
                      onPressed: () {
                        play();
                      },
                      child: const Text('بدء'))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (fromPause) {
                              if (duration == 0) {
                                context.read<TimerProvider>().cancel();
                                _animationController.forward();
                                _countDownController.restart(duration: 0);
                              } else {
                                _animationController.forward();
                                context.read<TimerProvider>().restart(duration);
                                _countDownController.restart(
                                    duration: duration);
                              }
                            } else {
                              if (duration == 0) {
                                context.read<TimerProvider>().cancel();
                                _animationController.reverse();
                                _countDownController.restart(duration: 0);
                              } else {
                                _animationController.reverse();
                                context.read<TimerProvider>().restart(duration);
                                _countDownController.restart(
                                    duration: duration);
                              }
                            }
                          },
                          icon: const Icon(Icons.replay_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            duration = 0;
                            if (_animationController.isCompleted) {
                              _animationController.reverse();
                            }
                            if (fromPause) {
                              _animationController.forward();
                            }
                            context.read<TimerProvider>().cancel();
                            _countDownController.restart(duration: 0);
                          },
                          icon: const Icon(Icons.close),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_animationController.isDismissed) {
                              _animationController.forward();
                              if (fromPause) {
                                context.read<TimerProvider>().resume();
                                _countDownController.resume();
                              } else {
                                context.read<TimerProvider>().pause();
                                _countDownController.pause();
                              }
                            } else if (_animationController.isCompleted) {
                              _animationController.reverse();
                              if (!fromPause) {
                                context.read<TimerProvider>().resume();
                                _countDownController.resume();
                              } else {
                                context.read<TimerProvider>().pause();
                                _countDownController.pause();
                              }
                            }
                          },
                          icon: AnimatedIcon(
                            icon: fromPause
                                ? AnimatedIcons.play_pause
                                : AnimatedIcons.pause_play,
                            progress: _animationController,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ));
  }

  Expanded expandedWhell(
      String text, ScrollController controller, Color primaryColor) {
    return Expanded(
      child: Column(
        children: [
          Text(text),
          Expanded(
              child: ListWheelScrollView(
            offAxisFraction: 0,
            itemExtent: 40,
            controller: controller,
            children: secondsNminutes
                .map(
                  (e) => Container(
                      margin:
                          const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: primaryColor.withOpacity(1),
                              spreadRadius: 2,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
                .toList(),
          )),
        ],
      ),
    );
  }

  Consumer<TimerProvider> getCircular(Color primaryColor) {
    return Consumer<TimerProvider>(builder: (context, value, child) {
      return CircularCountDownTimer(
        width: 200,
        isReverse: true,
        controller: _countDownController,
        autoStart: true,
        fillColor: Colors.grey,
        height: 200,
        onStart: () async {
          if (value.isPause) {
            await Future.delayed(
              const Duration(milliseconds: 1),
              () => _countDownController.pause(),
            );
          }
        },
        strokeWidth: 10,
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ringColor: primaryColor,
        initialDuration: value.currentTime,
        duration: value.durationTime,
      );
    });
  }

  Widget getTimer(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: primaryColor.withOpacity(0.7),
              spreadRadius: 2,
              blurStyle: BlurStyle.outer,
              blurRadius: 20)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      width: 200,
      height: 100,
      child: Row(
        children: [
          const Icon(Icons.arrow_right),
          expandedWhell('ثواني', _scrollController, primaryColor),
          const Text(" : "),
          expandedWhell('دقائق', _scrollController2, primaryColor),
          const Icon(Icons.arrow_left),
        ],
      ),
    );
  }
}

const List<String> secondsNminutes = [
  '00',
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
  '51',
  '52',
  '53',
  '54',
  '55',
  '56',
  '57',
  '58',
  '59',
];
