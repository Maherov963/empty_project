import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:al_khalil/app/components/my_drawer.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/pages/group/group_dashboard.dart';
import 'package:al_khalil/app/pages/person/add_person.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/waiting_animation.dart';
import '../../providers/managing/group_provider.dart';
import '../additional_point/add_pts_admin_page.dart';
import '../additional_point/give_points.dart';
import '../memorization/test_home_page.dart';
import '../person/person_dash.dart';
import 'dart:io';
import '../memorization/slide_widget.dart';
import '../setting/change_password.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<void> refreshStudents(BuildContext context) async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getStudentsForTesters();
      if (state is PersonsState && context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TestHomePage(students: state.persons),
        ));
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  Future<void> refreshStudentsPayment(BuildContext context) async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getStudentsForTesters();
      if (state is PersonsState && context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GivePtsPage(students: state.persons),
        ));
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  Future<void> refreshMyAccount() async {
    await context.read<CoreProvider>().initialState().then((state) {
      if (state is PersonState) {
        setState(() {
          context.read<CoreProvider>().myAccount = state.person;
        });
      }
      if (state is ErrorState) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "الخليل");
      }
    });
  }

  bool isOnline = true;
  @override
  void initState() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        isOnline = false;
      } else {
        isOnline = true;
      }
    });
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {
          isOnline = false;
        });
      } else {
        setState(() {
          isOnline = true;
        });
      }
    });
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshMyAccount();
      if (context.read<CoreProvider>().myAccount!.password!.length < 5) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.rightSlide,
          btnOkText: "تغيير",
          dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          btnCancelText: "لاحقاً",
          btnOkColor: Theme.of(context).colorScheme.secondary,
          btnCancelColor: Theme.of(context).colorScheme.error,
          title: 'الخليل',
          desc: 'كلمة المرور ضعيفة جداً الرجاء تغييرها',
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ));
          },
        ).show();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var person = Provider.of<CoreProvider>(context, listen: false).myAccount;
    List<IdNameModel> moderatorG = person!.custom!.moderatorGroups!
      ..forEach((element) {
        element.myRank = IdNameModel.asModerator;
      });
    List<IdNameModel> assistantG = person.custom!.assitantsGroups!
      ..forEach((element) {
        element.myRank = IdNameModel.asAssistant;
      });
    List<IdNameModel> supervisorG = person.custom!.superVisorGroups!
      ..forEach((element) {
        element.myRank = IdNameModel.asSupervisor;
      });
    List<IdNameModel> mineGroup = moderatorG + assistantG + supervisorG;

    List<HomeCard> home = [
      if (person.custom!.addPerson)
        HomeCard(
          icon: Icons.person_add,
          label: 'إضافة شخص جديد',
          onTap: context.watch<PersonProvider>().isLoadingIn ||
                  context.watch<GroupProvider>().isLoadingIn
              ? null
              : () async {
                  await Provider.of<PersonProvider>(context, listen: false)
                      .getTheAllPersons()
                      .then((state) async {
                    if (state is PersonsState) {
                      Provider.of<PersonProvider>(context, listen: false)
                          .people = state.persons;
                      await Provider.of<GroupProvider>(context, listen: false)
                          .getAllGroups()
                          .then((state) {
                        if (state is GroupsState) {
                          Provider.of<GroupProvider>(context, listen: false)
                              .groups = state.groups;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPersonPage(),
                              ));
                        } else if (state is ErrorState) {
                          MySnackBar.showMySnackBar(
                              state.failure.message, context,
                              contentType: ContentType.failure,
                              title: "حدث خطأ");
                        }
                      });
                    } else if (state is ErrorState) {
                      MySnackBar.showMySnackBar(state.failure.message, context,
                          contentType: ContentType.failure, title: "حدث خطأ");
                    }
                  });
                },
        ),
      if (person.custom!.addGroup)
        HomeCard(
          icon: Icons.group_add,
          label: 'إضافة حلقة جديدة',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddGroup(),
              ),
            );
          },
        ),
      if (person.custom!.viewPeople)
        HomeCard(
          icon: Icons.people,
          label: 'سجل الأشخاص',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonDash(),
                ));
          },
        ),
      if (person.custom!.viewGroups)
        HomeCard(
          icon: Icons.group_rounded,
          label: 'سجل الحلقات',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupDash(),
                ));
          },
        ),
      if (person.custom!.evaluation && person.custom!.admin)
        HomeCard(
          icon: Icons.monetization_on_outlined,
          label: 'إضافة نقاط',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPtsAdminPage(),
              ),
            );
          },
        ),
      if (person.custom!.test)
        HomeCard(
          icon: Icons.spatial_tracking_sharp,
          label: 'سبر',
          onTap: () async {
            await refreshStudents(context);
          },
        ),
      if (person.custom!.admin)
        HomeCard(
          icon: Icons.clean_hands,
          label: 'تسليم نقاط',
          onTap: () async {
            await refreshStudentsPayment(context);
          },
        ),
    ];
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تحذير'),
              content: const Text('هل تود الخروج من التطبيق؟'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      exit(0);
                      // Navigator.pop(context, true);
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
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          actions: [
            Visibility(
              visible: context.watch<PersonProvider>().isLoadingIn ||
                  context.watch<GroupProvider>().isLoadingIn,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: MyWaitingAnimation(),
              ),
            ),
          ],
          title: const Text("جامع إبراهيم الخليل"),
          bottom: TabBar(
            // isScrollable: true,
            splashBorderRadius: BorderRadius.circular(5),
            tabs: const [
              Tab(text: "الصفحة الرئيسية"),
              Tab(text: "حلقاتي"),
            ],
            controller: _tabController,
          ),
        ),
        body: Column(
          children: [
            if (context.watch<CoreProvider>().isLoggingIn != null)
              const LinearProgressIndicator(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          color: Theme.of(context).colorScheme.onSecondary,
                          onRefresh: refreshMyAccount,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: home.length,
                            itemBuilder: (context, index) {
                              return CardButton(
                                  label: home[index].label!,
                                  icon: home[index].icon!,
                                  onTap: home[index].onTap);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      thickness: 0.5,
                      endIndent: 10,
                      indent: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(mineGroup[index].name.toString()),
                        leading: const Icon(Icons.groups),
                        //subtitle: Text(mineGroup[index].val.toString()),
                        onTap: () {
                          showModalBottomSheet(
                              showDragHandle: true,
                              isScrollControlled: true,
                              useSafeArea: true,
                              //enableDrag: false,
                              // shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.only(
                              //         topLeft: Radius.circular(25),
                              //         topRight: Radius.circular(25))),
                              context: context,
                              builder: (ctx) => SlideWidget(
                                  id: mineGroup[index].id!,
                                  myRank: mineGroup[index].myRank!));
                        },
                      );
                    },
                    itemCount: mineGroup.length,
                  ),
                ],
              ),
            ),
            if (!isOnline)
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.error,
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsets.all(5),
                child: const Text("لا يوجد إنترنت"),
              ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const CardButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shadowColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onError),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCard {
  final String? label;
  final VoidCallback? onTap;
  final IconData? icon;

  HomeCard({this.label, this.onTap, this.icon});
}
