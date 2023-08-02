import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/chooser_button.dart';
import '../../components/chooser_list.dart';
import '../../components/my_snackbar.dart';
import '../../components/waiting_animation.dart';
import '../../providers/states/provider_states.dart';
import '../../utils/widgets/my_compobox.dart';
import '../../utils/widgets/my_text_form_field.dart';
import '../auth/log_in.dart';

class AddGroup extends StatefulWidget {
  final Group? group;
  final bool fromeEdit;
  const AddGroup({super.key, this.group, this.fromeEdit = false});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  Group group = Group(
    students: const [],
    assistants: const [],
    state: IdNameModel(),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تحذير'),
              content: const Text('لن يتم حفظ التغييرات'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('نعم')),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('لا')),
              ],
            );
          },
        );
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // color: Colors.grey[800],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                              initVal: group.groupName,
                              onChanged: (p0) => group.groupName = p0,
                              labelText: "اسم الحلقة:",
                              minimum: 3,
                            ),
                          ),
                          MyInfoCardEdit(
                            child: Row(
                              children: [
                                const Text("صف الحلقة"),
                                10.getWidthSizedBox(),
                                Expanded(
                                    child: MyComboBox(
                                        text: group.classs,
                                        onChanged: (p0) {
                                          group.classs = p0;
                                        },
                                        items: context
                                            .read<CoreProvider>()
                                            .educationTypes)),
                              ],
                            ),
                          ),
                          ChooserButtonn(
                            title: "أستاذ الحلقة",
                            text: "اختر أستاذاً للإضافة",
                            controller: moderator,
                            onPressed: context
                                        .watch<PersonProvider>()
                                        .isLoadingPerson ==
                                    moderator.id
                                ? null
                                : () async {
                                    await MyRouter.navigateToPerson(
                                        context, moderator.id!);
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
                                      if (state is PersonsState) {
                                        var choosen =
                                            await MySnackBar.showMyChooseOne(
                                                stPer: 2,
                                                title: "اختر أستاذاً للإضافة",
                                                context: context,
                                                data: state.persons
                                                    .map((e) => IdNameModel(
                                                        id: e.id,
                                                        name:
                                                            "${e.firstName} ${e.lastName}"))
                                                    .toList(),
                                                idNameModel: moderator);
                                        setState(() {
                                          moderator = choosen ?? moderator;
                                        });
                                      }
                                      if (state is ErrorState &&
                                          context.mounted) {
                                        MySnackBar.showMySnackBar(
                                            state.failure.message, context,
                                            contentType: ContentType.failure,
                                            title: "حدث خطأ");
                                      }
                                    });
                                  },
                          ),
                          ChooserButtonn(
                            title: "مشرف الحلقة",
                            text: "اختر مشرفاً للإضافة",
                            controller: supervisor,
                            onPressed: context
                                        .watch<PersonProvider>()
                                        .isLoadingPerson ==
                                    supervisor.id
                                ? null
                                : () async {
                                    await MyRouter.navigateToPerson(
                                        context, supervisor.id!);
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
                                      if (state is PersonsState) {
                                        var choosen =
                                            await MySnackBar.showMyChooseOne(
                                                stPer: 2,
                                                title: "اختر مشرفاً للإضافة",
                                                context: context,
                                                data: state.persons
                                                    .map((e) => IdNameModel(
                                                        id: e.id,
                                                        name:
                                                            "${e.firstName} ${e.lastName}"))
                                                    .toList(),
                                                idNameModel: supervisor);
                                        setState(() {
                                          supervisor = choosen ?? supervisor;
                                        });
                                      }
                                      if (state is ErrorState &&
                                          context.mounted) {
                                        MySnackBar.showMySnackBar(
                                            state.failure.message, context,
                                            contentType: ContentType.failure,
                                            title: "حدث خطأ");
                                      }
                                    });
                                  },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                                initVal: group.privateMeeting,
                                onChanged: (p0) => group.privateMeeting = p0,
                                labelText: "موعد الجلسة:"),
                          ),
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
                                            person: Person(student: Student()))
                                        .then((state) async {
                                      if (state is PersonsState) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                          context: context,
                                          data: state.persons
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
                                        MySnackBar.showMySnackBar(
                                            state.failure.message, context,
                                            contentType: ContentType.failure,
                                            title: "حدث خطأ");
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
                                      if (state is PersonsState) {
                                        var x =
                                            await MySnackBar.showMyltiPicker(
                                                context: context,
                                                data: state.persons
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
                                        MySnackBar.showMySnackBar(
                                            state.failure.message, context,
                                            contentType: ContentType.failure,
                                            title: "حدث خطأ");
                                      }
                                    });
                                  },
                          )
                        ],
                      )),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addGroup(BuildContext context) async {
    if (group.classs == null) {
      MySnackBar.showMySnackBar("أدخل صف الحلقة", context,
          contentType: ContentType.warning, title: "تحذير");
    } else if (key.currentState!.validate()) {
      group.assistants = assistants.map((e) => Person(id: e.id)).toList();
      group.students = students.map((e) => Person(id: e.id)).toList();
      group.superVisor = Person(id: supervisor.id, firstName: supervisor.name);
      group.moderator = Person(id: moderator.id, firstName: moderator.name);
      final ProviderStates state =
          await context.read<GroupProvider>().addGroup(group);
      if (state is PermissionState && context.mounted) {
        MySnackBar.showMySnackBar(
            "لقد تم النعديل على صلاحيات يرجى اعادة تسجيل الدخول", context,
            contentType: ContentType.failure, title: "حدث خطأ");
        context.read<CoreProvider>().signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ),
            (route) => false);
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGroup(),
            ));
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
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        Navigator.pop(
          context,
        );
      }
    }
  }
}
