import 'package:al_khalil/app/components/person_selector.dart';
import 'package:al_khalil/app/pages/additional_point/add_pts_admin_page.dart';
import 'package:al_khalil/app/pages/additional_point/give_points.dart';
import 'package:al_khalil/app/pages/admin_notes/admin_notes_dash.dart';
import 'package:al_khalil/app/pages/attendence/attendence_dash.dart';
import 'package:al_khalil/app/pages/group/add_group.dart';
import 'package:al_khalil/app/pages/group/group_dashboard.dart';
import 'package:al_khalil/app/pages/memorization/test_home_page.dart';
import 'package:al_khalil/app/pages/memorization/test_in_date_page.dart';
import 'package:al_khalil/app/pages/person/new_add_person.dart';
import 'package:al_khalil/app/pages/person/person_dash.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminstrationPage extends StatefulWidget {
  const AdminstrationPage({super.key});

  @override
  State<AdminstrationPage> createState() => _AdminstrationPageState();
}

class _AdminstrationPageState extends State<AdminstrationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder: (_, value, __) {
        List<HomeCard> home = [
          if (value.myAccount!.custom!.adder)
            HomeCard(
              icon: Icons.person_add,
              label: 'إضافة شخص جديد',
              onTap: () async {
                context.myPush(const AddNewPerson());
              },
            ),
          if (value.myAccount!.custom!.addGroup)
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
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              icon: Icons.people,
              label: 'سجل الأشخاص',
              onTap: () {
                context.myPush(const PersonDash());
              },
            ),
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              icon: CupertinoIcons.person_2_square_stack,
              label: 'فلترة الأشخاص',
              onTap: () {
                context.myPush(const PersonSelector());
              },
            ),
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              icon: Icons.group_rounded,
              label: 'سجل الحلقات',
              onTap: () {
                context.myPush(const GroupDash());
              },
            ),
          if (value.myAccount!.custom!.admin)
            HomeCard(
              icon: Icons.monetization_on_outlined,
              label: 'سجل النقاط',
              onTap: () {
                context.myPush(const AddPtsAdminPage());
              },
            ),
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              icon: Icons.notes,
              label: 'سجل الملاحظات',
              onTap: () {
                context.myPush(const AdminNoteDash());
              },
            ),
          if (value.myAccount!.custom!.test)
            HomeCard(
              icon: Icons.spatial_tracking_sharp,
              label: 'سبر',
              onTap: () async {
                context.myPush(const TestHomePage());
              },
            ),
          if (value.myAccount!.custom!.admin)
            HomeCard(
              icon: Icons.clean_hands,
              label: 'تسليم نقاط',
              onTap: () async {
                context.myPush(const GivePtsPage());
              },
            ),
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              label: "سجل السبر",
              icon: Icons.dataset_rounded,
              onTap: () async {
                context.myPush(const TestsInDatePage());
              },
            ),
          if (value.myAccount!.custom!.isAdminstration)
            HomeCard(
              label: "سجل الحضور",
              icon: Icons.perm_contact_calendar_sharp,
              onTap: () async {
                context.myPush(const AttendanceDash());
              },
            ),
          HomeCard(
            label: "محفوظاتي",
            icon: Icons.menu_book,
            onTap: () async {
              context.myPush(QuranHomeScreen(
                reason: PageState.view,
                student: value.myAccount,
              ));
            },
          ),
        ];
        return GridView.builder(
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
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
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
