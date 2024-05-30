import 'package:al_khalil/app/pages/additional_point/add_pts_admin_page.dart';
import 'package:al_khalil/app/pages/additional_point/give_points.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/pages/group/group_dashboard.dart';
import 'package:al_khalil/app/pages/memorization/test_home_page.dart';
import 'package:al_khalil/app/pages/memorization/test_in_date_page.dart';
import 'package:al_khalil/app/pages/person/new_add_person.dart';
import 'package:al_khalil/app/pages/person/person_dash.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminstrationPage extends StatefulWidget {
  const AdminstrationPage({super.key});

  @override
  State<AdminstrationPage> createState() => _AdminstrationPageState();
}

class _AdminstrationPageState extends State<AdminstrationPage> {
  Future<void> refreshMyAccount() async {
    await context.read<CoreProvider>().initialState().then((state) {
      if (state is PersonState) {
        setState(() {
          context.read<CoreProvider>().myAccount = state.person;
        });
      }
      if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
    });
  }

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
        CustomToast.handleError(state.failure);
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
        CustomToast.handleError(state.failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CoreProvider, Person?>(
      selector: (_, p1) => p1.myAccount,
      builder: (_, person, __) {
        List<HomeCard> home = [
          if (person!.custom!.adder)
            HomeCard(
              icon: Icons.person_add,
              label: 'إضافة شخص جديد',
              onTap: () async {
                context.myPush(const AddNewPerson());
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
          if (person.custom!.isAdminstration)
            HomeCard(
              icon: Icons.people,
              label: 'سجل الأشخاص',
              onTap: () {
                context.myPush(const PersonDash());
              },
            ),
          if (person.custom!.isAdminstration)
            HomeCard(
              icon: Icons.group_rounded,
              label: 'سجل الحلقات',
              onTap: () {
                context.myPush(const GroupDash());
              },
            ),
          if (person.custom!.admin)
            HomeCard(
              icon: Icons.monetization_on_outlined,
              label: 'إضافة نقاط',
              onTap: () {
                context.myPush(const AddPtsAdminPage());
              },
            ),
          // if (person.custom!.test)
          //   HomeCard(
          //     icon: Icons.spatial_tracking_sharp,
          //     label: 'سبر',
          //     onTap: () async {
          //       await refreshStudents(context);
          //     },
          //   ),
          if (person.custom!.admin)
            HomeCard(
              icon: Icons.clean_hands,
              label: 'تسليم نقاط',
              onTap: () async {
                await refreshStudentsPayment(context);
              },
            ),
          if (person.custom!.isAdminstration)
            HomeCard(
              label: "سجل السبر",
              icon: Icons.dataset_rounded,
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TestsInDatePage(),
                ));
              },
            )
        ];

        return Column(
          children: [
            if (context.watch<CoreProvider>().isLoggingIn != null)
              const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshMyAccount,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: home.length,
                  itemBuilder: (context, index) {
                    return CardButton(
                      label: home[index].label!,
                      icon: home[index].icon!,
                      onTap: home[index].onTap,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).hoverColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
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
