import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/utils/widgets/my_radiobutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List _langs = ["العربية", "الإنجليزية", "لغة النظام"];
  final List _langStates = ["ar", "en", null];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اللغة")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<CoreProvider>(builder: (context, ref, child) {
              final lang = ref.local;
              return ListView.separated(
                itemCount: _langs.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return MyRadioButton(
                    text: _langs[index],
                    groupValue: lang,
                    value: _langStates[index],
                    onChanged: (val) {
                      ref.setLocale(val);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
