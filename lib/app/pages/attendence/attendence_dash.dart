import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/wheel_picker.dart';
import 'package:al_khalil/app/pages/attendence/student_attendence_page.dart';
import 'package:al_khalil/app/pages/group/group_profile.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/features/quran/widgets/expanded_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceDash extends StatefulWidget {
  const AttendanceDash({super.key});

  @override
  State<AttendanceDash> createState() => _AttendanceDashState();
}

class _AttendanceDashState extends State<AttendanceDash> {
  bool isLoading = false;
  bool showUnActive = false;
  Attendence? attendence;
  int? _current;
  String date = DateTime.now().getYYYYMMDD();

  getStudentAttendence(String date) async {
    setState(() {
      isLoading = true;
    });
    await context.read<AttendenceProvider>().viewAttendence(null, date).then(
      (state) async {
        if (state is DataState<Attendence>) {
          attendence = state.data;
        }
        if (state is ErrorState) {
          CustomToast.handleError(state.failure);
        }
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getStudentAttendence(date);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سجل الحضور")),
      body: Column(
        children: [
          MyInfoCardEdit(
            child: InkWell(
              onTap: () async {
                String? year = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return YearPickerDialog(
                      init: attendence?.attendenceDate,
                      dates: attendence?.dates ?? [],
                    );
                  },
                );
                if (context.mounted && year != null) {
                  date = year;
                  attendence = null;
                  await getStudentAttendence(year);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_down),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  head: "العدد الكلي",
                  body: attendence?.activeStudentsCount.toString() ?? "",
                ),
              ),
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  head: "عدد الحضور",
                  body: attendence?.getAttendants().toString() ?? "",
                ),
              ),
              5.getWidthSizedBox,
              Expanded(
                child: MyInfoCard(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  head: "عدد الغياب",
                  body: attendence?.getAbsents().toString() ?? "",
                ),
              ),
              5.getWidthSizedBox,
            ],
          ),
          attendence == null && isLoading
              ? getLoader()
              : attendence == null
                  ? getError()
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => getStudentAttendence(date),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final groupAttendance =
                                attendence?.getAttendantsInGroup(
                                    attendence!.groups![index].id!,
                                    showUnActive);
                            return ExpandedSection(
                              expand: _current == index,
                              onTap: () {
                                if (groupAttendance.isNotEmpty) {
                                  setState(() {
                                    if (_current == index) {
                                      _current = null;
                                    } else {
                                      _current = index;
                                    }
                                  });
                                }
                              },
                              expandedChild: (groupAttendance
                                      ?.map<Widget>((e) => ListTile(
                                            leading: e.stateAttendance
                                                ? Icon(
                                                    Icons.done,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                            onTap: () async {
                                              context
                                                  .myPush(StudentAttendancePage(
                                                id: e.person!.id!,
                                              ));
                                            },
                                            title: Text(
                                                e.person?.getFullName() ?? ""),
                                          ))
                                      .toList() ??
                                  [])
                                ..insert(
                                  0,
                                  SwitchListTile(
                                    value: showUnActive,
                                    title: const Text("إظهار الغياب"),
                                    onChanged: (val) {
                                      setState(() {
                                        showUnActive = !showUnActive;
                                      });
                                    },
                                  ),
                                ),
                              child: ListTile(
                                title: Text(
                                    attendence?.groups?[index].groupName ?? ""),
                                leading: IconButton(
                                  onPressed: () {
                                    context.myPush(GroupProfile(
                                      id: attendence?.groups?[index].id,
                                    ));
                                  },
                                  icon: const Icon(Icons.remove_red_eye),
                                ),
                                trailing: Text(
                                  groupAttendance?.length.toString() ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: groupAttendance!.isNotEmpty
                                        ? null
                                        : Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: attendence?.groups?.length ?? 0,
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
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                getStudentAttendence(DateTime.now().getYYYYMMDD());
              });
            },
            child: Text(
              "إعادة المحاولة",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
            ),
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
/**
 *    return Container(
                              constraints: const BoxConstraints(minHeight: 50),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.2,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                children: [
                                  MyCell(
                                    text: attendence
                                        ?.studentAttendance?[index].person
                                        ?.getFullName(),
                                    flex: 4,
                                    isButton: true,
                                  ),
                                  MyCell(
                                    text: attendence?.studentAttendance?[index]
                                        .stateAttendance
                                        .toString(),
                                    flex: 6,
                                  ),
                                  MyCell(
                                    text: attendence?.studentAttendance?[index]
                                        .person?.student?.groubName,
                                    flex: 2,
                                  ),
                                ],
                              ),
                            );
                        
 */