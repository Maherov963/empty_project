import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/pages/home/search_bar.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/widgets/circle_avatar_button.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/features/downloads/widgets/my_popup_menu.dart';
import '../../../domain/models/management/person.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../router/router.dart';
import '../../utils/messges/toast.dart';

class PersonDash extends StatefulWidget {
  const PersonDash({super.key});

  @override
  State<PersonDash> createState() => _PersonDashState();
}

class _PersonDashState extends State<PersonDash> {
  SortType isFirsSort = SortType.none;
  SortType isLastSort = SortType.none;
  bool _showUnActive = false;

  List<Person> people = [];

  Future<void> refreshAll() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await context.read<PersonProvider>().getTheAllPersons();
      if (state is DataState<List<Person>> && context.mounted) {
        context.read<PersonProvider>().people = state.data;
        people = state.data.where((e) {
          return _showUnActive ? true : e.isActive;
        }).toList();
        setState(() {});
      }
      if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshAll();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myPermission = context.read<CoreProvider>().myPermission;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar<Person>(
                trailing: MyPopUpMenu(
                  list: [
                    if (myPermission.isAdminManager)
                      MyPopUpMenu.getWithCheckBox(
                        "عرض غير النشطين",
                        _showUnActive,
                        // context,
                        onTap: () {
                          _showUnActive = !_showUnActive;
                          people =
                              context.read<PersonProvider>().people.where((e) {
                            return _showUnActive ? true : e.isActive;
                          }).toList();
                          setState(() {});
                        },
                      )
                  ],
                ),
                leading: const BackButton(),
                hint: "ابحث في الأشخاص",
                title: "ابحث في ${people.length} شخص",
                enable: true,
                onSearch: (p0) {
                  if (p0.isEmpty) {
                    return [];
                  }
                  return people
                      .where(
                        (item) => item
                            .getFullName(fromSearch: true)
                            .getSearshFilter()
                            .contains(p0.getSearshFilter()),
                      )
                      .toList();
                },
                resultBuilder: (p0, p1, person) {
                  return ListTile(
                    leading: CircleAvatarButton(
                      radius: 15,
                      fullName: person.getFullName(),
                      id: person.id,
                    ),
                    title: Text(person.getFullName(fromSearch: true)),
                    trailing: Text(person.id.toString()),
                    onTap: () {
                      context.navigateToPerson(person.id);
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: context.watch<PersonProvider>().isLoadingIn,
              child: const LinearProgressIndicator(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshAll,
                child: CustomTaple(
                  culomn: [
                    const CustomCulomnCell(
                      flex: 1,
                      text: "المعرف",
                      sortType: SortType.none,
                    ),
                    CustomCulomnCell(
                      flex: 3,
                      text: "الاسم",
                      onSort: () async {
                        sortFirst(context.read<PersonProvider>().people);
                      },
                      sortType: isFirsSort,
                    ),
                    CustomCulomnCell(
                      flex: 3,
                      text: "الكنية",
                      onSort: () async {
                        sortLast(context.read<PersonProvider>().people);
                      },
                      sortType: isLastSort,
                    ),
                  ],
                  row: people.map(
                    (e) => CustomRow(
                      row: [
                        CustomCell(flex: 1, text: e.id.toString()),
                        CustomCell(
                          flex: 3,
                          text: e.firstName,
                          onTap: () {
                            context.navigateToPerson(e.id);
                          },
                        ),
                        CustomCell(flex: 3, text: e.lastName),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sortBirth(List<Person> persons) {
    setState(() {
      isFirsSort = SortType.none;
      if (isLastSort == SortType.inc) {
        isLastSort = SortType.dec;
      } else {
        isLastSort = SortType.inc;
      }
      if (isFirsSort == SortType.inc) {
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
      isLastSort = SortType.none;
      if (isFirsSort == SortType.inc) {
        isFirsSort = SortType.dec;
      } else {
        isFirsSort = SortType.inc;
      }
      if (isFirsSort == SortType.inc) {
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
      isFirsSort = SortType.none;
      if (isLastSort == SortType.inc) {
        isLastSort = SortType.dec;
      } else {
        isLastSort = SortType.inc;
      }
      if (isLastSort == SortType.inc) {
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
