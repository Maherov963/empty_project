import 'package:al_khalil/app/components/wheel_picker.dart';
import 'package:al_khalil/app/pages/person/person_profile.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/widgets/auto_complete.dart';
import 'package:al_khalil/app/utils/widgets/my_button_menu.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/app/utils/widgets/my_pass_form_field.dart';
import 'package:al_khalil/app/utils/widgets/my_phone_field.dart';
import 'package:al_khalil/app/utils/widgets/my_text_form_field.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/features/quran/widgets/expanded_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/static/custom_state.dart';

class PersonStep extends StatefulWidget {
  const PersonStep({
    super.key,
    this.enabled = true,
    this.fromEdit = false,
    required this.person,
    this.people,
  });
  final bool fromEdit;
  final bool enabled;
  final Person person;
  final List<Person>? people;
  @override
  State<PersonStep> createState() => _PersonStepState();
}

class _PersonStepState extends State<PersonStep> {
  int? _currentExpanded;
  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount!;
    if (widget.person.id == null && !myAccount.custom!.addPerson) {
      return const Center(child: Text("لاتمتلك الصلاحيات لإضافة أشخاص"));
    } else {
      if (widget.person.id != null && !myAccount.custom!.editPerson) {
        return const Center(child: Text("لاتمتلك الصلاحيات لتعديل أشخاص"));
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle("معلومات عامة"),
            if (widget.person.id != null)
              MyTextFormField(
                enabled: false,
                initVal: widget.person.id.toString(),
                labelText: "رقم التعريف",
              ),
            10.getHightSizedBox,
            MyAutoComplete(
              labelText: "الاسم",
              people: widget.people,
              enabled: widget.enabled,
              onSelected: (p0) async {
                if (myAccount.custom!.editPerson && p0.id != myAccount.id) {
                  await context.navigateToEditPerson(p0.id!);
                } else {
                  await context.navigateToPerson(p0.id!);
                }
              },
              initVal: widget.person.firstName,
              onChanged: (p0) => widget.person.firstName = p0,
            ),
            10.getHightSizedBox,
            MyAutoComplete(
              labelText: "الكنية",
              people: widget.people,
              enabled: widget.enabled,
              onSelected: (p0) async {
                if (myAccount.custom!.editPerson && p0.id != myAccount.id) {
                  await context.navigateToEditPerson(p0.id!);
                } else {
                  await context.navigateToPerson(p0.id!);
                }
              },
              initVal: widget.person.lastName,
              onChanged: (p0) => widget.person.lastName = p0,
            ),
            10.getHightSizedBox,
            MyButtonMenu(
              onTap: () async {
                final year = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return YearPickerDialog(
                      init: widget.person.birthDate,
                      dates: List.generate(60, (index) => "${1960 + index}"),
                    );
                  },
                );
                if (year != null) {
                  setState(() {
                    widget.person.birthDate = year;
                  });
                }
              },
              enabled: widget.enabled,
              title: "سنة الميلاد",
              value: widget.person.birthDate?.substring(0, 4),
            ),
            10.getHightSizedBox,
            MyPhoneField(
              initVal: widget.person.primaryNumber,
              enabled: widget.enabled,
              onTap: (isCall) {
                callWhatsApp(widget.person.primaryNumber, isCall);
              },
              onChanged: (p0) => setState(() {
                widget.person.primaryNumber = p0;
              }),
              labelText: "الرقم الشخصي",
            ),
            buildTitle("الدراسة"),
            MyComboBox(
              enabled: widget.enabled,
              text: Education.getEducationFromId(
                  widget.person.education?.educationTypeId),
              hint: "المرحلة الدراسية",
              items: Education.educationTypes,
              onChanged: (value) {
                setState(() {
                  widget.person.education = Education();
                  widget.person.education?.educationTypeId =
                      Education.getIdFromEducation(value);
                });
              },
            ),
            10.getHightSizedBox,
            Visibility(
              visible: widget.person.education?.educationTypeId ==
                      Education.graduatedId ||
                  widget.person.education?.educationTypeId ==
                      Education.collegeId,
              child: MyTextFormField(
                enabled: widget.enabled,
                initVal: widget.person.education?.majorName,
                onChanged: (p0) => widget.person.education!.majorName = p0,
                labelText: "الاختصاص",
              ),
            ),
            10.getHightSizedBox,
            Visibility(
              visible: widget.person.education?.educationTypeId ==
                  Education.collegeId,
              child: MyTextFormField(
                enabled: widget.enabled,
                initVal: widget.person.education?.majorYear,
                onChanged: (p0) => widget.person.education!.majorYear = p0,
                labelText: "السنة",
                textInputType: TextInputType.number,
              ),
            ),
            buildTitle("العنوان"),
            MyTextFormField(
              enabled: widget.enabled,
              initVal: widget.person.address?.area,
              onChanged: (p0) => widget.person.address!.area = p0,
              labelText: "المنطقة",
            ),
            10.getHightSizedBox,
            MyTextFormField(
              enabled: widget.enabled,
              initVal: widget.person.address?.mark,
              onChanged: (p0) => widget.person.address?.mark = p0,
              labelText: "علامة",
              suffixIcon: const Icon(Icons.location_on),
            ),
            buildTitle(" الأب"),
            MyTextFormField(
              enabled: widget.enabled,
              initVal: widget.person.father?.fatherName,
              onChanged: (p0) => widget.person.father?.fatherName = p0,
              labelText: "اسم الأب",
              minimum: 2,
            ),
            10.getHightSizedBox,
            MyPhoneField(
              enabled: widget.enabled,
              initVal: widget.person.father?.phoneNumber,
              onTap: (isCall) {
                callWhatsApp(widget.person.father?.phoneNumber, isCall);
              },
              onChanged: (p0) => setState(() {
                widget.person.father?.phoneNumber = p0;
              }),
              labelText: "رقم الأب",
            ),
            10.getHightSizedBox,
            MyTextFormField(
              enabled: widget.enabled,
              initVal: widget.person.father?.jobName,
              onChanged: (p0) => widget.person.father?.jobName = p0,
              labelText: "عمل الأب",
            ),
            10.getHightSizedBox,
            MyComboBox(
              enabled: widget.enabled,
              text: CustomState.getStateFromId(widget.person.father?.state),
              hint: "حالة الأب",
              items: CustomState.personStates,
              onChanged: (value) {
                setState(() {
                  widget.person.father?.state =
                      CustomState.getIdFromState(value);
                });
              },
            ),
            10.getHightSizedBox,
            ExpandedSection(
              expand: _currentExpanded == 0,
              onTap: () {
                setState(() {
                  if (_currentExpanded == 0) {
                    _currentExpanded = null;
                  } else {
                    _currentExpanded = 0;
                  }
                });
              },
              child: buildTitle(" الأم"),
              expandedChild: [
                MyTextFormField(
                  enabled: widget.enabled,
                  initVal: widget.person.mother?.motherName,
                  labelText: "اسم الأم",
                  onChanged: (p0) => widget.person.mother?.motherName = p0,
                ),
                10.getHightSizedBox,
                MyPhoneField(
                  enabled: widget.enabled,
                  onChanged: (p0) => setState(() {
                    widget.person.mother?.phoneNumber = p0;
                  }),
                  initVal: widget.person.mother?.phoneNumber,
                  onTap: (isCall) {
                    callWhatsApp(widget.person.mother?.phoneNumber, isCall);
                  },
                  labelText: "رقم الأم",
                ),
                10.getHightSizedBox,
                MyTextFormField(
                  enabled: widget.enabled,
                  initVal: widget.person.mother?.jobName,
                  onChanged: (p0) => widget.person.mother?.jobName = p0,
                  labelText: "عمل الأم",
                ),
                10.getHightSizedBox,
                MyComboBox(
                  enabled: widget.enabled,
                  text: CustomState.getStateFromId(widget.person.mother?.state),
                  hint: "حالة الأم",
                  items: CustomState.personStates,
                  onChanged: (value) {
                    setState(() {
                      widget.person.mother?.state =
                          CustomState.getIdFromState(value);
                    });
                  },
                ),
              ],
            ),
            10.getHightSizedBox,
            ExpandedSection(
              expand: _currentExpanded == 1,
              onTap: () {
                setState(() {
                  if (_currentExpanded == 1) {
                    _currentExpanded = null;
                  } else {
                    _currentExpanded = 1;
                  }
                });
              },
              child: buildTitle(" القريب"),
              expandedChild: [
                MyTextFormField(
                  initVal: widget.person.kin?.kinName,
                  onChanged: (p0) => widget.person.kin!.kinName = p0,
                  enabled: widget.enabled,
                  labelText: "اسم القريب",
                ),
                10.getHightSizedBox,
                MyPhoneField(
                  initVal: widget.person.kin?.phoneNumber,
                  enabled: widget.enabled,
                  onTap: (isCall) {
                    callWhatsApp(widget.person.kin?.phoneNumber, isCall);
                  },
                  onChanged: (p0) => setState(() {
                    widget.person.kin?.phoneNumber = p0;
                  }),
                  labelText: "رقم القريب",
                ),
                10.getHightSizedBox,
                MyComboBox(
                  text: CustomState.getStateFromId(widget.person.kin?.state),
                  enabled: widget.enabled,
                  hint: "حالة القريب",
                  items: CustomState.personStates,
                  onChanged: (value) {
                    setState(() {
                      widget.person.kin?.state =
                          CustomState.getIdFromState(value);
                    });
                  },
                ),
              ],
            ),
            buildTitle("رقم التواصل"),
            MyPhoneField(
              enabled: widget.enabled,
              labelText: "رقم التواصل",
              enableSearch: true,
              isRequired: true,
              onTap: (isCall) {
                callWhatsApp(widget.person.whatsappNumber, isCall);
              },
              onSelected: (p0) async {
                setState(() {
                  widget.person.whatsappNumber = p0;
                });
              },
              data: getNumbers,
              initVal: widget.person.whatsappNumber,
              onChanged: (p0) => widget.person.whatsappNumber = p0,
            ),
            10.getHightSizedBox,
            ExpandedSection(
              expand: _currentExpanded == 2,
              onTap: () {
                setState(() {
                  if (_currentExpanded == 2) {
                    _currentExpanded = null;
                  } else {
                    _currentExpanded = 2;
                  }
                });
              },
              child: buildTitle("معلومات إضافية"),
              expandedChild: [
                MyTextFormField(
                  initVal: widget.person.job,
                  enabled: widget.enabled,
                  onChanged: (p0) => widget.person.job = p0,
                  labelText: "العمل",
                  suffixIcon: const Icon(Icons.work),
                ),
                10.getHightSizedBox,
                MyTextFormField(
                  initVal: widget.person.email,
                  labelText: "الايميل",
                  enabled: widget.enabled,
                  onChanged: (p0) => widget.person.email = p0,
                  textInputType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.alternate_email),
                ),
                10.getHightSizedBox,
                MyTextFormField(
                  initVal: widget.person.distinguishingSigns,
                  labelText: "علامات مميزة",
                  enabled: widget.enabled,
                  onChanged: (p0) => widget.person.distinguishingSigns = p0,
                ),
                10.getHightSizedBox,
                MyTextFormField(
                  initVal: widget.person.note,
                  enabled: widget.enabled,
                  labelText: "ملاحظات",
                  textInputType: TextInputType.multiline,
                  onChanged: (p0) => widget.person.note = p0,
                ),
                10.getHightSizedBox,
                if (myAccount.custom!.appoint)
                  MyTextFormField(
                    labelText: "اسم المستخدم",
                    initVal: widget.person.userName,
                    suffixIcon: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.person.userName ?? ""),
                          );
                        },
                        icon: const Icon(Icons.copy)),
                    enabled: widget.enabled,
                    onChanged: (p0) => widget.person.userName = p0,
                  ),
                10.getHightSizedBox,
                if (myAccount.custom!.appoint && widget.enabled)
                  MyTextPassField(
                    enable: widget.enabled,
                    labelText: "كلمة المرور",
                    onChanged: (p0) => widget.person.password = p0,
                  ),
                10.getHightSizedBox,
              ],
            ),
            10.getHightSizedBox,
          ],
        );
      }
    }
  }

  List<PhoneNumber> get getNumbers {
    final List<PhoneNumber> list = [];
    if ((widget.person.primaryNumber?.length ?? 0) >= 10) {
      list.add(
        PhoneNumber(number: widget.person.primaryNumber!, name: "الرقم الشخصي"),
      );
    }
    if ((widget.person.father?.phoneNumber?.length ?? 0) >= 10) {
      list.add(
        PhoneNumber(
            number: widget.person.father!.phoneNumber!, name: "رقم الأب"),
      );
    }
    if ((widget.person.mother?.phoneNumber?.length ?? 0) >= 10) {
      list.add(
        PhoneNumber(
            number: widget.person.mother!.phoneNumber!, name: "رقم الأم"),
      );
    }
    if ((widget.person.kin?.phoneNumber?.length ?? 0) >= 10) {
      list.add(
        PhoneNumber(
            number: widget.person.kin!.phoneNumber!, name: "رقم القريب"),
      );
    }
    return list;
  }

  buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: Divider()),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
