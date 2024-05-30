import 'package:al_khalil/app/components/chooser_list.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/home/dynamic_banner.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_checkbox.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/app/utils/widgets/my_text_form_field.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/custom.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionStep extends StatefulWidget {
  final Custom custom;
  const PermissionStep({super.key, required this.custom});

  @override
  State<PermissionStep> createState() => _PermissionStepState();
}

class _PermissionStepState extends State<PermissionStep> {
  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount!;

    return !myAccount.custom!.appoint
        ? const Center(child: Text(CustomToast.noPermissionError))
        : Column(
            children: [
              DynamicBanner(
                color: Colors.red,
                visable: CustomState.getStateFromId(widget.custom.state) !=
                    CustomState.active,
                text: "حالة الأستاذ غير نشط",
                icon: Icons.warning_amber,
              ),
              10.getHightSizedBox,
              MyComboBox(
                text: CustomState.getStateFromId(widget.custom.state),
                hint: "حالة الأستاذ",
                items: CustomState.activationStates,
                onChanged: (value) {
                  setState(() {
                    widget.custom.state = CustomState.getIdFromState(value);
                  });
                },
              ),
              MyCheckBox(
                val: widget.custom.admin,
                text: "admin",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.admin = p0!;
                  widget.custom.tester = p0;
                  widget.custom.manager = p0;
                  widget.custom.moderator = p0;
                  widget.custom.supervisor = p0;
                  widget.custom.assistant = p0;
                  widget.custom.custom = p0;
                  widget.custom.adder = p0;
                  widget.custom.reciter = p0;
                  widget.custom.seller = p0;
                  widget.custom.viewPerson = p0;
                  widget.custom.viewPeople = p0;
                  widget.custom.addPerson = p0;
                  widget.custom.editPerson = p0;
                  widget.custom.viewGroups = p0;
                  widget.custom.viewGroup = p0;
                  widget.custom.appointStudent = p0;
                  widget.custom.viewRecite = p0;
                  widget.custom.appoint = p0;
                  widget.custom.deletePerson = p0;
                  widget.custom.addGroup = p0;
                  widget.custom.editGroup = p0;
                  widget.custom.deleteGroup = p0;
                  widget.custom.observe = p0;
                  widget.custom.recite = p0;
                  widget.custom.test = p0;
                  widget.custom.sell = p0;
                  widget.custom.attendance = p0;
                  widget.custom.viewAttendance = p0;
                  widget.custom.evaluation = p0;
                  widget.custom.level = p0;
                  widget.custom.viewLog = p0;
                },
              ),
              MyCheckBox(
                val: widget.custom.tester,
                text: "tester",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.tester = p0!;
                  widget.custom.test = p0;
                  widget.custom.viewGroup = p0;
                  widget.custom.viewPerson = p0;
                  widget.custom.viewRecite = p0;
                  widget.custom.editPerson = p0;
                },
              ),
              MyCheckBox(
                val: widget.custom.manager,
                text: "manager",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.manager = p0!;
                },
              ),
              Column(
                children: [
                  MyCheckBox(
                    val: widget.custom.moderator,
                    text: "moderator",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.moderator = p0!;
                      widget.custom.editPerson = p0;
                      widget.custom.viewPerson = p0;
                      widget.custom.appointStudent = p0;
                      widget.custom.viewGroup = p0;
                      widget.custom.recite = p0;
                      widget.custom.viewRecite = p0;
                      widget.custom.attendance = p0;
                      widget.custom.viewAttendance = p0;
                      widget.custom.evaluation = p0;
                    },
                  ),
                  !widget.custom.moderator
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "الحلقات الخاصة بالأستاذ",
                          text: "اختر حلقة للإضافة",
                          isPerson: false,
                          choosingData: widget.custom.moderatorGroups!,
                          insertPressed: context
                                  .watch<GroupProvider>()
                                  .isLoadingIn
                              ? null
                              : () async {
                                  await context
                                      .read<GroupProvider>()
                                      .getAllGroups()
                                      .then((state) async {
                                    if (state is GroupsState) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          context: context,
                                          isPerson: false,
                                          data: state.groups
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: "${e.groupName}"))
                                              .toList(),
                                          choosen: List.generate(
                                              widget.custom.moderatorGroups!
                                                  .length,
                                              (index) => IdNameModel(
                                                  id: widget
                                                      .custom
                                                      .moderatorGroups![index]
                                                      .id,
                                                  name: widget
                                                      .custom
                                                      .moderatorGroups![index]
                                                      .name)));

                                      setState(() {
                                        widget.custom.moderatorGroups =
                                            x ?? widget.custom.moderatorGroups;
                                      });
                                    }
                                    if (state is ErrorState &&
                                        context.mounted) {
                                      CustomToast.handleError(state.failure);
                                    }
                                  });
                                },
                        )
                ],
              ),
              Column(
                children: [
                  MyCheckBox(
                    val: widget.custom.supervisor,
                    text: "supervisor",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.supervisor = p0!;
                      widget.custom.viewGroup = p0;
                      widget.custom.editPerson = p0;
                      widget.custom.viewGroups = p0;
                      widget.custom.viewPeople = p0;
                      widget.custom.viewPerson = p0;
                      widget.custom.viewRecite = p0;
                      widget.custom.viewAttendance = p0;
                    },
                  ),
                  !widget.custom.supervisor
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "الحلقات الخاصة بالمشرف",
                          text: "اختر حلقة للإضافة",
                          isPerson: false,
                          choosingData: widget.custom.superVisorGroups!,
                          insertPressed: context
                                  .watch<GroupProvider>()
                                  .isLoadingIn
                              ? null
                              : () async {
                                  await context
                                      .read<GroupProvider>()
                                      .getAllGroups()
                                      .then((state) async {
                                    if (state is GroupsState) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          // title: "اختر حلقة للإضافة",
                                          context: context,
                                          isPerson: false,
                                          data: state.groups
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: "${e.groupName}"))
                                              .toList(),
                                          choosen: List.generate(
                                              widget.custom.superVisorGroups!
                                                  .length,
                                              (index) => IdNameModel(
                                                  id: widget
                                                      .custom
                                                      .superVisorGroups![index]
                                                      .id,
                                                  name: widget
                                                      .custom
                                                      .superVisorGroups![index]
                                                      .name)));

                                      setState(() {
                                        widget.custom.superVisorGroups =
                                            x ?? widget.custom.superVisorGroups;
                                      });
                                    }
                                    if (state is ErrorState &&
                                        context.mounted) {
                                      CustomToast.handleError(state.failure);
                                    }
                                  });
                                },
                        )
                ],
              ),
              Column(
                children: [
                  MyCheckBox(
                    val: widget.custom.assistant,
                    text: "assistant",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.assistant = p0!;
                      widget.custom.viewGroup = p0;
                      widget.custom.recite = p0;
                      widget.custom.viewRecite = p0;
                      widget.custom.editPerson = p0;
                    },
                  ),
                  !widget.custom.assistant
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "حلقات الأستاذ المساعد",
                          text: "اختر حلقة للإضافة",
                          isPerson: false,
                          choosingData: widget.custom.assitantsGroups!,
                          insertPressed: context
                                  .watch<GroupProvider>()
                                  .isLoadingIn
                              ? null
                              : () async {
                                  await context
                                      .read<GroupProvider>()
                                      .getAllGroups()
                                      .then((state) async {
                                    if (state is GroupsState) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          context: context,
                                          isPerson: false,
                                          data: state.groups
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: "${e.groupName}"))
                                              .toList(),
                                          choosen: List.generate(
                                              widget.custom.assitantsGroups!
                                                  .length,
                                              (index) => IdNameModel(
                                                  id: widget
                                                      .custom
                                                      .assitantsGroups![index]
                                                      .id,
                                                  name: widget
                                                      .custom
                                                      .assitantsGroups![index]
                                                      .name)));

                                      setState(() {
                                        widget.custom.assitantsGroups =
                                            x ?? widget.custom.assitantsGroups;
                                      });
                                    }
                                    if (state is ErrorState &&
                                        context.mounted) {
                                      CustomToast.handleError(state.failure);
                                    }
                                  });
                                },
                        )
                ],
              ),
              MyCheckBox(
                val: widget.custom.custom,
                text: "custom",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.custom = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.adder,
                text: "adder",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.adder = p0!;
                  widget.custom.viewPeople = p0;
                  widget.custom.viewPerson = p0;
                  widget.custom.addPerson = p0;
                  widget.custom.editPerson = p0;
                  widget.custom.viewGroups = p0;
                  widget.custom.viewGroup = p0;
                  widget.custom.appointStudent = p0;
                },
              ),
              MyCheckBox(
                val: widget.custom.reciter,
                text: "reciter",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.reciter = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.seller,
                text: "seller",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.seller = p0!;
                },
              ),
              const Divider(),
              MyCheckBox(
                val: widget.custom.viewPerson,
                text: "viewPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewPerson = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewPeople,
                text: "viewPeople",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewPeople = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.addPerson,
                text: "addPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.addPerson = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.editPerson,
                text: "editPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.editPerson = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewGroups,
                text: "viewGroups",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewGroups = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewGroup,
                text: "viewGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewGroup = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.appointStudent,
                text: "appointStudent",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.appointStudent = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewRecite,
                text: "viewRecite",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewRecite = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.appoint,
                text: "appoint",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.appoint = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.deletePerson,
                text: "deletePerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.deletePerson = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.addGroup,
                text: "addGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.addGroup = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.editGroup,
                text: "editGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.editGroup = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.deleteGroup,
                text: "deleteGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.deleteGroup = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.observe,
                text: "observe",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.observe = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.recite,
                text: "recite",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.recite = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.test,
                text: "test",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.test = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.sell,
                text: "sell",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.sell = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.attendance,
                text: "attendance",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.attendance = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewAttendance,
                text: "viewAttendance",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewAttendance = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.evaluation,
                text: "evaluation",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.evaluation = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.level,
                text: "level",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.level = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewLog,
                text: "viewLog",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewLog = p0!;
                },
              ),
              MyTextFormField(
                labelText: "ملاحظات",
                maximum: 1000,
                initVal: widget.custom.note,
                onChanged: (p0) => widget.custom.note = p0,
              ),
              100.getHightSizedBox,
            ],
          );
  }
}
