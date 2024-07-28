import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/management/person.dart';

class GivePtsPage extends StatefulWidget {
  const GivePtsPage({super.key});

  @override
  State<GivePtsPage> createState() => _GivePtsPageState();
}

class _GivePtsPageState extends State<GivePtsPage> {
  TextEditingController textEditingController = TextEditingController();
  List<Person>? data;
  List<Person> searchList = [];
  List<String> groups = [];
  String? choosinGroup;
  bool isLoading = false;
  Failure? failure;
  int totalPts = 0;
  int totalMoney = 0;
  int totalPtsGroup = 0;
  int totalMoneyGroup = 0;
  SortType isNameSort = SortType.none;
  SortType isPointsSort = SortType.none;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      refreshStudents();
    });
    super.initState();
  }

  Future<void> refreshStudents() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    data = null;
    setState(() {});
    final state = await context.read<PersonProvider>().getStudentsForTesters();
    if (state is DataState<List<Person>> && mounted) {
      data = state.data;
      searchList = data!;
      await getTotalPts();
    }
    if (state is ErrorState && context.mounted) {
      CustomToast.handleError(state.failure);
      failure = state.failure;
    }
    isLoading = false;
    setState(() {});
  }

  getTotalPts() {
    for (var element in data!) {
      totalPts = totalPts + int.parse(element.tempPoints.toString());
      totalMoney = totalMoney +
          int.parse(element.tempPoints.toString()).getCeilToThousand();
      if (!groups.contains(element.student!.groubName!)) {
        groups.add(element.student!.groubName!);
      }
    }
    groups.sort((a, b) => a.compareTo(b));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسليم نقاط"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (data != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                child: MyComboBox(
                  text: choosinGroup,
                  items: groups,
                  hint: "اختر حلقة",
                  onChanged: (p0) {
                    int t;
                    totalPtsGroup = 0;
                    totalMoneyGroup = 0;
                    setState(() {
                      searchList = [];
                      for (var element in data!) {
                        if (element.student!.groubName == p0) {
                          searchList.add(element);
                          t = int.parse(element.tempPoints.toString());
                          totalPtsGroup = totalPtsGroup + t;
                          totalMoneyGroup =
                              totalMoneyGroup + t.getCeilToThousand();
                        }
                      }
                      searchList.sort(
                        (a, b) => a.getFullName().compareTo(b.getFullName()),
                      );
                    });
                    choosinGroup = p0;
                  },
                ),
              ),
            if (data != null)
              Row(
                children: [
                  5.getWidthSizedBox,
                  Expanded(
                    child: MyInfoCard(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      head: "نقاط المعهد",
                      body: "$totalPts نقطة",
                    ),
                  ),
                  5.getWidthSizedBox,
                  Expanded(
                    child: MyInfoCard(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      head: "المبلغ الإجمالي",
                      body: "$totalMoney ل.س",
                    ),
                  ),
                  5.getWidthSizedBox,
                ],
              ),
            if (choosinGroup != null)
              Row(
                children: [
                  5.getWidthSizedBox,
                  Expanded(
                    child: MyInfoCard(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      head: "نقاط الحلقة",
                      body: "$totalPtsGroup نقطة",
                    ),
                  ),
                  5.getWidthSizedBox,
                  Expanded(
                    child: MyInfoCard(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      head: "المبلغ للحلقة",
                      body: "$totalMoneyGroup ل.س",
                    ),
                  ),
                  5.getWidthSizedBox,
                ],
              ),
            TryAgainLoader(
              isLoading: isLoading,
              isData: data != null,
              failure: failure,
              onRetry: refreshStudents,
              child: Expanded(
                child: CustomTaple(
                  culomn: [
                    CustomCulomnCell(
                      text: "الاسم",
                      sortType: isNameSort,
                      onSort: sortName,
                    ),
                    CustomCulomnCell(
                      text: "النقاط",
                      sortType: isPointsSort,
                      onSort: sortPoints,
                    ),
                    const CustomCulomnCell(text: "المبلغ"),
                    const CustomCulomnCell(text: "تسليم"),
                  ],
                  row: searchList.map(
                    (e) => CustomRow(
                      row: [
                        CustomCell(
                          text: e.getFullName(),
                          onTap: () {
                            context.navigateToPerson(e.id);
                          },
                        ),
                        CustomCell(
                          text: e.tempPoints,
                        ),
                        CustomCell(
                          isDanger: e.tempPoints!.startsWith("-"),
                          text:
                              "${int.parse(e.tempPoints.toString()).getCeilToThousand()}",
                        ),
                        CustomIconCell(
                          icon: Icons.clean_hands,
                          isLoading: context
                              .watch<AdditionalPointsProvider>()
                              .loadingQeuee
                              .contains(e.id),
                          onTap: () {
                            if (e.tempPoints == "0") {
                              return;
                            }
                            CustomDialog.showDeleteDialig(context)
                                .then((value) async {
                              if (value) {
                                int pts = int.parse(e.tempPoints.toString());
                                await context
                                    .read<AdditionalPointsProvider>()
                                    .addAdditionalPoints(
                                      AdditionalPoints(
                                        note: "تسليم نقاط",
                                        recieverPep: e,
                                        senderPer: context
                                            .read<CoreProvider>()
                                            .myAccount,
                                        points: pts * -1,
                                      ),
                                    )
                                    .then(
                                  (state) {
                                    if (state is ErrorState) {
                                      CustomToast.handleError(state.failure);
                                    } else if (state is DataState) {
                                      setState(() {
                                        totalPts = totalPts - pts;
                                        totalPtsGroup = totalPtsGroup - pts;
                                        totalMoneyGroup = totalMoneyGroup -
                                            pts.getCeilToThousand();
                                        totalMoney = totalMoney -
                                            pts.getCeilToThousand();
                                        e.tempPoints = "0";
                                      });
                                      CustomToast.showToast(
                                          CustomToast.succesfulMessage);
                                    }
                                  },
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sortName() {
    setState(() {
      isPointsSort = SortType.none;
      if (isNameSort == SortType.inc) {
        isNameSort = SortType.dec;
      } else {
        isNameSort = SortType.inc;
      }
      if (isNameSort == SortType.inc) {
        searchList.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
      } else {
        searchList.sort((a, b) => (b.getFullName()).compareTo(a.getFullName()));
      }
    });
  }

  sortPoints() {
    setState(() {
      isNameSort = SortType.none;
      if (isPointsSort == SortType.inc) {
        isPointsSort = SortType.dec;
      } else {
        isPointsSort = SortType.inc;
      }
      if (isPointsSort == SortType.inc) {
        searchList.sort(
          (a, b) => (int.parse(a.tempPoints.toString()))
              .compareTo(int.parse(b.tempPoints.toString())),
        );
      } else {
        searchList.sort(
          (a, b) => (int.parse(b.tempPoints.toString()))
              .compareTo(int.parse(a.tempPoints.toString())),
        );
      }
    });
  }
}
