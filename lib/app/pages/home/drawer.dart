import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.onChange,
    required this.currentIndex,
  });
  final Function(int) onChange;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: currentIndex,
      onDestinationSelected: onChange,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "الخليل",
            style: Theme.of(context).textTheme.titleLarge,
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
          enabled: false,
          label: Text("القران الكريم"),
          selectedIcon: Icon(Icons.menu_book),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text("الإعدادات"),
        ),
      ],
    );
  }
}
