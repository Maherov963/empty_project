import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:al_khalil/features/quran/widgets/expanded_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/chooser_button.dart';
import '../../components/chooser_list.dart';
import '../../components/my_snackbar.dart';
import '../../components/waiting_animation.dart';
import '../../utils/messges/toast.dart';
import '../../utils/widgets/my_text_form_field.dart';

class AddGroup extends StatefulWidget {
  final Group? group;
  final bool fromeEdit;
  const AddGroup({super.key, this.group, this.fromeEdit = false});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  Group group = Group(
    assistants: const [],
    students: const [],
    // ignore: prefer_const_literals_to_create_immutables
    educations: [],
  );

  IdNameModel moderator = IdNameModel();
  IdNameModel supervisor = IdNameModel();
  List<IdNameModel> students = [];
  List<IdNameModel> assistants = [];
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.group != null) {
      group = widget.group!.copy();
      if (group.superVisor != null) {
        supervisor = IdNameModel(
            id: group.superVisor!.id, name: group.superVisor!.getFullName());
      }
      if (group.moderator != null) {
        moderator = IdNameModel(
            id: group.moderator!.id, name: group.moderator!.getFullName());
      }
      students = group.students!
          .map((e) => IdNameModel(id: e.id, name: e.getFullName()))
          .toList();
      assistants = widget.group!.assistants!
          .map((e) => IdNameModel(id: e.id, name: e.getFullName()))
          .toList();
    }
    super.initState();
  }

  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (can) async {
        if (can) {
          return;
        }
        final canPop =
            await CustomDialog.showYesNoDialog(context, "لن يتم حفظ التغييرات");
        if (canPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Consumer<GroupProvider>(
        builder: (_, value, __) => Form(
          key: key,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 150,
                  actions: [
                    IconButton(
                        onPressed: value.isLoadingIn
                            ? null
                            : () async {
                                if (widget.fromeEdit) {
                                  await _editGroup(context);
                                } else {
                                  await _addGroup(context);
                                }
                              },
                        icon: value.isLoadingIn
                            ? const MyWaitingAnimation()
                            : const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      children: [
                        Text(
                          widget.fromeEdit ? "تعديل حلقة" : "حلقة جديدة",
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                          ),
                        ),
                      ],
                    ),
                    expandedTitleScale: 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          MyTextFormField(
                            initVal: group.groupName,
                            onChanged: (p0) => group.groupName = p0,
                            labelText: "اسم الحلقة:",
                            minimum: 3,
                          ),
                          10.getHightSizedBox,
                          ExpandedSection(
                            onTap: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                            expand: _expanded,
                            expandedChild: [
                              IconButton(
                                onPressed: () {
                                  CustomSheet.showMyBottomSheet(
                                    context,
                                    MultiSelectChip(
                                      options: Education.educationTypesIds,
                                      selected: group.educations!,
                                      onChange: (p0) {
                                        setState(
                                          () {
                                            if (group.educations!
                                                .contains(p0)) {
                                              group.educations!.remove(p0);
                                            } else {
                                              group.educations!.add(p0);
                                            }
                                            group.educations!.sort();
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                              ...group.educations!
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Chip(
                                        deleteIcon: const Icon(Icons.close),
                                        deleteIconColor: Colors.red,
                                        onDeleted: () {
                                          setState(() {
                                            group.educations!.remove(e);
                                          });
                                        },
                                        label: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                              Education.getEducationFromId(e)
                                                  .toString()),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                            child: const ListTile(
                                title: Text("المراحل التعليمية")),
                          ),
                          // MyComboBox(
                          //   text: Education.getEducationFromId(group.classs),
                          //   onChanged: (p0) {
                          //     group.classs = Education.getIdFromEducation(p0);
                          //   },
                          //   items: context.read<CoreProvider>().educationTypes,
                          // ),
                          10.getHightSizedBox,
                          ChooserButtonn(
                            title: "أستاذ الحلقة",
                            text: "اختر أستاذاً للإضافة",
                            controller: moderator,
                            onPressed: () async {
                              await context.navigateToPerson(moderator.id!);
                            },
                            insertPressed: context
                                    .watch<PersonProvider>()
                                    .isLoadingModerators
                                ? null
                                : () async {
                                    await context
                                        .read<PersonProvider>()
                                        .getModerators()
                                        .then((state) async {
                                      if (state is DataState<List<Person>>) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                          disableMulti: true,
                                          context: context,
                                          data: state.data
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: e.getFullName()))
                                              .toList(),
                                          choosen: [],
                                        );
                                        setState(() {
                                          moderator =
                                              x?.firstOrNull ?? moderator;
                                        });
                                      }
                                      if (state is ErrorState &&
                                          context.mounted) {
                                        CustomToast.handleError(state.failure);
                                      }
                                    });
                                  },
                          ),
                          10.getHightSizedBox,
                          ChooserButtonn(
                            title: "مشرف الحلقة",
                            text: "اختر مشرفاً للإضافة",
                            controller: supervisor,
                            onPressed: () async {
                              await context.navigateToPerson(supervisor.id!);
                            },
                            insertPressed: context
                                    .watch<PersonProvider>()
                                    .isLoadingSupervisors
                                ? null
                                : () async {
                                    await context
                                        .read<PersonProvider>()
                                        .getSupervisors()
                                        .then((state) async {
                                      if (state is DataState<List<Person>>) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                          disableMulti: true,
                                          context: context,
                                          data: state.data
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: e.getFullName()))
                                              .toList(),
                                          choosen: [],
                                        );
                                        setState(() {
                                          supervisor =
                                              x?.firstOrNull ?? supervisor;
                                        });
                                      }
                                      if (state is ErrorState &&
                                          context.mounted) {
                                        CustomToast.handleError(state.failure);
                                      }
                                    });
                                  },
                          ),

                          5.getHightSizedBox,
                          ChooserListo(
                            title: "طلاب الحلقة",
                            text: "اختر طلاب الحلقة",
                            isPerson: true,
                            choosingData: students,
                            insertPressed: context
                                    .watch<PersonProvider>()
                                    .isLoadingIn
                                ? null
                                : () async {
                                    await context
                                        .read<PersonProvider>()
                                        .getAllPersons(
                                            person: Person(
                                                student: Student(
                                                    state:
                                                        CustomState.activeId)))
                                        .then((state) async {
                                      if (state is DataState<List<Person>>) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                          context: context,
                                          data: state.data
                                              .map((e) => IdNameModel(
                                                  id: e.id,
                                                  name: e.getFullName()))
                                              .toList(),
                                          choosen: students
                                              .map((e) => e.copy())
                                              .toList(),
                                        );

                                        setState(() {
                                          if (x != null) {
                                            students =
                                                x.map((e) => e.copy()).toList();
                                          }
                                        });
                                      }
                                      if (state is ErrorState &&
                                          context.mounted) {
                                        CustomToast.handleError(state.failure);
                                      }
                                    });
                                  },
                          ),
                          ChooserListo(
                            title: "الأساتذة المساعدون",
                            text: "اختر أستاذاً",
                            isPerson: true,
                            choosingData: assistants,
                            insertPressed: context
                                    .watch<PersonProvider>()
                                    .isLoadingAssistants
                                ? null
                                : () async {
                                    await context
                                        .read<PersonProvider>()
                                        .getAssistants()
                                        .then((state) async {
                                      if (state is DataState<List<Person>>) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                                context: context,
                                                data: state.data
                                                    .map((e) => IdNameModel(
                                                        id: e.id,
                                                        name: e.getFullName()))
                                                    .toList(),
                                                choosen: assistants
                                                    .map((e) => IdNameModel(
                                                        id: e.id, name: e.name))
                                                    .toList());
                                        setState(() {
                                          if (x != null) {
                                            assistants =
                                                x.map((e) => e.copy()).toList();
                                          }
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addGroup(BuildContext context) async {
    if (group.educations!.isEmpty) {
      CustomToast.showToast("أدخل المرحلة التعليمية");
    } else if (key.currentState!.validate()) {
      group.assistants = assistants.map((e) => Person(id: e.id)).toList();
      group.students = students.map((e) => Person(id: e.id)).toList();
      group.superVisor = Person(id: supervisor.id, firstName: supervisor.name);
      group.moderator = Person(id: moderator.id, firstName: moderator.name);
      final ProviderStates state =
          await context.read<GroupProvider>().addGroup(group);
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);
        context.myPushReplacment(const AddGroup());
      }
    }
  }

  _editGroup(BuildContext context) async {
    if (key.currentState!.validate()) {
      group.assistants = assistants.map((e) => Person(id: e.id)).toList();
      group.students = students.map((e) => Person(id: e.id)).toList();
      group.superVisor = Person(id: supervisor.id);
      group.moderator = Person(id: moderator.id);
      final ProviderStates state =
          await context.read<GroupProvider>().editGroup(group);
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);
        Navigator.pop(context);
      }
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<int> options;
  final List<int> selected;
  final Function(int) onChange;
  const MultiSelectChip({
    super.key,
    required this.onChange,
    required this.options,
    required this.selected,
  });

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  void _onSelectionChanged(int choice, bool selected) {
    widget.onChange.call(choice);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: widget.options
            .map(
              (choice) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip.elevated(
                  padding: const EdgeInsets.all(4),
                  label: Text(Education.getEducationFromId(choice).toString()),
                  selected: widget.selected.contains(choice),
                  onSelected: (selected) =>
                      _onSelectionChanged(choice, selected),
                  color: WidgetStatePropertyAll(
                      !widget.selected.contains(choice)
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
