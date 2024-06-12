import 'package:al_khalil/features/quran/widgets/span_word.dart';
import 'package:flutter/material.dart';

const String tajweedRules =
    '''يرمز له باللون الأصفر و للتجويد 5 نقاط مقسمة على 5 أخطاء
 أحكام التجويد المطلوبة:
1- أحكام النون الساكنة والتنوين
2- أحكام الميم الساكنة
3- المد المتصل
4- المد المنفصل''';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "مساعدة",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              expandedTitleScale: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "أخطاء التسميع",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التشكيلي"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأحمر ووجود خطأ تشكيلي واحد مرسب"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tashkelColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ الحفظي"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأزرق ووجود خطأين حفظيين مرسب"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: forgetColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التجويدي"),
                      subtitle: getSubTitle(tajweedRules),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tajweedColor,
                      ),
                    ),
                    const Divider(thickness: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "تقديرات التسميع",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("ممتاز"),
                      subtitle: getSubTitle("11 - 15 نقطة حسب علامة التجويد"),
                      leading: const Icon(
                        Icons.done,
                        color: tajweedColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("جيد جداً"),
                      subtitle: getSubTitle("6 - 10 نقاط حسب علامة التجويد"),
                      leading: Icon(
                        Icons.done,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("جيد"),
                      subtitle: getSubTitle("5 نقاط (بدون تجويد)"),
                      leading: const Icon(
                        Icons.done,
                        color: forgetColor,
                      ),
                    ),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "أخطاء السبر",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التشكيلي - لم يصحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأحمر ويخصم 10 علامات من 100"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tashkelColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التشكيلي - صحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأحمر ويخصم 5 علامات من 100"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tashkelColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ الحفظي - لم يصحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأزرق ويخصم 5 علامات من 100"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: forgetColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ الحفظي - صحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأزرق ويخصم علامتين من 100"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: forgetColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التجويدي - لم يصحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأصفر ويخصم 5 علامات من 25"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tajweedColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("الخطأ التجويدي - صحح لنفسه"),
                      subtitle: getSubTitle(
                          "يرمز له باللون الأصفر ويخصم علامتين من 25"),
                      leading: const Icon(
                        Icons.warning_amber,
                        color: tajweedColor,
                      ),
                    ),
                    const Divider(thickness: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "تقديرات السبر",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("ممتاز"),
                      subtitle: getSubTitle("110 من 125"),
                      leading: const Icon(
                        Icons.done,
                        color: tajweedColor,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("جيد جداً"),
                      subtitle: getSubTitle("90 من 125"),
                      leading: Icon(
                        Icons.done,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      title: getListTitle("جيد"),
                      subtitle: getSubTitle("80 من 125"),
                      leading: const Icon(
                        Icons.done,
                        color: forgetColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDivider() => const Divider(
        thickness: 10,
        endIndent: 0,
        indent: 0,
      );
}

Widget getListTitle(String title) => Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
      ),
    );
Widget getSubTitle(String? title) => Text(
      title ?? "",
      style: const TextStyle(),
    );
