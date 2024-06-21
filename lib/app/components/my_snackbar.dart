import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import '../router/router.dart';
import '../utils/widgets/my_search_field.dart';
import 'my_info_card_edit.dart';

class MySnackBar {
  static Future<IdNameModel?> showMyChooseOne({
    required String title,
    required BuildContext context,
    required List<IdNameModel> data,
    required IdNameModel idNameModel,
    String? classs,
    int? count,
    int stPer = 1,
  }) async {
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

  static Future<List<IdNameModel>?> showMyltiPicker({
    required BuildContext context,
    required List<IdNameModel> data,
    bool enabled = true,
    required List<IdNameModel> choosen,
    bool isPerson = true,
    bool disableMulti = false,
  }) async {
    return await showModalBottomSheet<List<IdNameModel>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return MultiBottomPicker(
          data: data,
          choosen: choosen,
          disableMulti: disableMulti,
        );
      },
    );
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
    return TextButton(
      onPressed: stPer == 1
          ? null
          : () async {
              await context.navigateToPerson(id);
            },
      child: Text(
        name,
        style: TextStyle(
            color: stPer == 1 ? null : Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}

class MultiBottomPicker extends StatefulWidget {
  const MultiBottomPicker({
    super.key,
    required this.data,
    required this.choosen,
    required this.disableMulti,
  });
  final List<IdNameModel> data;
  final List<IdNameModel> choosen;
  final bool disableMulti;
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
    choosen = widget.choosen;
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
                if (!widget.disableMulti)
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (widget.data.length != choosen.length) {
                          choosen = [];
                          for (var e in widget.data) {
                            choosen.add(e);
                          }
                        } else {
                          choosen = [];
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.select_all,
                        color: widget.data.length == choosen.length
                            ? Theme.of(context).colorScheme.primary
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
                  selected: choosen.contains(filtered[index]),
                  idNameModel: filtered[index],
                  onTap: () {
                    if (widget.disableMulti) {
                      choosen = [];
                    }
                    FocusScope.of(context).unfocus();
                    setState(() {
                      if (!choosen.contains(filtered[index])) {
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
              color: Theme.of(context).hoverColor,
              alignment: AlignmentDirectional.centerStart,
              child: const Text("تم اختيارهم"),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemBuilder: (context, index) => MyPickItem(
                  selected: true,
                  idNameModel: choosen[index],
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      choosen.remove(choosen[index]);
                    });
                  },
                ),
                scrollDirection: Axis.horizontal,
                itemCount: choosen.length,
              ),
            ),
            CustomTextButton(
              text: "حفظ",
              onPressed: () {
                Navigator.pop(context, choosen);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyPickItem extends StatefulWidget {
  const MyPickItem({
    super.key,
    required this.idNameModel,
    this.onTap,
    required this.selected,
  });
  final IdNameModel idNameModel;
  final bool selected;
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
                if (widget.selected)
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ClipOval(
                  child: SizedBox.square(
                      dimension: widget.selected ? 40 : 50,
                      child: Image.asset("assets/images/profile.png")),
                ),
                if (widget.selected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: const Icon(Icons.done),
                    ),
                  ),
                if (widget.selected)
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
