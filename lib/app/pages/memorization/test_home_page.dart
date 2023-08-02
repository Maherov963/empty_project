import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/management/person.dart';
import '../../../domain/models/static/id_name_model.dart';
import '../../components/my_snackbar.dart';
import '../../providers/core_provider.dart';
import '../../providers/managing/memorization_provider.dart';
import '../../providers/states/provider_states.dart';
import 'memorization_page.dart';

class TestHomePage extends StatefulWidget {
  final List<Person> students;
  const TestHomePage({super.key, required this.students});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  TextEditingController textEditingController = TextEditingController();
  List<Person> suggestionList = [];
  List<Person> searchList = [];
  List<String> groups = [];
  String? choosinGroup;
  @override
  void initState() {
    for (var element in widget.students) {
      if (!groups.contains(element.student!.groupIdName!.name)) {
        groups.add(element.student!.groupIdName!.name!);
      }
    }
    groups.sort(
      (a, b) => a.compareTo(b),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                children: [
                  const BackButton(),
                  Expanded(
                    child: MyComboBox(
                      withBorder: false,
                      text: choosinGroup,
                      items: groups,
                      hint: "اختر حلقة",
                      onChanged: (p0) {
                        setState(() {
                          suggestionList = [];
                          for (var element in widget.students) {
                            if (element.student!.groupIdName!.name == p0) {
                              suggestionList.add(element);
                            }
                          }
                          searchList = suggestionList;
                          searchList.sort(
                            (a, b) =>
                                a.getFullName().compareTo(b.getFullName()),
                          );
                        });
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
                    trailing:
                        context.watch<MemorizationProvider>().isLoadingMemo ==
                                searchList[index].id
                            ? const MyWaitingAnimation()
                            : null,
                    onTap:
                        context.watch<MemorizationProvider>().isLoadingMemo !=
                                null
                            ? null
                            : () async {
                                await context
                                    .read<MemorizationProvider>()
                                    .getMemorization(searchList[index].id!)
                                    .then(
                                  (state) {
                                    if (state is ErrorState) {
                                      MySnackBar.showMySnackBar(
                                          state.failure.message, context,
                                          contentType: ContentType.failure,
                                          title: "حدث خطأ تقني");
                                    } else if (state is QuranState) {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return MemorizationPage(
                                            myRank: IdNameModel.asTester,
                                            listners: [
                                              context
                                                  .read<CoreProvider>()
                                                  .myAccount!
                                            ],
                                            person: searchList[index],
                                            quranSections: state.quranSections,
                                          );
                                        },
                                      ));
                                    }
                                  },
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
}
