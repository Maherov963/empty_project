import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/wheel_picker.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/static/date.dart';
import '../../components/my_info_card.dart';
import '../../components/waiting_animation.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

import '../../utils/messges/toast.dart';

// ignore: must_be_immutable
class RecitingPage extends StatefulWidget {
  final Reciting reciting;
  final List<Person> listners;

  final int myRank;
  const RecitingPage({
    super.key,
    required this.reciting,
    required this.listners,
    required this.myRank,
  });

  @override
  State<RecitingPage> createState() => _RecitingPageState();
}

class _RecitingPageState extends State<RecitingPage> {
  late Reciting _reciting = Reciting();

  @override
  initState() {
    _reciting = widget.reciting.copy();
    if (_reciting.tajweed) {
      taqders.add(
        IdNameModel(id: 3, name: "ممتاز"),
      );
      taqders.remove(
        IdNameModel(id: 1, name: "جيد"),
      );
    }
    super.initState();
  }

  late TextEditingController duration = TextEditingController(
      text: _reciting.duration == null ? "0" : _reciting.duration.toString());
  List<IdNameModel> taqders = [
    IdNameModel(id: 1, name: "جيد"),
    IdNameModel(id: 2, name: "جيد جداً"),
  ];
  @override
  Widget build(BuildContext context) {
    Person myAccount = context.read<CoreProvider>().myAccount!;
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
                    if (_reciting.ratesIdRate != null &&
                        _reciting.ratesIdRate != 0) {
                      _reciting.duration = int.tryParse(duration.text) ?? 0;
                      if (_reciting.idReciting == null) {
                        context
                            .read<MemorizationProvider>()
                            .recite(_reciting)
                            .then((state) {
                          if (state is IdState) {
                            CustomToast.showToast(state.message);

                            _reciting.idReciting = state.id;
                            Navigator.pop<Reciting>(context, _reciting);
                          }
                          if (state is ErrorState) {
                            CustomToast.handleError(state.failure);
                          }
                        });
                      } else {
                        context
                            .read<MemorizationProvider>()
                            .editRecite(_reciting)
                            .then((state) {
                          if (state is MessageState) {
                            CustomToast.showToast(state.message);
                            Navigator.pop<Reciting>(context, _reciting);
                          }
                          if (state is ErrorState) {
                            CustomToast.handleError(state.failure);
                          }
                        });
                      }
                    } else {
                      CustomToast.showToast("أدخل التقدير");
                    }
                  },
            child: context.watch<MemorizationProvider>().isLoadingIn
                ? const MyWaitingAnimation()
                : const Icon(
                    Icons.done,
                  )),
        appBar: AppBar(
          title: Text(_reciting.reciterPep!.getFullName()),
          elevation: 15,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                MyInfoCard(
                    body: _reciting.page.toString(), head: "رقم الصفحة :"),
                MyInfoCardEdit(
                  child: InkWell(
                    onTap: widget.myRank != IdNameModel.asModerator &&
                            !myAccount.custom!.admin
                        ? null
                        : () async {
                            String? year = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return YearPickerDialog(
                                  init: _reciting.listenerPer?.getFullName(),
                                  dates: widget.listners
                                      .map((e) => e.getFullName())
                                      .toList(),
                                );
                              },
                            );
                            if (year != null) {
                              setState(() {
                                _reciting.listenerPer = widget.listners
                                    .firstWhere((e) => e.getFullName() == year);
                              });
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("الأستاذ المستمع"),
                          Text(
                            _reciting.listenerPer!.getFullName(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          20.getWidthSizedBox,
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
                                _reciting.createdAt = dateTime.getYYYYMMDD();
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
                                MehDate.getDateTime(_reciting.createdAt),
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
                          const Text("تاريخ تسميع الصفحة : "),
                          Text("${_reciting.createdAt}"),
                          const Icon(Icons.date_range),
                        ],
                      ),
                    ),
                  ),
                ),
                MyInfoCardEdit(
                  child: Row(
                    children: [
                      const Text("التقدير"),
                      10.getWidthSizedBox,
                      Expanded(
                          child: MyComboBox(
                              text: taqders
                                  .firstWhere(
                                    (element) =>
                                        element.id == _reciting.ratesIdRate,
                                    orElse: () => IdNameModel(),
                                  )
                                  .name,
                              onChanged: (p0) {
                                setState(() {
                                  _reciting.ratesIdRate = taqders
                                      .firstWhere(
                                          (element) => element.name == p0)
                                      .id;
                                });
                              },
                              items: taqders.map((e) => e.name!).toList())),
                      Expanded(
                        child: MyCheckBox(
                          val: _reciting.tajweed,
                          text: "مع تجويد",
                          onChanged: (p0) {
                            setState(() {
                              _reciting.tajweed = p0!;
                              _reciting.ratesIdRate = null;
                              if (p0) {
                                taqders.add(
                                  IdNameModel(id: 3, name: "ممتاز"),
                                );
                                taqders.remove(
                                  IdNameModel(id: 1, name: "جيد"),
                                );
                              } else {
                                taqders.add(
                                  IdNameModel(id: 1, name: "جيد"),
                                );
                                taqders.remove(
                                  IdNameModel(id: 3, name: "ممتاز"),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // MyInfoCardEdit(
                //   child:
                // ),

                Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyTextFormField(
                      labelText: "الأخطاء",
                      onChanged: (p0) => _reciting.mistakes = p0,
                      textInputType: TextInputType.multiline,
                      initVal: _reciting.mistakes,
                    )),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyTextFormField(
                      labelText: "الملاحظات",
                      onChanged: (p0) => _reciting.notes = p0,
                      initVal: _reciting.notes,
                      textInputType: TextInputType.multiline,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
