import 'package:al_khalil/app/pages/attendence/attendence_page.dart';
import 'package:al_khalil/app/pages/memorization/memorization_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({super.key});

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  Group? _group;
  int? _selectedGroup;
  bool _isLoading = false;

  getFuture() async {
    setState(() {
      _isLoading = true;
    });
    if (_selectedGroup == null) {
      return;
    }
    await Provider.of<GroupProvider>(context, listen: false)
        .getGroup(_selectedGroup!)
        .then((state) {
      if (state is GroupState) {
        _group = state.group;
      }
      if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  late List<IdNameModel> groups;

  @override
  void initState() {
    groups = context.read<CoreProvider>().myAccount?.custom?.getGroups ?? [];

    _selectedGroup =
        context.read<CoreProvider>().myAccount?.custom?.defaultGroup;
    if (groups.length == 1) {
      _selectedGroup = groups.first.id;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        getFuture();
      });
    } else if (_selectedGroup != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        getFuture();
      });
    }
    super.initState();
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;
    return Consumer<CoreProvider>(builder: (context, value, child) {
      // groups = value.myAccount?.custom?.getGroups ?? [];
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _group == null
                    ? null
                    : () async {
                        if (!context
                            .read<CoreProvider>()
                            .myAccount!
                            .custom!
                            .viewAttendance) {
                          CustomToast.showToast(CustomToast.noPermissionError);
                        } else {
                          await context
                              .read<AttendenceProvider>()
                              .viewAttendence(
                                  _group!.id!, DateTime.now().getYYYYMMDD())
                              .then(
                            (state) async {
                              if (state is AttendenceState) {
                                if (state
                                    .attendence.studentAttendance!.isEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      if (context
                                          .read<CoreProvider>()
                                          .allowed
                                          .contains(DateTime.now().weekday)) {
                                        return AttendancePage(
                                          myRank: groups.first.myRank!,
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
                                          myRank: groups.first.myRank!,
                                          attendence: Attendence(
                                            dates: state.attendence.dates,
                                            attendenceDate: "",
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
                                    }),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AttendancePage(
                                        myRank: groups.first.myRank!,
                                        attendence: state.attendence,
                                      ),
                                    ),
                                  );
                                }
                              }
                              if (state is ErrorState) {
                                CustomToast.handleError(state.failure);
                              }
                            },
                          );
                        }
                      },
                icon: const Icon(Icons.date_range, size: 35),
              ),
              if (groups.length == 1)
                Expanded(
                  child: CustomChip(
                    onSelected: (va) {
                      setState(() {
                        _selectedGroup = groups.first.id;
                        getFuture();
                      });
                    },
                    selected: true,
                    starred: false,
                    name: groups.first.name!,
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: groups
                          .map(
                            (e) => CustomChip(
                              selected: _selectedGroup == e.id,
                              name: e.name,
                              starred: myAccount?.custom?.defaultGroup == e.id,
                              onStarTap: () async {
                                if (myAccount?.custom?.defaultGroup == e.id) {
                                  await context
                                      .read<GroupProvider>()
                                      .setDefaultGroup(null);
                                  if (mounted) {
                                    await context
                                        .read<CoreProvider>()
                                        .getCashedAccount();

                                    setState(() {});
                                  }
                                } else {
                                  await context
                                      .read<GroupProvider>()
                                      .setDefaultGroup(e.id!);
                                  if (mounted) {
                                    await context
                                        .read<CoreProvider>()
                                        .getCashedAccount();

                                    setState(() {});
                                  }
                                }
                              },
                              onSelected: (_) {
                                setState(() {
                                  _selectedGroup = e.id;
                                  groups.removeWhere(
                                    (element) => element.id == e.id,
                                  );
                                  groups.insert(0, e);
                                  controller.animateTo(
                                    0,
                                    duration: Durations.short1,
                                    curve: Curves.linear,
                                  );
                                  getFuture();
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              IconButton(
                onPressed: _group == null
                    ? null
                    : () {
                        context.navigateToGroup(_group!.id!);
                      },
                icon: const Icon(
                  Icons.info_outline,
                  size: 35,
                ),
              ),
            ],
          ),
          _isLoading
              ? getLoader()
              : _group?.id != _selectedGroup
                  ? getError()
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                          onTap: () async {
                            await context
                                .read<MemorizationProvider>()
                                .getMemorization(_group!.students![index].id!)
                                .then((state) {
                              if (state is ErrorState) {
                                CustomToast.handleError(state.failure);
                              } else if (state is QuranState) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    List<Person> listners = _group!.assistants!
                                        .map((e) => e.copy())
                                        .toList();
                                    if (_group?.moderator != null &&
                                        !listners.contains(_group!.moderator)) {
                                      listners.add(_group!.moderator!.copy());
                                    }
                                    if (myAccount != _group!.moderator &&
                                        myAccount != _group!.moderator &&
                                        !listners.contains(myAccount)) {
                                      listners.add(myAccount!.copy());
                                    }

                                    return MemorizationPage(
                                      myRank: groups.first.myRank!,
                                      listners: listners,
                                      person: _group!.students![index],
                                      quranSections: state.quranSections,
                                    );
                                    // return const QuranHomeScreen();
                                  },
                                ));
                              }
                            });
                          },
                          title: Text(
                              _group?.students?[index].getFullName() ?? ""),
                        ),
                        itemCount: _group?.students?.length,
                      ),
                    ),
        ],
      );
    });
  }

  getError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: TextButton(
          onPressed: () => getFuture(),
          child: Text(
            "إعادة المحاولة",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ),
    );
  }

  getLoader() {
    return Column(
      children: List.filled(7, const Skeleton(height: 60)),
    );
  }
}

class CustomChip extends StatelessWidget {
  final void Function()? onStarTap;
  final void Function(bool)? onSelected;
  final String? name;
  final bool selected;
  final bool starred;

  const CustomChip({
    super.key,
    this.onStarTap,
    this.onSelected,
    required this.starred,
    required this.selected,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onLongPress: onStarTap == null
            ? null
            : () {
                final RenderBox object =
                    context.findRenderObject() as RenderBox;
                final globalPosition = object.localToGlobal(Offset.zero);
                final RelativeRect menuLocation = RelativeRect.fromRect(
                  globalPosition & object.size,
                  Offset.zero & MediaQuery.of(context).size,
                );
                showMenu(
                  context: context,
                  position: menuLocation,
                  items: [
                    PopupMenuItem(
                        onTap: onStarTap,
                        child: Row(
                          children: [
                            if (starred)
                              const Text("إزالة تثبيت")
                            else
                              const Text("تثبيت"),
                            10.getWidthSizedBox,
                            const Icon(Icons.push_pin_rounded),
                          ],
                        )),
                  ],
                );
              },
        child: ChoiceChip(
          showCheckmark: false,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name ?? "", style: Theme.of(context).textTheme.titleLarge),
              5.getWidthSizedBox,
              if (starred)
                Icon(
                  Icons.push_pin_rounded,
                  color: theme.colorScheme.primary,
                )
            ],
          ),
          onSelected: onSelected,
          selected: selected,
        ),
      ),
    );
  }
}
