import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/my_info_card_button.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/features/quran/widgets/expanded_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/attendence/attendence.dart';
import '../../components/my_fab_group.dart';
import '../../providers/managing/attendence_provider.dart';
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
  bool isLoading = true;
  bool _showUnActive = false;
  int? _currentExpanded;

  init() async {
    isLoading = true;
    await context.read<GroupProvider>().getGroup(widget.id!).then((state) {
      if (state is DataState<Group> && mounted) {
        setState(() {
          isLoading = false;
          _group = state.data;
        });
      }
      if (state is ErrorState && mounted) {
        setState(() {
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
    return Scaffold(
      floatingActionButton: MyFabGroup(
        fabModel: [
          FabModel(
            tag: 2,
            icon: Icons.date_range,
            onTap: () async {
              if (_group != null) {
                if (!context
                    .read<CoreProvider>()
                    .myAccount!
                    .custom!
                    .viewAttendance) {
                  CustomToast.showToast(CustomToast.noPermissionError);
                } else {
                  await context
                      .read<AttendenceProvider>()
                      .viewAttendence(_group!.id!, DateTime.now().getYYYYMMDD())
                      .then((state) async {
                    if (state is DataState<Attendence>) {
                      if (state.data.studentAttendance!.isEmpty) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            if (context
                                    .read<CoreProvider>()
                                    .allowed
                                    .contains(DateTime.now().weekday) ||
                                context
                                    .read<CoreProvider>()
                                    .myAccount!
                                    .custom!
                                    .admin ||
                                context
                                    .read<CoreProvider>()
                                    .myAccount!
                                    .custom!
                                    .manager) {
                              return AttendancePage(
                                attendence: Attendence(
                                  dates: state.data.dates,
                                  attendenceDate: DateTime.now().getYYYYMMDD(),
                                  studentAttendance: _group!
                                      .getStudents(false)!
                                      .map((e) => StudentAttendece(
                                          person: Person(
                                              id: e.id,
                                              firstName: e.firstName,
                                              lastName: e.lastName)))
                                      .toList(),
                                  groupId: _group!.id,
                                ),
                              );
                            } else {
                              return AttendancePage(
                                attendence: Attendence(
                                  dates: state.data.dates,
                                  attendenceDate: DateTime.now().getYYYYMMDD(),
                                  studentAttendance: _group!.students!
                                      .map((e) => StudentAttendece(
                                          person: Person(
                                              id: e.id,
                                              firstName: e.firstName,
                                              lastName: e.lastName)))
                                      .toList(),
                                  groupId: _group!.id,
                                ),
                              );
                            }
                          },
                        ));
                      } else {
                        context.myPush(AttendancePage(attendence: state.data));
                      }
                    }
                    if (state is ErrorState) {
                      CustomToast.handleError(state.failure);
                    }
                  });
                }
              }
            },
          ),
          FabModel(
            icon: Icons.edit,
            onTap: () {
              if (_group != null) {
                if (!context
                    .read<CoreProvider>()
                    .myAccount!
                    .custom!
                    .editGroup) {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _group?.groupName ?? "اسم الحلقة",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
              expandedTitleScale: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _group == null && isLoading
                  ? getLoader()
                  : _group == null
                      ? getError()
                      : Column(
                          children: [
                            MyInfoCard(
                              head: "اسم الحلقة:",
                              body: _group?.groupName,
                            ),
                            ExpandedSection(
                              color: Theme.of(context).focusColor,
                              expand: _currentExpanded == 3,
                              onTap: () {
                                setState(() {
                                  if (_currentExpanded == 3) {
                                    _currentExpanded = null;
                                  } else {
                                    _currentExpanded = 3;
                                  }
                                });
                              },
                              expandedChild: _group!.educations!
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Chip(
                                        label: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            Education.getEducationFromId(e) ??
                                                "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              child: const ListTile(
                                  title: Text("المراحل التعليمية")),
                            ),
                            5.getHightSizedBox,
                            MyInfoCardButton(
                              head: "مشرف الحلقة:",
                              name: _group?.superVisor?.getFullName(),
                              onPressed: _group!.superVisor == null
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
                              onPressed: _group!.moderator == null
                                  ? null
                                  : () async {
                                      await context.navigateToPerson(
                                          _group!.moderator!.id!);
                                    },
                            ),
                            MyInfoCard(
                              head: "موعد الجلسة:",
                              body: _group!.privateMeeting,
                            ),
                            ExpandedSection(
                              color: Theme.of(context).focusColor,
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
                              expandedChild: _group!
                                  .getStudents(_showUnActive)!
                                  .map<Widget>((e) => ListTile(
                                        title: Text(e.getFullName(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.blue)),
                                        trailing: Text(
                                            Education.getEducationFromId(e
                                                    .education
                                                    ?.educationTypeId) ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        onTap: () async {
                                          await context.navigateToPerson(e.id!);
                                        },
                                      ))
                                  .toList()
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
                                trailing: Text(
                                    "\t\t\t\t\t\t\t${_group!.getStudents(_showUnActive)!.length}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ),
                            ),
                            5.getHightSizedBox,
                            ExpandedSection(
                              color: Theme.of(context).focusColor,
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
                              expandedChild: _group!.assistants!
                                  .map(
                                    (e) => ListTile(
                                      title: Text(e.getFullName(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.blue)),
                                      onTap: () async {
                                        await context.navigateToPerson(e.id!);
                                      },
                                    ),
                                  )
                                  .toList(),
                              child: ListTile(
                                title: const Text(
                                  "الأساتذة المساعدون:",
                                ),
                                trailing: Text(
                                    _group!.assistants!.length.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ),
                            ),
                            100.getHightSizedBox,
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  getError() {
    return Column(
      children: [
        100.getHightSizedBox,
        TextButton(
          onPressed: () {
            setState(() {
              init();
            });
          },
          child: Text(
            "إعادة المحاولة",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ],
    );
  }

  getLoader() {
    return const Column(
      children: [
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
      ],
    );
  }
}
