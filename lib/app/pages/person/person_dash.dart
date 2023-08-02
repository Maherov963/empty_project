import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/domain/models/management/custom.dart';
import 'package:al_khalil/domain/models/management/student.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/management/person.dart';
import '../../router/router.dart';
import '../../utils/widgets/cell.dart';
import 'mybar.dart' as mine;

class PersonDash extends StatefulWidget {
  const PersonDash({super.key});

  @override
  State<PersonDash> createState() => _PersonDashState();
}

class _PersonDashState extends State<PersonDash> {
  Future<void> refreshAll() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getTheAllPersons();
      if (state is PersonsState && context.mounted) {
        Provider.of<PersonProvider>(context, listen: false).people =
            state.persons;
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  Future<void> refreshStudents() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getAllPersons(
              person:
                  Person(student: Student(studentState: IdNameModel(id: 2))));
      if (state is PersonsState && context.mounted) {
        Provider.of<PersonProvider>(context, listen: false).students =
            state.persons;
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  Future<void> refreshCustoms() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getAllPersons(person: Person(custom: Custom()));
      if (state is PersonsState && context.mounted) {
        Provider.of<PersonProvider>(context, listen: false).customs =
            state.persons;
      }
      if (state is ErrorState && context.mounted) {
        MySnackBar.showMySnackBar(state.failure.message, context,
            contentType: ContentType.failure, title: "حدث خطأ");
      }
    }
  }

  final mine.SearchController _controller = mine.SearchController();
  bool isFirsInc = false;
  bool isLastInc = false;
  bool isBirthInc = false;
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.account_circle), label: "الكل"),
          NavigationDestination(
              icon: Icon(Icons.accessibility_sharp), label: "طلاب"),
          NavigationDestination(
              icon: Icon(Icons.assignment_ind_sharp), label: "أساتذة"),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: mine.SearchAnchor.bar(
                viewHintText: "ابحث هنا",
                barLeading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                barTrailing: const [Icon(Icons.search)],
                viewBackgroundColor:
                    Theme.of(context).appBarTheme.backgroundColor,
                barBackgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).appBarTheme.backgroundColor),
                isFullScreen: false,
                onTap: () {
                  if (_controller.isOpen) {
                    _controller.buildTextSpan(
                        context: context, withComposing: false);
                  } else {}
                },
                barHintText: "ابحث في الأشخاص",
                suggestionsBuilder: (context, controller) {
                  List results = [];
                  if (controller.text != "") {
                    results = context
                        .read<PersonProvider>()
                        .people
                        .where(
                          (item) =>
                              item.getFullName().getSearshFilter().contains(
                                    controller.text.getSearshFilter(),
                                  ),
                        )
                        .toList();
                  }

                  return results.map<Widget>((e) => ListTile(
                        title: Text(e.getFullName()),
                        onTap: () => MyRouter.navigateToPerson(context, e.id!),
                      ));
                },
                searchController: _controller,
              ),
            ),
            Visibility(
              visible: context.watch<PersonProvider>().isLoadingIn,
              child: const LinearProgressIndicator(),
            ),
            Row(
              children: [
                MyCell(
                  text: "الاسم",
                  flex: 6,
                  isTitle: true,
                  onTap: () async {
                    _currentIndex == 0
                        ? sortFirst(context.read<PersonProvider>().people)
                        : _currentIndex == 1
                            ? sortFirst(context.read<PersonProvider>().students)
                            : sortFirst(context.read<PersonProvider>().customs);
                  },
                ),
                MyCell(
                  text: "الكنية",
                  flex: 6,
                  isTitle: true,
                  onTap: () async {
                    _currentIndex == 0
                        ? sortLast(context.read<PersonProvider>().people)
                        : _currentIndex == 1
                            ? sortLast(context.read<PersonProvider>().students)
                            : sortLast(context.read<PersonProvider>().customs);
                  },
                ),
              ],
            ),
            Consumer<PersonProvider>(
              builder: (__, prov, _) {
                List<Person> value = _currentIndex == 0
                    ? prov.people
                    : _currentIndex == 1
                        ? prov.students
                        : prov.customs;
                return Expanded(
                  child: RefreshIndicator(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    color: Theme.of(context).colorScheme.onSecondary,
                    onRefresh: _currentIndex == 0
                        ? refreshAll
                        : _currentIndex == 1
                            ? refreshStudents
                            : refreshCustoms,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Row(
                          children: [
                            MyCell(
                              text: value[index].firstName,
                              flex: 6,
                              isButton: true,
                              textColor: Theme.of(context).colorScheme.tertiary,
                              onTap: prov.isLoadingPerson == value[index].id
                                  ? null
                                  : () async {
                                      await MyRouter.navigateToPerson(
                                          context, value[index].id!);
                                    },
                            ),
                            MyCell(
                              text: value[index].lastName,
                              flex: 6,
                            ),
                          ],
                        ),
                        itemCount: value.length,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  sortBirth(List<Person> persons) {
    setState(() {
      isBirthInc = !isBirthInc;
      if (isBirthInc) {
        persons.sort(
          (a, b) => (a.birthDate ?? "").compareTo(b.birthDate ?? ""),
        );
      } else {
        persons.sort(
          (a, b) => (b.birthDate ?? "").compareTo(a.birthDate ?? ""),
        );
      }
    });
  }

  sortFirst(List<Person> persons) {
    setState(() {
      isFirsInc = !isFirsInc;
      if (isFirsInc) {
        persons.sort(
          (a, b) => (a.firstName ?? "").compareTo(b.firstName ?? ""),
        );
      } else {
        persons.sort(
          (a, b) => (b.firstName ?? "").compareTo(a.firstName ?? ""),
        );
      }
    });
  }

  sortLast(List<Person> persons) {
    setState(() {
      isLastInc = !isLastInc;
      if (isLastInc) {
        persons.sort(
          (a, b) => (a.lastName ?? "").compareTo(b.lastName ?? ""),
        );
      } else {
        persons.sort(
          (a, b) => (b.lastName ?? "").compareTo(a.lastName ?? ""),
        );
      }
    });
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = context
        .read<PersonProvider>()
        .people
        .where((item) => item.getFullName().contains(query
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].getFullName()),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? context.read<PersonProvider>().people
        : context
            .read<PersonProvider>()
            .people
            .where((item) => item
                .getFullName()
                .replaceAll("أ", "ا")
                .replaceAll("إ", "ا")
                .replaceAll("ة", "ه")
                .contains(query
                    .replaceAll("أ", "ا")
                    .replaceAll("إ", "ا")
                    .replaceAll("ة", "ه")))
            .toList();
    return SearchPage(suggestionList: suggestionList);
  }
}

class SearchPage extends StatelessWidget {
  final List<Person> suggestionList;
  const SearchPage({super.key, required this.suggestionList});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonProvider>(
      builder: (__, value, _) {
        return Column(
          children: [
            Visibility(
              visible: value.isLoadingPerson != null,
              child: const LinearProgressIndicator(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestionList[index].getFullName()),
                    trailing: Text(suggestionList[index].id!.toString()),
                    onTap: value.isLoadingPerson != null
                        ? null
                        : () async {
                            MyRouter.navigateToPerson(
                                context, suggestionList[index].id!);
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
