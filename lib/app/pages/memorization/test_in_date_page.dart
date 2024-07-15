// ignore_for_file: prefer_const_constructors

import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/page.dart';
import 'package:al_khalil/features/downloads/widgets/my_popup_menu.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/messges/toast.dart';

class TestsInDatePage extends StatefulWidget {
  const TestsInDatePage({super.key});

  @override
  State<TestsInDatePage> createState() => _TestsInDatePageState();
}

class _TestsInDatePageState extends State<TestsInDatePage> {
  SortType isNameSort = SortType.none;
  SortType isJuzeSort = SortType.none;
  SortType isPercentSort = SortType.none;
  SortType isGroupSort = SortType.none;
  bool _showFail = true;
  String? firstDate;
  String? lastDate;
  bool _isLoading = false;
  Failure? failure;

  List<Person>? tested;
  List<Person> filtered = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTests();
    });
    super.initState();
  }

  getDateRange() async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale("en"),
      cancelText: "إلغاء",
      textDirection: TextDirection.rtl,
      builder: (context, child) => child!,
    );

    if (dateRange != null) {
      firstDate = dateRange.start.getYYYYMMDD();
      lastDate = dateRange.end.getYYYYMMDD();
      setState(() {});
      await getTests();
    }
  }

  getFiltered() {
    if (tested == null) {
      return [];
    }
    if (_showFail) {
      return tested;
    }
    List<Person> list = [];
    for (var e in tested!) {
      final tests =
          e.tests!.where((test) => test.rate != Reciting.failReciteId);
      if (tests.isEmpty) {
        continue;
      } else {
        list.add(e);
      }
    }
    return list;
  }

  Future getTests() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    tested = null;
    setState(() {});
    final state = await context
        .read<MemorizationProvider>()
        .getTestsInDate(firstDate, lastDate);
    if (state is DataState<List<Person>> && mounted) {
      tested = state.data;
      filtered = getFiltered();
    } else if (state is ErrorState && mounted) {
      failure = state.failure;
      CustomToast.handleError(state.failure);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل السبر"),
        actions: [
          MyPopUpMenu(
            list: [
              MyPopUpMenu.getWithCheckBox(
                "عرض الرسوب",
                _showFail,
                onTap: () {
                  _showFail = !_showFail;
                  filtered = getFiltered();
                  setState(() {});
                },
              )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  onTap: getDateRange,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  head: "تاريخ البداية",
                  body: firstDate ?? "غير محدد",
                  child: firstDate == null
                      ? null
                      : IconButton(
                          onPressed: () {
                            firstDate = null;
                            getTests();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: theme.colorScheme.error,
                          ),
                        ),
                ),
              ),
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  onTap: getDateRange,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  head: "تاريخ النهاية",
                  body: lastDate ?? "غير محدد",
                  child: lastDate == null
                      ? null
                      : IconButton(
                          onPressed: () {
                            lastDate = null;
                            getTests();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: theme.colorScheme.error,
                          ),
                        ),
                ),
              ),
              5.getWidthSizedBox,
            ],
          ),
          TryAgainLoader(
            isLoading: _isLoading,
            isData: tested != null,
            onRetry: getTests,
            failure: failure,
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: getTests,
                child: CustomTaple(
                  culomn: [
                    CustomCulomnCell(
                      text: "الاسم",
                      sortType: isNameSort,
                      onSort: sortName,
                    ),
                    CustomCulomnCell(
                      text: "عدد الأجزاء",
                      sortType: isJuzeSort,
                      onSort: sortJuze,
                    ),
                    CustomCulomnCell(
                      text: "النسبة",
                      sortType: isPercentSort,
                      onSort: sortPercentage,
                    ),
                    CustomCulomnCell(
                      text: "الحلقة",
                      sortType: isGroupSort,
                      onSort: sortGroup,
                    ),
                  ],
                  row: filtered.map(
                    (e) => CustomRow(
                      row: [
                        CustomCell(
                          text: e.getFullName(),
                          onTap: () {
                            CustomSheet.showMyBottomSheet(
                              context,
                              (p0) => Column(
                                children: [
                                  MyInfoCard(
                                    head: "الطالب",
                                    body: e.getFullName(),
                                    child: IconButton(
                                      onPressed: () {
                                        context.navigateToPerson(e.id);
                                      },
                                      icon: Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTaple(
                                      controller: p0,
                                      culomn: const [
                                        CustomCulomnCell(text: "الجزء"),
                                        CustomCulomnCell(text: "العلامة"),
                                        CustomCulomnCell(text: "التاريخ"),
                                        CustomCulomnCell(text: "تفاصيل"),
                                      ],
                                      row: e.getTests(_showFail)?.map(
                                            (studentTests) => CustomRow(
                                              row: [
                                                CustomCell(
                                                  text: studentTests.section
                                                      .toString(),
                                                ),
                                                CustomCell(
                                                  text: studentTests.mark
                                                      .toString(),
                                                ),
                                                CustomCell(
                                                  text: studentTests.createdAt,
                                                ),
                                                CustomIconCell(
                                                  icon: Icons.info_outlined,
                                                  onTap: () {
                                                    CustomSheet
                                                        .showMyBottomSheet(
                                                      context,
                                                      (p0) => TestSaveSheet(
                                                        enable: false,
                                                        quranTest: studentTests,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        CustomCell(
                            text: e.getTests(_showFail)?.length.toString()),
                        CustomCell(text: e.getTestsAvg(_showFail).toString()),
                        CustomCell(text: e.student?.groubName),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sortName() {
    setState(() {
      isGroupSort = SortType.none;
      isJuzeSort = SortType.none;
      isPercentSort = SortType.none;
      if (isNameSort == SortType.inc) {
        isNameSort = SortType.dec;
      } else {
        isNameSort = SortType.inc;
      }
      if (isNameSort == SortType.inc) {
        filtered.sort(
          (a, b) => (a.getFullName()).compareTo(b.getFullName()),
        );
      } else {
        filtered.sort(
          (a, b) => (b.getFullName()).compareTo(a.getFullName()),
        );
      }
    });
  }

  sortPercentage() {
    setState(() {
      isGroupSort = SortType.none;
      isJuzeSort = SortType.none;
      isNameSort = SortType.none;
      if (isPercentSort == SortType.inc) {
        isPercentSort = SortType.dec;
      } else {
        isPercentSort = SortType.inc;
      }
      if (isPercentSort == SortType.inc) {
        filtered.sort(
          (a, b) {
            int avrgA = a.getTestsAvg(_showFail);

            int avrgB = b.getTestsAvg(_showFail);

            return (avrgA).compareTo(avrgB);
          },
        );
      } else {
        filtered.sort(
          (a, b) {
            double avrgA = 0;
            a.tests?.forEach((element) {
              avrgA = avrgA + element.mark!.toDouble();
            });
            if (a.tests!.isNotEmpty) {
              avrgA = avrgA / a.tests!.length;
            }

            double avrgB = 0;
            b.tests?.forEach((element) {
              avrgB = avrgB + element.mark!.toDouble();
            });
            if (b.tests!.isNotEmpty) {
              avrgB = avrgB / b.tests!.length;
            }

            return (avrgB).compareTo(avrgA);
          },
        );
      }
    });
  }

  sortJuze() {
    setState(() {
      isGroupSort = SortType.none;
      isPercentSort = SortType.none;
      isNameSort = SortType.none;
      if (isJuzeSort == SortType.inc) {
        isJuzeSort = SortType.dec;
      } else {
        isJuzeSort = SortType.inc;
      }
      if (isJuzeSort == SortType.inc) {
        filtered.sort(
          (a, b) => (a.tests?.length ?? 0).compareTo(b.tests?.length ?? 0),
        );
      } else {
        filtered.sort(
          (a, b) => (b.tests?.length ?? 0).compareTo(a.tests?.length ?? 0),
        );
      }
    });
  }

  sortGroup() {
    setState(() {
      isJuzeSort = SortType.none;
      isPercentSort = SortType.none;
      isNameSort = SortType.none;
      if (isGroupSort == SortType.inc) {
        isGroupSort = SortType.dec;
      } else {
        isGroupSort = SortType.inc;
      }
      if (isGroupSort == SortType.inc) {
        filtered.sort(
          (a, b) => (a.student?.groubName ?? "")
              .compareTo(b.student?.groubName ?? ""),
        );
      } else {
        filtered.sort(
          (a, b) => (b.student?.groubName ?? "")
              .compareTo(a.student?.groubName ?? ""),
        );
      }
    });
  }
}
