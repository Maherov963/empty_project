import 'package:al_khalil/app/components/chooser_list.dart';
import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/my_info_list.dart';
import 'package:al_khalil/app/pages/home/home_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/static/id_name_model.dart';
import '../../components/chooser_button.dart';
import '../../components/image_picker_mobile.dart';
import '../../components/my_snackbar.dart';
import '../../components/waiting_animation.dart';
import '../../components/wheel_picker.dart';
import '../../providers/states/provider_states.dart';
import '../../router/router.dart';
import '../../utils/widgets/auto_complete.dart';
import '../../utils/widgets/auto_complete_number.dart';

class AddPersonPage extends StatefulWidget {
  final Person? person;
  final bool fromEdit;
  const AddPersonPage({
    this.person,
    super.key,
    this.fromEdit = false,
  });

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  Person _person = Person(
    personState: IdNameModel(),
    father: Father(fatherState: IdNameModel()),
    mother: Mother(motherState: IdNameModel()),
    address: Address(),
    education: Education(),
    student: Student(
      groupIdName: IdNameModel(),
      studentState: IdNameModel(),
    ),
    custom: Custom(
      assitantsGroups: const [],
      superVisorGroups: const [],
      moderatorGroups: const [],
      state: IdNameModel(),
    ),
    kin: Kin(kinState: IdNameModel()),
  );
  bool showMajorName = false;
  bool showMajorYear = false;
  late TextEditingController imageController;
  TextEditingController nameController = TextEditingController();
  final _key = GlobalKey<FormState>();
  var _currentIndex = 0;
  List<String> years = List.generate(60, (index) => "${1960 + index}");

