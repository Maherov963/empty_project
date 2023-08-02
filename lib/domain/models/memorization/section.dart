import 'page.dart';
import 'test.dart';

class QuranSection {
  int idSection;
  QuranTest? test;
  List<QuranPage> pages;

  QuranSection({
    required this.idSection,
    required this.test,
    required this.pages,
  });

  factory QuranSection.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonPages = json['pages'];
    List<QuranPage> pages =
        jsonPages.map((page) => QuranPage.fromJson(page)).toList();

    return QuranSection(
      idSection: json['ID_Section'],
      test: json['test'] == null ? null : QuranTest.fromJson(json['test']),
      pages: pages,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Section': idSection,
        'test': test?.toJson(),
        'pages': pages.map((page) => page.toJson()).toList(),
      };

  QuranSection copy() => QuranSection.fromJson(toJson());
}
