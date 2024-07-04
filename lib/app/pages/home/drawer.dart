import 'package:al_khalil/app/components/alkhalil_logo.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.onChange,
    required this.currentIndex,
  });
  final void Function(int) onChange;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationDrawer(
      selectedIndex: currentIndex,
      onDestinationSelected: onChange,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: AlkhalilLogo(),
              ),
              Text("الخليل", style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.group),
          label: Text("حلقاتي"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.mosque_rounded),
          label: Text("صفحة الإدارة"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.book),
          label: Text("القران الكريم"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.menu_book),
          label: Text("محفوظاتي"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text("الإعدادات"),
        ),
      ],
    );
  }
}
