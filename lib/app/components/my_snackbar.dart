import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/components/group_selector.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../router/router.dart';
import '../utils/widgets/my_checkbox.dart';
import '../utils/widgets/my_search_field.dart';
import 'my_info_card_edit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MySnackBar {
  static showMySnackBar(String content, BuildContext context,
      {required ContentType contentType, String? title}) {
    // if (context.mounted) {
    Fluttertoast.cancel();
    // FToast().removeCustomToast();
    // FToast().init(context);
    // FToast().showToast(
    //     child: Dismissible(
    //   key: const Key("value"),
    //   child: Container(
    //     constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //       color: Theme.of(context).brightness == Brightness.dark
    //           ? Color.fromARGB(255, 43, 42, 42)
    //           : Colors.white,
    //     ),
    //     padding: EdgeInsets.all(8),
    //     // width: 150,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Expanded(
    //           child: Text(
    //             content,
    //             maxLines: 2,
    //             style: TextStyle(
    //               fontSize: 12,
    //               overflow: TextOverflow.ellipsis,
    //               color: contentType == ContentType.failure
    //                   ? Theme.of(context).colorScheme.error
    //                   : contentType == ContentType.success
    //                       ? Theme.of(context).colorScheme.onSecondary
    //                       : contentType == ContentType.warning
    //                           ? color12
    //                           : Theme.of(context).colorScheme.tertiary,
    //             ),
    //           ),
    //         ),
    //         Image.asset(
    //           "assets/images/logo.png",
    //           width: 32,
    //           height: 32,
    //         ),
    //       ],
    //     ),
    //   ),
    // ));
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        webShowClose: true,
        // webPosition: ToastGravity.BOTTOM_RIGHT,
        webBgColor: "linear-gradient(to right, #121B22, #121B22)",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   elevation: 0,
    //   duration: const Duration(seconds: 5),
    //   backgroundColor: Colors.transparent,
    //   dismissDirection: DismissDirection.horizontal,
    //   content: MyAwesomeSnackbarContent(
    //     title: title ?? "الخليل",
    //     message: content,
    //     titleFontSize: 16,
    //     messageFontSize: 14,

    //     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
    //     contentType: contentType,
    //   ),
    // ));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       duration: Duration(seconds: 2),
    //       content: Text(
    //         content,
    //         style: const TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //       action: SnackBarAction(
    //           label: "نسخ",
    //           textColor: Colors.black,
    //           onPressed: () {
    //             Clipboard.setData(ClipboardData(text: content));
    //           }),
    //       backgroundColor: Colors.grey,
    //       behavior: SnackBarBehavior.fixed,
    //       dismissDirection: DismissDirection.horizontal),
    // );
    // }
  }

  static Future<IdNameModel?> showMyGroupOne(
      {required String title,
      required BuildContext context,
      required List<IdNameModel> data,
      required List<IdNameModel> classsCount,
      required IdNameModel idNameModel,
      int stGrPer = 1}) async {
    return await showDialog<IdNameModel>(
        context: context,
        builder: (ctx) => GroupSelector(
            title: title,
            data: data,
            classsCount: classsCount,
            idNameModel: idNameModel,
            ctx: ctx));
  }

  static Future<IdNameModel?> showMyChooseOne(
      {required String title,
      required BuildContext context,
      required List<IdNameModel> data,
      required IdNameModel idNameModel,
      String? classs,
      int? count,
      int stPer = 1}) async {
    return await showDialog<IdNameModel>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Text(title),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop<IdNameModel>(ctx, idNameModel);
              },
              child: Text(
                "إلغاء",
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
              )),
        ],
        content: SizedBox(
          width: 500,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemBuilder: (_, index) => GestureDetector(
                          onTap: () {
                            Navigator.pop<IdNameModel>(ctx, data[index]);
                          },
                          child: MyInfoCardEdit(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NameButton(
                                  id: data[index].id!,
                                  name: data[index].name.toString(),
                                  stPer: stPer,
                                ),
                                const IconButton(
                                    onPressed: null, icon: Icon(Icons.add)),
                              ],
                            ),
                          ),
                        ),
                    itemCount: data.length),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<List<IdNameModel>?> showMyChooseMulti({
    required String title,
    required BuildContext context,
    required List<IdNameModel> data,
    required List<IdNameModel> choosen,
    bool isPerson = true,
  }) async {
    for (var element in data) {
      for (var choosenElement in choosen) {
        if (choosenElement == element) {
          element.val = true;
        }
      }
    }
    return await showDialog<List<IdNameModel>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop<List<IdNameModel>>(ctx, null);
              },
              child: Text(
                "إلغاء",
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop<List<IdNameModel>>(ctx, choosen);
              },
              child: Text(
                "تم",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )),
        ],
        content: StatefulBuilder(builder: (statecontext, setState) {
          return SizedBox(
            width: 500,
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (_, index) => MyInfoCardEdit(
                            child:
                                // TextButton(
                                //   onPressed: () async {
                                //     if (!isPerson) {
                                //       MyRouter.navigateToGroup(
                                //           statecontext, data[index].id!);
                                //     } else {
                                //       MyRouter.navigateToPerson(
                                //           statecontext, data[index].id!);
                                //     }
                                //   },
                                //   child: Text(

                                //     style: TextStyle(
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .tertiary),
                                //   ),
                                // ),
                                MyCheckBox(
                              text: data[index].name.toString(),
                              val: data[index].val,
                              onChanged: (value) {
                                setState(() {
                                  data[index].val = value!;
                                  if (data[index].val) {
                                    choosen.add(data[index]);
                                  } else {
                                    choosen.remove(data[index]);
                                  }
                                });
                              },
                            ),
                          ),
                      itemCount: data.length),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  static Future<List<IdNameModel>?> showMyltiPicker({
    required BuildContext context,
    required List<IdNameModel> data,
    required List<IdNameModel> choosen,
    bool isPerson = true,
  }) async {
    for (var element in data) {
      for (var choosenElement in choosen) {
        if (choosenElement == element) {
          element.val = true;
          choosenElement.val = true;
        }
      }
    }
    return await showModalBottomSheet<List<IdNameModel>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return MultiBottomPicker(data: data, choosen: choosen);
      },
    );
  }

  static Future<bool> showDeleteDialig(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تحذير'),
              content: const Text('سيتم الحذف بدون تراجع!'),
              actions: [
                TextButton.icon(
                    style: ButtonStyle(
                        overlayColor: MaterialStatePropertyAll(
                            Colors.red.withOpacity(0.2)),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('حذف')),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('إلغاء')),
              ],
            );
          },
        ) ??
        false;
  }
}

