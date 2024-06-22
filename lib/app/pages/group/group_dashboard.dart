import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GroupDash extends StatefulWidget {
  const GroupDash({super.key});

  @override
  State<GroupDash> createState() => _GroupDashState();
}

class _GroupDashState extends State<GroupDash> {
  Future<void> refresh() async {
    GroupProvider prov = context.read<GroupProvider>();
    if (!prov.isLoadingIn) {
      final state = await prov.getAllGroups();
      if (state is DataState<List<Group>>) {
        prov.groups = state.data;
        prov.totalStudent = 0;
        for (var e in prov.groups) {
          prov.totalStudent = prov.totalStudent + e.students!.length;
        }
        calculateStudents();
      }
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);
      }
    }
  }

  calculateStudents() {
    if (context.mounted) {
      _students = 0;
      context
          .read<GroupProvider>()
          .groups
          .forEach((e) => _students += e.students!.length);
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refresh();
    });
    super.initState();
  }

  int _students = 0;
  SortType isStudentsSort = SortType.none;
  SortType isClasssSort = SortType.none;
  SortType isNameSort = SortType.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سجل الحلقات $_students"),
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.replay_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: context.watch<GroupProvider>().isLoadingIn,
            child: const LinearProgressIndicator(),
          ),
          Selector<GroupProvider, List<Group>>(
            selector: (p0, p1) => p1.groups,
            builder: (__, value, _) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () => refresh(),
                  child: CustomTaple(
                      culomn: [
                        CustomCulomnCell(
                          sortType: isNameSort,
                          flex: 4,
                          text: "اسم الحلقة",
                          onSort: onNameSort,
                        ),
                        CustomCulomnCell(
                          flex: 6,
                          text: "الصف",
                          sortType: isClasssSort,
                          onSort: onClassSort,
                        ),
                        CustomCulomnCell(
                          flex: 2,
                          text: "الطلاب",
                          sortType: isStudentsSort,
                          onSort: onStudentSort,
                        ),
                      ],
                      row: value
                          .map(
                            (e) => CustomRow(
                              row: [
                                CustomCell(
                                  flex: 4,
                                  text: e.groupName,
                                  onTap: () {
                                    context.navigateToGroup(e.id!);
                                  },
                                ),
                                CustomCell(flex: 6, text: e.getEducations),
                                CustomCell(
                                    flex: 2, text: "${e.students?.length}"),
                              ],
                            ),
                          )
                          .toList()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  onNameSort() {
    setState(() {
      isStudentsSort = SortType.none;
      isClasssSort = SortType.none;
      if (isNameSort == SortType.inc) {
        isNameSort = SortType.dec;
      } else {
        isNameSort = SortType.inc;
      }
      if (isNameSort == SortType.inc) {
        context.read<GroupProvider>().groups.sort(
              (a, b) => (a.groupName ?? "").compareTo(b.groupName ?? ""),
            );
      } else {
        context.read<GroupProvider>().groups.sort(
              (a, b) => (b.groupName ?? "").compareTo(a.groupName ?? ""),
            );
      }
    });
  }

  onClassSort() {
    setState(() {
      isStudentsSort = SortType.none;
      isNameSort = SortType.none;
      if (isClasssSort == SortType.inc) {
        isClasssSort = SortType.dec;
      } else {
        isClasssSort = SortType.inc;
      }
      if (isClasssSort == SortType.inc) {
        context.read<GroupProvider>().groups.sort(
              (a, b) => (a.educations?.firstOrNull ?? 0)
                  .compareTo(b.educations?.firstOrNull ?? 0),
            );
      } else {
        context.read<GroupProvider>().groups.sort(
              (a, b) => (b.educations?.firstOrNull ?? 0)
                  .compareTo(a.educations?.firstOrNull ?? 0),
            );
      }
    });
  }

  onStudentSort() {
    setState(() {
      isClasssSort = SortType.none;
      isNameSort = SortType.none;
      if (isStudentsSort == SortType.inc) {
        isStudentsSort = SortType.dec;
      } else {
        isStudentsSort = SortType.inc;
      }
      if (isStudentsSort == SortType.inc) {
        context.read<GroupProvider>().groups.sort(
              (a, b) => a.students!.length.compareTo(b.students!.length),
            );
      } else {
        context.read<GroupProvider>().groups.sort(
              (a, b) => b.students!.length.compareTo(a.students!.length),
            );
      }
    });
  }
}
