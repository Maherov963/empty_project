import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/components/wheel_picker.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/static/date.dart';
import '../../components/my_info_card.dart';
import '../../utils/widgets/my_text_form_field.dart';

// ignore: must_be_immutable
class TestPage extends StatefulWidget {
  final QuranTest quranTest;
  const TestPage({
    super.key,
    required this.quranTest,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late QuranTest _quranTest = QuranTest();
  @override
  initState() {
    _quranTest = widget.quranTest.copy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Person myAccount = context.read<CoreProvider>().myAccount!;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تحذير'),
              content: const Text('لن يتم حفظ التعديلات'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('أعي ذلك')),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('البقاء')),
              ],
            );
          },
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: context.watch<MemorizationProvider>().isLoadingIn
                ? null
                : () async {
                    if (_quranTest.idTest == null) {
                      await context
                          .read<MemorizationProvider>()
                          .test(_quranTest)
                          .then(
                        (state) {
                          if (state is IdState) {
                            MySnackBar.showMySnackBar(
                                "تمت العملية بنجاح", context,
                                contentType: ContentType.success,
                                title: "الخليل");
                            _quranTest.idTest = state.id;
                            Navigator.pop<QuranTest>(context, _quranTest);
                          }
                          if (state is ErrorState) {
                            MySnackBar.showMySnackBar(
                                state.failure.message, context,
                                contentType: ContentType.failure,
                                title: "الخليل");
                          }
                        },
                      );
                    } else {
                      await context
                          .read<MemorizationProvider>()
                          .editTest(_quranTest)
                          .then(
                        (state) {
                          if (state is MessageState) {
                            MySnackBar.showMySnackBar(
                                "تمت العملية بنجاح", context,
                                contentType: ContentType.success,
                                title: "الخليل");
                            Navigator.pop<QuranTest>(context, _quranTest);
                          }
                          if (state is ErrorState) {
                            MySnackBar.showMySnackBar(
                                state.failure.message, context,
                                contentType: ContentType.failure,
                                title: "الخليل");
                          }
                        },
                      );
                    }
                  },
            child: context.watch<MemorizationProvider>().isLoadingIn
                ? const MyWaitingAnimation()
                : const Icon(
                    Icons.done,
                  )),
        appBar: AppBar(
          title: Text(_quranTest.testedPep?.getFullName() ?? ""),
          elevation: 15,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                MyInfoCard(
                    body: _quranTest.section?.toString(), head: "الجزء :"),
                MyInfoCardEdit(
                  child: InkWell(
                    onTap: context.watch<PersonProvider>().isLoadingTesters
                        ? null
                        : () async {
                            await context
                                .read<PersonProvider>()
                                .getTesters()
                                .then(
                              (state) async {
                                if (state is PersonsState) {
                                  String? year = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return YearPickerDialog(
                                        init:
                                            _quranTest.testerPer?.getFullName(),
                                        dates: state.persons
                                            .map((e) => e.getFullName())
                                            .toList(),
                                      );
                                    },
                                  );
                                  if (year != null) {
                                    setState(
                                      () {
                                        _quranTest.testerPer = state.persons
                                            .firstWhere(
                                                (e) => e.getFullName() == year);
                                      },
                                    );
                                  }
                                }
                                if (state is ErrorState && context.mounted) {
                                  MySnackBar.showMySnackBar(
                                      state.failure.message, context,
                                      contentType: ContentType.failure,
                                      title: "الخليل");
                                }
                              },
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("أستاذ السبر :"),
                          Text(
                            _quranTest.testerPer!.getFullName(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          20.getWidthSizedBox(),
                          if (context.watch<PersonProvider>().isLoadingTesters)
                            const MyWaitingAnimation(),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: DatePickerWidget(
                            dateFormat: 'dd-MM-yyyy',
                            onMonthChangeStartWithFirstDate: true,
                            maxDateTime: DateTime.now(),
                            minDateTime: DateTime(2020),
                            onChange: (dateTime, selectedIndex) {
                              HapticFeedback.lightImpact();
                            },
                            onConfirm: (dateTime, selectedIndex) {
                              setState(() {
                                _quranTest.createdAt = dateTime.getYYYYMMDD();
                              });
                            },
                            pickerTheme: DateTimePickerTheme(
                                confirm: Text(
                                  "حفظ",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                ),
                                cancel: Text(
                                  "إلغاء",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onError),
                                ),
                                backgroundColor: Colors.transparent,
                                itemTextStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError)),
                            initialDateTime:
                                MehDate.getDateTime(_quranTest.createdAt),
                          ),
                        ),
                      ),
                    );
                  },
                  child: MyInfoCardEdit(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("تاريخ السبر : "),
                          Text("${_quranTest.createdAt}"),
                          const Icon(Icons.date_range),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: MyTextFormField(
                    labelText: "الأخطاء",
                    onChanged: (p0) => _quranTest.mistakes = p0,
                    initVal: _quranTest.mistakes,
                    textInputType: TextInputType.multiline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: MyTextFormField(
                    labelText: "الملاحظات",
                    onChanged: (p0) => _quranTest.notes = p0,
                    initVal: _quranTest.notes,
                    textInputType: TextInputType.multiline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    const Text("علامة السبر : "),
                    Text(
                      '${_quranTest.mark!}%',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        inactiveColor: Theme.of(context).focusColor,
                        value: _quranTest.mark! / 100,
                        min: 0.8,
                        onChanged: (value) {
                          if (_quranTest.mark != (value * 100).round()) {
                            HapticFeedback.lightImpact();
                          }
                          setState(() {
                            _quranTest.mark = (value * 100).round();
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    const Text("نقاط التجويد : "),
                    Text(
                      '${_quranTest.tajweed ?? 0}/25',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        inactiveColor: Theme.of(context).focusColor,
                        value: (_quranTest.tajweed ?? 0) / 25,
                        onChanged: (value) {
                          setState(() {
                            if (_quranTest.tajweed != (value * 25).round()) {
                              HapticFeedback.lightImpact();
                            }
                            _quranTest.tajweed = (value * 25).round();
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
