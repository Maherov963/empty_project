import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../../domain/models/attendence/attendence.dart';
import '../../components/waiting_animation.dart';
import '../../providers/managing/group_provider.dart';
import '../../providers/states/provider_states.dart';
import '../../utils/messges/toast.dart';
import '../../utils/widgets/skeleton.dart';
import '../additional_point/add_pts_moderator_page.dart';
import '../attendence/attendence_page.dart';
import 'memorization_page.dart';

class SlideWidget extends StatefulWidget {
  final int id;
  final int myRank;
  const SlideWidget({
    super.key,
    required this.id,
    required this.myRank,
  });

  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  Group? group;
  String? error;

  getFuture() async {
    group = null;
    error = null;
    await Provider.of<GroupProvider>(context, listen: false)
        .getGroup(widget.id)
        .then((state) {
      if (state is GroupState) {
        group = state.group;
      }
      if (state is ErrorState) {
        error = state.failure.message;
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFuture();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    Person? myAccount = context.read<CoreProvider>().myAccount;

    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 1,
        expand: false,
        builder: (ctx, controller) {
          return Consumer<GroupProvider>(
            builder: (_, value, __) {
              return value.isLoadingGroup == widget.id && group == null
                  ? getLoadState(controller)
                  : group == null
                      ? Center(
                          child: TextButton(
                              onPressed: () async {
                                await getFuture();
                              },
                              child: Text("$error")))
                      : Consumer<MemorizationProvider>(
                          builder: (__, val, _) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    context
                                            .watch<AttendenceProvider>()
                                            .isLoadingIn
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: MyWaitingAnimation(),
                                          )
                                        : IconButton(
                                            onPressed: () async {
                                              if (!context
                                                  .read<CoreProvider>()
                                                  .myAccount!
                                                  .custom!
                                                  .viewAttendance) {
                                                CustomToast.showToast(
                                                    CustomToast
                                                        .noPermissionError);
                                              } else {
                                                await context
                                                    .read<AttendenceProvider>()
                                                    .viewAttendence(
                                                        group!.id!,
                                                        DateTime.now()
                                                            .getYYYYMMDD())
                                                    .then(
                                                  (state) async {
                                                    if (state
                                                        is AttendenceState) {
                                                      if (state
                                                          .attendence
                                                          .studentAttendance!
                                                          .isEmpty) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                            if (context
                                                                .read<
                                                                    CoreProvider>()
                                                                .allowed
                                                                .contains(DateTime
                                                                        .now()
                                                                    .weekday)) {
                                                              return AttendancePage(
                                                                myRank: widget
                                                                    .myRank,
                                                                attendence:
                                                                    Attendence(
                                                                  dates: state
                                                                      .attendence
                                                                      .dates,
                                                                  attendenceDate:
                                                                      DateTime.now()
                                                                          .getYYYYMMDD(),
                                                                  studentAttendance: group!
                                                                      .students!
                                                                      .map((e) => StudentAttendece(
                                                                          person: Person(
                                                                              id: e.id,
                                                                              firstName: e.firstName,
                                                                              lastName: e.lastName)))
                                                                      .toList(),
                                                                  groupId:
                                                                      group!.id,
                                                                ),
                                                              );
                                                            } else {
                                                              return AttendancePage(
                                                                myRank: widget
                                                                    .myRank,
                                                                attendence:
                                                                    Attendence(
                                                                  dates: state
                                                                      .attendence
                                                                      .dates,
                                                                  attendenceDate:
                                                                      "",
                                                                  studentAttendance: group!
                                                                      .students!
                                                                      .map((e) => StudentAttendece(
                                                                          person: Person(
                                                                              id: e.id,
                                                                              firstName: e.firstName,
                                                                              lastName: e.lastName)))
                                                                      .toList(),
                                                                  groupId:
                                                                      group!.id,
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AttendancePage(
                                                              myRank:
                                                                  widget.myRank,
                                                              attendence: state
                                                                  .attendence,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                    if (state is ErrorState) {
                                                      CustomToast.showToast(
                                                          state
                                                              .failure.message);
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.date_range,
                                              size: 40,
                                            ),
                                          ),
                                    Text(group!.groupName!),
                                    IconButton(
                                      onPressed: () {
                                        context.navigateToGroup(group!.id!);
                                      },
                                      icon: const Icon(
                                        Icons.info_outline_rounded,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(endIndent: 10, indent: 10),
                                Expanded(
                                  child: group!.students!.isEmpty
                                      ? const Center(
                                          child: Text("لا يوجد طلاب"),
                                        )
                                      : ListView.builder(
                                          controller: controller,
                                          itemBuilder: (ctn, index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: val.isLoadingMemo ==
                                                      group!
                                                          .students![index].id!
                                                  ? const MyWaitingAnimation()
                                                  : const Icon(
                                                      Icons.arrow_back_ios),
                                              onTap: val.isLoadingMemo ==
                                                      group!
                                                          .students![index].id!
                                                  ? null
                                                  : () async {
                                                      await context
                                                          .read<
                                                              MemorizationProvider>()
                                                          .getMemorization(
                                                              group!
                                                                  .students![
                                                                      index]
                                                                  .id!)
                                                          .then((state) {
                                                        if (state
                                                            is ErrorState) {
                                                          CustomToast.showToast(
                                                              state.failure
                                                                  .message);
                                                        } else if (state
                                                            is QuranState) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              List<Person>
                                                                  listners =
                                                                  group!
                                                                      .assistants!
                                                                      .map((e) =>
                                                                          e.copy())
                                                                      .toList();
                                                              if (group?.moderator !=
                                                                      null &&
                                                                  !listners
                                                                      .contains(
                                                                          group!
                                                                              .moderator)) {
                                                                listners.add(group!
                                                                    .moderator!
                                                                    .copy());
                                                              }
                                                              if (myAccount != group!.moderator &&
                                                                  myAccount !=
                                                                      group!
                                                                          .moderator &&
                                                                  !listners
                                                                      .contains(
                                                                          myAccount)) {
                                                                listners.add(
                                                                    myAccount!
                                                                        .copy());
                                                              }

                                                              return MemorizationPage(
                                                                myRank: widget
                                                                    .myRank,
                                                                listners:
                                                                    listners,
                                                                person: group!
                                                                        .students![
                                                                    index],
                                                                quranSections: state
                                                                    .quranSections,
                                                              );
                                                              // return const QuranHomeScreen();
                                                            },
                                                          ));
                                                        }
                                                      });
                                                    },
                                              title: Text(
                                                group!.students![index]
                                                    .getFullName(),
                                              ),
                                              trailing: !myAccount!
                                                      .custom!.evaluation
                                                  ? null
                                                  : context
                                                              .watch<
                                                                  AdditionalPointsProvider>()
                                                              .isLoadingPts ==
                                                          group!
                                                              .students![index]
                                                              .id
                                                      ? const MyWaitingAnimation()
                                                      : TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiary
                                                                      .withOpacity(
                                                                          0.1))),
                                                          child: Text(
                                                            group!
                                                                    .students![
                                                                        index]
                                                                    .tempPoints ??
                                                                "0",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                          ),
                                                          onPressed: () async {
                                                            await context
                                                                .read<
                                                                    AdditionalPointsProvider>()
                                                                .viewAdditionalPoints(
                                                                    AdditionalPoints(
                                                                  recieverPep:
                                                                      group!.students![
                                                                          index],
                                                                  senderPer:
                                                                      myAccount,
                                                                  createdAt: DateTime
                                                                          .now()
                                                                      .getYYYYMMDD(),
                                                                ))
                                                                .then((state) {
                                                              if (state
                                                                  is AdditonalPtsState) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AddPointsPage(
                                                                        addPoints:
                                                                            state.additionalPoints,
                                                                        sender:
                                                                            myAccount,
                                                                        reciever:
                                                                            group!.students![index],
                                                                      ),
                                                                    ));
                                                              } else if (state
                                                                  is ErrorState) {
                                                                CustomToast
                                                                    .handleError(
                                                                        state
                                                                            .failure);
                                                              }
                                                            });
                                                          },
                                                        ),
                                            ),
                                          ),
                                          itemCount: group!.students!.length,
                                        ),
                                ),
                              ],
                            );
                          },
                        );
            },
          );
        });
  }

  getLoadState(ScrollController controller) {
    return ListView(
      controller: controller,
      children: const [
        Row(
          children: [
            Skeleton(height: 50, width: 50, radius: 50),
            Expanded(child: Skeleton(height: 35)),
            Skeleton(height: 50, width: 50, radius: 50),
          ],
        ),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
      ],
    );
  }
}
