import 'package:al_khalil/app/pages/additional_point/add_pts_moderator_page.dart';
import 'package:al_khalil/app/pages/attendence/attendence_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
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
      if (state is DataState<Group>) {
        _group = state.data
          ..students?.removeWhere(
            (e) => e.student?.state != CustomState.activeId,
          );
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
      groups.sort((a, b) => a.id == _selectedGroup ? 0 : 1);
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
                              if (state is DataState<Attendence>) {
                                if (state.data.studentAttendance!.isEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      if (context
                                          .read<CoreProvider>()
                                          .allowed
                                          .contains(DateTime.now().weekday)) {
                                        return AttendancePage(
                                          attendence: Attendence(
                                            dates: state.data.dates,
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
                                          attendence: Attendence(
                                            dates: state.data.dates,
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
                                  context.myPush(
                                    AttendancePage(
                                      attendence: state.data,
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
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Divider(thickness: 0.4),
                        itemBuilder: (context, index) => ListTile(
                          onTap: () async {
                            context.myPush(QuranHomeScreen(
                              reason: PageState.reciting,
                              student: _group?.students?[index],
                            ));
                          },
                          trailing: CustomTextButton(
                            onPressed: () async {
                              await context
                                  .read<AdditionalPointsProvider>()
                                  .viewAdditionalPoints(AdditionalPoints(
                                    recieverPep: _group!.students![index],
                                    senderPer: myAccount,
                                    createdAt: DateTime.now().getYYYYMMDD(),
                                  ))
                                  .then((state) {
                                if (state
                                    is DataState<List<AdditionalPoints>>) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPointsPage(
                                        addPoints: state.data,
                                        sender: myAccount!,
                                        reciever: _group!.students![index],
                                      ),
                                    ),
                                  );
                                } else if (state is ErrorState) {
                                  CustomToast.handleError(state.failure);
                                }
                              });
                            },
                            text: _group?.students?[index].tempPoints
                                    .toString() ??
                                "",
                          ),
                          subtitle: Text(Education.getEducationFromId(_group
                                  ?.students?[index]
                                  .education
                                  ?.educationTypeId) ??
                              ""),
                          title: Text(
                              _group?.students?[index].getFullName() ?? ""),
                        ),
                        itemCount: _group?.students?.length ?? 0,
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
