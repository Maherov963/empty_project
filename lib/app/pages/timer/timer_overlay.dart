import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/timer_provider.dart';

class TimerOverLay extends StatefulWidget {
  const TimerOverLay({super.key});

  @override
  State<TimerOverLay> createState() => _TimerOverLayState();
}

class _TimerOverLayState extends State<TimerOverLay> {
  @override
  Widget build(BuildContext context) {
    var prov = context.watch<TimerProvider>();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    // _offset = Offset.zero;
    return Positioned(
        left: prov.offset.dx,
        top: prov.offset.dy,
        child: GestureDetector(
          onLongPress: () {
            prov.closeOverLay();
          },
          onPanUpdate: (details) {
            prov.offset += details.delta;
            prov.offset = Offset(
                prov.offset.dx < 0
                    ? 0.0
                    : prov.offset.dx + 50 > w
                        ? w - 50
                        : prov.offset.dx,
                prov.offset.dy < 0
                    ? 0.0
                    : prov.offset.dy + 50 > h
                        ? h - 50
                        : prov.offset.dy);
            prov.entry!.markNeedsBuild();
            setState(() {});
          },
          child: Material(
            color: Colors.transparent,
            child: prov.remainTime == '00:00'
                ? Center(
                    child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'انتهى المؤقت',
                        style: TextStyle(
                            color: Color.fromARGB(255, 228, 146, 174),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ))
                : Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: prov.isPause
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.green.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: FittedBox(
                              child: Text(
                                prov.remainTime,
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    context.read<TimerProvider>().isPause
                                        ? context.read<TimerProvider>().resume()
                                        : context.read<TimerProvider>().pause();
                                  },
                                  child: Icon(
                                    context.watch<TimerProvider>().isPause
                                        ? Icons.play_arrow
                                        : Icons.pause,
                                    // color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
