import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/components/try_again_loader.dart';
import 'package:al_khalil/app/pages/group/group_profile.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PersonSelector extends StatefulWidget {
  const PersonSelector({
    super.key,
    this.withPop = false,
    this.fetchData,
    this.multi = true,
  });
  final bool withPop;
  final bool multi;
  final Future<ProviderStates> Function()? fetchData;
  @override
  State<PersonSelector> createState() => _PersonSelectorState();
}

class _PersonSelectorState extends State<PersonSelector> {
  List<Person> result = [];
  List<Person> selected = [];
  List<Person>? people;
  Failure? _failure;
  bool _isLoading = false;
  Future getData() async {
    _isLoading = true;
    setState(() {});
    final state = await widget.fetchData?.call() ??
        await context.read<PersonProvider>().getTheAllPersons();
    if (state is ErrorState) {
      _failure = state.failure;
    } else if (state is DataState<List<Person>>) {
      people = state.data.where((e) {
        return e.isActive || widget.withPop;
      }).toList();
      result = people!;
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getData();
      },
    );
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (widget.withPop) {
                  Navigator.pop(context, selected);
                  return;
                }
                CustomDialog.showDialoug(
                  context,
                  ActionPage(people: selected),
                  "اختر الإجراء",
                );
              },
              child: const Icon(Icons.navigate_next),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(color: colorScheme.surfaceContainer),
            constraints: const BoxConstraints(minHeight: 50),
            child: SafeArea(
              child: Row(
                children: [
                  const BackButton(),
                  Expanded(
                    child: TextField(
                      enabled: people != null,
                      autofocus: true,
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          result = people
                                  ?.where(
                                    (item) => item
                                        .getFullName(fromSearch: true)
                                        .getSearshFilter()
                                        .contains(value.getSearshFilter()),
                                  )
                                  .toList() ??
                              [];
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "ابحث في الأشخاص",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          result = people!;
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          ),
          if (selected.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemBuilder: (context, index) => MyPickItem(
                  selected: true,
                  text: selected[index].getFullName(fromSearch: true),
                  onTap: () {
                    setState(() {});
                    selected.remove(selected[index]);
                  },
                ),
                scrollDirection: Axis.horizontal,
                itemCount: selected.length,
              ),
            ),
          if (result.isEmpty && _controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Lottie.asset(
                "assets/animations/empty_search.json",
                width: 200,
              ),
            ),
          if (result.isEmpty && _controller.text.isNotEmpty)
            const Text("لاتوجد نتائج بحث"),
          TryAgainLoader(
            failure: _failure,
            isData: people != null,
            isLoading: _isLoading,
            onRetry: getData,
            child: Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, endIndent: 10, indent: 10),
                itemBuilder: (context, index) {
                  final person = result[index];
                  // final color =
                  //     person.isActive ? colorScheme.primary : colorScheme.error;
                  return ListTile(
                    title: Text(
                      person.getFullName(fromSearch: true),
                      // style: style,
                    ),
                    leading: SelectedImage(
                      radius: 20,
                      isSelected: selected.contains(person),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          context.navigateToPerson(person.id);
                        },
                        icon: const Icon(Icons.remove_red_eye)),
                    onTap: () {
                      if (!widget.multi) {
                        selected = [];
                      }
                      selected.addOrDelete(person);
                      _controller.clear();
                      result = people!;
                      setState(() {});
                    },
                  );
                },
                itemCount: result.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionPage extends StatefulWidget {
  const ActionPage({super.key, required this.people});
  final List<Person> people;
  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextButton(
          text: "إضافة نقاط",
          onPressed: () {
            CustomDialog.showDialoug(
              context,
              PointSheet(
                students: widget.people
                    .map(
                      (e) => e.toStudent,
                    )
                    .toList(),
              ),
              "إضافة نقاط",
            );
          },
        ),
        5.getHightSizedBox,
        CustomTextButton(
          text: "إضافة ملاحظة إدارية",
          onPressed: () {
            CustomDialog.showDialoug(
              context,
              AdminNotesSheet(
                people: widget.people,
              ),
              "إضافة ملاحظة إدارية",
            );
          },
        ),
        5.getHightSizedBox,
        CustomTextButton(
          text: "نقل طلاب",
          onPressed: () {
            CustomDialog.showDialoug(
              context,
              MoveSheet(
                students: widget.people.map((e) => e.toStudent).toList(),
              ),
              "نقل طلاب",
            );
          },
        ),
        5.getHightSizedBox,
        CustomTextButton(
          text: "تغيير حالة",
          onPressed: () {
            CustomDialog.showDialoug(
              context,
              StateSheet(
                students: widget.people.map((e) => e.toStudent).toList(),
              ),
              "تغيير حالة",
            );
          },
        ),
      ],
    );
  }
}
