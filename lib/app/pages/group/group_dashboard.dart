import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/cell.dart';
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
    _students = 0;
    context
        .read<GroupProvider>()
        .groups
        .forEach((e) => _students += e.students!.length);
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refresh();
    });
    super.initState();
  }

  int _students = 0;
  bool isStudentsInc = false;
  bool isClasssInc = false;
  bool isNameInc = false;

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
          Container(
            constraints: const BoxConstraints(minHeight: 50),
            child: Row(
              children: [
                MyCell(
                  text: "اسم الحلقة",
                  flex: 4,
                  isTitle: true,
                  onTap: () async {},
                ),
                MyCell(
                  text: "الصف",
                  flex: 6,
                  isTitle: true,
                  onTap: () async {
                    setState(
                      () {
                        isClasssInc = !isClasssInc;
                        if (isClasssInc) {
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
                      },
                    );
                  },
                ),
                MyCell(
                  onTap: () async {
                    setState(() {
                      isStudentsInc = !isStudentsInc;
                      if (isStudentsInc) {
                        context.read<GroupProvider>().groups.sort(
                              (a, b) => a.students!.length
                                  .compareTo(b.students!.length),
                            );
                      } else {
                        context.read<GroupProvider>().groups.sort(
                              (a, b) => b.students!.length
                                  .compareTo(a.students!.length),
                            );
                      }
                    });
                  },
                  text: "الطلاب",
                  flex: 2,
                  isTitle: true,
                  tooltip:
                      context.watch<GroupProvider>().totalStudent.toString(),
                ),
              ],
            ),
          ),
          Selector<GroupProvider, List<Group>>(
            selector: (p0, p1) => p1.groups,
            builder: (__, value, _) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () => refresh(),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            MyCell(
                              text: value[index].groupName,
                              flex: 4,
                              isButton: true,
                              textColor: Theme.of(context).colorScheme.tertiary,
                              onTap: context
                                          .watch<GroupProvider>()
                                          .isLoadingGroup ==
                                      value[index].id
                                  ? null
                                  : () async {
                                      await context
                                          .navigateToGroup(value[index].id!);
                                    },
                            ),
                            MyCell(
                              text: value[index].getEducations,
                              flex: 6,
                            ),
                            MyCell(
                              text: value[index].students?.length.toString(),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: value.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  buildCellText(String? text) {
    return Text(
      text ?? "",
      maxLines: 2,
      overflow: TextOverflow.visible,
    );
  }
}
/**
 * 
 * 
 * DataTable2(
                    columnSpacing: 40,
                    horizontalMargin: 12,
                    columns: [
                      DataColumn(
                        label: const Text("اسم الحلقة"),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            isNameInc = !isNameInc;
                            if (isNameInc) {
                              context.read<GroupProvider>().groups.sort(
                                    (a, b) => (a.groupName ?? "")
                                        .compareTo(b.groupName ?? ""),
                                  );
                            } else {
                              context.read<GroupProvider>().groups.sort(
                                    (a, b) => (b.groupName ?? "")
                                        .compareTo(a.groupName ?? ""),
                                  );
                            }
                          });
                        },
                      ),
                      DataColumn(
                        label: Text("الصف"),
                      ),
                      DataColumn(
                        label: Text("عدد الطلاب"),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      value.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(buildCellText(value[index].groupName)),
                          DataCell(buildCellText(value[index].getEducations)),
                          DataCell(buildCellText(
                              value[index].students!.length.toString())),
                        ],
                      ),
                    ),
                  ),
              
 * 
 * 

          
 * 
 * 
 * 
 * 
 */