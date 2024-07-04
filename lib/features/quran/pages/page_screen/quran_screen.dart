import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_button_menu.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import 'package:al_khalil/features/quran/domain/models/quran.dart';
import 'package:al_khalil/features/quran/pages/page_screen/help_screen.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/components/person_selector.dart';
import 'bottom_banner.dart';
import 'page_builder.dart';
import 'upper_baner.dart';

class QuranScreen extends StatefulWidget {
  final int initialPage;
  final Person? student;
  final Person? reciter;
  final Memorization? memorization;
  final PageState reason;

  const QuranScreen({
    super.key,
    required this.initialPage,
    this.student,
    this.reciter,
    this.memorization,
    required this.reason,
  });

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  Reciting? _reciting;
  QuranTest? _quranTest;

  late List<Mistake> oldMistakes;
  bool _showBaner = false;
  PageState _pageState = PageState.nothing;
  late int _page = widget.initialPage;

  late List<PageQuran> quranPages = quranProvider.quranPages;

  late final PageController _pageController =
      PageController(initialPage: widget.initialPage - 1);

  @override
  void initState() {
    getInfo();
    oldMistakes = widget.memorization?.calculateOldReciteMistakes() ?? [];
    super.initState();
  }

  void getInfo() {
    if (!_pageState.isNone) {
      return;
    }
    if (widget.reason.isReciting || widget.reason.isView) {
      _reciting = widget.memorization?.getSuccesRecite(_page)?.copy();
      setState(() {});
    } else if (widget.reason.isTesting) {
      _quranTest =
          widget.memorization?.getSuccesTest(Quran.getJuzOfPage(_page))?.copy();
      setState(() {});
    }
  }

  void _onScreenTap() {
    setState(() {
      _showBaner = !_showBaner;
    });
  }

  void _onReciteStart() {
    if (widget.memorization?.juz != null &&
        Quran.getJuzOfPage(_page) != widget.memorization?.juz) {
      CustomToast.showToast(
          "الرجاء إنهاء الجزء ${widget.memorization?.juz} أولاً");
      return;
    }
    _reciting = Reciting(
      mistakes: [],
      reciterPep: widget.student,
      listenerPer: widget.reciter,
      page: _page,
      createdAt: DateTime.now().getYYYYMMDD(),
    );
    _pageState = PageState.reciting;
    setState(() {});
  }

  void _onReciteDelete() {
    widget.memorization?.recites?.removeWhere(
      (element) => element.idReciting == _reciting?.idReciting,
    );
    _reciting = null;
    oldMistakes = widget.memorization?.calculateOldReciteMistakes() ?? [];
    setState(() {});
  }

  void _onReciteSave() async {
    final state = await CustomSheet.showMyBottomSheet(
      context,
      (p0) => SaveSheet(
        reciting: _reciting!,
        reciter: widget.reciter!,
      ),
    );

    if (state == null) {
      return;
    } else if (state == -1) {
      _reciting = null;
      _pageState = PageState.nothing;
    } else {
      _reciting = state;
      widget.memorization?.recites?.add(_reciting!);
      if (_reciting?.ratesIdRate == Reciting.failReciteId) {
        _reciting = null;
      }
      oldMistakes = widget.memorization?.calculateOldReciteMistakes() ?? [];
      _pageState = PageState.nothing;
    }
    setState(() {});
  }

  void _onMistakes(int id, List<Mistake> mistake) {
    if (widget.reason == PageState.reciting) {
      setState(() {
        _reciting?.mistakes?.removeWhere((element) => element.wordId == id);
        _reciting?.mistakes?.addAll(mistake);
      });
    } else {
      setState(() {
        _quranTest?.mistakes?.removeWhere((element) => element.wordId == id);
        _quranTest?.mistakes?.addAll(mistake);
      });
    }
  }

  void _onTestStart() async {
    _quranTest = QuranTest(
      mistakes: [],
      section: Quran.getJuzOfPage(_page),
      testedPep: widget.student,
      testerPer: widget.reciter,
      createdAt: DateTime.now().getYYYYMMDD(),
    );
    setState(() {
      _pageState = PageState.testing;
    });
  }

