import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../../domain/models/models.dart';
import '../../components/my_info_card.dart';
import '../../components/my_info_card_edit.dart';
import '../../components/waiting_animation.dart';
import '../../providers/managing/additional_points_provider.dart';
import '../../utils/messges/toast.dart';

class AddPointsPage extends StatefulWidget {
  final List<AdditionalPoints> addPoints;
  final Person sender;
  final Person reciever;
  const AddPointsPage(
      {super.key,
      required this.addPoints,
      required this.sender,
      required this.reciever});

  @override
  State<AddPointsPage> createState() => _AddPointsPageState();
}

class _AddPointsPageState extends State<AddPointsPage> {
  AdditionalPoints draft = AdditionalPoints();
  int? isPressed;
  late int max;
  late int maxDefault = 25;
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    max = maxDefault;
    widget.addPoints.map((e) {
      max = max - (e.points ?? 0);
    }).toList();
    return Scaffold(
      appBar:
          AppBar(title: Text("إضافة نقاط ل${widget.reciever.getFullName()} ")),
      floatingActionButton: FloatingActionButton(
        onPressed: context.watch<AdditionalPointsProvider>().isLoadingIn
            ? null
            : () async {
                if (widget.addPoints.length >= 5 || max == 0) {
                  CustomToast.showToast("لقد وصلت إلى الحد اليومي");
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AddPtsDialog(
                        max: max,
                        reciever: widget.reciever,
                        sender: widget.sender),
                  ).then((value) {
                    if (value is AdditionalPoints) {
                      setState(() {
                        isPressed = null;
                        widget.addPoints.add(value);
                      });
                    }
                  });
                }
              },
        child: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isPressed = null;
          });
        },
        child: Form(
          key: _key,
          child: ListView.builder(
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  draft = widget.addPoints[index].copyWith();
                  isPressed = index;
                });
              },
              child: AnimatedSwitcher(
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 300),
                child: isPressed != index
                    ? MyInfoCard(
                        key: Key("$index a"),
                        body: "النقاط : ${widget.addPoints[index].points}",
                        head: "الوصف : ${widget.addPoints[index].note}")
                    : MyInfoCardEdit(
                        key: Key("$index b"),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(((draft.points ?? 0)).toString()),
                                Expanded(
                                  child: Slider(
                                    value: (draft.points ?? 0) / 100,
                                    min: 0,
                                    max: (max +
                                            (widget.addPoints[index].points ??
                                                0)) /
                                        100,
                                    divisions: ((max +
                                                (widget.addPoints[index]
                                                        .points ??
                                                    0)) /
                                            5)
                                        .floor(),
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
                              textInputType: TextInputType.multiline,
                              minimum: 3,
                              onChanged: (p0) => draft.note = p0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                context
                                        .watch<AdditionalPointsProvider>()
                                        .isLoadingIn
                                    ? const MyWaitingAnimation()
                                    : CustomTextButton(
                                        onPressed: () async {
                                          CustomDialog.showDeleteDialig(context)
                                              .then((value) async {
                                            if (value) {
                                              await context
                                                  .read<
                                                      AdditionalPointsProvider>()
                                                  .deleteAdditionalPoints(
                                                      draft.id!)
                                                  .then((state) {
                                                if (state is DataState) {
                                                  setState(() {
                                                    isPressed = null;
                                                    widget.addPoints
                                                        .removeAt(index);
                                                  });
                                                  CustomToast.showToast(
                                                      CustomToast
                                                          .succesfulMessage);
                                                } else if (state
                                                    is ErrorState) {
                                                  CustomToast.handleError(
                                                      state.failure);
                                                }
                                              });
                                            }
                                          });
                                        },
                                        text: "حذف",
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                context
                                        .watch<AdditionalPointsProvider>()
                                        .isLoadingIn
                                    ? const MyWaitingAnimation()
                                    : CustomTextButton(
                                        onPressed: () async {
                                          if (draft.points == null ||
                                              draft.points == 0) {
                                            CustomToast.showToast(
                                                "اختر قيمة النقاط");
                                          } else if ((_key.currentState!
                                              .validate())) {
                                            AdditionalPoints draftAccepted =
                                                draft.copyWith();
                                            await context
                                                .read<
                                                    AdditionalPointsProvider>()
                                                .editAdditionalPoints(draft)
                                                .then((state) {
                                              if (state is DataState) {
                                                setState(() {
                                                  widget.addPoints[index] =
                                                      draftAccepted.copyWith();
                                                  isPressed = null;
                                                });
                                                CustomToast.showToast(
                                                    state.data);
                                              } else if (state is ErrorState) {
                                                CustomToast.showToast(
                                                    state.failure.message);
                                              }
                                            });
                                          }
                                        },
                                        text: "حفظ",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                CustomTextButton(
                                  onPressed: () {
                                    setState(() {
                                      isPressed = null;
                                    });
                                  },
                                  text: "إلغاء",
                                  color: Theme.of(context).disabledColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            itemCount: widget.addPoints.length,
          ),
        ),
      ),
    );
  }
}

class AddPtsDialog extends StatefulWidget {
  const AddPtsDialog(
      {super.key,
      required this.max,
      required this.sender,
      required this.reciever});
  final int max;
  final Person sender;
  final Person reciever;
  @override
  State<AddPtsDialog> createState() => _AddPtsDialogState();
}

class _AddPtsDialogState extends State<AddPtsDialog> {
  final _key = GlobalKey<FormState>();
  late final AdditionalPoints draft = AdditionalPoints(
      createdAt: DateTime.now().getYYYYMMDD(),
      senderPer: widget.sender,
      recieverPep: widget.reciever,
      note: widget.sender.custom!.admin ? "قرار إداري" : null);
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
                        min: 0,
                        max: widget.max / 100,
                        divisions: (widget.max / 5).round(),
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
                  textInputType: TextInputType.multiline,
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
              : CustomTextButton(
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
                  color: Theme.of(context).colorScheme.primary,
                  text: "حفظ",
                ),
          CustomTextButton(
            color: Theme.of(context).disabledColor,
            onPressed: () {
              Navigator.pop(context);
            },
            text: "إلغاء",
          ),
        ],
      ),
    );
  }
}
