import 'package:al_khalil/app/components/my_info_card.dart';
import 'package:al_khalil/app/components/my_info_list.dart';
import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/pages/person/new_add_person.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/models/static/id_name_model.dart';
import '../../components/my_fab.dart';
import '../../components/my_info_card_button.dart';
import '../../components/my_info_card_edit.dart';
import '../../components/my_info_list_button.dart';
import '../../components/user_profile_appbar.dart';
import '../../providers/managing/memorization_provider.dart';
import '../../providers/managing/person_provider.dart';
import '../../providers/states/provider_states.dart';
import '../../router/router.dart';
import '../../utils/messges/toast.dart';
import '../../utils/widgets/widgets.dart';
import '../memorization/memorization_page.dart';

// ignore: must_be_immutable
class PersonProfile extends StatefulWidget {
  int? id;
  Person? person;
  PersonProfile({
    super.key,
    this.id,
    this.person,
  });

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  final _scrollController = ScrollController();
  var _currentIndex = 0;
  late Person? _person = widget.person;
  late bool isLoading = widget.person == null;

  init() async {
    isLoading = true;
    if (widget.person != null) {
      // setState(() {
      // isLoading = false;
      // _person = widget.person;
      // });
    } else {
      await context.read<PersonProvider>().getPerson(widget.id!).then((state) {
        if (state is PersonState && mounted) {
          setState(() {
            isLoading = false;
            _person = state.person;
          });
        }
        if (state is ErrorState && mounted) {
          setState(() {
            isLoading = false;
          });
          CustomToast.handleError(state.failure);
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
    late List<Widget> taps = [
      Column(
        children: [
          if (myAccount.custom!.isAdminstration)
            MyInfoCard(
              head: "رقم التعريف:",
              body: _person!.id.toString(),
            ),
          MyInfoCard(
            head: "الاسم:",
            body: _person!.firstName,
          ),
          MyInfoCard(
            head: "الكنية:",
            body: _person!.lastName,
          ),
          MyInfoCard(
            head: "سنة الميلاد:",
            body: _person!.birthDate,
          ),
          MyInfoCard(
            head: " حالة الشخص:",
            body: CustomState.getStateFromId(_person?.personState),
          ),
          MyInfoCard(
            head: " العمل:",
            body: _person!.job,
          ),
          MyInfoList(
            title: "الدراسة",
            data: [
              MyInfoCard(
                head: " المرحلة الدراسية:",
                body: Education.getEducationFromId(
                    _person!.education!.educationTypeId),
              ),
              if (_person!.education!.majorName != null)
                MyInfoCard(
                  head: "اسم الاختصاص:",
                  body: _person!.education!.majorName,
                ),
              if (_person!.education!.majorYear != null)
                MyInfoCard(
                  head: "سنة الاختصاص:",
                  body: _person!.education!.majorYear,
                ),
            ],
          ),
          MyInfoList(
            title: "العنوان",
            data: [
              // MyInfoCard(
              //   head: "المحافظة:",
              //   body: _person!.address!.city,
              // ),
              MyInfoCard(
                head: "المنطقة:",
                body: _person!.address!.area,
              ),
              // MyInfoCard(
              //   head: "الشارع:",
              //   body: _person!.address!.street,
              // ),
              MyInfoCard(
                head: "علامة:",
                body: _person!.address!.mark,
              ),
            ],
          ),
          MyInfoList(
            title: "الأب",
            data: [
              MyInfoCard(
                head: "اسم الأب:",
                body: _person!.father!.fatherName,
              ),
              MyInfoCard(
                head: "عمل الأب:",
                body: _person!.father!.jobName,
              ),
              MyInfoCard(
                head: "رقم الأب:",
                body: _person!.father!.phoneNumber,
                child: _person!.father!.phoneNumber == null
                    ? null
                    : IconButton(
                        onPressed: () async {
                          await callWhatsApp(
                              _person!.father!.phoneNumber!, true);
                        },
                        icon: const Icon(Icons.call)),
              ),
              MyInfoCard(
                head: "حالة الأب:",
                body: CustomState.getStateFromId(_person?.father?.state),
              ),
            ],
          ),
          MyInfoList(
            title: "الأم",
            data: [
              MyInfoCard(
                head: "اسم الأم",
                body: _person?.mother!.motherName,
              ),
              MyInfoCard(
                head: "عمل الأم",
                body: _person!.mother!.jobName,
              ),
              MyInfoCard(
                head: "رقم الأم",
                body: _person!.mother!.phoneNumber,
                child: _person!.mother!.phoneNumber == null
                    ? null
                    : IconButton(
                        onPressed: () async {
                          await callWhatsApp(
                              _person!.mother!.phoneNumber!, true);
                        },
                        icon: const Icon(Icons.call)),
              ),
              MyInfoCard(
                head: "حالة الأم",
                body: CustomState.getStateFromId(_person?.mother?.state),
              ),
            ],
          ),
          MyInfoList(
            title: "القريب",
            data: [
              MyInfoCard(
                head: "اسم القريب:",
                body: _person!.kin!.kinName,
              ),
              MyInfoCard(
                head: "حالة القريب:",
                body: CustomState.getStateFromId(_person?.kin?.state),
              ),
              MyInfoCard(
                head: "رقم القريب:",
                body: _person!.kin!.phoneNumber,
                child: _person!.kin!.phoneNumber == null
                    ? null
                    : IconButton(
                        onPressed: () async {
                          await callWhatsApp(_person!.kin!.phoneNumber!, true);
                        },
                        icon: const Icon(Icons.call)),
              ),
            ],
          ),
          MyInfoCard(
            head: "الرقم الشخصي:",
            body: _person!.primaryNumber,
            child: _person!.primaryNumber == null
                ? null
                : IconButton(
                    tooltip: "مكالمة",
                    onPressed: () async {
                      await callWhatsApp(_person!.primaryNumber!, true);
                    },
                    icon: const Icon(Icons.call)),
          ),
          MyInfoCard(
            head: "رقم التواصل:",
            body: _person!.whatsappNumber,
            child: _person!.whatsappNumber == null
                ? null
                : Row(
                    children: [
                      IconButton(
                          tooltip: "مكالمة",
                          onPressed: () async {
                            await callWhatsApp(_person!.whatsappNumber!, true);
                          },
                          icon: const Icon(Icons.call)),
                      IconButton(
                        tooltip: "وتس اب",
                        onPressed: () async {
                          await callWhatsApp(_person!.whatsappNumber!, false);
                        },
                        icon: FaIcon(FontAwesomeIcons.whatsapp,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
          ),
          MyInfoCard(
            head: "رصيد النقاط:",
            body: _person!.tempPoints.toString(),
          ),
          MyInfoCard(
            head: "الايميل:",
            body: _person!.email,
          ),
          MyInfoCard(
            head: "علامات مميزة:",
            body: _person!.distinguishingSigns,
          ),
          MyInfoCard(
            head: "ملاحظات:",
            body: _person!.note,
          ),
          !myAccount.custom!.appoint
              ? const SizedBox.shrink()
              : MyInfoCard(
                  head: "اسم الحساب:",
                  body: _person!.userName,
                  child: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: _person?.userName ?? ""));
                      CustomToast.showToast("تم نسخ النص للحافظة");
                    },
                  ),
                ),
          100.getHightSizedBox
        ],
      ),
      Column(
        children: [
          MyInfoCard(
            head: " حالة الطالب:",
            body: CustomState.getStateFromId(_person?.student?.state),
          ),
          MyInfoCard(
            head: "تاريخ التسجيل:",
            body: _person?.student?.registerDate,
          ),
          MyInfoCardButton(
            head: "الحلقة المنضم إليها:",
            name: _person!.student!.groubName,
            onPressed: context.watch<GroupProvider>().isLoadingGroup ==
                    _person!.student!.groubId
                ? null
                : () {
                    context.navigateToGroup(_person!.student!.groubId!);
                  },
          ),
          100.getHightSizedBox,
        ],
      ),
      Column(
        children: [
          MyInfoCardEdit(
            child: MyCheckBox(
              val: _person!.custom!.admin,
              text: "admin",
              editable: false,
            ),
          ),
          MyInfoCardEdit(
            child: MyCheckBox(
              val: _person!.custom!.tester,
              text: "tester",
              editable: false,
            ),
          ),
          MyInfoCardEdit(
            child: MyCheckBox(
              val: _person!.custom!.manager,
              text: "manager",
              editable: false,
            ),
          ),
          MyInfoCardEdit(
              child: Column(
            children: [
              MyCheckBox(
                val: _person!.custom!.moderator,
                text: "moderator",
                editable: false,
              ),
              !_person!.custom!.moderator
                  ? const SizedBox.shrink()
                  : MyInfoList(
                      title: "moderatorGroups",
                      data: _person!.custom!.moderatorGroups!
                          .map((e) => MyInfoListButton(
                                idNameModel: e,
                                onPressed: context
                                            .watch<GroupProvider>()
                                            .isLoadingGroup ==
                                        e.id
                                    ? null
                                    : () async {
                                        await context.navigateToGroup(e.id!);
                                      },
                              ))
                          .toList(),
                    ),
            ],
          )),
          MyInfoCardEdit(
              child: Column(
            children: [
              MyCheckBox(
                val: _person!.custom!.supervisor,
                text: "supervisor",
                editable: false,
              ),
              !_person!.custom!.supervisor
                  ? const SizedBox.shrink()
                  : MyInfoList(
                      title: "superVisorGroups",
                      data: _person!.custom!.superVisorGroups!
                          .map((e) => MyInfoListButton(
                                idNameModel: e,
                                onPressed: context
                                            .watch<GroupProvider>()
                                            .isLoadingGroup ==
                                        e.id
                                    ? null
                                    : () async {
                                        await context.navigateToGroup(e.id!);
                                      },
                              ))
                          .toList(),
                    )
            ],
          )),
          MyInfoCardEdit(
              child: Column(
            children: [
              MyCheckBox(
                val: _person!.custom!.assistant,
                text: "assistant",
                editable: false,
              ),
              !_person!.custom!.assistant
                  ? const SizedBox.shrink()
                  : MyInfoList(
                      title: "assitantsGroups",
                      data: _person!.custom!.assitantsGroups!
                          .map((e) => MyInfoListButton(
                                idNameModel: e,
                                onPressed: context
                                            .watch<GroupProvider>()
                                            .isLoadingGroup ==
                                        e.id
                                    ? null
                                    : () async {
                                        await context.navigateToGroup(e.id!);
                                      },
                              ))
                          .toList(),
                    )
            ],
          )),
          MyInfoCardEdit(
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.custom,
              text: "custom",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.custom = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.reciter,
              text: "reciter",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.reciter = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.seller,
              text: "seller",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.seller = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.adder,
              text: "adder",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.adder = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.appoint,
              text: "appoint",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.appoint = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewPerson,
              text: "viewPerson",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewPerson = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.addPerson,
              text: "addPerson",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.addPerson = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.editPerson,
              text: "editPerson",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.editPerson = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewGroup,
              text: "viewGroup",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewGroup = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.deletePerson,
              text: "deletePerson",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.deletePerson = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.addGroup,
              text: "addGroup",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.addGroup = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.appointStudent,
              text: "appointStudent",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.appointStudent = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewGroups,
              text: "viewGroups",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewGroups = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewPeople,
              text: "viewPeople",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewPeople = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewRecite,
              text: "viewRecite",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewRecite = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.editGroup,
              text: "editGroup",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.editGroup = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.deleteGroup,
              text: "deleteGroup",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.deleteGroup = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.observe,
              text: "observe",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.observe = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.recite,
              text: "recite",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.recite = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.test,
              text: "test",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.test = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.sell,
              text: "sell",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.sell = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.attendance,
              text: "attendance",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.attendance = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.evaluation,
              text: "evaluation",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.evaluation = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewAttendance,
              text: "viewAttendance",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewAttendance = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.level,
              text: "level",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.level = p0!;
              },
            ),
          ),
          MyInfoCardEdit(
            isfunc: true,
            child: MyCheckBox(
              editable: false,
              val: _person!.custom!.viewLog,
              text: "viewLog",
              onChanged: (p0) {
                setState(() {});
                _person!.custom!.viewLog = p0!;
              },
            ),
          ),
          MyInfoCard(
            head: " ملاحظات:",
            body: _person!.custom!.note,
          ),
          MyInfoCard(
            head: " حالة الأستاذ:",
            body: CustomState.getStateFromId(_person?.custom?.state),
          ),
          if (myAccount.custom!.admin)
            MyInfoCardEdit(
                child: ListTile(
              onTap: context.watch<PersonProvider>().isLoadingIn
                  ? null
                  : () async {
                      CustomDialog.showDeleteDialig(context)
                          .then((value) async {
                        if (value) {
                          await context
                              .read<PersonProvider>()
                              .deletePerson(_person!.id!)
                              .then((state) {
                            if (state is MessageState) {
                              CustomToast.showToast(state.message);
                            } else if (state is ErrorState) {
                              CustomToast.handleError(state.failure);
                            }
                          });
                        }
                      });
                    },
              title: Text("حذف الحساب",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  )),
              trailing: context.watch<PersonProvider>().isLoadingIn
                  ? MyWaitingAnimation(
                      color: Theme.of(context).colorScheme.error,
                    )
                  : Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
            )),
          100.getHightSizedBox,
        ],
      ),
    ];

    return Scaffold(
      floatingActionButton: _person == null
          ? null
          : MyFab(
              editPressed: () async {
                if (!context
                    .read<CoreProvider>()
                    .myAccount!
                    .custom!
                    .editPerson) {
                  CustomToast.showToast(CustomToast.noPermissionError);
                } else if (!Provider.of<CoreProvider>(context, listen: false)
                        .myAccount!
                        .custom!
                        .adder &&
                    !Provider.of<CoreProvider>(context, listen: false)
                        .myAccount!
                        .custom!
                        .admin &&
                    !Provider.of<CoreProvider>(context, listen: false)
                        .myAccount!
                        .custom!
                        .manager &&
                    !Provider.of<CoreProvider>(context, listen: false)
                        .myAccount!
                        .custom!
                        .moderator) {
                  CustomToast.showToast(CustomToast.noPermissionError);
                } else {
                  context.myPushReplacment(
                      AddNewPerson(fromEdit: true, person: _person));
                }
              },
              recitePressed: context
                          .watch<MemorizationProvider>()
                          .isLoadingMemo ==
                      _person?.id
                  ? null
                  : () async {
                      if (Provider.of<CoreProvider>(context, listen: false)
                          .myAccount!
                          .custom!
                          .viewRecite) {
                        await context
                            .read<MemorizationProvider>()
                            .getMemorization(_person!.id!)
                            .then((state) {
                          if (state is ErrorState) {
                            CustomToast.handleError(state.failure);
                          } else if (state is QuranState) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MemorizationPage(
                                  myRank: myAccount.custom!.admin
                                      ? IdNameModel.asAdmin
                                      : IdNameModel.asWatcher,
                                  listners: [myAccount],
                                  person: _person!,
                                  quranSections: state.quranSections,
                                );
                              },
                            ));
                          }
                        });
                      } else {
                        CustomToast.showToast(CustomToast.noPermissionError);
                      }
                    },
              testPressed: () {
                CustomToast.showToast("soon");
              },
            ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.account_circle), label: "شخص"),
          const NavigationDestination(
              icon: Icon(Icons.accessibility_sharp), label: "طالب"),
          if (myAccount.custom!.appoint)
            const NavigationDestination(
                icon: Icon(Icons.assignment_ind_sharp), label: "أستاذ"),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          UserProfileAppBar(
            scrollController: _scrollController,
            firstLastName: _person?.getFullName() ?? "",
            file: _person?.imageLink ?? "",
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: _person == null && isLoading
                  ? getLoader()
                  : _person == null
                      ? getError()
                      : taps[_currentIndex],
            ),
          )),
        ],
      ),
    );
  }

  getError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: TextButton(
          onPressed: () {
            setState(() {
              init();
            });
          },
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

callWhatsApp(String? number, bool isCall) async {
  if (number == null) {
    CustomToast.showToast("not valid");
    return;
  }
  var contact = number;
  const String content = "";
  var androidUrl =
      isCall ? 'tel:$contact' : "whatsapp://send?phone=$contact&text=$content";

  await launchUrl(Uri.parse(androidUrl));
}
