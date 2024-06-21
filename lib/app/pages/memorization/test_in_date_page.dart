import 'package:al_khalil/app/pages/additional_point/add_pts_admin_page.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/widgets/cell.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/messges/toast.dart';

class TestsInDatePage extends StatefulWidget {
  const TestsInDatePage({super.key});

  @override
  State<TestsInDatePage> createState() => _TestsInDatePageState();
}

class _TestsInDatePageState extends State<TestsInDatePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDateRange();
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
    firstDate = dateRange?.start.getYYYYMMDD();
    lastDate = dateRange?.end.getYYYYMMDD();
    setState(() {});
    await getTests();
  }

  getTests() async {
    final state = await context
        .read<MemorizationProvider>()
        .getTestsInDate(firstDate, lastDate);
    if (state is DataState<List<Person>> && mounted) {
      tested = state.data;
    } else if (state is ErrorState && mounted) {
      CustomToast.handleError(state.failure);
    }
  }

  bool isNameInc = false;
  bool isJuzeInc = false;
  bool isPercentInc = false;
  bool isGroupInc = false;

  String? firstDate;
  String? lastDate;
  List<Person> tested = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل السبر"),
        actions: [
          IconButton(
            onPressed: () async {
              getDateRange();
            },
            icon: const Icon(
              Icons.date_range_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: context.watch<MemorizationProvider>().isLoadingIn,
            child: const LinearProgressIndicator(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("من : ${firstDate ?? "غير محدد"}"),
              Text("إلى : ${lastDate ?? "غير محدد"}"),
            ],
          ),
          Row(
            children: [
              MyCell(
                text: "الطالب",
                flex: 5,
                isTitle: true,
                onTap: () async {
                  sortName();
                },
              ),
              MyCell(
                text: "عدد الأجزاء",
                flex: 2,
                isTitle: true,
                onTap: () async {
                  sortJuze();
                },
              ),
              MyCell(
                onTap: () async {
                  sortPercentage();
                },
                text: "النسبة",
                flex: 2,
                isTitle: true,
              ),
              MyCell(
                onTap: () async {
                  sortGroup();
                },
                text: "الحلقة",
                flex: 5,
                isTitle: true,
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => getTests(),
              child: Scrollbar(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    double avrg = 0;
                    tested[index].tests?.forEach((element) {
                      avrg = avrg + element.mark!.toDouble();
                    });
                    if (tested[index].tests!.isNotEmpty) {
                      avrg = avrg / tested[index].tests!.length;
                    }
                    return Row(
                      children: [
                        MyCell(
                          text: tested[index].getFullName(),
                          flex: 5,
                          isButton: true,
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              showDragHandle: true,
                              enableDrag: true,
                              builder: (context) => DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        MyCell(
                                          text: "الجزء",
                                          flex: 5,
                                          isTitle: true,
                                          onTap: () async {},
                                        ),
                                        MyCell(
                                          text: "العلامة",
                                          flex: 2,
                                          isTitle: true,
                                          onTap: () async {},
                                        ),
                                        MyCell(
                                          onTap: () async {},
                                          text: "التاريخ",
                                          flex: 5,
                                          isTitle: true,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: tested[index].tests?.length,
                                      itemBuilder: (context, index2) => Row(
                                        children: [
                                          MyCell(
                                            text: tested[index]
                                                .tests?[index2]
                                                .section
                                                .toString(),
                                            flex: 5,
                                            textColor: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            isButton: true,
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    InfoDialog(
                                                        title: "معلومات السبر",
                                                        infoData: [
                                                          getInfoCard(
                                                              "الجزء",
                                                              tested[index]
                                                                  .tests?[
                                                                      index2]
                                                                  .section
                                                                  .toString()),
                                                          const Divider(),
                                                          getInfoCard(
                                                              "اسم الطالب",
                                                              tested[index]
                                                                  .tests?[
                                                                      index2]
                                                                  .testedPep
                                                                  ?.getFullName()),
                                                          const Divider(),
                                                          getInfoCard(
                                                              "الأستاذ الذي سبر له",
                                                              tested[index]
                                                                  .tests?[
                                                                      index2]
                                                                  .testerPer
                                                                  ?.getFullName()),
                                                          const Divider(),
                                                          getInfoCard("التقدير",
                                                              "${tested[index].tests?[index2].mark ?? ""}%"),
                                                          const Divider(),
                                                          getInfoCard(
                                                              "نقاط التجويد",
                                                              tested[index]
                                                                  .tests?[
                                                                      index2]
                                                                  .tajweed
                                                                  .toString()),
                                                          const Divider(),
                                                          const Divider(),
                                                          getInfoCard(
                                                              "تاريخ العملية",
                                                              "${tested[index].tests?[index2].createdAt}"),
                                                          const Divider(),
                                                          getInfoCard(
                                                              "الملاحظات",
                                                              tested[index]
                                                                  .tests?[
                                                                      index2]
                                                                  .notes),
                                                        ],
                                                        onDelete: () async {
                                                          await context
                                                              .read<
                                                                  MemorizationProvider>()
                                                              .deleteTest(
                                                                  tested[index]
                                                                      .tests![
                                                                          index2]
                                                                      .idTest!)
                                                              .then((state) {
                                                            if (state
                                                                is DataState) {
                                                              CustomToast.showToast(
                                                                  CustomToast
                                                                      .succesfulMessage);
                                                              setState(() {
                                                                tested[index]
                                                                    .tests
                                                                    ?.removeAt(
                                                                        index2);
                                                              });
                                                            }
                                                            if (state
                                                                is ErrorState) {
                                                              CustomToast
                                                                  .showToast(state
                                                                      .failure
                                                                      .message);
                                                            }
                                                          });
                                                        }),
                                              );
                                            },
                                          ),
                                          MyCell(
                                            text: tested[index]
                                                .tests?[index2]
                                                .mark
                                                .toString(),
                                            flex: 2,
                                            onTap: () async {},
                                          ),
                                          MyCell(
                                            onTap: () async {},
                                            text: tested[index]
                                                .tests?[index2]
                                                .createdAt,
                                            flex: 5,
                                          ),
                                        ],
                                      ),
                                      controller: scrollController,
                                    )),
                                  ],
                                ),
                              ),
                            );
                          },
                          textColor: Theme.of(context).colorScheme.tertiary,
                        ),
                        MyCell(
                          text: tested[index].tests?.length.toString(),
                          flex: 2,
                        ),
                        MyCell(
                          text: avrg.round().toString(),
                          flex: 2,
                        ),
                        MyCell(
                          text: tested[index].student?.groubName,
                          flex: 5,
                        ),
                      ],
                    );
                  },
                  itemCount: tested.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getInfoCard(String? head, String? body) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: RichText(
          text: TextSpan(
            text: "$head : ",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: body ?? "",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

  sortName() {
    setState(() {
      isNameInc = !isNameInc;
      if (isNameInc) {
        tested.sort(
          (a, b) => (a.getFullName()).compareTo(b.getFullName()),
        );
      } else {
        tested.sort(
          (a, b) => (b.getFullName()).compareTo(a.getFullName()),
        );
      }
    });
  }

  sortPercentage() {
    setState(() {
      isJuzeInc = !isJuzeInc;
      if (isJuzeInc) {
        tested.sort(
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

            return (avrgA).compareTo(avrgB);
          },
        );
      } else {
        tested.sort(
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
      isPercentInc = !isPercentInc;
      if (isPercentInc) {
        tested.sort(
          (a, b) => (a.tests?.length ?? 0).compareTo(b.tests?.length ?? 0),
        );
      } else {
        tested.sort(
          (a, b) => (b.tests?.length ?? 0).compareTo(a.tests?.length ?? 0),
        );
      }
    });
  }

  sortGroup() {
    setState(() {
      isGroupInc = !isGroupInc;
      if (isGroupInc) {
        tested.sort(
          (a, b) => (a.student?.groubName ?? "")
              .compareTo(b.student?.groubName ?? ""),
        );
      } else {
        tested.sort(
          (a, b) => (b.student?.groubName ?? "")
              .compareTo(a.student?.groubName ?? ""),
        );
      }
    });
  }
}
