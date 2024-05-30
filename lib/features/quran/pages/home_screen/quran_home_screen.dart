import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/features/quran/domain/models/ayah.dart';
import 'package:al_khalil/main.dart';
import 'package:flutter/material.dart';
import '../../widgets/expanded_widget.dart';
import '../page_screen/quran_screen.dart';

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key, this.student});
  final Person? student;
  static Widget resualtBuilder(
          BuildContext context, int controller, Ayah ayah) =>
      ListTile(
        title: Text(ayah.ayah),
        subtitle: Text(
            "سورة ${ayah.suraName} : ${ayah.ayahId} (صفحة ${ayah.pageId})"),
        onTap: () {
          context.myPush(
            QuranScreen(initialPage: ayah.pageId),
          );
        },
      );
  static List<Ayah> onSearch(String text) {
    return quranProvider.quran.searchAyah(text);
  }

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  int? _currentExpandedTile;

  late final quran = quranProvider.quran;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quran.juzs.length,
              itemBuilder: (context, index) => ExpandedSection(
                expandedChild: quran.juzs[index].pages
                    .map(
                      (e) => ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Center(child: Text(e.isFirstPage)),
                        subtitle: const Center(
                          child: Text(
                            "ممتاز",
                            style: TextStyle(color: Colors.amber, fontSize: 18),
                          ),
                        ),
                        leading: Text(
                          "\t\t\t${e.id}",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Text(
                          "عبد الرحمن عثمان\n2002-02-02",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        onTap: () {
                          context.myPush(QuranScreen(initialPage: e.id));
                        },
                      ),
                    )
                    .toList(),
                expand: _currentExpandedTile == index,
                onTap: () {
                  setState(() {
                    if (_currentExpandedTile == index) {
                      _currentExpandedTile = null;
                    } else {
                      _currentExpandedTile = index;
                    }
                  });
                },
                child: ListTile(
                  title: Text("الجزء ${quran.juzs[index].juzId}"),
                  subtitle: const Text("تم تسميع 0"),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text("المسبورات"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
