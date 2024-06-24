import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../../domain/models/models.dart';
import '../../components/waiting_animation.dart';
import '../../providers/managing/additional_points_provider.dart';
import '../../utils/messges/toast.dart';

class AddPointsPage extends StatefulWidget {
  final Person reciever;
  const AddPointsPage({
    super.key,
    required this.reciever,
  });

  @override
  State<AddPointsPage> createState() => _AddPointsPageState();
}

class _AddPointsPageState extends State<AddPointsPage> {
  List<AdditionalPoints>? addPoints;

  AdditionalPoints draft = AdditionalPoints();

  late int max;
  late int maxDefault = 25;
  bool _isLoading = false;
  Failure? failure;
  late final myAccount = context.read<CoreProvider>().myAccount;
  final _key = GlobalKey<FormState>();
  Future getPoints() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    setState(() {});
    final state = await context
        .read<AdditionalPointsProvider>()
        .viewAdditionalPoints(AdditionalPoints(
          recieverPep: widget.reciever,
          senderPer: myAccount,
          createdAt: DateTime.now().getYYYYMMDD(),
        ));
    if (state is DataState<List<AdditionalPoints>>) {
      addPoints = state.data;
    } else if (state is ErrorState) {
      failure = state.failure;
      CustomToast.handleError(state.failure);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => getPoints(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    max = maxDefault;
    addPoints?.map((e) {
      max = max - (e.points ?? 0);
    }).toList();
    return Scaffold(
      appBar:
          AppBar(title: Text("إضافة نقاط ل${widget.reciever.getFullName()} ")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (addPoints == null ||
              context.read<AdditionalPointsProvider>().isLoadingIn) {
            return;
          }
          if (addPoints!.length >= 5 || max == 0) {
            CustomToast.showToast("لقد وصلت إلى الحد اليومي");
          } else {
            final value = await showDialog(
              context: context,
              builder: (context) => AddPtsDialog(
                max: max,
                additionalPoints: AdditionalPoints(
                  createdAt: DateTime.now().getYYYYMMDD(),
                  senderPer: myAccount,
                  recieverPep: widget.reciever,
                ),
              ),
            );
            if (value is AdditionalPoints) {
              addPoints?.add(value);
              setState(() {});
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: TryAgainLoader(
        isLoading: _isLoading,
        onRetry: getPoints,
        isData: addPoints != null,
        failure: failure,
        child: Form(
          key: _key,
          child: RefreshIndicator(
            onRefresh: getPoints,
            child: CustomTaple(
              culomn: const [
                CustomCulomnCell(text: "الوصف"),
                CustomCulomnCell(text: "النقاط"),
                CustomCulomnCell(text: "تعديل"),
              ],
              row: addPoints?.map(
                (e) => CustomRow(
                  row: [
                    CustomCell(text: e.note),
                    CustomCell(text: e.points.toString()),
                    CustomIconCell(
                      icon: Icons.edit,
                      onTap: () async {
                        if (context
                            .read<AdditionalPointsProvider>()
                            .isLoadingIn) {
                          return;
                        }
                        final value = await showDialog(
                          context: context,
                          builder: (context) => AddPtsDialog(
                            max: max + e.points!,
                            additionalPoints: e,
                          ),
                        );
                        if (value is int) {
                          addPoints?.remove(e);
                          setState(() {});
                        } else if (value is AdditionalPoints) {
                          e.points = value.points;
                          e.note = value.note;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddPtsDialog extends StatefulWidget {
  const AddPtsDialog({
    super.key,
    required this.max,
    required this.additionalPoints,
  });
  final int max;
  final AdditionalPoints additionalPoints;
  @override
  State<AddPtsDialog> createState() => _AddPtsDialogState();
}

class _AddPtsDialogState extends State<AddPtsDialog> {
  final _key = GlobalKey<FormState>();
  late final AdditionalPoints draft = widget.additionalPoints.copyWith();
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AdditionalPointsProvider>().isLoadingIn;

    return AlertDialog(
      title: const Text("إضافة نقاط"),
      content: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      actions: [
        Visibility(
          replacement: const MyWaitingAnimation(),
          visible: !isLoading,
          child: CustomTextButton(
            text: "حفظ",
            onPressed: () async {
              if (draft.points == null || draft.points == 0) {
                CustomToast.showToast("اختر قيمة النقاط");
              } else if ((_key.currentState!.validate())) {
                if (draft.id == null) {
                  final state = await context
                      .read<AdditionalPointsProvider>()
                      .addAdditionalPoints(draft);
                  if (state is DataState<int>) {
                    CustomToast.showToast(CustomToast.succesfulMessage);
                    draft.id = state.data;
                    Navigator.pop<AdditionalPoints>(context, draft);
                  } else if (state is ErrorState) {
                    CustomToast.handleError(state.failure);
                  }
                } else {
                  final state = await context
                      .read<AdditionalPointsProvider>()
                      .editAdditionalPoints(draft);
                  if (state is DataState) {
                    CustomToast.showToast(CustomToast.succesfulMessage);
                    Navigator.pop<AdditionalPoints>(context, draft);
                  } else if (state is ErrorState) {
                    CustomToast.handleError(state.failure);
                  }
                }
              }
            },
          ),
        ),
        if (draft.id != null)
          Visibility(
            replacement: const MyWaitingAnimation(),
            visible: !isLoading,
            child: CustomTextButton(
              text: "حذف",
              color: Theme.of(context).colorScheme.error,
              onPressed: () async {
                final ensure = await CustomDialog.showDeleteDialig(context);
                if (!ensure) return;
                final state = await context
                    .read<AdditionalPointsProvider>()
                    .deleteAdditionalPoints(draft.id!);
                if (state is DataState) {
                  CustomToast.showToast(CustomToast.succesfulMessage);
                  Navigator.pop(context, draft.id);
                } else if (state is ErrorState) {
                  CustomToast.handleError(state.failure);
                }
              },
            ),
          )
      ],
    );
  }
}
