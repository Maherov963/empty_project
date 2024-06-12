import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/management/person.dart';

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  TextEditingController textEditingController = TextEditingController();
  List<Person> suggestionList = [];
  List<Person> searchList = [];
  List<String> groups = [];
  String? choosinGroup;
  List<Person>? students;

  Future<void> refreshStudents() async {
    if (!context.read<PersonProvider>().isLoadingIn) {
      final state = await Provider.of<PersonProvider>(context, listen: false)
          .getStudentsForTesters();
      if (state is DataState<List<Person>> && mounted) {
        students = state.data;
        for (var element in students!) {
          if (!groups.contains(element.student?.groubName)) {
            groups.add(element.student!.groubName!);
          }
        }
        groups.sort(
          (a, b) => a.compareTo(b),
        );
        setState(() {});
      }
      if (state is ErrorState && context.mounted) {
        CustomToast.handleError(state.failure);
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refreshStudents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: students == null && !context.read<PersonProvider>().isLoadingIn
            ? getLoader()
            : students == null
                ? getError()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            const BackButton(),
                            Expanded(
                              child: MyComboBox(
                                text: choosinGroup,
                                items: groups,
                                hint: "اختر حلقة",
                                onChanged: (p0) {
                                  setState(
                                    () {
                                      suggestionList = [];
                                      for (var element in students!) {
                                        if (element.student!.groubName == p0) {
                                          suggestionList.add(element);
                                        }
                                      }
                                      searchList = suggestionList;
                                      searchList.sort(
                                        (a, b) => a
                                            .getFullName()
                                            .compareTo(b.getFullName()),
                                      );
                                    },
                                  );
                                  choosinGroup = p0;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(searchList[index].getFullName()),
                              leading: const Icon(Icons.spatial_tracking_sharp),
                              onTap: () async {
                                context.myPush(
                                  QuranHomeScreen(
                                    reason: PageState.testing,
                                    student: searchList[index],
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: searchList.length,
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  getError() {
    return Column(
      children: [
        100.getHightSizedBox,
        TextButton(
          onPressed: () async {
            setState(() {});
            await refreshStudents();
          },
          child: Text(
            "إعادة المحاولة",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ],
    );
  }

  getLoader() {
    return const Column(
      children: [
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
        Skeleton(height: 75),
      ],
    );
  }
}
