import 'package:al_khalil/app/components/my_info_card_button.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/pages/person/student_step.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/adminstrative_note_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/app/utils/widgets/my_button_menu.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/my_text_form_field.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/features/downloads/widgets/my_popup_menu.dart';
import 'package:al_khalil/features/quran/widgets/expanded_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/my_fab_group.dart';
import '../../utils/messges/toast.dart';
import '../attendence/attendence_page.dart';

class GroupProfile extends StatefulWidget {
  final int? id;
  const GroupProfile({super.key, this.id});

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  Group? _group;
  bool isLoading = false;
  bool _showUnActive = false;
  int? _currentExpanded;
  List<Student> _selectedStudents = [];
  Failure? failure;
  Future init() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _group = null;
      _selectedStudents = [];
    });
    await context.read<GroupProvider>().getGroup(widget.id!).then((state) {
      if (state is DataState<Group> && mounted) {
        setState(() {
          isLoading = false;
          _group = state.data;
        });
      }
      if (state is ErrorState && mounted) {
        setState(() {
          failure = state.failure;
          isLoading = false;
        });
        CustomToast.handleError(state.failure);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;
    final theme = Theme.of(context);
    return PopScope(
      canPop: _selectedStudents.isEmpty,
      onPopInvoked: (didPop) {
        if (!didPop) {
          setState(() {});
          _selectedStudents = [];
        }
      },
      child: Scaffold(
        floatingActionButton: MyFabGroup(
          fabModel: [
            FabModel(
              tag: 2,
              icon: Icons.date_range,
              onTap: () async {
                if (!myAccount!.custom!.viewAttendance) {
                  CustomToast.showToast(CustomToast.noPermissionError);
                } else {
                  context.myPush(AttendancePage(group: _group!));
                }
              },
            ),
            FabModel(
              icon: Icons.edit,
              onTap: () {
                if (_group != null) {
                  if (!myAccount!.custom!.editGroup) {
                    CustomToast.showToast(CustomToast.noPermissionError);
                  } else {
                    context.myPush(AddGroup(group: _group, fromeEdit: true));
                  }
                }
              },
              tag: 1,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: init,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                actions: [
                  if (_selectedStudents.isNotEmpty)
                    MyPopUpMenu(
                      list: [
                        MyPopUpMenu.getWithIcon(
                          "نقل",
                          CupertinoIcons.move,
                          onTap: () {
                            CustomDialog.showDialoug(
                              context,
                              MoveSheet(students: _selectedStudents),
                              "نقل طلاب",
                            );
                          },
                        ),
                        MyPopUpMenu.getWithIcon(
                          "إضافة نقاط",
                          CupertinoIcons.money_dollar_circle,
                          onTap: () {
                            CustomDialog.showDialoug(
                              context,
                              PointSheet(students: _selectedStudents),
                              "إضافة نقاط",
                            );
                          },
                        ),
                        MyPopUpMenu.getWithIcon(
                          "تغيير حالة",
                          CupertinoIcons.person_badge_minus,
                          onTap: () {
                            CustomDialog.showDialoug(
                              context,
                              StateSheet(students: _selectedStudents),
                              "تغيير حالة",
                            );
                          },
                        ),
                      ],
                    )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    _group?.groupName ?? "اسم الحلقة",
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.appBarTheme.foregroundColor,
                    ),
                  ),
                  expandedTitleScale: 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TryAgainLoader(
                    failure: failure,
                    isLoading: isLoading,
                    isData: _group != null,
                    onRetry: init,
                    child: Column(
                      children: [
                        MyTextFormField(
                          labelText: "اسم الحلقة",
                          initVal: _group?.groupName,
                          enabled: false,
                        ),
                        5.getHightSizedBox,
                        ExpandedSection(
                          color: theme.colorScheme.surfaceContainer,
                          expand: _currentExpanded == 3,
                          onTap: () {
                            if (_currentExpanded == 3) {
                              _currentExpanded = null;
                            } else {
                              _currentExpanded = 3;
                            }
                            setState(() {});
                          },
                          expandedChild: _group?.educations?.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Chip(
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    Education.getEducationFromId(e) ?? "",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child:
                              const ListTile(title: Text("المراحل التعليمية")),
                        ),
                        5.getHightSizedBox,
                        MyInfoCardButton(
                          head: "مشرف الحلقة:",
                          name: _group?.superVisor?.getFullName(),
                          onPressed: _group?.superVisor == null
                              ? null
                              : () async {
                                  await context.navigateToPerson(
                                      _group!.superVisor!.id!);
                                },
                        ),
                        5.getHightSizedBox,
                        MyInfoCardButton(
                          head: "أستاذ الحلقة:",
                          name: _group?.moderator?.getFullName(),
                          onPressed: _group?.moderator == null
                              ? null
                              : () async {
                                  await context
                                      .navigateToPerson(_group!.moderator!.id!);
                                },
                        ),
                        5.getHightSizedBox,
                        ExpandedSection(
                          color: theme.colorScheme.surfaceContainer,
                          expand: _currentExpanded == 1,
                          onTap: () {
                            setState(() {
                              if (_currentExpanded == 1) {
                                _currentExpanded = null;
                              } else {
                                _currentExpanded = 1;
                              }
                            });
                          },
                          expandedChild: (_group
                                  ?.getStudents(_showUnActive)
                                  ?.map<Widget>((e) => ListTile(
                                        onLongPress: () {
                                          if (!myAccount!
                                              .custom!.isAdminstration) {
                                            return;
                                          }
                                          if (_selectedStudents
                                              .contains(e.student)) {
                                            _selectedStudents.removeWhere(
                                                (element) =>
                                                    element.id == e.id);
                                          } else {
                                            _selectedStudents.add(e.student!);
                                          }
                                          setState(() {});
                                        },
                                        leading: _selectedStudents.isEmpty
                                            ? null
                                            : Checkbox(
                                                value: _selectedStudents
                                                    .contains(e.student),
                                                onChanged: (value) {
                                                  if (value!) {
                                                    _selectedStudents
                                                        .add(e.student!);
                                                  } else {
                                                    _selectedStudents
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                e.id);
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                        title: Text(e.getFullName(),
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(color: Colors.blue)),
                                        trailing: Text(
                                            Education.getEducationFromId(e
                                                    .education
                                                    ?.educationTypeId) ??
                                                "",
                                            style: theme.textTheme.bodyMedium),
                                        onTap: () async {
                                          if (_selectedStudents.isNotEmpty) {
                                            if (_selectedStudents
                                                .contains(e.student)) {
                                              _selectedStudents.removeWhere(
                                                  (element) =>
                                                      element.id == e.id);
                                            } else {
                                              _selectedStudents.add(e.student!);
                                            }
                                            setState(() {});
                                          } else {
                                            await context
                                                .navigateToPerson(e.id!);
                                          }
                                        },
                                      ))
                                  .toList() ??
                              [])
                            ..insert(
                              0,
                              SwitchListTile(
                                value: _showUnActive,
                                title: const Text("إظهار غير النشطين"),
                                onChanged: (val) {
                                  setState(() {
                                    _showUnActive = !_showUnActive;
                                  });
                                },
                              ),
                            ),
                          child: ListTile(
                            title: const Text("طلاب الحلقة:"),
                            leading: _selectedStudents.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      if (_selectedStudents.length !=
                                          _group?.students?.length) {
                                        _selectedStudents = _group!.students!
                                            .map((e) => e.student!)
                                            .toList();
                                      } else {
                                        _selectedStudents = [];
                                      }
                                      setState(() {});
                                    },
                                    color: _selectedStudents.length ==
                                            _group?.students?.length
                                        ? theme.colorScheme.primary
                                        : null,
                                    icon: const Icon(Icons.select_all_outlined),
                                  ),
                            trailing: Text(
                              "\t\t\t\t\t\t\t${_group?.getStudents(_showUnActive)?.length}",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                        5.getHightSizedBox,
                        ExpandedSection(
                          color: theme.colorScheme.surfaceContainer,
                          expand: _currentExpanded == 0,
                          onTap: () {
                            setState(() {
                              if (_currentExpanded == 0) {
                                _currentExpanded = null;
                              } else {
                                _currentExpanded = 0;
                              }
                            });
                          },
                          expandedChild: _group?.assistants
                                  ?.map(
                                    (e) => ListTile(
                                      title: Text(e.getFullName(),
                                          style: theme.textTheme.titleMedium!
                                              .copyWith(color: Colors.blue)),
                                      onTap: () async {
                                        await context.navigateToPerson(e.id!);
                                      },
                                    ),
                                  )
                                  .toList() ??
                              [],
                          child: ListTile(
                            title: const Text(
                              "الأساتذة المساعدون:",
                            ),
                            trailing: Text(
                                _group?.assistants?.length.toString() ?? "",
                                style: theme.textTheme.titleSmall),
                          ),
                        ),
                        5.getHightSizedBox,
                        100.getHightSizedBox,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoveSheet extends StatefulWidget {
  final List<Student> students;
  const MoveSheet({super.key, required this.students});

  @override
  State<MoveSheet> createState() => _MoveSheetState();
}

class _MoveSheetState extends State<MoveSheet> {
  bool isLoading = true;
  List<Group>? _groups;
  Group? selectedGroup;
  Failure? failure;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getGroups();
    });
    super.initState();
  }

  void _getGroups() async {
    isLoading = true;
    setState(() {});
    await Provider.of<GroupProvider>(context, listen: false)
        .getAllGroups()
        .then((state) async {
      if (state is DataState<List<Group>> && mounted) {
        _groups = state.data;
      } else if (state is ErrorState) {
        failure = state.failure;
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TryAgainLoader(
      isLoading: isLoading,
      isData: _groups != null,
      onRetry: _getGroups,
      skeletonCount: 2,
      failure: failure,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyButtonMenu(
            title: "الحلقة",
            value: selectedGroup?.groupName,
            onTap: () async {
              final group = await CustomSheet.showMyBottomSheet<Group>(
                context,
                (p0) => GroupsShooser(
                  groups: _groups!,
                  selected: selectedGroup?.id,
                ),
              );
              if (group != null) {
                setState(() {
                  selectedGroup = group;
                });
              }
            },
          ),
          10.getHightSizedBox,
          Visibility(
            visible: !context.watch<GroupProvider>().isLoadingIn,
            replacement: const MyWaitingAnimation(),
            child: CustomTextButton(
              text: "نقل",
              showBorder: true,
              onPressed: () async {
                if (selectedGroup == null) {
                  CustomToast.showToast("اختر الحلقة");
                  return;
                }
                final state = await context
                    .read<GroupProvider>()
                    .moveStudents(widget.students, selectedGroup!.id!);
                if (state is ErrorState && context.mounted) {
                  CustomToast.handleError(state.failure);
                }
                if (state is DataState && context.mounted) {
                  CustomToast.showToast(CustomToast.succesfulMessage);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StateSheet extends StatefulWidget {
  final List<Student> students;
  const StateSheet({super.key, required this.students});

  @override
  State<StateSheet> createState() => _StateSheetState();
}

class _StateSheetState extends State<StateSheet> {
  int selectedState = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyComboBox(
            text: CustomState.getStateFromId(selectedState),
            hint: "حالة الطالب",
            items: CustomState.activationStates,
            onChanged: (value) {
              setState(() {
                selectedState = CustomState.getIdFromState(value)!;
              });
            },
          ),
        ),
        10.getHightSizedBox,
        Visibility(
          visible: !context.watch<GroupProvider>().isLoadingIn,
          replacement: const MyWaitingAnimation(),
          child: CustomTextButton(
            text: "تغيير",
            showBorder: true,
            onPressed: () async {
              final state = await context
                  .read<GroupProvider>()
                  .setStudentsState(widget.students, selectedState);
              if (state is ErrorState && context.mounted) {
                CustomToast.handleError(state.failure);
              }
              if (state is DataState && context.mounted) {
                CustomToast.showToast(CustomToast.succesfulMessage);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
}

class PointSheet extends StatefulWidget {
  final List<Student> students;
  const PointSheet({super.key, required this.students});

  @override
  State<PointSheet> createState() => _PointSheetState();
}

class _PointSheetState extends State<PointSheet> {
  int? points;
  String note = "قرار إداري";
  bool isAdd = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyTextFormField(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isAdd = !isAdd;
                });
              },
              icon: isAdd ? const Icon(Icons.add) : const Icon(Icons.minimize),
            ),
            labelText: "النقاط",
            textInputType: TextInputType.number,
            initVal: points?.toString(),
            maximum: 4,
            onChanged: (p0) => points = int.tryParse(p0) ?? 0,
          ),
        ),
        10.getHightSizedBox,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyTextFormField(
            labelText: "ملاحظة",
            initVal: note,
            onChanged: (p0) => note = p0,
          ),
        ),
        10.getHightSizedBox,
        Visibility(
          visible: !context.watch<GroupProvider>().isLoadingIn,
          replacement: const MyWaitingAnimation(),
          child: CustomTextButton(
            text: "إضافة",
            onPressed: () async {
              points = points ?? 0;
              final state =
                  await context.read<GroupProvider>().evaluateStudents(
                        widget.students,
                        isAdd ? points! : -points!,
                        note,
                      );
              if (state is ErrorState && context.mounted) {
                CustomToast.handleError(state.failure);
              }
              if (state is DataState && context.mounted) {
                CustomToast.showToast(CustomToast.succesfulMessage);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
}

class AdminNotesSheet extends StatefulWidget {
  final List<Person> people;
  final AdminstrativeNote? note;
  const AdminNotesSheet({super.key, required this.people, this.note});

  @override
  State<AdminNotesSheet> createState() => _AdminNotesSheetState();
}

class _AdminNotesSheetState extends State<AdminNotesSheet> {
  late TextEditingController controller =
      TextEditingController(text: widget.note?.note);

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextFormField(
              labelText: "الملاحظة",
              maximum: 250,
              minimum: 1,
              textEditingController: controller,
            )),
        10.getHightSizedBox,
        Visibility(
          visible: !context
              .watch<AdminstrativeNoteProvider>()
              .isLoadingIn
              .contains(widget.note?.id ?? 0),
          replacement: const MyWaitingAnimation(),
          child: CustomTextButton(
            text: "إضافة",
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final note = AdminstrativeNote(
                id: widget.note?.id,
                people: widget.note?.people ?? widget.people,
                admin: widget.note?.admin ?? myAccount,
                note: controller.text,
                updatedAt:
                    widget.note?.updatedAt ?? DateTime.now().getYYYYMMDD(),
              );
              ProviderStates state;

              if (widget.note != null) {
                state = await context
                    .read<AdminstrativeNoteProvider>()
                    .editAdminstrativeNote(note);
              } else {
                state = await context
                    .read<AdminstrativeNoteProvider>()
                    .addAdminstrativeNote(note);
              }
              if (state is DataState && mounted) {
                CustomToast.showToast(CustomToast.succesfulMessage);
                Navigator.pop(context);
              } else if (state is ErrorState && mounted) {
                CustomToast.handleError(state.failure);
              }
            },
          ),
        ),
      ],
    );
  }
}
