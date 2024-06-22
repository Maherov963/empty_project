import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/pages/additional_point/students_page_add_pts.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../../domain/models/management/person.dart';
import '../../components/waiting_animation.dart';
import '../../providers/managing/person_provider.dart';
import '../../utils/messges/toast.dart';

//485
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

  Future<void> refreshStudents(BuildContext context) async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getStudentsForTesters();
      if (state is DataState<List<Person>> && context.mounted) {
        showModalBottomSheet(
                isScrollControlled: true,
                showDragHandle: true,
                useSafeArea: true,
                context: context,
                builder: (context) => StudentsAddPtsPage(students: state.data))
            .then((value) {
          if (value is AdditionalPoints) {
            setState(() {
              persons?.add(value);
            });
          }
        });
      }
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);
      }
    }
  }

  refReshPoints() async {
    if (isLoadingIn) {
      return;
    }
    setState(() {
      persons = null;
      isLoadingIn = true;
    });
    await context
        .read<AdditionalPointsProvider>()
        .viewAdditionalPoints(AdditionalPoints())
        .then((state) {
      if (state is DataState<List<AdditionalPoints>>) {
        setState(() {
          persons = state.data.reversed.toList();
        });
      } else if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نقاط الطلاب")),
      floatingActionButton: FloatingActionButton(
        onPressed: context.watch<PersonProvider>().isLoadingIn
            ? null
            : () async {
                await refreshStudents(context);
              },
        child: context.watch<PersonProvider>().isLoadingIn
            ? const MyWaitingAnimation(
                color: Colors.white,
              )
            : const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Visibility(
            visible: context.watch<AdditionalPointsProvider>().isLoadingIn,
            child: const LinearProgressIndicator(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: CustomTaple(
                culomn: [
                  CustomCulomnCell(
                    flex: 1,
                    text: "الأستاذ",
                    sortType: SortType.none,
                    onSort: sortSender,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "الطالب",
                    sortType: SortType.none,
                    onSort: sortSender,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "التاريخ",
                    sortType: SortType.none,
                    onSort: sortSender,
                  ),
                  CustomCulomnCell(
                    flex: 1,
                    text: "النقاط",
                    sortType: SortType.none,
                    onSort: sortSender,
                  ),
                ],
                row: persons
                        ?.map(
                          (e) => CustomRow(
                            row: [
                              CustomCell(text: e.senderPer?.getFullName()),
                              CustomCell(text: e.recieverPep?.getFullName()),
                              CustomCell(text: e.createdAt),
                              CustomCell(text: e.points.toString()),
                            ],
                          ),
                        )
                        .toList() ??
                    [],
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

/**child: ListView.builder(
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          MyCell(
                            text: addPoints[index].senderPer?.getFullName(),
                            flex: 6,
                            textColor: Theme.of(context).colorScheme.tertiary,
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                  title: "التفاصيل",
                                  infoData: [
                                    getInfoCard(
                                        "الأستاذ",
                                        addPoints[index]
                                            .senderPer
                                            ?.getFullName()),
                                    getInfoCard(
                                        "الطالب",
                                        addPoints[index]
                                            .recieverPep
                                            ?.getFullName()),
                                    getInfoCard(
                                        "التاريخ", addPoints[index].createdAt),
                                    getInfoCard("النقاط",
                                        addPoints[index].points?.toString()),
                                    getInfoCard("الوصف", addPoints[index].note),
                                  ],
                                  onDelete: () async {
                                    await context
                                        .read<AdditionalPointsProvider>()
                                        .deleteAdditionalPoints(
                                            addPoints[index].id!)
                                        .then((state) {
                                      if (state is DataState) {
                                        setState(() {
                                          addPoints.removeAt(index);
                                        });
                                        CustomToast.showToast(
                                            CustomToast.succesfulMessage);
                                      } else if (state is ErrorState) {
                                        CustomToast.handleError(state.failure);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          MyCell(
                            text: addPoints[index].recieverPep?.getFullName(),
                            flex: 6,
                          ),
                          MyCell(
                            text: addPoints[index].createdAt,
                            flex: 6,
                          ),
                          MyCell(
                            text: addPoints[index].points?.toString(),
                            flex: 6,
                            textColor: (addPoints[index].points ?? 0) > 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                    ),
                    itemCount: addPoints.length,
                  ), */
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
        CustomTextButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'حسناً',
        ),
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

class AddPtsDialog extends StatefulWidget {
  const AddPtsDialog({super.key, required this.sender, required this.reciever});
  final Person sender;
  final Person reciever;
  @override
  State<AddPtsDialog> createState() => _AddPtsDialogState();
}

class _AddPtsDialogState extends State<AddPtsDialog> {
  final _key = GlobalKey<FormState>();
  late final AdditionalPoints draft = AdditionalPoints(
    senderPer: widget.sender,
    recieverPep: widget.reciever,
    note: widget.sender.custom!.admin ? "قرار إداري" : null,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: const Text("إضافة نقاط"),
        content: Form(
          key: _key,
          child: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView(
              children: [
                Row(
                  children: [
                    Text(((draft.points ?? 0)).toString()),
                    Expanded(
                      child: Slider(
                        value: (draft.points ?? 0) / 100,
                        min: -1,
                        label: ((draft.points ?? 0)).toString(),
                        onChanged: (value) {
                          setState(() {
                            draft.points = (value * 100).toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                MyTextFormField(
                  labelText: "الوصف",
                  initVal: draft.note,
                  minimum: 2,
                  onChanged: (p0) => draft.note = p0,
                ),
              ],
            ),
          ),
        ),
        actions: [
          context.watch<AdditionalPointsProvider>().isLoadingIn
              ? const MyWaitingAnimation()
              : ElevatedButton(
                  onPressed: () async {
                    if (draft.points == null || draft.points == 0) {
                      CustomToast.showToast("اختر قيمة النقاط");
                    } else if ((_key.currentState!.validate())) {
                      await context
                          .read<AdditionalPointsProvider>()
                          .addAdditionalPoints(draft)
                          .then((state) {
                        if (state is DataState<int>) {
                          CustomToast.showToast(CustomToast.succesfulMessage);
                          draft.id = state.data;
                          Navigator.pop<AdditionalPoints>(context, draft);
                        } else if (state is ErrorState) {
                          CustomToast.handleError(state.failure);
                        }
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).dialogBackgroundColor),
                    foregroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.onSecondary),
                  ),
                  child: const Text("حفظ"),
                ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).dialogBackgroundColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
        ],
      ),
    );
  }
}
