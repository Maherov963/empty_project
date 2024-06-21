import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/pages/person/person_step.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'permissioin_step.dart';
import 'student_step.dart';

class AddNewPerson extends StatefulWidget {
  final bool fromEdit;
  final Person? person;

  const AddNewPerson({
    super.key,
    this.fromEdit = false,
    this.person,
  });

  @override
  State<AddNewPerson> createState() => _AddNewPersonState();
}

class _AddNewPersonState extends State<AddNewPerson> {
  late final Person _person;

  List<Person>? _people;
  List<Group>? _groups;
  bool _isLoadingPersons = true;
  bool _isLoadingGroups = true;
  int _currentStep = 0;

  late Person myAccount;
  final _key = GlobalKey<FormState>();

  void _getTheAllPerson() async {
    await Provider.of<PersonProvider>(context, listen: false)
        .getTheAllPersons()
        .then((state) async {
      if (state is DataState<List<Person>> && mounted) {
        _people = state.data;
      } else if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
      setState(() {
        _isLoadingPersons = false;
      });
    });
  }

  void _getGroups() async {
    _isLoadingGroups = true;
    setState(() {});
    await Provider.of<GroupProvider>(context, listen: false)
        .getAllGroups()
        .then((state) async {
      if (state is DataState<List<Group>> && mounted) {
        _groups = state.data;
      } else if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
      setState(() {
        _isLoadingGroups = false;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.fromEdit) {
        _isLoadingPersons = false;
        _people = [];
        setState(() {});
      } else {
        _getTheAllPerson();
      }
    });

    if (widget.fromEdit) {
      _person = widget.person!.copy();
    } else {
      _person = Person.create();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myAccount = context.read<CoreProvider>().myAccount!;
    final theme = Theme.of(context);
    final load = context.watch<PersonProvider>().isLoadingIn ||
        context.watch<GroupProvider>().isLoadingIn;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (_currentStep != 0) {
          setState(() {
            _currentStep--;
          });
        } else {
          if (!context.mounted) {
            return;
          }
          final state =
              await CustomDialog.showYesNoDialog(context, "هل تود الخروج");
          if (state && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.fromEdit
                ? "تعديل ${_person.getFullName()}"
                : "إضافة حساب جديد")),
        body: Center(
          child: SizedBox(
            width: isWin ? 600 : null,
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _submitStep,
              onStepCancel: _skipStep,
              onStepTapped: _onTapStep,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: myAccount.custom?.isAdminstration == true
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (myAccount.custom?.isAdminstration == true)
                      Visibility(
                        visible: !load,
                        replacement: const MyWaitingAnimation(),
                        child: CustomTextButton(
                          text: "تخطي",
                          color: theme.colorScheme.error,
                          onPressed: details.onStepCancel,
                        ),
                      ),
                    Visibility(
                      visible: !load,
                      replacement: const MyWaitingAnimation(),
                      child: CustomTextButton(
                        text: "متابعة",
                        onPressed: details.onStepContinue,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                );
              },
              elevation: 10,
              steps: [
                Step(
                  title: Text(
                    "الشخص",
                    style: TextStyle(
                      color:
                          _currentStep == 0 ? theme.colorScheme.primary : null,
                    ),
                  ),
                  content: _people == null && _isLoadingPersons
                      ? getLoader()
                      : _people == null
                          ? getError(_getTheAllPerson)
                          : Form(
                              key: _key,
                              child: PersonStep(
                                fromEdit: widget.fromEdit,
                                person: _person,
                                people: _people!,
                              ),
                            ),
                  isActive: _currentStep == 0,
                  state:
                      _currentStep == 0 ? StepState.editing : StepState.indexed,
                ),
                Step(
                  title: Text(
                    "الطالب",
                    style: TextStyle(
                      color:
                          _currentStep == 1 ? theme.colorScheme.primary : null,
                    ),
                  ),
                  content: _groups == null && _isLoadingGroups
                      ? getLoader()
                      : _groups == null
                          ? getError(_getGroups)
                          : StudentStep(
                              student: _person.student!,
                              fromEdit: widget.fromEdit,
                              classs: _person.education?.educationTypeId ?? 0,
                              groups: _groups ?? [],
                            ),
                  isActive: _currentStep == 1,
                  state:
                      _currentStep == 1 ? StepState.editing : StepState.indexed,
                ),
                if (myAccount.custom!.appoint)
                  Step(
                    title: Text(
                      "الأستاذ",
                      style: TextStyle(
                        color: _currentStep == 2
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    state: !myAccount.custom!.appoint
                        ? StepState.disabled
                        : _currentStep == 2
                            ? StepState.editing
                            : StepState.indexed,
                    content: _groups == null && _isLoadingGroups
                        ? getLoader()
                        : _groups == null
                            ? getError(_getGroups)
                            : PermissionStep(custom: _person.custom!),
                    isActive: _currentStep == 2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _skipStep() async {
    FocusManager.instance.primaryFocus?.unfocus();
    switch (_currentStep) {
      case 0:
        if (_person.id == null &&
            _person.education?.educationTypeId != null &&
            _person.lastName != null) {
          CustomToast.showToast("لا يمكنك التخطي");
        } else {
          _person.student?.state = CustomState.activeId;
          if (_person.student?.id != null && !myAccount.custom!.adder) {
            _isLoadingGroups = false;
            _groups = [];
            setState(() {
              _currentStep++;
            });
          } else {
            _getGroups();
            setState(() {
              _currentStep++;
            });
          }
        }
        break;
      case 1:
        if (!myAccount.custom!.appoint) {
          Navigator.of(context).pop();
          return;
        }
        setState(() {
          _currentStep++;
        });
        break;
      case 2:
        Navigator.pop(context);
        break;
    }
  }

  _submitStep() async {
    FocusManager.instance.primaryFocus?.unfocus();
    bool succed = false;
    switch (_currentStep) {
      case 0:
        if (_person.id == null) {
          succed = await _addPerson();
        } else {
          succed = await _editPerson();
        }
        break;
      case 1:
        if (_person.student?.id == null) {
          succed = await _addStudent();
        } else {
          succed = await _editStudent();
        }
        break;
      case 2:
        if (_person.custom?.id == null) {
          succed = await _addPermission();
        } else {
          succed = await _editPermission();
        }
        break;
    }
    if (succed) {
      if (_currentStep == 2 && mounted) {
        Navigator.of(context).pop();
        return;
      }
      if (_currentStep == 0) {
        _person.student?.state = CustomState.activeId;
        if (_person.student?.id != null && !(myAccount.custom!.adder)) {
          _isLoadingGroups = false;
          _groups = [];
          setState(() {});
        } else {
          _getGroups();
        }
      }
      if (_currentStep == 1 && mounted && !myAccount.custom!.appoint) {
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        _currentStep++;
      });
    }
  }

  _onTapStep(int step) async {
    if (step >= _currentStep) {
      return;
    }
    setState(() {
      _currentStep = step;
    });
  }

  Future<bool> _addPerson() async {
    if (_person.birthDate == null) {
      CustomToast.showToast("اختر سنة الميلاد");
    } else {
      if (_person.education!.educationTypeId == null) {
        CustomToast.showToast("اختر المرحلة الدراسية");
      } else if (_person.mother!.state == null ||
          _person.father!.state == null) {
        CustomToast.showToast("اختر حالة الأب /الأم");
      } else if (_key.currentState!.validate()) {
        _person.student!.registerDate = DateTime.now().toString();
        if (_person.email != null && !_person.email!.contains("@")) {
          _person.email = "${_person.email}@gmail.com";
        }
        final ProviderStates state =
            await context.read<PersonProvider>().addPerson(_person);
        if (state is ErrorState && context.mounted) {
          CustomToast.handleError(state.failure);

          return false;
        }
        if (state is DataState<int> && context.mounted) {
          _person.id = state.data;
          return true;
        }
      } else if (context.mounted) {
        CustomToast.showToast("املأ الحقول الضرورية");
      }
      return false;
    }
    return false;
  }

  Future<bool> _editPerson() async {
    if (_person.education!.educationTypeId == null) {
      CustomToast.showToast("اختر المرحلة الدراسية");
    } else if (_person.birthDate == null) {
      CustomToast.showToast("اختر سنة الميلاد");
    } else if (_person.mother!.state == null || _person.father!.state == null) {
      CustomToast.showToast("اختر حالة الأب /الأم");
    } else if (_key.currentState!.validate()) {
      final ProviderStates state =
          await context.read<PersonProvider>().editPerson(_person);
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);

        return false;
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);
        return true;
      }
    } else if (context.mounted) {
      CustomToast.showToast("املأ الحقول الضرورية");
    }
    return false;
  }

  Future<bool> _addStudent() async {
    if (_person.student!.groubId == null) {
      CustomToast.showToast("اختر حلقة الطالب");
    } else if (_person.student!.state == null) {
      CustomToast.showToast("اختر حالة الطالب");
    } else {
      _person.student!.id = _person.id;
      final ProviderStates state =
          await context.read<PersonProvider>().addStudent(_person.student!);
      if (state is ErrorState && context.mounted) {
        _person.student!.id = null;
        CustomToast.handleError(state.failure);

        return false;
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);
        return true;
      }
    }
    return false;
  }

  Future<bool> _editStudent() async {
    if (_person.student!.groubId == null) {
      CustomToast.showToast("اختر حلقة الطالب");
    } else if (_person.student!.state == null) {
      CustomToast.showToast("اختر حالة الطالب");
    } else {
      final ProviderStates state =
          await context.read<PersonProvider>().editStudent(_person.student!);
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);

        return false;
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);
        return true;
      }
    }

    return false;
  }

  Future<bool> _addPermission() async {
    if (_person.custom!.state == null) {
      CustomToast.showToast("اختر حالة الأستاذ");
    } else {
      _person.custom!.id = _person.id;
      final ProviderStates state =
          await context.read<PersonProvider>().addPermission(_person.custom!);
      if (state is ErrorState && context.mounted) {
        _person.custom!.id = null;
        CustomToast.handleError(state.failure);

        return false;
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);

        return true;
      }
    }

    return false;
  }

  Future<bool> _editPermission() async {
    if (_person.custom!.state == null) {
      CustomToast.showToast("اختر حالة الأستاذ");
    } else {
      final ProviderStates state =
          await context.read<PersonProvider>().editPermission(_person.custom!);
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);

        return false;
      }
      if (state is DataState && context.mounted) {
        CustomToast.showToast(CustomToast.succesfulMessage);

        return true;
      }
    }
    return false;
  }

  getError(Function() onTap) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: TextButton(
          onPressed: onTap,
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
