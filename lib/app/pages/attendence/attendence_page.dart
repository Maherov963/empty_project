import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/pages/attendence/student_attendence_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/attendence_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_button_menu.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/waiting_animation.dart';
import '../../components/wheel_picker.dart';

class AttendancePage extends StatefulWidget {
  final Group group;
  const AttendancePage({super.key, required this.group});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Attendence? _attendence;
  Attendence? _submittedAttendence;
  Failure? _failure;
  bool _isLoading = false;
  String date = DateTime.now().getYYYYMMDD();

  Future refreshAttendenc() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _attendence = null;
    setState(() {});
    final state = await context
        .read<AttendenceProvider>()
        .viewAttendence(widget.group.id!, date);
    if (state is DataState<Attendence>) {
      if (state.data.studentAttendance!.isEmpty) {
        _attendence = Attendence(
          dates: state.data.dates,
          attendenceDate: date,
          studentAttendance: widget.group
              .getStudents()!
              .map((e) => StudentAttendece(person: e))
              .toList(),
          groupId: widget.group.id,
        );
        _attendence!.dates!.add(date);
        _submittedAttendence = _attendence?.copy();
      } else {
        _attendence = state.data;
        _submittedAttendence = _attendence?.copy();
      }
    }
    if (state is ErrorState) {
      _failure = state.failure;
      CustomToast.handleError(state.failure);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshAttendenc();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount!;
    return PopScope(
      canPop: false,
      onPopInvoked: (can) async {
        if (can) {
          return;
        }
        if (_submittedAttendence == _attendence) {
          Navigator.pop(context);
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
        appBar: AppBar(title: const Text('الحضور اليومي')),
        body: Column(
          children: [
            if (_isLoading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyButtonMenu(
                      title: "تاريخ الحضور",
                      value: date,
                      onTap: () async {
                        String? year = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return YearPickerDialog(
                              init: date,
                              dates: _attendence?.dates ?? [],
                            );
                          },
                        );
                        if (year != null) {
                          date = year;
                          refreshAttendenc();
                        }
                      },
                    ),
                  ),
                  if (myAccount.custom!.admin)
                    IconButton.filledTonal(
                      onPressed: () async {
                        final year = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (year == null) {
                          return;
                        }
                        date = year.getYYYYMMDD();
                        setState(() {});
                        if (_attendence!.dates!.contains(date)) {
                          refreshAttendenc();
                        } else {
                          _attendence!.studentAttendance = widget
                              .group.students!
                              .map((e) => StudentAttendece(person: e))
                              .toList();
                          _attendence!.attendenceDate = date;
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                ],
              ),
            ),
            TryAgainLoader(
              isLoading: _isLoading,
              isData: _attendence != null,
              failure: _failure,
              onRetry: refreshAttendenc,
              child: Expanded(
                child: CustomTaple(
                  culomn: const [
                    CustomCulomnCell(text: "الاسم"),
                    CustomCulomnCell(text: "الحضور"),
                    CustomCulomnCell(text: "اللباس"),
                    CustomCulomnCell(text: "السلوك"),
                  ],
                  row: _attendence?.studentAttendance?.map(
                    (e) => CustomRow(
                      row: [
                        CustomCell(
                          text: e.person?.getFullName(),
                          onTap: () {
                            context.myPush(
                                StudentAttendancePage(person: e.person!));
                          },
                        ),
                        CheckBoxCell(
                          isChecked: e.stateAttendance,
                          onTap: () {
                            e.stateBehavior = !e.stateAttendance;
                            if (e.stateAttendance) {
                              e.stateGarrment = !e.stateAttendance;
                            }
                            e.stateAttendance = !e.stateAttendance;
                            setState(() {});
                          },
                        ),
                        CheckBoxCell(
                          isChecked: e.stateGarrment,
                          onTap: () {
                            if (e.stateAttendance) {
                              e.stateGarrment = !e.stateGarrment;
                              setState(() {});
                            }
                          },
                        ),
                        CheckBoxCell(
                          isChecked: e.stateBehavior,
                          onTap: () {
                            if (e.stateAttendance) {
                              e.stateBehavior = !e.stateBehavior;
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_attendence != null)
              Visibility(
                replacement: const MyWaitingAnimation(),
                visible: !context.watch<AttendenceProvider>().isLoadingIn,
                child: CustomTextButton(
                  text: "حفظ التفقد",
                  onPressed: () async {
                    final state = await context
                        .read<AttendenceProvider>()
                        .attendence(_attendence!);
                    if (state is DataState) {
                      _submittedAttendence = _attendence?.copy();
                      CustomToast.showToast(CustomToast.succesfulMessage);
                    }
                    if (state is ErrorState) {
                      CustomToast.handleError(state.failure);
                    }
                  },
                ),
              ),
            5.getHightSizedBox,
          ],
        ),
      ),
    );
  }
}
