import 'package:al_khalil/app/components/my_info_card_edit.dart';
import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/management/person.dart';
import '../../components/my_snackbar.dart';
import '../../providers/states/provider_states.dart';

class GivePtsPage extends StatefulWidget {
  final List<Person> students;
  const GivePtsPage({super.key, required this.students});

  @override
  State<GivePtsPage> createState() => _GivePtsPageState();
}

class _GivePtsPageState extends State<GivePtsPage> {
  TextEditingController textEditingController = TextEditingController();
  List<Person> suggestionList = [];
  List<Person> searchList = [];
  List<String> groups = [];
  String? choosinGroup;

  int totalPts = 0;
  int totalMoney = 0;
  @override
  void initState() {
    for (var element in widget.students) {
      totalPts = totalPts + int.parse(element.tempPoints.toString());
      totalMoney = totalMoney +
          int.parse(element.tempPoints.toString()).getCeilToThousand();
      if (!groups.contains(element.student!.groupIdName!.name)) {
        groups.add(element.student!.groupIdName!.name!);
      }
    }
    groups.sort(
      (a, b) => a.compareTo(b),
    );
    super.initState();
  }

  int totalPtsGroup = 0;
  int totalMoneyGroup = 0;

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
                        int t;
                        totalPtsGroup = 0;
                        totalMoneyGroup = 0;
                        setState(() {
                          suggestionList = [];
                          for (var element in widget.students) {
                            if (element.student!.groupIdName!.name == p0) {
                              suggestionList.add(element);
                              t = int.parse(element.tempPoints.toString());
                              totalPtsGroup = totalPtsGroup + t;
                              totalMoneyGroup =
                                  totalMoneyGroup + t.getCeilToThousand();
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
            MyInfoCardEdit(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "النقاط الإجمالية للمعهد : ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$totalPts نقطة",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "المبلغ الإجمالي للمعهد : ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$totalMoney ل.س",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (choosinGroup != null)
              MyInfoCardEdit(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "النقاط الإجمالية للحلقة : ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "$totalPtsGroup نقطة",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "المبلغ الإجمالي للحلقة : ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "$totalMoneyGroup ل.س",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchList[index].getFullName()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${searchList[index].tempPoints} نقطة",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${int.parse(searchList[index].tempPoints.toString()).getCeilToThousand()} ل.س",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    leading: const Icon(Icons.clean_hands),
                    trailing:
                        context.watch<AdditionalPointsProvider>().isLoadingIn
                            ? const MyWaitingAnimation()
                            : null,
                    onTap: () async {
                      MySnackBar.showDeleteDialig(context).then((value) async {
                        if (value) {
                          int pts = int.parse(
                            searchList[index].tempPoints.toString(),
                          );
                          await context
                              .read<AdditionalPointsProvider>()
                              .addAdditionalPoints(
                                AdditionalPoints(
                                  note: "تسليم نقاط",
                                  recieverPep: searchList[index],
                                  senderPer:
                                      context.read<CoreProvider>().myAccount,
                                  points: pts * -1,
                                ),
                              )
                              .then(
                            (state) {
                              if (state is ErrorState) {
                                MySnackBar.showMySnackBar(
                                    state.failure.message, context,
                                    contentType: ContentType.failure,
                                    title: "حدث خطأ تقني");
                              } else if (state is IdState) {
                                setState(() {
                                  totalPts = totalPts - pts;
                                  totalPtsGroup = totalPtsGroup - pts;
                                  totalMoneyGroup =
                                      totalMoneyGroup - pts.getCeilToThousand();
                                  totalMoney =
                                      totalMoney - pts.getCeilToThousand();
                                  searchList[index].tempPoints = "0";
                                });
                                MySnackBar.showMySnackBar(
                                    "تمت عملية بنجاح", context,
                                    contentType: ContentType.failure,
                                    title: "حدث خطأ تقني");
                              }
                            },
                          );
                        }
                      });
                    },
                  );
                },
                itemCount: searchList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
