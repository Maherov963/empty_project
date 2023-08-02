import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import '../../../domain/models/management/person.dart';
import '../../components/my_snackbar.dart';
import '../../providers/states/provider_states.dart';
import '../../utils/widgets/my_search_field.dart';

class StudentsAddPtsPage extends StatefulWidget {
  final List<Person> students;
  const StudentsAddPtsPage({
    super.key,
    required this.students,
  });

  @override
  State<StudentsAddPtsPage> createState() => _StudentsAddPtsPageState();
}

class _StudentsAddPtsPageState extends State<StudentsAddPtsPage> {
  TextEditingController textEditingController = TextEditingController();
  late List<Person> searchList = widget.students;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      minChildSize: 0.5,
      builder: (_, scrollController) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: MySearchField(
            labelText: "اسم الطالب",
            textEditingController: textEditingController,
            onChanged: (p0) {
              setState(() {
                if (p0.isEmpty) {
                  searchList = widget.students;
                } else {
                  searchList = [];
                  for (var element in widget.students) {
                    if (element
                        .getFullName()
                        .getSearshFilter()
                        .contains(p0.getSearshFilter())) {
                      searchList.add(element);
                    }
                  }
                }
              });
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchList[index].getFullName()),
                    subtitle:
                        Text(searchList[index].student!.groupIdName!.name!),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AddPtsDialog(
                            reciever: searchList[index],
                            sender: context.read<CoreProvider>().myAccount!),
                      ).then((value) {
                        if (value is AdditionalPoints) {
                          setState(() {
                            MySnackBar.showMySnackBar(
                                "تمت عملية الإضافة بنجاح", context,
                                contentType: ContentType.success,
                                title: "الخليل");
                            Navigator.pop(context, value);
                          });
                        }
                      });
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

class AddPtsDialog extends StatefulWidget {
  const AddPtsDialog({super.key, required this.sender, required this.reciever});
  final Person sender;
  final Person reciever;
  @override
  State<AddPtsDialog> createState() => _AddPtsDialogState();
}

class _AddPtsDialogState extends State<AddPtsDialog> {
  final _key = GlobalKey<FormState>();
  late final AdditionalPoints draft = AdditionalPoints(
    senderPer: widget.sender,
    recieverPep: widget.reciever,
    createdAt: DateTime.now().getYYYYMMDD(),
    note: widget.sender.custom!.admin ? "قرار إداري" : null,
  );
  bool isAdd = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: const Text("إضافة نقاط"),
        content: Form(
          key: _key,
          child: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView(
              children: [
                MyCheckBox(
                  val: isAdd,
                  text: isAdd ? "إضافة" : "حسم",
                  onChanged: (p0) {
                    setState(() {
                      isAdd = p0!;
                    });
                  },
                ),
                10.getHightSizedBox(),
                MyTextFormField(
                  preIcon: isAdd ? null : const Icon(Icons.minimize),
                  labelText: "النقاط",
                  textInputType: TextInputType.number,
                  initVal: draft.points?.toString() ?? "",
                  maximum: 4,
                  onChanged: (p0) => draft.points = int.tryParse(p0),
                ),
                10.getHightSizedBox(),
                MyTextFormField(
                  labelText: "الوصف",
                  initVal: draft.note,
                  minimum: 2,
                  onChanged: (p0) => draft.note = p0,
                ),
              ],
            ),
          ),
        ),
        actions: [
          context.watch<AdditionalPointsProvider>().isLoadingIn
              ? const MyWaitingAnimation()
              : ElevatedButton(
                  onPressed: () async {
                    if (draft.points == null || draft.points == 0) {
                      MySnackBar.showMySnackBar("اختر قيمة النقاط", context,
                          contentType: ContentType.warning, title: "انتبه");
                    } else if ((_key.currentState!.validate())) {
                      if (!isAdd) draft.points = draft.points! * (-1);
                      await context
                          .read<AdditionalPointsProvider>()
                          .addAdditionalPoints(draft)
                          .then((state) {
                        if (state is IdState) {
                          MySnackBar.showMySnackBar(
                              "تمت العملية بنجاح", context,
                              contentType: ContentType.failure,
                              title: "الخليل");
                          draft.id = state.id;
                          Navigator.pop<AdditionalPoints>(context, draft);
                        } else if (state is ErrorState) {
                          MySnackBar.showMySnackBar(
                              state.failure.message, context,
                              contentType: ContentType.failure,
                              title: "الخليل");
                        }
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).dialogBackgroundColor),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onSecondary),
                  ),
                  child: const Text("حفظ"),
                ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).dialogBackgroundColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
        ],
      ),
    );
  }
}
