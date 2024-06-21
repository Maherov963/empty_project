import 'package:al_khalil/app/pages/attendence/student_attendence_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../components/my_info_card_edit.dart';
import '../../components/waiting_animation.dart';
import '../../components/wheel_picker.dart';

class AttendancePage extends StatefulWidget {
  final Attendence? attendence;
  const AttendancePage({super.key, required this.attendence});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Attendence _attendence;

  @override
  void initState() {
    _attendence = widget.attendence!.copy();
    if (!_attendence.dates!.contains(_attendence.attendenceDate) &&
        _attendence.attendenceDate != "اختر") {
      _attendence.dates!.add(_attendence.attendenceDate!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
    return PopScope(
      canPop: false,
      onPopInvoked: (can) async {
        if (can) {
          return;
        }
       final canPop =
            await CustomDialog.showYesNoDialog(context, "لن يتم حفظ التغييرات");
        if (canPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        appBar: AppBar(
          title: const Text('الحضور اليومي'),
          actions: [
            Selector<AttendenceProvider, bool>(
              selector: (p0, p1) => p1.isLoadingIn,
              builder: (__, value, _) => !value
                  ? const SizedBox.square()
                  : const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: MyWaitingAnimation(),
                    ),
            )
          ],
        ),
        body: Column(
          children: [
            MyInfoCardEdit(
              child: InkWell(
                onTap: () async {
                  if (myAccount.custom!.admin || myAccount.custom!.manager) {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    ).then((value) async {
                      if (value != null) {
                        if (_attendence.dates!.contains(value.getYYYYMMDD())) {
                          if (context.mounted) {
                            await context
                                .read<AttendenceProvider>()
                                .viewAttendence(
                                    _attendence.groupId!, value.getYYYYMMDD())
                                .then(
                              (state) async {
                                if (state is DataState<Attendence>) {
                                  setState(() {
                                    _attendence = state.data;
                                  });
                                }
                                if (state is ErrorState) {
                                  CustomToast.handleError(state.failure);
                                }
                              },
                            );
                          }
                        } else {
                          setState(() {
                            _attendence.studentAttendance!.map((e) {
                              e.stateAttendance = false;
                              e.stateBehavior = false;
                              e.stateGarrment = false;
                            }).toList();
                            _attendence.attendenceDate = value.getYYYYMMDD();
                          });
                        }
                      }
                    });
                  } else {
                    String? year = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return YearPickerDialog(
                          init: _attendence.attendenceDate,
                          dates: _attendence.dates!,
                        );
                      },
                    );
                    if (context.mounted && year != null) {
                      await context
                          .read<AttendenceProvider>()
                          .viewAttendence(_attendence.groupId!, year)
                          .then(
                        (state) async {
                          if (state is DataState<Attendence>) {
                            setState(() {
                              _attendence = state.data;
                            });
                          }
                          if (state is ErrorState) {
                            CustomToast.handleError(state.failure);
                          }
                        },
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${_attendence.attendenceDate}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            10.getHightSizedBox,
            Table(
                border: TableBorder.all(color: Colors.grey, width: 0.5),
                columnWidths: const {
                  0: FractionColumnWidth(0.4),
                  1: FractionColumnWidth(0.2),
                  2: FractionColumnWidth(0.2),
                  3: FractionColumnWidth(0.2),
                },
                children: [
                  TableRow(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'الاسم',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'الحضور',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'اللباس',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'السلوك',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ]),
                ]),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.4),
                    1: FractionColumnWidth(0.2),
                    2: FractionColumnWidth(0.2),
                    3: FractionColumnWidth(0.2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: Colors.grey, width: 0.5),
                  children: _attendence.studentAttendance!.map(
                    (student) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StudentAttendancePage(
                                              id: student.person!.id!,
                                            ),
                                          ));
                                    },
                                    child: Text(
                                      "${student.person?.getFullName()}",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Checkbox(
                              activeColor: Colors.transparent,
                              checkColor: Theme.of(context).colorScheme.primary,
                              isError: !student.stateAttendance,
                              value: student.stateAttendance,
                              onChanged: !myAccount.custom!.attendance ||
                                      _attendence.attendenceDate == ""
                                  ? null
                                  : (value) {
                                      setState(() {
                                        HapticFeedback.heavyImpact();
                                        student.stateAttendance = value!;
                                        student.stateBehavior = value;
                                        if (!value) {
                                          student.stateGarrment = value;
                                        }
                                      });
                                    },
                            ),
                          ),
                          Checkbox(
                            activeColor: Colors.transparent,
                            value: student.stateGarrment,
                            checkColor: Theme.of(context).colorScheme.primary,
                            isError: !student.stateGarrment,
                            onChanged: !myAccount.custom!.attendance ||
                                    _attendence.attendenceDate == ""
                                ? null
                                : (value) {
                                    if (student.stateAttendance) {
                                      setState(() {
                                        HapticFeedback.heavyImpact();
                                        student.stateGarrment = value!;
                                      });
                                    }
                                  },
                          ),
                          Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: Theme.of(context).colorScheme.primary,
                            value: student.stateBehavior,
                            isError: !student.stateBehavior,
                            onChanged: !myAccount.custom!.attendance ||
                                    _attendence.attendenceDate == ""
                                ? null
                                : (value) {
                                    if (student.stateAttendance) {
                                      setState(() {
                                        HapticFeedback.heavyImpact();
                                        student.stateBehavior = value!;
                                      });
                                    }
                                  },
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !myAccount.custom!.attendance ||
                        _attendence.attendenceDate == ""
                    ? const SizedBox.shrink()
                    : TextButton.icon(
                        onPressed: context
                                .watch<AttendenceProvider>()
                                .isLoadingIn
                            ? null
                            : () async {
                                await context
                                    .read<AttendenceProvider>()
                                    .attendence(_attendence)
                                    .then(
                                  (state) async {
                                    if (state is DataState) {
                                      CustomToast.showToast(
                                          CustomToast.succesfulMessage);
                                    }
                                    if (state is ErrorState) {
                                      CustomToast.handleError(state.failure);
                                    }
                                  },
                                );
                              },
                        icon: Icon(
                          Icons.save,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(
                          "حفظ التفقد",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
