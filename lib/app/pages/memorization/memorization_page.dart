import 'package:al_khalil/app/pages/memorization/test_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/managing/memorization_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/memorization/section.dart';
import 'package:al_khalil/domain/models/memorization/test.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/memorization/page.dart';
import '../../../domain/models/static/id_name_model.dart';
import '../../components/waiting_animation.dart';
import '../../utils/messges/toast.dart';
import '../../utils/themes/dark_theme.dart';
import 'reciting_page.dart';

class MemorizationPage extends StatefulWidget {
  final List<QuranSection> quranSections;
  final Person person;
  final List<Person> listners;
  final int myRank;
  const MemorizationPage({
    super.key,
    required this.quranSections,
    required this.person,
    required this.listners,
    required this.myRank,
  });

  @override
  State<MemorizationPage> createState() => _MemorizationPageState();
}

class _MemorizationPageState extends State<MemorizationPage> {
  List<IdNameModel> taqders = [
    IdNameModel(id: 0, name: "تسميع قديم"),
    IdNameModel(id: 1, name: "جيد"),
    IdNameModel(id: 2, name: "جيد جداً"),
    IdNameModel(id: 3, name: "ممتاز"),
  ];

  late Person myAccount;
  @override
  Widget build(BuildContext context) {
    myAccount = context.read<CoreProvider>().myAccount!;
    return Scaffold(
        appBar: AppBar(), body: Center(child: const Text("غير متاح")));

    return Scaffold(
      appBar: AppBar(
        title: Text("محفوظات ${widget.person.getFullName()} "),
        elevation: 15,
      ),
      body: ListView(
        children: widget.quranSections
            .map(
              (section) => Padding(
                padding: const EdgeInsets.all(0.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  child: ExpansionTile(
                    backgroundColor: Theme.of(context).focusColor,
                    leading: const Icon(Icons.arrow_drop_down_sharp),
                    trailing: section.test == null
                        ? TextButton.icon(
                            label: Text("سبر الجزء",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                            icon: Icon(
                              Icons.spatial_tracking_outlined,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () async {
                              if (!myAccount.custom!.test) {
                                CustomToast.showToast(
                                    CustomToast.noPermissionError);
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestPage(
                                      quranTest: QuranTest(
                                        testedPep: widget.person,
                                        testerPer: myAccount,
                                        section: section.idSection,
                                        createdAt: DateTime.now().getYYYYMMDD(),
                                      ),
                                    ),
                                  ),
                                ).then((value) {
                                  if (value is QuranTest) {
                                    setState(() {
                                      section.test = value;
                                    });
                                  }
                                });
                              }
                            },
                          )
                        : TextButton.icon(
                            label: Text("تم السبر",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                            icon: Icon(
                              Icons.done,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => InfoDialog(
                                  title: "معلومات السبر",
                                  infoData: [
                                    getInfoCard("الجزء",
                                        section.test?.section.toString()),
                                    const Divider(),
                                    getInfoCard("اسم الطالب",
                                        section.test?.testedPep?.getFullName()),
                                    const Divider(),
                                    getInfoCard("الأستاذ الذي سبر له",
                                        section.test?.testerPer?.getFullName()),
                                    const Divider(),
                                    getInfoCard("التقدير",
                                        "${section.test?.mark ?? ""}%"),
                                    const Divider(),
                                    getInfoCard("نقاط التجويد",
                                        section.test?.tajweed?.toString()),
                                    const Divider(),
                                    getInfoCard(
                                        "الأخطاء", section.test?.mistakes),
                                    const Divider(),
                                    getInfoCard("تاريخ العملية",
                                        "${section.test?.createdAt}"),
                                    const Divider(),
                                    getInfoCard(
                                        "الملاحظات", section.test?.notes),
                                  ],
                                  onDelete: () async {
                                    await context
                                        .read<MemorizationProvider>()
                                        .deleteTest(section.test!.idTest!)
                                        .then((state) {
                                      if (state is MessageState) {
                                        CustomToast.showToast(state.message);
                                        setState(() {
                                          section.test = null;
                                        });
                                      }
                                      if (state is ErrorState) {
                                        CustomToast.handleError(state.failure);
                                      }
                                    });
                                  },
                                  onEdit: () async {
                                    if (!myAccount.custom!.test) {
                                      CustomToast.showToast(
                                          CustomToast.noPermissionError);
                                    } else {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TestPage(
                                            quranTest: section.test!,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value is QuranTest) {
                                          setState(() {
                                            section.test = value;
                                          });
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                    // trailing: Icon(Icons.percent_rounded),
                    subtitle: Row(
                      children: [
                        Text("تم تسميع",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onError)),
                        Text(
                            " ${section.pages.where((e) => e.reciting != null).length}",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                    title: Text("الجزء ${section.idSection}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError)),
                    children: section.pages
                        .map(
                          (page) => ListTile(
                            onTap: page.reciting == null
                                ? () async {
                                    if (!myAccount.custom!.recite) {
                                      CustomToast.showToast(
                                          CustomToast.noPermissionError);
                                    } else {
                                      await Navigator.push<Reciting>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecitingPage(
                                              myRank: widget.myRank,
                                              listners: widget.listners,
                                              reciting: Reciting(
                                                createdAt: DateTime.now()
                                                    .getYYYYMMDD(),
                                                listenerPer: myAccount,
                                                reciterPep: widget.person,
                                                page: page.idPage,
                                              ),
                                            ),
                                          )).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            page.reciting = value;
                                          });
                                        }
                                      });
                                    }
                                  }
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => InfoDialog(
                                        title: "معلومات التسميع",
                                        infoData: [
                                          getInfoCard("الصفحة",
                                              page.reciting?.page.toString()),
                                          const Divider(),
                                          getInfoCard(
                                              "الأستاذ المستمع",
                                              page.reciting?.listenerPer
                                                  ?.getFullName()),
                                          const Divider(),
                                          getInfoCard(
                                              "الطالب",
                                              page.reciting?.reciterPep
                                                  ?.getFullName()),
                                          const Divider(),
                                          getInfoCard(
                                              "التقدير",
                                              taqders[page.reciting
                                                          ?.ratesIdRate ??
                                                      1]
                                                  .name
                                                  .toString()),
                                          const Divider(),
                                          getInfoCard("تاريح التسميع",
                                              page.reciting?.createdAt),
                                          const Divider(),
                                          getInfoCard("الأخطاء",
                                              page.reciting?.mistakes),
                                          const Divider(),
                                          getInfoCard("الملاحظات",
                                              page.reciting?.notes),
                                        ],
                                        onEdit: () async {
                                          if (!myAccount.custom!.recite) {
                                            CustomToast.showToast(
                                                CustomToast.noPermissionError);
                                          } else {
                                            await Navigator.push<Reciting>(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RecitingPage(
                                                    myRank: widget.myRank,
                                                    listners: widget.listners,
                                                    reciting: page.reciting!,
                                                  ),
                                                )).then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  page.reciting = value;
                                                });
                                              }
                                            });
                                          }
                                        },
                                        onDelete: () async {
                                          await context
                                              .read<MemorizationProvider>()
                                              .deleteRecite(
                                                  page.reciting!.idReciting!)
                                              .then((state) {
                                            if (state is MessageState) {
                                              CustomToast.showToast(
                                                  state.message);
                                              setState(() {
                                                page.reciting = null;
                                              });
                                            }
                                            if (state is ErrorState) {
                                              CustomToast.showToast(
                                                  state.failure.message);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  },
                            trailing: page.reciting == null
                                ? null
                                : Text(
                                    "${page.reciting?.listenerPer?.getFullName()}"),
                            leading: Text("الصفحة ${page.idPage}"),
                            subtitle: Text(page.surah ?? ""),
                            title: page.reciting == null
                                ? null
                                : Text(
                                    taqders[page.reciting?.ratesIdRate ?? 1]
                                        .name
                                        .toString(),
                                    style: TextStyle(
                                        color: page.reciting?.ratesIdRate == 1
                                            ? Colors.blue
                                            : page.reciting?.ratesIdRate == 2
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary
                                                : page.reciting?.ratesIdRate ==
                                                        3
                                                    ? color12
                                                    : null),
                                  ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  getInfoCard(String? head, String? body) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: RichText(
          text: TextSpan(
            text: "$head : ",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: body ?? "",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
}

class InfoDialog extends StatelessWidget {
  final List<Widget> infoData;
  final String title;
  final void Function()? onEdit;
  final Future<void> Function()? onDelete;
  const InfoDialog({
    super.key,
    required this.title,
    required this.infoData,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.info_outline),
      iconColor: Theme.of(context).colorScheme.onSecondary,
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: infoData,
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).focusColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('حسناً', style: TextStyle(color: Colors.white)),
        ),
        if (onEdit != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onEdit!();
            },
            child: const Text(
              'تعديل',
            ),
          ),
        if (onDelete != null)
          context.watch<MemorizationProvider>().isLoadingIn
              ? const MyWaitingAnimation()
              : ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.error)),
                  onPressed: () async {
                    CustomDialog.showDeleteDialig(context).then((value) async {
                      if (value) {
                        await onDelete!().then((value) {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  },
                  child: const Text(
                    'حذف',
                  ),
                ),
      ],
    );
  }
}
