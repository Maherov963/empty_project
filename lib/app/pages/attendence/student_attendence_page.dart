import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/managing/attendence_provider.dart';

//210
class StudentAttendancePage extends StatefulWidget {
  final Person person;
  const StudentAttendancePage({super.key, required this.person});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<StudentAttendece>? _studentAttendece;

  Failure? _failure;
  bool _isLoading = false;
  getStudentAttendence() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _studentAttendece = null;
    setState(() {});
    final state = await context
        .read<AttendenceProvider>()
        .viewStudentAttendence(widget.person.id!);
    if (state is DataState<List<StudentAttendece>> && mounted) {
      _studentAttendece = state.data;
    } else if (state is ErrorState && mounted) {
      _failure = state.failure;
      CustomToast.handleError(state.failure);
    }
    _isLoading = false;
    setState(() {});
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
        title: Text(widget.person.getFullName()),
        actions: [
          IconButton(
            onPressed: () {
              context.navigateToPerson(widget.person.id);
            },
            icon: const Icon(Icons.remove_red_eye),
          )
        ],
      ),
      body: TryAgainLoader(
        isLoading: _isLoading,
        isData: _studentAttendece != null,
        failure: _failure,
        onRetry: getStudentAttendence,
        child: CustomTaple(
            culomn: const [
              CustomCulomnCell(text: "التاريخ"),
              CustomCulomnCell(text: "الحضور"),
              CustomCulomnCell(text: "اللباس"),
              CustomCulomnCell(text: "السلوك"),
            ],
            row: _studentAttendece?.map(
              (e) => CustomRow(
                row: [
                  CustomCell(text: e.attendenceDate),
                  CheckBoxCell(isChecked: e.stateAttendance),
                  CheckBoxCell(isChecked: e.stateGarrment),
                  CheckBoxCell(isChecked: e.stateBehavior),
                ],
              ),
            )),
      ),
    );
  }
}
