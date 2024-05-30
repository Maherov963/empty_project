import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import 'package:flutter/material.dart';
import 'bottom_banner.dart';
import 'page_builder.dart';
import 'upper_baner.dart';

class QuranScreen extends StatefulWidget {
  final int initialPage;
  const QuranScreen({
    Key? key,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  void _onScreenTap() {
    setState(() {
      _showBaner = !_showBaner;
    });
  }

  void _onStartTap() {
    setState(() {
      _isStarted = true;
    });
  }

  void _onSaveTap() async {
    final save = await CustomDialog.showTowOptionDialog(
      context: context,
      content: "هل تريد حفظ التسميع؟",
      refuseText: "تجاهل",
      agreeText: "حفظ",
    );
    if (save == null) {
      return;
    } else if (save == true) {
    } else {}
    _isStarted = false;
    setState(() {});
  }

  void _onMistakes(int id, List<Mistake> mistake) {
    setState(() {
      mistakes.removeWhere((element) => element.idWord == id);
      mistakes.addAll(mistake);
    });
  }

  List<Mistake> mistakes = [];
  bool _showBaner = false;
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isStarted,
      onPopInvoked: (didPop) {
        if (!didPop) {
          CustomToast.showToast("قم بإنهاء التسميع أولاً");
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 221, 220, 215),
                Color.fromARGB(255, 255, 255, 253),
                Color.fromARGB(255, 221, 220, 215),
              ],
            ),
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: _onScreenTap,
                child: PageBuilder(
                  initialPage: widget.initialPage,
                  isStarted: _isStarted,
                  mistakes: mistakes,
                  onMistake: _onMistakes,
                ),
              ),
              Column(
                children: [
                  UpperBanner(visable: _showBaner),
                  const Expanded(child: SizedBox.shrink()),
                  BottomBanner(
                    visable: _showBaner,
                    isStarted: _isStarted,
                    onStart: _onStartTap,
                    onSave: _onSaveTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