  void _onTestSave() async {
    final state = await CustomSheet.showMyBottomSheet(
      context,
      (p0) => TestSaveSheet(quranTest: _quranTest!),
    );

    if (state == null) {
      return;
    } else if (state == -1) {
      _quranTest = null;
      _pageState = PageState.nothing;
    } else {
      _quranTest = state;
      widget.memorization?.tests?.add(_quranTest!);
      if (_quranTest?.rate == Reciting.failReciteId) {
        _quranTest = null;
      }
      oldMistakes = widget.memorization?.calculateOldReciteMistakes() ?? [];
      _pageState = PageState.nothing;
    }
    setState(() {});
  }

  void _onTestDelete() {
    widget.memorization?.tests?.removeWhere(
      (element) => element.idTest == _quranTest?.idTest,
    );
    _quranTest = null;
    oldMistakes = widget.memorization?.calculateOldReciteMistakes() ?? [];
    setState(() {});
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(page,
        curve: Curves.linear, duration: Durations.short1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _pageState.isNone,
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
                  pageController: _pageController,
                  test: _quranTest,
                  onChangePage: (p0) {
                    if (_pageState.isTesting) {
                      final lastPage =
                          quranProvider.getLastPageOfJuz(_quranTest!.section!);
                      final firstPage =
                          quranProvider.getFirstPageOfJuz(_quranTest!.section!);
                      if (p0 > lastPage - 1) {
                        _animateToPage(lastPage - 1);
                      } else if (p0 < firstPage) {
                        _animateToPage(firstPage - 1);
                      }
                    }
                    _page = p0 + 1;
                    getInfo();
                  },
                  quranPages: quranPages,
                  reciting: _reciting,
                  initialPage: widget.initialPage,
                  pageState: _pageState,
                  oldMistakes: oldMistakes,
                  onMistake: _onMistakes,
                ),
              ),
              UpperBanner(
                visable: _showBaner,
                pageId: _page,
                memorization: widget.memorization,
                title: widget.student?.getFullName(),
              ),
              if (widget.student != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomBanner(
                    visable: _showBaner,
                    reciting: _reciting,
                    pageState: _pageState,
                    onReciteSave: _onReciteSave,
                    onReciteStart: _onReciteStart,
                    onTestSave: _onTestSave,
                    onTestStart: _onTestStart,
                    onReciteDelete: _onReciteDelete,
                    onTestDelete: _onTestDelete,
                    reason: widget.reason,
                    test: _quranTest,
                    reciter: widget.reciter!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveSheet extends StatefulWidget {
  final Person reciter;
  final Reciting reciting;
  final bool enable;

  const SaveSheet({
    super.key,
    required this.reciting,
    this.enable = true,
    required this.reciter,
  });

  @override
  State<SaveSheet> createState() => _SaveSheetState();
}

class _SaveSheetState extends State<SaveSheet> {
  late final Reciting _recite;

  get onPressed => null;
  @override
  void initState() {
    _recite = widget.reciting.copy();
    _recite.ratesIdRate ??= _recite.calculateRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                5.getWidthSizedBox,
                Expanded(
                  child: MyInfoCard(
                    head: "التقدير:",
                    body: Reciting.getRateFromId(_recite.ratesIdRate),
                    child: IconButton(
                      onPressed: () {
                        context.myPush(const HelpScreen());
                      },
                      icon: const Icon(Icons.help_outline_rounded),
                    ),
                  ),
                ),
                5.getWidthSizedBox,
                Expanded(
                  child: MyInfoCard(
                    head: "التجويد:",
                    body: "",
                    child: Switch(
                      value: _recite.tajweed,
                      onChanged: !widget.enable
                          ? null
                          : (value) {
                              setState(() {
                                _recite.tajweed = !_recite.tajweed;
                                _recite.ratesIdRate = _recite.calculateRate();
                              });
                            },
                    ),
                  ),
                ),
                5.getWidthSizedBox,
              ],
            ),
            MyInfoCard(
              head: "التاريخ:",
              body: _recite.createdAt,
            ),
            MyInfoCard(
              head: "الأستاذ المستمع:",
              body: _recite.listenerPer?.getFullName(),
            ),
            if (widget.enable)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Visibility(
                    visible: !context.watch<MemorizationProvider>().isLoadingIn,
                    replacement: const MyWaitingAnimation(),
                    child: CustomTextButton(
                      text: "حفظ",
                      onPressed: () async {
                        _recite.ratesIdRate = _recite.calculateRate();
                        setState(() {});
                        final state = await context
                            .read<MemorizationProvider>()
                            .recite(_recite);
                        if (state is DataState<int> && mounted) {
                          _recite.idReciting = state.data;
                          CustomToast.showToast(CustomToast.succesfulMessage);
                          Navigator.pop(context, _recite);
                        } else if (state is ErrorState && mounted) {
                          CustomToast.handleError(state.failure);
                        }
                      },
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Visibility(
                    visible: !context.watch<MemorizationProvider>().isLoadingIn,
                    replacement: const MyWaitingAnimation(),
                    child: CustomTextButton(
                      text: "تجاهل",
                      onPressed: () async {
                        if (_recite.mistakes!.isEmpty) {
                          Navigator.pop(context, -1);
                        } else {
                          _recite.ratesIdRate = Reciting.failReciteId;
                          setState(() {});
                          final state = await context
                              .read<MemorizationProvider>()
                              .recite(_recite);
                          if (state is DataState<int> && mounted) {
                            _recite.idReciting = state.data;
                            CustomToast.showToast(CustomToast.succesfulMessage);
                            Navigator.pop(context, _recite);
                          } else if (state is ErrorState && mounted) {
                            CustomToast.handleError(state.failure);
                          }
                        }
                      },
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Visibility(
                  visible: !context.watch<MemorizationProvider>().isLoadingIn,
                  replacement: const MyWaitingAnimation(),
                  child: CustomTextButton(
                    text: "حذف",
                    onPressed: () async {
                      final ensure =
                          await CustomDialog.showDeleteDialig(context);
                      if (!ensure) {
                        return;
                      }
                      final state = await context
                          .read<MemorizationProvider>()
                          .deleteRecite(_recite.idReciting!);
                      if (state is DataState && mounted) {
                        CustomToast.showToast(CustomToast.succesfulMessage);
                        Navigator.pop(context, 1);
                      } else if (state is ErrorState && mounted) {
                        CustomToast.handleError(state.failure);
                      }
                    },
                    color: theme.colorScheme.error,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class TestSaveSheet extends StatefulWidget {
  final QuranTest quranTest;
  final bool enable;

  const TestSaveSheet({
    super.key,
    required this.quranTest,
    this.enable = true,
  });

  @override
  State<TestSaveSheet> createState() => _TestSaveSheetState();
}

class _TestSaveSheetState extends State<TestSaveSheet> {
  late final QuranTest _quranTest;

  @override
  void initState() {
    _quranTest = widget.quranTest.copy();
    _quranTest.tajweedMark ??= _quranTest.calculateTajweedMark();
    _quranTest.mark ??= _quranTest.calculateMark();
    _quranTest.rate ??= _quranTest.calculateRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: [
          Row(
            children: [
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  head: "التقدير:",
                  body: Reciting.getRateFromId(_quranTest.rate) ?? "",
                  child: IconButton(
                    onPressed: () {
                      context.myPush(const HelpScreen());
                    },
                    icon: const Icon(Icons.help_outline_rounded),
                  ),
                ),
              ),
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  head: "التجويد:",
                  body: _quranTest.calculateTajweedMark().toString(),
                  child: Switch(
                    value: _quranTest.tajweed,
                    onChanged: !widget.enable
                        ? null
                        : (value) {
                            setState(() {
                              _quranTest.tajweed = !_quranTest.tajweed;
                              _quranTest.tajweedMark =
                                  _quranTest.calculateTajweedMark();
                              _quranTest.rate = _quranTest.calculateRate();
                            });
                          },
                  ),
                ),
              ),
              5.getWidthSizedBox,
            ],
          ),
          MyButtonMenu(
            title: "التاريخ:",
            enabled: widget.enable,
            value: _quranTest.createdAt,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(_quranTest.createdAt!),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _quranTest.createdAt = date.getYYYYMMDD();
                setState(() {});
              }
            },
          ),
          5.getHightSizedBox,
          MyButtonMenu(
            enabled: widget.enable,
            value: _quranTest.testerPer?.getFullName(),
            title: "أستاذ الحلقة:",
            onTapValue: () async {
              await context.navigateToPerson(_quranTest.testerPer?.id);
            },
            onTap: () async {
              final choosen = await context.myPush(
                PersonSelector(
                  withPop: true,
                  multi: false,
                  fetchData: context.read<PersonProvider>().getTesters,
                ),
              );
              if (choosen is List<Person>) {
                _quranTest.testerPer = choosen.first;
                setState(() {});
              }
            },
          ),
          5.getHightSizedBox,
          MyInfoCardEdit(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    "علامة الحفظ: ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: MyprogressBar(value: _quranTest.mark!),
                  ),
                ],
              ),
            ),
          ),
          5.getHightSizedBox,
          if (widget.enable)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: !context.watch<MemorizationProvider>().isLoadingIn,
                  replacement: const MyWaitingAnimation(),
                  child: CustomTextButton(
                    text: "حفظ",
                    onPressed: () async {
                      _quranTest.rate = _quranTest.calculateRate();
                      final state = await context
                          .read<MemorizationProvider>()
                          .test(_quranTest);
                      if (state is DataState<int> && mounted) {
                        _quranTest.idTest = state.data;
                        CustomToast.showToast(CustomToast.succesfulMessage);
                        Navigator.pop(context, _quranTest);
                      } else if (state is ErrorState && mounted) {
                        CustomToast.handleError(state.failure);
                      }
                    },
                    color: theme.colorScheme.primary,
                  ),
                ),
                Visibility(
                  visible: !context.watch<MemorizationProvider>().isLoadingIn,
                  replacement: const MyWaitingAnimation(),
                  child: CustomTextButton(
                    text: "تجاهل",
                    onPressed: () async {
                      if (_quranTest.mistakes!.isEmpty) {
                        Navigator.pop(context, -1);
                      } else {
                        _quranTest.rate = Reciting.failReciteId;
                        setState(() {});
                        final state = await context
                            .read<MemorizationProvider>()
                            .test(_quranTest);
                        if (state is DataState<int> && mounted) {
                          _quranTest.idTest = state.data;
                          CustomToast.showToast(CustomToast.succesfulMessage);
                          Navigator.pop(context, _quranTest);
                        } else if (state is ErrorState && mounted) {
                          CustomToast.handleError(state.failure);
                        }
                      }
                    },
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            )
          else
            Center(
              child: Visibility(
                visible: !context.watch<MemorizationProvider>().isLoadingIn,
                replacement: const MyWaitingAnimation(),
                child: CustomTextButton(
                  text: "حذف",
                  onPressed: () async {
                    final ensure = await CustomDialog.showDeleteDialig(context);
                    if (!ensure) {
                      return;
                    }
                    final state = await context
                        .read<MemorizationProvider>()
                        .deleteTest(_quranTest.idTest!);
                    if (state is DataState && mounted) {
                      CustomToast.showToast(CustomToast.succesfulMessage);
                      Navigator.pop(context, 1);
                    } else if (state is ErrorState && mounted) {
                      CustomToast.handleError(state.failure);
                    }
                  },
                  color: theme.colorScheme.error,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class MyprogressBar extends StatelessWidget {
  const MyprogressBar({super.key, required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 26,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: FractionalOffset.topRight,
            children: [
              Container(
                height: 24,
                width: constraints.maxWidth * value / 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getColor(context),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 8,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 8,
                    ),
                  ),
                ],
              ),
              Center(child: FittedBox(child: Text("$value%"))),
            ],
          ),
        );
      },
    );
  }

  Color getColor(context) {
    if (value < 80) {
      return Theme.of(context).colorScheme.error;
    }
    return ColorTween(
      begin: Theme.of(context).colorScheme.primaryContainer,
      end: Theme.of(context).colorScheme.error,
    ).lerp(1.1 - value / 100)!;
    // return Theme.of(context).colorScheme.primaryContainer;
  }
}

enum PageState {
  reciting,
  testing,
  view,
  nothing;

  bool get isTesting => this == testing;
  bool get isReciting => this == reciting;
  bool get isNone => this == nothing;
  bool get isView => this == view;
}
