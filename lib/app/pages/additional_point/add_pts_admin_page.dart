import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/person_selector.dart';
import 'package:al_khalil/app/pages/group/group_profile.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../components/waiting_animation.dart';
import '../../utils/messges/toast.dart';

//485 -> 466
class AddPtsAdminPage extends StatefulWidget {
  const AddPtsAdminPage({super.key});

  @override
  State<AddPtsAdminPage> createState() => _AddPtsAdminPageState();
}

class _AddPtsAdminPageState extends State<AddPtsAdminPage> {
  List<AdditionalPoints>? persons;
  bool isLoadingIn = false;

  SortType isSenderSort = SortType.none;
  SortType isRecieverSort = SortType.none;
  SortType isDateSort = SortType.none;
  SortType isPointsSort = SortType.none;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshPoints();
    });
    super.initState();
  }

  Future<void> refreshStudents() async {
    final popedData = await context.myPush(const PersonSelector(withPop: true));
    if (popedData is List<Person>) {
      CustomDialog.showDialoug(
        context,
        PointSheet(
          students: popedData
              .map(
                (e) => e.toStudent,
              )
              .toList(),
        ),
        "إضافة نقاط",
      );
    }
  }

  Future<void> refreshPoints() async {
    if (isLoadingIn) {
      return;
    }
    setState(() {
      persons = null;
      isLoadingIn = true;
    });
    final state = await context
        .read<AdditionalPointsProvider>()
        .viewAdditionalPoints(AdditionalPoints());
    if (state is DataState<List<AdditionalPoints>>) {
      persons = state.data.reversed.toList();
    } else if (state is ErrorState) {
      CustomToast.handleError(state.failure);
    }
    isLoadingIn = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نقاط الطلاب")),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshStudents,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoadingIn,
            child: const LinearProgressIndicator(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshPoints,
              child: CustomTaple(
                culomn: [
                  CustomCulomnCell(
                    flex: 1,
                    text: "الأستاذ",
                    sortType: isSenderSort,
                    onSort: sortSender,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "الطالب",
                    sortType: isRecieverSort,
                    onSort: sortReciever,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "التاريخ",
                    sortType: isDateSort,
                    onSort: sortDate,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "النقاط",
                    sortType: isPointsSort,
                    onSort: sortPoints,
                  ),
                ],
                row: persons?.map(
                  (e) => CustomRow(
                    row: [
                      CustomCell(
                        text: e.senderPer?.getFullName(),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => InfoDialog(
                              title: "التفاصيل",
                              infoData: [
                                getInfoCard(
                                    "الأستاذ", e.senderPer?.getFullName()),
                                getInfoCard(
                                    "الطالب", e.recieverPep?.getFullName()),
                                getInfoCard("التاريخ", e.createdAt),
                                getInfoCard("النقاط", e.points?.toString()),
                                getInfoCard("الوصف", e.note),
                              ],
                              onDelete: () async {
                                final state = await context
                                    .read<AdditionalPointsProvider>()
                                    .deleteAdditionalPoints(e.id!);
                                if (state is DataState) {
                                  persons?.removeWhere(
                                      (element) => e.id == element.id);
                                  setState(() {});
                                  CustomToast.showToast(
                                      CustomToast.succesfulMessage);
                                } else if (state is ErrorState) {
                                  CustomToast.handleError(state.failure);
                                }
                              },
                            ),
                          );
                        },
                      ),
                      CustomCell(text: e.recieverPep?.getFullName()),
                      CustomCell(text: e.createdAt),
                      CustomCell(
                        text: e.points.toString(),
                        isDanger: e.points?.isNegative ?? false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sortSender() {
    setState(() {
      isDateSort = SortType.none;
      isPointsSort = SortType.none;
      isRecieverSort = SortType.none;
      if (isSenderSort == SortType.inc) {
        isSenderSort = SortType.dec;
      } else {
        isSenderSort = SortType.inc;
      }
      if (isSenderSort == SortType.inc) {
        persons?.sort(
          (a, b) => (a.senderPer?.getFullName() ?? "")
              .compareTo(b.senderPer?.getFullName() ?? ""),
        );
      } else {
        persons?.sort(
          (a, b) => (b.senderPer?.getFullName() ?? "")
              .compareTo(a.senderPer?.getFullName() ?? ""),
        );
      }
    });
  }

  sortReciever() {
    setState(() {
      isDateSort = SortType.none;
      isPointsSort = SortType.none;
      isSenderSort = SortType.none;
      if (isRecieverSort == SortType.inc) {
        isRecieverSort = SortType.dec;
      } else {
        isRecieverSort = SortType.inc;
      }
      if (isRecieverSort == SortType.inc) {
        persons?.sort(
          (a, b) => (a.recieverPep?.getFullName() ?? "")
              .compareTo(b.recieverPep?.getFullName() ?? ""),
        );
      } else {
        persons?.sort(
          (a, b) => (b.recieverPep?.getFullName() ?? "")
              .compareTo(a.recieverPep?.getFullName() ?? ""),
        );
      }
    });
  }

  sortDate() {
    setState(() {
      isRecieverSort = SortType.none;
      isPointsSort = SortType.none;
      isSenderSort = SortType.none;
      if (isDateSort == SortType.inc) {
        isDateSort = SortType.dec;
      } else {
        isDateSort = SortType.inc;
      }
      if (isDateSort == SortType.inc) {
        persons?.sort(
          (a, b) => (a.createdAt ?? "").compareTo(b.createdAt ?? ""),
        );
      } else {
        persons?.sort(
          (a, b) => (b.createdAt ?? "").compareTo(a.createdAt ?? ""),
        );
      }
    });
  }

  sortPoints() {
    setState(() {
      isRecieverSort = SortType.none;
      isDateSort = SortType.none;
      isSenderSort = SortType.none;
      if (isPointsSort == SortType.inc) {
        isPointsSort = SortType.dec;
      } else {
        isPointsSort = SortType.inc;
      }
      if (isPointsSort == SortType.inc) {
        persons?.sort(
          (a, b) => (a.points ?? 0).compareTo(b.points ?? 0),
        );
      } else {
        persons?.sort(
          (a, b) => (b.points ?? 0).compareTo(a.points ?? 0),
        );
      }
    });
  }

  getInfoCard(String? head, String? body) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: RichText(
          text: TextSpan(
            text: "$head : ",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: body ?? "",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
}

class InfoDialog extends StatelessWidget {
  final List<Widget> infoData;
  final String title;
  final void Function()? onEdit;
  final Future<void> Function()? onDelete;
  const InfoDialog({
    super.key,
    required this.title,
    required this.infoData,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: infoData,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (onEdit != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onEdit!();
            },
            child: const Text(
              'تعديل',
            ),
          ),
        if (onDelete != null)
          context.watch<AdditionalPointsProvider>().isLoadingIn
              ? const MyWaitingAnimation()
              : CustomTextButton(
                  onPressed: () async {
                    CustomDialog.showDeleteDialig(context).then((value) async {
                      if (value) {
                        await onDelete!().then((value) {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  },
                  color: Theme.of(context).colorScheme.error,
                  text: 'حذف',
                ),
      ],
    );
  }
}