  @override
  initState() {
    if (widget.person != null) {
      _person = widget.person!.copy();
      _person.student ??= Student(
        groupIdName: IdNameModel(),
        studentState: IdNameModel(),
      );
      _person.personState ??= IdNameModel();
      _person.father ??= Father(fatherState: IdNameModel());
      _person.mother ??= Mother(motherState: IdNameModel());
      _person.address ??= Address();
      _person.education ??= Education();
      _person.custom ??= Custom(
        assitantsGroups: [],
        superVisorGroups: [],
        moderatorGroups: [],
        state: IdNameModel(),
      );
      _person.custom?.assitantsGroups ??= [];
      _person.custom?.superVisorGroups ??= [];
      _person.custom?.moderatorGroups ??= [];
      _person.kin ??= Kin(kinState: IdNameModel());
      imageController = TextEditingController(text: widget.person!.imageLink);
    } else {
      final stat = context.read<CoreProvider>();
      _person.personState = stat.parentsStates.first.copy();
      _person.father!.fatherState = stat.parentsStates.first.copy();
      _person.mother!.motherState = stat.parentsStates.first.copy();
      _person.personState = stat.parentsStates.first.copy();
      _person.student!.studentState = stat.groupStates.first.copy();
      _person.custom!.state = stat.groupStates.first.copy();
      imageController = TextEditingController(text: null);
    }
    _person.midName = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Person? myAccount = context.read<CoreProvider>().myAccount;
    List<Widget> taps = [
      _person.id == null && !myAccount!.custom!.addPerson
          ? const Text("لاتمتلك الصلاحيات لإضافة أشخاص")
          : _person.id != null && !myAccount!.custom!.editPerson
              ? const Text("لاتمتلك الصلاحيات لتعديل أشخاص")
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyAutoComplete(
                        labelText: "الاسم",
                        onSelected: (p0) async {
                          if (myAccount!.custom!.editPerson &&
                              p0 != myAccount.id) {
                            await MyRouter.navigateToEditPerson(context, p0);
                          } else {
                            await MyRouter.navigateToPerson(context, p0);
                          }
                        },
                        initVal: _person.firstName,
                        onChanged: (p0) => _person.firstName = p0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyAutoComplete(
                        labelText: "الكنية",
                        onSelected: (p0) async {
                          if (myAccount!.custom!.editPerson &&
                              p0 != myAccount.id) {
                            await MyRouter.navigateToEditPerson(context, p0);
                          } else {
                            await MyRouter.navigateToPerson(context, p0);
                          }
                        },
                        initVal: _person.lastName,
                        onChanged: (p0) => _person.lastName = p0,
                      ),
                    ),
                    MyInfoCardEdit(
                      child: InkWell(
                        onTap: () async {
                          String? year = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return YearPickerDialog(
                                init: _person.birthDate,
                                dates: List.generate(
                                    60, (index) => "${1960 + index}"),
                              );
                            },
                          );
                          if (year != null) {
                            setState(() {
                              _person.birthDate = year;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("سنة الميلاد"),
                              Text(
                                _person.birthDate?.substring(0, 4) == null
                                    ? 'اضغط للاختيار'
                                    : '${_person.birthDate?.substring(0, 4)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              20.getWidthSizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MyInfoList(
                      title: "الدراسة",
                      data: [
                        MyInfoCardEdit(
                          child: Row(
                            children: [
                              const Text("المرحلة الدراسية"),
                              10.getWidthSizedBox(),
                              Expanded(
                                  child: MyComboBox(
                                      text: _person.education!.educationType,
                                      onChanged: (p0) {
                                        if (p0 == "جامعي") {
                                          showMajorName = true;
                                          showMajorYear = true;
                                        } else if (p0 == "متخرج") {
                                          showMajorName = true;
                                          showMajorYear = false;
                                        } else {
                                          showMajorName = false;
                                          showMajorYear = false;
                                        }
                                        setState(() {});
                                        _person.education!.educationType = p0;
                                      },
                                      items: context
                                          .read<CoreProvider>()
                                          .educationTypes)),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showMajorName,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                              initVal: _person.education!.majorName,
                              onChanged: (p0) =>
                                  _person.education!.majorName = p0,
                              labelText: "اسم الاختصاص",
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showMajorYear,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                              initVal: _person.education!.majorYear,
                              onChanged: (p0) =>
                                  _person.education!.majorYear = p0,
                              labelText: "سنة الاختصاص",
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    MyInfoList(
                      title: "العنوان",
                      data: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.address!.area,
                            onChanged: (p0) => _person.address!.area = p0,
                            labelText: "المنطقة",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.address!.mark,
                            onChanged: (p0) => _person.address!.mark = p0,
                            labelText: "علامة",
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyPhoneField(
                        initVal: _person.primaryNumber,
                        onChanged: (p0) => _person.primaryNumber = p0,
                        labelText: "الرقم الشخصي",
                      ),
                    ),
                    MyInfoList(
                      title: "الأب",
                      data: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.father!.fatherName,
                            onChanged: (p0) => _person.father!.fatherName = p0,
                            labelText: "اسم الأب",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyPhoneField(
                            initVal: _person.father!.phoneNumber,
                            onChanged: (p0) => _person.father!.phoneNumber = p0,
                            labelText: "رقم الأب",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.father!.jobName,
                            onChanged: (p0) => _person.father!.jobName = p0,
                            labelText: "عمل الأب",
                          ),
                        ),
                        ChooserButtonn(
                          title: "حالة الأب",
                          text: "اختر حالة الأب",
                          isState: true,
                          controller: _person.father!.fatherState!,
                          insertPressed: () async {
                            var choosen = await MySnackBar.showMyChooseOne(
                                stPer: 1,
                                title: "اختر حالة الأب",
                                context: context,
                                data:
                                    context.read<CoreProvider>().parentsStates,
                                idNameModel: _person.father!.fatherState!);
                            setState(() {
                              _person.father!.fatherState!.id = choosen?.id;
                              _person.father!.fatherState!.name = choosen?.name;
                            });
                          },
                        ),
                      ],
                    ),
                    MyInfoList(
                      title: "الأم",
                      data: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.mother!.motherName,
                            labelText: "اسم الأم",
                            onChanged: (p0) => _person.mother!.motherName = p0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyPhoneField(
                            onChanged: (p0) => _person.mother!.phoneNumber = p0,
                            initVal: _person.mother!.phoneNumber,
                            labelText: "رقم الأم",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.mother!.jobName,
                            onChanged: (p0) => _person.mother!.jobName = p0,
                            labelText: "عمل الأم",
                          ),
                        ),
                        ChooserButtonn(
                          title: "حالة الأم",
                          text: "اختر حالة الأم",
                          isState: true,
                          controller: _person.mother!.motherState!,
                          insertPressed: () async {
                            var choosen = await MySnackBar.showMyChooseOne(
                                stPer: 1,
                                title: "اختر حالة الأم",
                                context: context,
                                data:
                                    context.read<CoreProvider>().parentsStates,
                                idNameModel: _person.mother!.motherState!);
                            setState(() {
                              _person.mother!.motherState!.id = choosen?.id;
                              _person.mother!.motherState!.name = choosen?.name;
                            });
                          },
                        ),
                      ],
                    ),
                    MyInfoList(
                      title: "قريب",
                      data: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.kin!.kinName,
                            onChanged: (p0) => _person.kin!.kinName = p0,
                            labelText: "اسم القريب",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyPhoneField(
                            initVal: _person.kin!.phoneNumber,
                            onChanged: (p0) => _person.kin!.phoneNumber = p0,
                            labelText: "رقم القريب",
                          ),
                        ),
                        ChooserButtonn(
                          title: "حالة القريب",
                          text: "اختر حالة القريب",
                          isState: true,
                          controller: _person.kin!.kinState!,
                          insertPressed: () async {
                            var choosen = await MySnackBar.showMyChooseOne(
                                stPer: 1,
                                title: "اختر حالة القريب",
                                context: context,
                                data:
                                    context.read<CoreProvider>().parentsStates,
                                idNameModel: _person.kin!.kinState!);
                            setState(() {
                              _person.kin!.kinState!.id = choosen?.id;
                              _person.kin!.kinState!.name = choosen?.name;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyAutoCompleteNumber(
                        onTap: () {
                          context.read<PersonProvider>().withFather =
                              _person.father!.phoneNumber != null &&
                                  _person.father!.phoneNumber != "";
                          context.read<PersonProvider>().withMother =
                              _person.mother!.phoneNumber != null &&
                                  _person.mother!.phoneNumber != "";
                          context.read<PersonProvider>().withKin =
                              _person.kin!.phoneNumber != null &&
                                  _person.kin!.phoneNumber != "";
                          context.read<PersonProvider>().withPersonal =
                              _person.primaryNumber != null &&
                                  _person.primaryNumber != "";
                        },
                        onSelected: (p0) async {
                          setState(() {
                            switch (p0) {
                              case "0رقم الأم":
                                _person.whatsappNumber =
                                    _person.mother!.phoneNumber;
                                break;
                              case "0رقم الأب":
                                _person.whatsappNumber =
                                    _person.father!.phoneNumber;
                                break;
                              case "0الرقم الشخصي":
                                _person.whatsappNumber = _person.primaryNumber;
                                break;
                              case "0رقم القريب":
                                _person.whatsappNumber =
                                    _person.kin!.phoneNumber;
                                break;
                            }
                          });
                        },
                        initVal: _person.whatsappNumber,
                        onChanged: (p0) => _person.whatsappNumber = p0,
                      ),
                    ),
                    MyInfoList(
                      title: "معلومات اضافية",
                      data: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.job,
                            onChanged: (p0) => _person.job = p0,
                            labelText: "العمل",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.email,
                            labelText: "الايميل",
                            onChanged: (p0) => _person.email = p0,
                            textInputType: TextInputType.emailAddress,
                            preIcon: const Icon(Icons.alternate_email),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.distinguishingSigns,
                            labelText: "علامات مميزة",
                            onChanged: (p0) => _person.distinguishingSigns = p0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormField(
                            initVal: _person.note,
                            labelText: "ملاحظات",
                            textInputType: TextInputType.multiline,
                            onChanged: (p0) => _person.note = p0,
                          ),
                        ),
                        ChooserButtonn(
                          title: "حالة الشخص",
                          text: "اختر حالة الشخص",
                          isState: true,
                          controller: _person.personState!,
                          insertPressed: () async {
                            var choosen = await MySnackBar.showMyChooseOne(
                                stPer: 1,
                                title: "اختر حالة الشخص",
                                context: context,
                                data:
                                    context.read<CoreProvider>().parentsStates,
                                idNameModel: _person.personState!);
                            setState(() {
                              //_person.personState = choosen;
                              _person.personState!.id = choosen?.id;
                              _person.personState!.name = choosen?.name;
                            });
                          },
                        ),
                        !myAccount!.custom!.appoint
                            ? 0.getHightSizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyTextFormField(
                                  labelText: "اسم حساب الشخص",
                                  initVal: _person.userName,
                                  onChanged: (p0) => _person.userName = p0,
                                ),
                              ),
                        !myAccount.custom!.appoint
                            ? 0.getHightSizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyTextPassField(
                                  enable: !(widget.fromEdit &&
                                      !myAccount.custom!.appoint),
                                  labelText: "كلمة المرور",
                                  onChanged: (p0) => _person.password = p0,
                                  autofillHints: const [
                                    AutofillHints.newPassword
                                  ],
                                ),
                              ),
                      ],
                    ),
                    100.getHightSizedBox(),
                  ],
                ),
      _person.id == null && !myAccount.custom!.addPerson
          ? const Text("لاتمتلك الصلاحيات لإضافة أشخاص")
          : _person.id != null && !myAccount.custom!.editPerson
              ? const Text("لاتمتلك الصلاحيات لتعديل أشخاص")
              : Column(
                  children: [
                    20.getHightSizedBox(),
                    ImagePickerMobile(
                        imageController: imageController, radius: 50),
                    20.getHightSizedBox(),
                    const Text("اختر صورة شخصية"),
                    100.getHightSizedBox(),
                  ],
                ),
      _person.student!.id == null && !myAccount.custom!.appointStudent
          ? const Text("لاتمتلك الصلاحيات لإضافة طلاب")
          : _person.student!.id != null && !myAccount.custom!.appointStudent
              ? const Text("لاتمتلك الصلاحيات لتعديل طلاب")
              : Column(
                  children: [
                    if (_person.student!.studentState!.id != 2)
                      IconButton(
                        onPressed: () {
                          MySnackBar.showMySnackBar(
                              "حالة الطالب غير نشط", context,
                              contentType: ContentType.warning, title: "انتبه");
                        },
                        icon: Icon(
                          Icons.warning_amber,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ChooserButtonn(
                      title: "حالة الطالب",
                      isState: true,
                      text: "اختر حالة الطالب",
                      controller: _person.student!.studentState!,
                      onDelete: () {
                        setState(() {});
                      },
                      insertPressed: () async {
                        var choosen = await MySnackBar.showMyChooseOne(
                            stPer: 1,
                            title: "اختر حالة الطالب",
                            context: context,
                            data: context.read<CoreProvider>().groupStates,
                            idNameModel: _person.student!.studentState!);
                        setState(() {
                          // _person.student!.studentState = IdNameModel();
                          _person.student!.studentState!.id = choosen?.id;
                          _person.student!.studentState!.name = choosen?.name;
                        });
                      },
                    ),
                    ChooserButtonn(
                      title: "حلقة الطالب",
                      text: "اختر حلقة الطالب",
                      onPressed: context
                                  .watch<GroupProvider>()
                                  .isLoadingGroup ==
                              _person.student?.groupIdName?.id
                          ? null
                          : () async {
                              await MyRouter.navigateToGroup(
                                  context, _person.student!.groupIdName!.id!);
                            },
                      controller: _person.student!.groupIdName!,
                      insertPressed: context.watch<GroupProvider>().isLoadingIn
                          ? null
                          : () async {
                              await context
                                  .read<GroupProvider>()
                                  .getAllGroups()
                                  .then((state) async {
                                if (state is GroupsState) {
                                  var choosen = await MySnackBar.showMyGroupOne(
                                      classsCount: state.groups
                                          .map((e) => IdNameModel(
                                              id: e.students!.length,
                                              name: e.classs))
                                          .toList(),
                                      stGrPer: 2,
                                      title: "اختر حلقة الطالب",
                                      context: context,
                                      data: state.groups
                                          .map((e) => IdNameModel(
                                              id: e.id, name: e.groupName))
                                          .toList(),
                                      idNameModel:
                                          _person.student!.groupIdName!);
                                  setState(() {
                                    _person.student!.groupIdName =
                                        choosen ?? _person.student!.groupIdName;
                                  });
                                }
                                if (state is ErrorState && context.mounted) {
                                  MySnackBar.showMySnackBar(
                                      state.failure.message, context,
                                      contentType: ContentType.failure,
                                      title: "حدث خطأ");
                                }
                              });
                            },
                    ),
                    100.getHightSizedBox(),
                  ],
                ),
      _person.custom!.id == null && !myAccount.custom!.appoint
          ? const Text("لاتمتلك الصلاحيات لإضافة أستاذ")
          : _person.custom!.id != null && !myAccount.custom!.appoint
              ? const Text("لاتمتلك الصلاحيات لتعديل أستاذ")
              : Column(
                  children: [
                    if (_person.custom!.state!.id != 2)
                      IconButton(
                          onPressed: () {
                            MySnackBar.showMySnackBar(
                                "حالة الأستاذ غير نشط", context,
                                contentType: ContentType.warning,
                                title: "انتبه");
                          },
                          icon: Icon(
                            Icons.warning_amber,
                            color: Theme.of(context).colorScheme.error,
                          )),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.admin,
                        text: "admin",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.admin = p0!;
                          _person.custom!.tester = p0;
                          _person.custom!.manager = p0;
                          _person.custom!.moderator = p0;
                          _person.custom!.supervisor = p0;
                          _person.custom!.assistant = p0;
                          _person.custom!.custom = p0;
                          _person.custom!.adder = p0;
                          _person.custom!.reciter = p0;
                          _person.custom!.seller = p0;
                          _person.custom!.viewPerson = p0;
                          _person.custom!.viewPeople = p0;
                          _person.custom!.addPerson = p0;
                          _person.custom!.editPerson = p0;
                          _person.custom!.viewGroups = p0;
                          _person.custom!.viewGroup = p0;
                          _person.custom!.appointStudent = p0;
                          _person.custom!.viewRecite = p0;
                          _person.custom!.appoint = p0;
                          _person.custom!.deletePerson = p0;
                          _person.custom!.addGroup = p0;
                          _person.custom!.editGroup = p0;
                          _person.custom!.deleteGroup = p0;
                          _person.custom!.observe = p0;
                          _person.custom!.recite = p0;
                          _person.custom!.test = p0;
                          _person.custom!.sell = p0;
                          _person.custom!.attendance = p0;
                          _person.custom!.viewAttendance = p0;
                          _person.custom!.evaluation = p0;
                          _person.custom!.level = p0;
                          _person.custom!.viewLog = p0;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.tester,
                        text: "tester",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.tester = p0!;
                          _person.custom!.test = p0;
                          _person.custom!.viewGroup = p0;
                          _person.custom!.viewPerson = p0;
                          _person.custom!.viewRecite = p0;
                          _person.custom!.editPerson = p0;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.manager,
                        text: "manager",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.manager = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                        child: Column(
                      children: [
                        MyCheckBox(
                          val: _person.custom!.moderator,
                          text: "moderator",
                          onChanged: (p0) {
                            setState(() {});
                            _person.custom!.moderator = p0!;
                            _person.custom!.editPerson = p0;
                            _person.custom!.viewPerson = p0;
                            _person.custom!.viewGroup = p0;
                            _person.custom!.recite = p0;
                            _person.custom!.viewRecite = p0;
                            _person.custom!.attendance = p0;
                            _person.custom!.viewAttendance = p0;
                            _person.custom!.evaluation = p0;
                          },
                        ),
                        !_person.custom!.moderator
                            ? const SizedBox.shrink()
                            : ChooserListo(
                                title: "الحلقات الخاصة بالأستاذ",
                                text: "اختر حلقة للإضافة",
                                isPerson: false,
                                choosingData: _person.custom!.moderatorGroups!,
                                insertPressed:
                                    context.watch<GroupProvider>().isLoadingIn
                                        ? null
                                        : () async {
                                            await context
                                                .read<GroupProvider>()
                                                .getAllGroups()
                                                .then((state) async {
                                              if (state is GroupsState) {
                                                var x = await MySnackBar
                                                    .showMyltiPicker(
                                                        // title: "اختر حلقة للإضافة",
                                                        context: context,
                                                        isPerson: false,
                                                        data: state.groups
                                                            .map((e) => IdNameModel(
                                                                id: e.id,
                                                                name:
                                                                    "${e.groupName}"))
                                                            .toList(),
                                                        choosen: List.generate(
                                                            _person
                                                                .custom!
                                                                .moderatorGroups!
                                                                .length,
                                                            (index) => IdNameModel(
                                                                id: _person
                                                                    .custom!
                                                                    .moderatorGroups![
                                                                        index]
                                                                    .id,
                                                                name: _person
                                                                    .custom!
                                                                    .moderatorGroups![index]
                                                                    .name)));

                                                setState(() {
                                                  _person.custom!
                                                          .moderatorGroups =
                                                      x ??
                                                          _person.custom!
                                                              .moderatorGroups;
                                                });
                                              }
                                              if (state is ErrorState &&
                                                  context.mounted) {
                                                MySnackBar.showMySnackBar(
                                                    state.failure.message,
                                                    context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "حدث خطأ");
                                              }
                                            });
                                          },
                              )
                      ],
                    )),
                    MyInfoCardEdit(
                        child: Column(
                      children: [
                        MyCheckBox(
                          val: _person.custom!.supervisor,
                          text: "supervisor",
                          onChanged: (p0) {
                            setState(() {});
                            _person.custom!.supervisor = p0!;
                            _person.custom!.viewGroup = p0;
                            _person.custom!.editPerson = p0;
                            _person.custom!.viewGroups = p0;
                            _person.custom!.viewPeople = p0;
                            _person.custom!.viewPerson = p0;
                            _person.custom!.viewRecite = p0;
                            _person.custom!.viewAttendance = p0;
                          },
                        ),
                        !_person.custom!.supervisor
                            ? const SizedBox.shrink()
                            : ChooserListo(
                                title: "الحلقات الخاصة بالمشرف",
                                text: "اختر حلقة للإضافة",
                                isPerson: false,
                                choosingData: _person.custom!.superVisorGroups!,
                                insertPressed:
                                    context.watch<GroupProvider>().isLoadingIn
                                        ? null
                                        : () async {
                                            await context
                                                .read<GroupProvider>()
                                                .getAllGroups()
                                                .then((state) async {
                                              if (state is GroupsState) {
                                                var x = await MySnackBar
                                                    .showMyltiPicker(
                                                        // title: "اختر حلقة للإضافة",
                                                        context: context,
                                                        isPerson: false,
                                                        data: state.groups
                                                            .map((e) => IdNameModel(
                                                                id: e.id,
                                                                name:
                                                                    "${e.groupName}"))
                                                            .toList(),
                                                        choosen: List.generate(
                                                            _person
                                                                .custom!
                                                                .superVisorGroups!
                                                                .length,
                                                            (index) => IdNameModel(
                                                                id: _person
                                                                    .custom!
                                                                    .superVisorGroups![
                                                                        index]
                                                                    .id,
                                                                name: _person
                                                                    .custom!
                                                                    .superVisorGroups![index]
                                                                    .name)));

                                                setState(() {
                                                  _person.custom!
                                                          .superVisorGroups =
                                                      x ??
                                                          _person.custom!
                                                              .superVisorGroups;
                                                });
                                              }
                                              if (state is ErrorState &&
                                                  context.mounted) {
                                                MySnackBar.showMySnackBar(
                                                    state.failure.message,
                                                    context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "حدث خطأ");
                                              }
                                            });
                                          },
                              )
                      ],
                    )),
                    MyInfoCardEdit(
                        child: Column(
                      children: [
                        MyCheckBox(
                          val: _person.custom!.assistant,
                          text: "assistant",
                          onChanged: (p0) {
                            setState(() {});
                            _person.custom!.assistant = p0!;
                            _person.custom!.viewGroup = p0;
                            _person.custom!.recite = p0;
                            _person.custom!.viewRecite = p0;
                            _person.custom!.editPerson = p0;
                          },
                        ),
                        !_person.custom!.assistant
                            ? const SizedBox.shrink()
                            : ChooserListo(
                                title: "الحلقات الأستاذ المساعد",
                                text: "اختر حلقة للإضافة",
                                isPerson: false,
                                choosingData: _person.custom!.assitantsGroups!,
                                insertPressed:
                                    context.watch<GroupProvider>().isLoadingIn
                                        ? null
                                        : () async {
                                            await context
                                                .read<GroupProvider>()
                                                .getAllGroups()
                                                .then((state) async {
                                              if (state is GroupsState) {
                                                var x = await MySnackBar
                                                    .showMyltiPicker(
                                                        // title: "اختر حلقة للإضافة",
                                                        context: context,
                                                        isPerson: false,
                                                        data: state.groups
                                                            .map((e) => IdNameModel(
                                                                id: e.id,
                                                                name:
                                                                    "${e.groupName}"))
                                                            .toList(),
                                                        choosen: List.generate(
                                                            _person
                                                                .custom!
                                                                .assitantsGroups!
                                                                .length,
                                                            (index) => IdNameModel(
                                                                id: _person
                                                                    .custom!
                                                                    .assitantsGroups![
                                                                        index]
                                                                    .id,
                                                                name: _person
                                                                    .custom!
                                                                    .assitantsGroups![index]
                                                                    .name)));

                                                setState(() {
                                                  _person.custom!
                                                          .assitantsGroups =
                                                      x ??
                                                          _person.custom!
                                                              .assitantsGroups;
                                                });
                                              }
                                              if (state is ErrorState &&
                                                  context.mounted) {
                                                MySnackBar.showMySnackBar(
                                                    state.failure.message,
                                                    context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "حدث خطأ");
                                              }
                                            });
                                          },
                              )
                      ],
                    )),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.custom,
                        text: "custom",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.custom = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.adder,
                        text: "adder",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.adder = p0!;
                          _person.custom!.viewPeople = p0;
                          _person.custom!.viewPerson = p0;
                          _person.custom!.addPerson = p0;
                          _person.custom!.editPerson = p0;
                          _person.custom!.viewGroups = p0;
                          _person.custom!.viewGroup = p0;
                          _person.custom!.appointStudent = p0;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.reciter,
                        text: "reciter",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.reciter = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      child: MyCheckBox(
                        val: _person.custom!.seller,
                        text: "seller",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.seller = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewPerson,
                        text: "viewPerson",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewPerson = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewPeople,
                        text: "viewPeople",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewPeople = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.addPerson,
                        text: "addPerson",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.addPerson = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.editPerson,
                        text: "editPerson",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.editPerson = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewGroups,
                        text: "viewGroups",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewGroups = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewGroup,
                        text: "viewGroup",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewGroup = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.appointStudent,
                        text: "appointStudent",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.appointStudent = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewRecite,
                        text: "viewRecite",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewRecite = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.appoint,
                        text: "appoint",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.appoint = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.deletePerson,
                        text: "deletePerson",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.deletePerson = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.addGroup,
                        text: "addGroup",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.addGroup = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.editGroup,
                        text: "editGroup",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.editGroup = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.deleteGroup,
                        text: "deleteGroup",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.deleteGroup = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.observe,
                        text: "observe",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.observe = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.recite,
                        text: "recite",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.recite = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.test,
                        text: "test",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.test = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.sell,
                        text: "sell",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.sell = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.attendance,
                        text: "attendance",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.attendance = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewAttendance,
                        text: "viewAttendance",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewAttendance = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.evaluation,
                        text: "evaluation",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.evaluation = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.level,
                        text: "level",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.level = p0!;
                        },
                      ),
                    ),
                    MyInfoCardEdit(
                      isfunc: true,
                      child: MyCheckBox(
                        val: _person.custom!.viewLog,
                        text: "viewLog",
                        onChanged: (p0) {
                          setState(() {});
                          _person.custom!.viewLog = p0!;
                        },
                      ),
                    ),
                    ChooserButtonn(
                      title: "حالة الأستاذ",
                      text: "اختر حالة الأستاذ",
                      isState: true,
                      onDelete: () {
                        setState(() {});
                      },
                      controller: _person.custom!.state!,
                      insertPressed: () async {
                        var choosen = await MySnackBar.showMyChooseOne(
                            stPer: 1,
                            title: "اختر حالة الأستاذ",
                            context: context,
                            data: context.read<CoreProvider>().groupStates,
                            idNameModel: _person.custom!.state!);
                        setState(() {
                          // _person.custom!.state = choosen;
                          _person.custom!.state!.id = choosen?.id;
                          _person.custom!.state!.name = choosen?.name;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextFormField(
                        labelText: "ملاحظات",
                        maximum: 1000,
                        initVal: _person.custom!.note,
                        onChanged: (p0) => _person.custom!.note = p0,
                      ),
                    ),
                    100.getHightSizedBox(),
                  ],
                ),
    ];
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تحذير'),
              content: const Text('لن يتم حفظ التغييرات'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('نعم')),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('لا')),
              ],
            );
          },
        );
      },
      child: Consumer<PersonProvider>(
          builder: (__, value, _) => Form(
                key: _key,
                child: Scaffold(
                  appBar: AppBar(
                    actions: [
                      Visibility(
                          replacement: IconButton(
                              onPressed: () async {
                                late bool boolean;
                                switch (_currentIndex) {
                                  case 0:
                                    if (_person.id != null) {
                                      boolean = await _editPerson();
                                    } else {
                                      boolean = await _addPerson(context);
                                    }
                                    break;
                                  case 1:
                                    if (mounted) {
                                      boolean = await _addImage(context);
                                    }
                                    break;
                                  case 2:
                                    if (_person.student!.id != null &&
                                        mounted) {
                                      boolean = await _editStudent(context);
                                    } else if (mounted) {
                                      boolean = await _addStudent(context);
                                    }
                                    break;
                                  case 3:
                                    if (_person.custom!.id != null && mounted) {
                                      boolean = await _editPermission(context);
                                    } else if (mounted) {
                                      boolean = await _addPermission(context);
                                    }
                                    break;
                                }
                                if (boolean && context.mounted) {
                                  if (_currentIndex == 2 &&
                                      !myAccount.custom!.appoint) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                        (route) => false);
                                  }

                                  if (_currentIndex == 3) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                        (route) => false);
                                  } else {
                                    if (_person.student!.groupIdName!.id ==
                                        null) {
                                      if (_person.education!.educationType !=
                                          null) {
                                        final groups = context
                                            .read<GroupProvider>()
                                            .groups;
                                        groups.sort(
                                          (a, b) {
                                            return a.students!.length
                                                .compareTo(b.students!.length);
                                          },
                                        );
                                        final g = groups.firstWhere(
                                          (element) =>
                                              element.classs ==
                                              _person.education!.educationType,
                                          orElse: () {
                                            return Group();
                                          },
                                        );
                                        _person.student!.groupIdName =
                                            IdNameModel(
                                                id: g.id, name: g.groupName);
                                      } else {
                                        _person.student!.groupIdName =
                                            IdNameModel(
                                                id: context
                                                    .read<GroupProvider>()
                                                    .groups
                                                    .first
                                                    .id,
                                                name: context
                                                    .read<GroupProvider>()
                                                    .groups
                                                    .first
                                                    .groupName);
                                      }
                                    }
                                    setState(() {
                                      if (_currentIndex == 0) {
                                        _currentIndex = _currentIndex + 2;
                                      } else {
                                        _currentIndex = _currentIndex + 1;
                                      }
                                    });
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.done,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )),
                          visible:
                              context.read<PersonProvider>().isLoadingPerson !=
                                      null ||
                                  context.read<PersonProvider>().isLoadingIn,
                          child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: MyWaitingAnimation())),
                    ],
                    title: widget.fromEdit
                        ? const Text("تعديل شخص")
                        : const Text("إضافة حساب جديد"),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  _currentIndex > 3
                                      ? const SizedBox.shrink()
                                      : taps[_currentIndex],
                                ],
                              ),
                            ),
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: _currentIndex == 0 ? false : true,
                                    child: TextButton(
                                      onPressed: value.isLoadingIn
                                          ? null
                                          : () async {
                                              setState(() {
                                                if (_currentIndex == 2) {
                                                  _currentIndex =
                                                      _currentIndex - 2;
                                                } else {
                                                  _currentIndex =
                                                      _currentIndex - 1;
                                                }
                                              });
                                            },
                                      child: Text(
                                        "السابق",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  (_currentIndex == 0 && !widget.fromEdit) ||
                                          (_currentIndex == 2 &&
                                              !myAccount.custom!.admin)
                                      ? const SizedBox.shrink()
                                      : TextButton(
                                          onPressed: value.isLoadingIn
                                              ? null
                                              : () async {
                                                  if (_currentIndex == 2 &&
                                                      !myAccount
                                                          .custom!.appoint) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomePage(),
                                                            ),
                                                            (route) => false);
                                                  }
                                                  if (_currentIndex == 3) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomePage(),
                                                            ),
                                                            (route) => false);
                                                  } else {
                                                    if (_person.student!
                                                            .groupIdName!.id ==
                                                        null) {
                                                      if (_person.education!
                                                              .educationType !=
                                                          null) {
                                                        final groups = context
                                                            .read<
                                                                GroupProvider>()
                                                            .groups;
                                                        groups.sort(
                                                          (a, b) {
                                                            return a.students!
                                                                .length
                                                                .compareTo(b
                                                                    .students!
                                                                    .length);
                                                          },
                                                        );
                                                        final g =
                                                            groups.firstWhere(
                                                          (element) =>
                                                              element.classs ==
                                                              _person.education!
                                                                  .educationType,
                                                          orElse: () {
                                                            return Group();
                                                          },
                                                        );
                                                        _person.student!
                                                                .groupIdName =
                                                            IdNameModel(
                                                                id: g.id,
                                                                name: g
                                                                    .groupName);
                                                      }
                                                    }
                                                    setState(() {
                                                      if (_currentIndex == 0) {
                                                        _currentIndex =
                                                            _currentIndex + 2;
                                                      } else {
                                                        _currentIndex =
                                                            _currentIndex + 1;
                                                      }
                                                    });
                                                  }
                                                },
                                          child: Text(
                                            "تخطي",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )),
    );
  }

  Future<bool> _addPerson(BuildContext context) async {
    if (_person.birthDate == null) {
      MySnackBar.showMySnackBar("اختر سنة الميلاد", context,
          contentType: ContentType.warning, title: "انتبه");
    } else {
      if (_person.education!.educationType == null) {
        MySnackBar.showMySnackBar("اختر المرحلة الدراسية", context,
            contentType: ContentType.warning, title: "انتبه");
      } else if (_person.mother!.motherState!.id == null ||
          _person.father!.fatherState!.id == null) {
        MySnackBar.showMySnackBar("اختر حالة الأب /الأم", context,
            contentType: ContentType.warning, title: "انتبه");
      } else if (_key.currentState!.validate()) {
        _person.student!.registerDate = DateTime.now().toString();
        if (_person.email != null && !_person.email!.contains("@")) {
          _person.email = "${_person.email}@gmail.com";
        }
        final ProviderStates state =
            await context.read<PersonProvider>().addPerson(_person);
        if (state is ErrorState && context.mounted) {
          MySnackBar.showMySnackBar(state.failure.message, context,
              contentType: ContentType.failure, title: "حدث خطأ");
          return false;
        }
        if (state is IdState && context.mounted) {
          _person.id = state.id;
          return true;
        }
      } else if (context.mounted) {
        MySnackBar.showMySnackBar("املأ الحقول الضرورية", context,
            contentType: ContentType.warning, title: "انتبه");
      }
    }

    return false;
  }

  Future<bool> _addImage(BuildContext context) async {
    _person.imageLink =
        imageController.text == "" ? null : imageController.text;
    if (_person.imageLink != null) {
      final ProviderStates state = await context
          .read<PersonProvider>()
          .addImage(_person.imageLink!, _person.id!);
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        return true;
      }
    }
    if (context.mounted) {
      MySnackBar.showMySnackBar("لم يتم اختيار صورة", context,
          contentType: ContentType.warning, title: "انتبه");
    }

    return false;
  }

  Future<bool> _addStudent(BuildContext context) async {
    if (_person.student!.groupIdName!.id == null) {
      MySnackBar.showMySnackBar("اختر حلقة الطالب", context,
          contentType: ContentType.warning, title: "انتبه");
    } else if (_person.student!.studentState!.id == null) {
      MySnackBar.showMySnackBar("اختر حالة الطالب", context,
          contentType: ContentType.warning, title: "انتبه");
    } else {
      _person.student!.id = _person.id;
      final ProviderStates state =
          await context.read<PersonProvider>().addStudent(_person.student!);
      if (state is ErrorState && context.mounted) {
        _person.student!.id = null;
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        return true;
      }
    }

    return false;
  }

  Future<bool> _addPermission(BuildContext context) async {
    if (_person.custom!.state!.id == null) {
      MySnackBar.showMySnackBar("اختر حالة الأستاذ", context,
          contentType: ContentType.warning, title: "الخليل");
    } else {
      _person.custom!.id = _person.id;
      final ProviderStates state =
          await context.read<PersonProvider>().addPermission(_person.custom!);
      if (state is ErrorState && context.mounted) {
        _person.custom!.id = null;
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");

        return true;
      }
    }

    return false;
  }

  Future<bool> _editStudent(BuildContext context) async {
    if (_person.student!.groupIdName!.id == null) {
      MySnackBar.showMySnackBar("اختر حلقة الطالب", context,
          contentType: ContentType.warning, title: "انتبه");
    } else if (_person.student!.studentState!.id == null) {
      MySnackBar.showMySnackBar("اختر حالة الطالب", context,
          contentType: ContentType.warning, title: "انتبه");
    } else {
      final ProviderStates state =
          await context.read<PersonProvider>().editStudent(_person.student!);
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");

        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        return true;
      }
    }

    return false;
  }

  Future<bool> _editPermission(BuildContext context) async {
    if (_person.custom!.state!.id == null) {
      MySnackBar.showMySnackBar("اختر حالة الأستاذ", context,
          contentType: ContentType.warning, title: "الخليل");
    } else {
      final ProviderStates state =
          await context.read<PersonProvider>().editPermission(_person.custom!);
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        return true;
      }
    }

    return false;
  }

  Future<bool> _editPerson() async {
    if (_person.education!.educationType == null) {
      MySnackBar.showMySnackBar("اختر المرحلة الدراسية", context,
          contentType: ContentType.warning, title: "انتبه");
    } else if (_person.birthDate == null) {
      MySnackBar.showMySnackBar("اختر سنة الميلاد", context,
          contentType: ContentType.warning, title: "انتبه");
    } else if (_person.mother!.motherState!.id == null ||
        _person.father!.fatherState!.id == null) {
      MySnackBar.showMySnackBar("اختر حالة الأب /الأم", context,
          contentType: ContentType.warning, title: "انتبه");
    } else if (_key.currentState!.validate()) {
      final ProviderStates state =
          await context.read<PersonProvider>().editPerson(_person);
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
        return false;
      }
      if (state is MessageState && context.mounted) {
        MySnackBar.showMySnackBar(state.message, context,
            contentType: ContentType.success, title: "الخليل");
        return true;
      }
    } else if (context.mounted) {
      MySnackBar.showMySnackBar("املأ الحقول الضرورية", context,
          contentType: ContentType.warning, title: "انتبه");
    }
    return false;
  }
}