class NameButton extends StatelessWidget {
  final int id;
  final String name;
  final int stPer;
  const NameButton({
    super.key,
    required this.id,
    required this.name,
    required this.stPer,
  });

  @override
  Widget build(BuildContext context) {
    return context.watch<PersonProvider>().isLoadingPerson == id
        ? const MyWaitingAnimation()
        : TextButton(
            onPressed: stPer == 1
                ? null
                : () async {
                    await MyRouter.navigateToPerson(context, id);
                  },
            child: Text(
              name,
              style: TextStyle(
                  color: stPer == 1
                      ? null
                      : Theme.of(context).colorScheme.tertiary),
            ),
          );
  }
}

class MultiBottomPicker extends StatefulWidget {
  const MultiBottomPicker(
      {super.key, required this.data, required this.choosen});
  final List<IdNameModel> data;
  final List<IdNameModel> choosen;
  @override
  State<MultiBottomPicker> createState() => _MultiBottomPickerState();
}

class _MultiBottomPickerState extends State<MultiBottomPicker> {
  TextEditingController controller = TextEditingController();
  List<IdNameModel> filtered = [];
  List<IdNameModel> choosen = [];
  @override
  void initState() {
    filtered = widget.data;
    for (var element in widget.data) {
      if (element.val) {
        choosen.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      builder: (_, scrollController) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (widget.data.length == choosen.length) {
                        for (var e in choosen) {
                          e.val = false;
                        }
                        choosen = [];
                      } else {
                        for (var e in widget.data) {
                          if (!e.val) {
                            e.val = true;
                            choosen.add(e);
                          }
                        }
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.select_all,
                      color: widget.data.length == choosen.length
                          ? Theme.of(context).colorScheme.onSecondary
                          : null,
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MySearchField(
                      labelText: "ابحث بالاسم ...",
                      textEditingController: controller,
                      onChanged: (p0) {
                        filtered = [];
                        for (var element in widget.data) {
                          if (element.name!
                              .getSearshFilter()
                              .contains(p0.getSearshFilter())) {
                            filtered.add(element);
                          }
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100, mainAxisExtent: 100),
                itemBuilder: (context, index) => MyPickItem(
                  idNameModel: filtered[index],
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      filtered[index].val = !filtered[index].val;
                      if (filtered[index].val) {
                        choosen.add(filtered[index]);
                      } else {
                        choosen.remove(filtered[index]);
                      }
                    });
                  },
                ),
                itemCount: filtered.length,
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              color: Theme.of(context).focusColor,
              alignment: AlignmentDirectional.centerStart,
              child: const Text("تم اختيارهم"),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemBuilder: (context, index) => MyPickItem(
                  idNameModel: choosen[index],
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      choosen[index].val = false;
                      choosen.remove(choosen[index]);
                    });
                  },
                ),
                scrollDirection: Axis.horizontal,
                itemCount: choosen.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, choosen);
                  },
                  child: Text(
                    "حفظ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "إلغاء",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyPickItem extends StatefulWidget {
  const MyPickItem({super.key, required this.idNameModel, this.onTap});
  final IdNameModel idNameModel;
  final void Function()? onTap;
  @override
  State<MyPickItem> createState() => _MyPickItemState();
}

class _MyPickItemState extends State<MyPickItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 100,
        width: 80,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.idNameModel.val)
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ClipOval(
                  child: SizedBox.square(
                      dimension: widget.idNameModel.val ? 40 : 50,
                      child: Image.asset("assets/images/profile.png")),
                ),
                if (widget.idNameModel.val)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: const Icon(Icons.done),
                    ),
                  ),
                if (widget.idNameModel.val)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Text(
                widget.idNameModel.name.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ContentType {
  warning,
  failure,
  success,
  help,
}
