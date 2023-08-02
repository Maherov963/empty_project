import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/my_info_card_button.dart';
import 'package:al_khalil/app/components/my_info_list.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/attendence/attendence.dart';
import '../../../domain/models/management/person.dart';
import '../../components/my_fab_group.dart';
import '../../components/my_info_list_button.dart';
import '../../providers/managing/attendence_provider.dart';
import '../../providers/states/provider_states.dart';
import '../attendence/attendence_page.dart';

// ignore: must_be_immutable
class GroupProfile extends StatefulWidget {
  int? id;
  GroupProfile({super.key, this.id});

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  Group? _group;
  bool isLoading = true;

  init() async {
    isLoading = true;
    await context.read<GroupProvider>().getGroup(widget.id!).then((state) {
      if (state is GroupState && mounted) {
        setState(() {
          isLoading = false;
          _group = state.group;
        });
      }
      if (state is ErrorState && mounted) {
        setState(() {
          isLoading = false;
        });
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
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
      floatingActionButton: _group == null
          ? null
          : MyFabGroup(
              attendencePressed: context.watch<AttendenceProvider>().isLoadingIn
                  ? null
                  : () async {
                      if (!context
                          .read<CoreProvider>()
                          .myAccount!
                          .custom!
                          .viewAttendance) {
                        MySnackBar.showMySnackBar(
                            "لا تملك الصلاحيات الكافية", context,
                            contentType: ContentType.warning, title: "الخليل");
                      } else {
                        await context
                            .read<AttendenceProvider>()
                            .viewAttendence(
                                _group!.id!, DateTime.now().getYYYYMMDD())
                            .then((state) async {
                          if (state is AttendenceState) {
                            if (state.attendence.studentAttendance!.isEmpty) {
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
                                      myRank: IdNameModel.asAdmin,
                                      attendence: Attendence(
                                        dates: state.attendence.dates,
                                        attendenceDate:
                                            DateTime.now().getYYYYMMDD(),
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
                                  } else {
                                    return AttendancePage(
                                      myRank: IdNameModel.asAdmin,
                                      attendence: Attendence(
                                        dates: state.attendence.dates,
                                        attendenceDate:
                                            DateTime.now().getYYYYMMDD(),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AttendancePage(
                                      myRank: IdNameModel.asAdmin,
                                      attendence: state.attendence,
                                    ),
                                  ));
                            }
                          }
                          if (state is ErrorState) {
                            MySnackBar.showMySnackBar(
                                state.failure.message, context,
                                contentType: ContentType.failure,
                                title: "الخليل");
                          }
                        });
                      }
                    },
              editPressed: () {
                if (!context
                    .read<CoreProvider>()
                    .myAccount!
                    .custom!
                    .editGroup) {
                  MySnackBar.showMySnackBar("لاتملك الصلاحيات الكافية", context,
                      contentType: ContentType.warning, title: "الخليل");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddGroup(group: _group, fromeEdit: true),
                      ));
                }
              },
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
                              MyInfoCard(
                                head: "صف الحلقة:",
                                body: _group?.classs,
                              ),
                              MyInfoCardButton(
                                head: "مشرف الحلقة:",
                                name: _group!.superVisor == null
                                    ? null
                                    : _group!.superVisor!.getFullName(),
                                onPressed: _group!.superVisor == null
                                    ? null
                                    : context
                                                .watch<PersonProvider>()
                                                .isLoadingPerson ==
                                            _group!.superVisor!.id!
                                        ? null
                                        : () async {
                                            await MyRouter.navigateToPerson(
                                                context,
                                                _group!.superVisor!.id!);
                                          },
                              ),
                              MyInfoCardButton(
                                head: "أستاذ الحلقة:",
                                name: _group!.moderator == null
                                    ? null
                                    : _group!.moderator!.getFullName(),
                                onPressed: _group!.moderator == null
                                    ? null
                                    : context
                                                .watch<PersonProvider>()
                                                .isLoadingPerson ==
                                            _group!.moderator!.id!
                                        ? null
                                        : () async {
                                            await MyRouter.navigateToPerson(
                                                context,
                                                _group!.moderator!.id!);
                                          },
                              ),
                              MyInfoCard(
                                head: "موعد الجلسة:",
                                body: _group!.privateMeeting,
                              ),
                              MyInfoList(
                                title: "طلاب الحلقة",
                                subtitle: Text(
                                    "العدد : ${_group?.students?.length}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                                data: _group!.students!
                                    .map((e) => MyInfoListButton(
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          idNameModel: IdNameModel(
                                            id: e.id,
                                            name: e.getFullName(),
                                          ),
                                          classs: e.education?.educationType,
                                          onPressed: context
                                                      .watch<PersonProvider>()
                                                      .isLoadingPerson ==
                                                  e.id
                                              ? null
                                              : () async {
                                                  await MyRouter
                                                      .navigateToPerson(
                                                          context, e.id!);
                                                },
                                        ))
                                    .toList(),
                              ),
                              MyInfoList(
                                title: "الأساتذة المساعدون:",
                                subtitle: Text(
                                    "العدد : ${_group?.assistants?.length}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),
                                data: _group!.assistants!
                                    .map((e) => MyInfoListButton(
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          idNameModel: IdNameModel(
                                            id: e.id,
                                            name: e.getFullName(),
                                          ),
                                          onPressed: context
                                                      .watch<PersonProvider>()
                                                      .isLoadingPerson ==
                                                  e.id
                                              ? null
                                              : () async {
                                                  await MyRouter
                                                      .navigateToPerson(
                                                          context, e.id!);
                                                },
                                        ))
                                    .toList(),
                              ),
                              100.getHightSizedBox(),
                            ],
                          )),
          ),
        ],
      ),
    );
  }

  getError() {
    return Column(
      children: [
        100.getHightSizedBox(),
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
