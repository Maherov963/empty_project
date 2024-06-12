import 'package:al_khalil/app/components/chooser_list.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/home/dynamic_banner.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_checkbox.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/app/utils/widgets/my_text_form_field.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionStep extends StatefulWidget {
  final Custom custom;
  final bool enabled;
  const PermissionStep({
    super.key,
    required this.custom,
    this.enabled = true,
  });

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
              // 10.getHightSizedBox,
              // Expanded(
              //   child: ListView.builder(
              //       itemCount: 5,
              //       scrollDirection: Axis.horizontal,
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) => Text("data")),
              // ),
              10.getHightSizedBox,
              MyComboBox(
                text: CustomState.getStateFromId(widget.custom.state),
                hint: "حالة الأستاذ",
                enabled: widget.enabled,
                items: CustomState.activationStates,
                onChanged: (value) {
                  setState(() {
                    widget.custom.state = CustomState.getIdFromState(value);
                  });
                },
              ),
              MyCheckBox(
                val: widget.custom.admin,
                editable: widget.enabled,
                text: "admin",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.admin = p0!;
                  widget.custom.refreshPermissionAfterRule(p0);
                },
              ),
              MyCheckBox(
                val: widget.custom.tester,
                editable: widget.enabled,
                text: "tester",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.tester = p0!;
                  widget.custom.refreshPermissionAfterRule(p0);

                  // widget.custom.test = p0;
                  // widget.custom.viewGroup = p0;
                  // widget.custom.viewPerson = p0;
                  // widget.custom.viewRecite = p0;
                  // widget.custom.editPerson = p0;
                },
              ),
              MyCheckBox(
                val: widget.custom.manager,
                editable: widget.enabled,
                text: "manager",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.manager = p0!;
                  widget.custom.refreshPermissionAfterRule(p0);
                },
              ),
              Column(
                children: [
                  MyCheckBox(
                    val: widget.custom.moderator,
                    editable: widget.enabled,
                    text: "moderator",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.moderator = p0!;
                      widget.custom.refreshPermissionAfterRule(p0);

                      // widget.custom.editPerson = p0;
                      // widget.custom.viewPerson = p0;
                      // widget.custom.appointStudent = p0;
                      // widget.custom.viewGroup = p0;
                      // widget.custom.recite = p0;
                      // widget.custom.viewRecite = p0;
                      // widget.custom.attendance = p0;
                      // widget.custom.viewAttendance = p0;
                      // widget.custom.evaluation = p0;
                    },
                  ),
                  !widget.custom.moderator
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "الحلقات الخاصة بالأستاذ",
                          text: "اختر حلقة للإضافة",
                          enabled: widget.enabled,
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
                                    if (state is DataState<List<Group>>) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          context: context,
                                          isPerson: false,
                                          data: state.data
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
                    editable: widget.enabled,
                    text: "supervisor",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.supervisor = p0!;
                      widget.custom.refreshPermissionAfterRule(p0);
                      // widget.custom.viewGroup = p0;
                      // widget.custom.viewGroups = p0;
                      // widget.custom.viewPeople = p0;
                      // widget.custom.viewPerson = p0;
                      // widget.custom.viewRecite = p0;
                      // widget.custom.viewAttendance = p0;
                    },
                  ),
                  !widget.custom.supervisor
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "الحلقات الخاصة بالمشرف",
                          text: "اختر حلقة للإضافة",
                          enabled: widget.enabled,
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
                                    if (state is DataState<List<Group>>) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          // title: "اختر حلقة للإضافة",
                                          context: context,
                                          isPerson: false,
                                          data: state.data
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
                    editable: widget.enabled,
                    text: "assistant",
                    onChanged: (p0) {
                      setState(() {});
                      widget.custom.assistant = p0!;
                      widget.custom.refreshPermissionAfterRule(p0);

                      // widget.custom.viewGroup = p0;
                      // widget.custom.recite = p0;
                      // widget.custom.viewRecite = p0;
                      // widget.custom.editPerson = p0;
                    },
                  ),
                  !widget.custom.assistant
                      ? const SizedBox.shrink()
                      : ChooserListo(
                          title: "حلقات الأستاذ المساعد",
                          text: "اختر حلقة للإضافة",
                          enabled: widget.enabled,
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
                                    if (state is DataState<List<Group>>) {
                                      var x = await MySnackBar.showMyltiPicker(
                                          context: context,
                                          isPerson: false,
                                          data: state.data
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
                val: widget.custom.adder,
                editable: widget.enabled,
                text: "adder",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.adder = p0!;
                  widget.custom.refreshPermissionAfterRule(p0);

                  // widget.custom.viewPeople = p0;
                  // widget.custom.viewPerson = p0;
                  // widget.custom.addPerson = p0;
                  // widget.custom.editPerson = p0;
                  // widget.custom.viewGroups = p0;
                  // widget.custom.viewGroup = p0;
                  // widget.custom.appointStudent = p0;
                },
              ),
              const Divider(),
              MyCheckBox(
                val: widget.custom.viewPerson,
                editable: widget.enabled,
                text: "viewPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewPerson = p0!;
                },
              ),
              MyCheckBox(
                val: widget.custom.viewPeople,
                editable: widget.enabled,
                text: "viewPeople",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewPeople = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.addPerson,
                text: "addPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.addPerson = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.editPerson,
                text: "editPerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.editPerson = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.viewGroups,
                text: "viewGroups",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewGroups = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.viewGroup,
                text: "viewGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewGroup = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.appointStudent,
                text: "appointStudent",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.appointStudent = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.viewRecite,
                text: "viewRecite",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewRecite = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.appoint,
                text: "appoint",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.appoint = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.deletePerson,
                text: "deletePerson",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.deletePerson = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.addGroup,
                text: "addGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.addGroup = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.editGroup,
                text: "editGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.editGroup = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.deleteGroup,
                text: "deleteGroup",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.deleteGroup = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.recite,
                text: "recite",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.recite = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.test,
                text: "test",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.test = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.attendance,
                text: "attendance",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.attendance = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.viewAttendance,
                text: "viewAttendance",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.viewAttendance = p0!;
                },
              ),
              MyCheckBox(
                editable: widget.enabled,
                val: widget.custom.evaluation,
                text: "evaluation",
                onChanged: (p0) {
                  setState(() {});
                  widget.custom.evaluation = p0!;
                },
              ),
              MyTextFormField(
                labelText: "ملاحظات",
                enabled: widget.enabled,
                maximum: 1000,
                initVal: widget.custom.note,
                onChanged: (p0) => widget.custom.note = p0,
              ),
              100.getHightSizedBox,
            ],
          );
  }
}
