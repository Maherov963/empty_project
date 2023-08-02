import 'dart:async';
import 'dart:io';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import '../pages/timer/timer_overlay.dart';

class TimerProvider with ChangeNotifier {
  int _currentTime = 0;
  int _duration = 0;
  bool _isWork = false;
  bool _isPause = false;
  OverlayEntry? entry;
  Offset offset = const Offset(20, 40);
  final CountDownController countDownController = CountDownController();
  late Timer timer;
  String remainTime = '00:00';
  bool get isPause => _isPause;
  set isPause(bool isWork) {
    _isPause = isPause;
    notifyListeners();
  }

  bool get isWork => _isWork;
  set isWork(bool isWork) {
    _isWork = isWork;
    notifyListeners();
  }

  int get currentTime => _currentTime;
  set currentTime(int ct) {
    _currentTime = ct;
    notifyListeners();
  }

  int get durationTime => _duration;
  set durationTime(int ct) {
    _duration = ct;
    notifyListeners();
  }

  startProvTimer() async {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _currentTime++;
        notifyListeners();
        remainTime = getT();
        if (_currentTime == _duration) {
          closeProvTimer();
          _currentTime = 0;
          _isWork = false;
          _isPause = false;
          _duration = 0;
          //closeOverLay();
          notifyListeners();
        }
      },
    );
  }

  closeProvTimer() {
    timer.cancel();
  }

  pause() {
    _isWork = true;
    _isPause = true;
    notifyListeners();
    closeProvTimer();
    if (Platform.isAndroid) {
      //Noti.closeAll();
      // Workmanager().cancelAll();
    }
  }

  resume() {
    _isWork = true;
    _isPause = false;
    notifyListeners();
    startProvTimer();
    if (Platform.isAndroid) {
      // Noti.showNoti(
      //     title: 'السلام عليكم',
      //     body: 'انتهى المؤقت',
      //     x: durationTime - currentTime);
      // Workmanager().registerOneOffTask('timer', 'run timer', inputData: {
      //   'duration': durationTime - currentTime,
      // });
    }
  }

  start(int duration) {
    _isWork = true;
    _isPause = false;
    _currentTime = 0;
    _duration = duration;
    if (Platform.isAndroid) {
      // Workmanager().registerOneOffTask('timer', 'run timer', inputData: {
      //   'duration': duration,
      // });
      // Noti.showNoti(title: 'السلام عليكم', body: 'انتهى المؤقت', x: duration);
    }
    notifyListeners();
    startProvTimer();
  }

  restart(int duration) {
    cancel();
    start(duration);
  }

  cancel() {
    _currentTime = 0;
    _isWork = false;
    _isPause = false;
    _duration = 0;
    if (Platform.isAndroid) {
      // Workmanager().cancelAll();
      //Noti.closeAll();
    }
    closeProvTimer();
    notifyListeners();
  }

  closeOverLay() {
    pause();
    entry?.remove();
    entry = null;
  }

  showOverLay(BuildContext ctx) {
    entry = OverlayEntry(
      builder: (context) => const TimerOverLay(),
    );
    final overlay = Overlay.of(ctx);
    overlay.insert(entry!);
  }

  getT() {
    int remain = durationTime - currentTime;
    if (remain < 10) {
      return '00:0$remain';
    }
    if (remain <= 59) {
      return '00:$remain';
    }
    if (remain > 59) {
      int m = remain ~/ 60;
      int s = remain - (60 * m);
      String min = '$m';
      String sec = '$s';
      if (m < 10) {
        min = '0$m';
      }
      if (s < 10) {
        sec = '0$s';
      }
      return '$min : $sec';
    }
  }
}
