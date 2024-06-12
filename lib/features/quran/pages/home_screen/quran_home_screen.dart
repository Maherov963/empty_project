import 'package:al_khalil/app/pages/home/search_bar.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/features/quran/domain/models/ayah.dart';
import 'package:al_khalil/features/quran/pages/page_screen/help_screen.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/expanded_widget.dart';
import '../page_screen/quran_screen.dart';

class QuranHomeScreen extends StatefulWidget {
  final Person? student;
  final PageState reason;

  const QuranHomeScreen({
    super.key,
    this.student,
    required this.reason,
  });

  static Widget resualtBuilder(
    BuildContext context,
    int controller,
    Ayah ayah,
  ) =>
      ListTile(
        title: Text(ayah.ayah),
        subtitle: Text(
            "سورة ${ayah.suraName} : ${ayah.ayahId} (صفحة ${ayah.pageId})"),
        onTap: () {
          context.myPush(
            QuranScreen(initialPage: ayah.pageId, reason: PageState.nothing),
          );
        },
      );

  static List<Ayah> onSearch(String text) {
    return quranProvider.quran.searchAyah(text);
  }

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  int? _currentExpandedTile;

  late final quran = quranProvider.quran;
  Memorization? memorization;
  bool _isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.student != null) {
        await _getMemorization();
      }
    });
    super.initState();
  }

  _getMemorization() async {
    if (widget.student != null) {
      _isLoading = true;
      setState(() {});
      await context
          .read<MemorizationProvider>()
          .getMemorization(widget.student!.id!)
          .then((state) {
        if (state is ErrorState) {
          CustomToast.handleError(state.failure);
        } else if (state is DataState<Memorization>) {
          memorization = state.data;
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.student != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(
                  hint: "ابحث في المصحف",
                  title: widget.student!.getFullName(),
                  trailing: IconButton(
                    onPressed: () {
                      context.myPush(const HelpScreen());
                    },
                    icon: const Icon(Icons.help_outline_rounded),
                  ),
                  enable: false,
                  leading: const BackButton(),
                  onSearch: QuranHomeScreen.onSearch,
                  resultBuilder: QuranHomeScreen.resualtBuilder,
                ),
              ),
            _isLoading
                ? getLoader()
                : memorization == null && widget.student != null
                    ? getError(_getMemorization)
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => _getMemorization(),
                          child: ListView.builder(
                            itemCount: quran.juzs.length,
                            itemBuilder: (context, index) {
                              final test = memorization
                                  ?.getSuccesTest(quran.juzs[index].juzId);
                              return ExpandedSection(
                                expandedChild: quran.juzs[index].pages.map(
                                  (e) {
                                    final recite =
                                        memorization?.getSuccesRecite(e.id);
                                    return _buildTile(
                                        recite, e.id, e.isFirstPage, myAccount);
                                  },
                                ).toList(),
                                expand: _currentExpandedTile == index,
                                onTap: () {
                                  setState(() {
                                    if (_currentExpandedTile == index) {
                                      _currentExpandedTile = null;
                                    } else {
                                      _currentExpandedTile = index;
                                    }
                                  });
                                },
                                child: _buildTileTest(
                                  test,
                                  quran.juzs[index].juzId,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    Reciting? recite,
    int page,
    String? pageHeader,
    Person? reciter,
  ) {
    return InkWell(
      onTap: () async {
        await context.myPush(
          QuranScreen(
            reason: widget.reason,
            initialPage: page,
            student: widget.student,
            memorization: memorization,
            reciter: reciter,
          ),
        );
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "\t\t\t$page",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Column(
                children: [
                  if (pageHeader != null) Text(pageHeader),
                  if (recite?.ratesIdRate != null)
                    Text(
                      Reciting.getRateFromId(recite!.ratesIdRate)!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: getColor(recite.ratesIdRate),
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              "${recite?.listenerPer?.getFullName() ?? ""}\n${recite?.createdAt ?? ""}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileTest(QuranTest? test, int juz) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "الجزء $juz \nتم تسميع ${memorization?.getSuccesfulRecites(juz) ?? ""} ",
              style: Theme.of(context).textTheme.titleMedium,
              // textAlign: TextAlign.,
            ),
            Expanded(
              child: Column(
                children: [
                  if (test?.rate != null && test?.rate != Reciting.failReciteId)
                    Text(
                      Reciting.getRateFromId(test?.rate)!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: getColor(test?.rate),
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              "${test?.testerPer?.getFullName() ?? ""}\n${test?.createdAt ?? ""}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Color? getColor(int? rate) {
    return switch (rate) {
      Reciting.failReciteId => const Color(0xffcc4125),
      Reciting.goodReciteId => const Color(0xff45818e),
      Reciting.veryGoodReciteId => const Color(0xff60DBB9),
      Reciting.excellentReciteId => const Color(0xffbf9000),
      int() => null,
      null => null,
    };
  }

  getError(Function() onTap) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: TextButton(
          onPressed: onTap,
          child: Text(
            "إعادة المحاولة",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ),
    );
  }

  getLoader() {
    return Column(
      children: List.filled(7, const Skeleton(height: 60)),
    );
  }
}
