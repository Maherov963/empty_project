import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/components/wheel_picker.dart';
import 'package:al_khalil/app/pages/attendence/student_attendence_page.dart';
import 'package:al_khalil/app/pages/group/group_profile.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_button_menu.dart';
import 'package:al_khalil/data/errors/failures.dart';
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
  Failure? _failure;
  String date = DateTime.now().getYYYYMMDD();

  Future getStudentAttendence() async {
    setState(() {
      isLoading = true;
    });
    await context.read<AttendenceProvider>().viewAttendence(null, date).then(
      (state) async {
        if (state is DataState<Attendence>) {
          attendence = state.data;
        }
        if (state is ErrorState) {
          _failure = state.failure;
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
      getStudentAttendence();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سجل الحضور")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: MyButtonMenu(
              title: "تاريخ الحضور",
              value: date,
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
                  getStudentAttendence();
                }
              },
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
          TryAgainLoader(
            isLoading: isLoading,
            isData: attendence != null,
            failure: _failure,
            onRetry: getStudentAttendence,
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: getStudentAttendence,
                child: ListView.separated(
                  separatorBuilder: (context, index) => 5.getHightSizedBox,
                  padding: const EdgeInsets.all(4),
                  itemBuilder: (context, index) {
                    final groupAttendance = attendence?.getAttendantsInGroup(
                        attendence!.groups![index].id!, showUnActive);
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
                      color: Theme.of(context).colorScheme.surfaceContainer,
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
                                      context.myPush(StudentAttendancePage(
                                        person: e.person!,
                                      ));
                                    },
                                    trailing: IconButton(
                                        onPressed: () {
                                          context
                                              .navigateToPerson(e.person!.id);
                                        },
                                        icon: const Icon(Icons.remove_red_eye)),
                                    title: Text(e.person?.getFullName() ?? ""),
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
                        title: Text(attendence?.groups?[index].groupName ?? ""),
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
          )
        ],
      ),
    );
  }
}
