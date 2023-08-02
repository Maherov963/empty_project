import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/managing/attendence_provider.dart';
import '../../providers/states/provider_states.dart';
import '../../utils/widgets/skeleton.dart';

// ignore: must_be_immutable
class StudentAttendancePage extends StatefulWidget {
  final int id;
  const StudentAttendancePage({
    super.key,
    required this.id,
  });

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<StudentAttendece>? _studentAttendece;
  bool isLoading = true;
  getStudentAttendence() async {
    isLoading = true;
    await context
        .read<AttendenceProvider>()
        .viewStudentAttendence(widget.id)
        .then((state) {
      if (state is StudentAttendenceState && mounted) {
        setState(() {
          isLoading = false;
          _studentAttendece = state.attendence;
        });
      }
      if (state is ErrorState && mounted) {
        setState(() {
          isLoading = false;
        });
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "الخليل");
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getStudentAttendence();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحضور اليومي'),
      ),
      body: _studentAttendece == null && isLoading
          ? getLoader()
          : _studentAttendece == null
              ? getError()
              : Column(
                  children: [
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
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'التاريخ',
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border:
                              TableBorder.all(color: Colors.grey, width: 0.5),
                          children: _studentAttendece!.map(
                            (student) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${student.attendenceDate}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Checkbox(
                                      activeColor: Colors.transparent,
                                      checkColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      isError: !student.stateAttendance,
                                      value: student.stateAttendance,
                                      onChanged: (_) {},
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.transparent,
                                    value: student.stateGarrment,
                                    checkColor:
                                        Theme.of(context).colorScheme.secondary,
                                    isError: !student.stateGarrment,
                                    onChanged: (_) {},
                                  ),
                                  Checkbox(
                                    activeColor: Colors.transparent,
                                    checkColor:
                                        Theme.of(context).colorScheme.secondary,
                                    value: student.stateBehavior,
                                    isError: !student.stateBehavior,
                                    onChanged: (_) {},
                                  ),
                                ],
                              );
                            },
                          ).toList(),
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
        100.getHightSizedBox(),
        Center(
          child: TextButton(
            // style: ButtonStyle(
            //     overlayColor: MaterialStatePropertyAll(Colors.white)),
            onPressed: () {
              setState(() {
                getStudentAttendence();
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
