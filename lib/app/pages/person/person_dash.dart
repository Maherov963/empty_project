import 'package:al_khalil/app/components/custom_taple/custom_taple.dart';
import 'package:al_khalil/app/pages/home/search_bar.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/widgets/my_checkbox.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import '../../../domain/models/management/person.dart';

import 'package:flutter/cupertino.dart';
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
  Future<void> refreshAll() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getTheAllPersons();
      if (state is DataState<List<Person>> && context.mounted) {
        Provider.of<PersonProvider>(context, listen: false).people = state.data;
      }
      if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
    }
  }

  SortType isFirsSort = SortType.none;
  SortType isLastSort = SortType.none;
  bool _showUnActive = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshAll();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar<Person>(
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.search),
                ),
                leading: const BackButton(),
                hint: "ابحث في الأشخاص",
                title: "سجل الأشخاص",
                enable: true,
                onSearch: (p0) {
                  if (p0.isEmpty) {
                    return [];
                  }
                  return context
                      .read<PersonProvider>()
                      .people
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
            Consumer<PersonProvider>(
              builder: (__, prov, _) {
                List<Person> value = prov.people.where(
                  (e) {
                    return _showUnActive
                        ? true
                        : e.personState == CustomState.activeId;
                  },
                ).toList();
                return Expanded(
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
                      row: value.map(
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
                );
              },
            ),
            if (myAccount!.custom!.isAdminManager)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MyCheckBox(
                  val: _showUnActive,
                  text: "عرض غير النشطين",
                  onChanged: (p0) {
                    setState(
                      () {
                        _showUnActive = !_showUnActive;
                      },
                    );
                  },
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
