import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../components/my_snackbar.dart';
import '../../utils/widgets/cell.dart';

class GroupDash extends StatefulWidget {
  const GroupDash({super.key});

  @override
  State<GroupDash> createState() => _GroupDashState();
}

class _GroupDashState extends State<GroupDash> {
  Future<void> refresh(BuildContext context) async {
    GroupProvider prov = context.read<GroupProvider>();
    if (!prov.isLoadingIn) {
      final state = await prov.getAllGroups();
      if (state is GroupsState) {
        prov.groups = state.groups;
        prov.totalStudent = 0;
        for (var e in prov.groups) {
          prov.totalStudent = prov.totalStudent + e.students!.length;
        }
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  bool isStudentsInc = false;
  bool isClasssInc = false;
  bool isNameInc = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الحلقات"),
      ),
      body: Column(
        children: [
          Visibility(
            visible: context.watch<GroupProvider>().isLoadingIn,
            child: const LinearProgressIndicator(),
          ),
          Row(
            children: [
              MyCell(
                text: "اسم الحلقة",
                flex: 5,
                isTitle: true,
                onTap: () async {
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
              MyCell(
                text: "الصف",
                flex: 4,
                isTitle: true,
                onTap: () async {
                  setState(
                    () {
                      isClasssInc = !isClasssInc;
                      if (isClasssInc) {
                        context.read<GroupProvider>().groups.sort(
                              (a, b) =>
                                  (a.classs ?? "").compareTo(b.classs ?? ""),
                            );
                      } else {
                        context.read<GroupProvider>().groups.sort(
                              (a, b) =>
                                  (b.classs ?? "").compareTo(a.classs ?? ""),
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
                tooltip: context.watch<GroupProvider>().totalStudent.toString(),
              ),
            ],
          ),
          Selector<GroupProvider, List<Group>>(
            selector: (p0, p1) => p1.groups,
            builder: (__, value, _) {
              return Expanded(
                child: RefreshIndicator(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  color: Theme.of(context).colorScheme.onSecondary,
                  onRefresh: () => refresh(context),
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            MyCell(
                              text: value[index].groupName,
                              flex: 5,
                              isButton: true,
                              textColor: Theme.of(context).colorScheme.tertiary,
                              onTap: context
                                          .watch<GroupProvider>()
                                          .isLoadingGroup ==
                                      value[index].id
                                  ? null
                                  : () async {
                                      await MyRouter.navigateToGroup(
                                          context, value[index].id!);
                                    },
                            ),
                            MyCell(
                              text: value[index].classs,
                              flex: 4,
                            ),
                            MyCell(
                              text: value[index].students?.length.toString(),
                              flex: 2,
                            ),
                          ],
                        );
                      },
                      itemCount: value.length,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
