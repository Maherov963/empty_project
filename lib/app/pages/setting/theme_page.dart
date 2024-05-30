import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/utils/widgets/my_radiobutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final List _langs = ["مفعل", "غير مفعل", "وضع النظام"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المظهر")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "الوضع الليلي",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Selector<CoreProvider, String>(
              selector: (_, p1) => p1.themeState,
              builder: (_, theme, __) {
                return ListView.separated(
                  itemCount: _langs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, index) {
                    return MyRadioButton(
                      text: _langs[index],
                      groupValue: theme,
                      value: ThemeState.value[index],
                      onChanged: (val) {
                        setState(() {
                          context
                              .read<CoreProvider>()
                              .setTheme(ThemeState.value[index]);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
