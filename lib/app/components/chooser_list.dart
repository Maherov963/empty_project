import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/managing/person_provider.dart';
import 'my_info_card_edit.dart';
import 'my_info_list.dart';

class ChooserListo extends StatefulWidget {
  const ChooserListo({
    super.key,
    required this.title,
    this.insertPressed,
    required this.text,
    required this.isPerson,
    required this.choosingData,
  });
  final List<IdNameModel> choosingData;
  final String title;
  final String text;
  final bool isPerson;
  final Function()? insertPressed;
  @override
  State<ChooserListo> createState() => _ChooserListState();
}

class _ChooserListState extends State<ChooserListo> {
  @override
  Widget build(BuildContext context) {
    return MyInfoList(
      title: widget.title,
      data: [
        Column(
          children: widget.choosingData
              .map((e) => MyInfoCardEdit(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        context.watch<PersonProvider>().isLoadingPerson ==
                                    e.id ||
                                context.watch<GroupProvider>().isLoadingGroup ==
                                    e.id
                            ? const MyWaitingAnimation()
                            : TextButton(
                                onPressed: widget.isPerson
                                    ? () async {
                                        await context.navigateToPerson(e.id!);
                                      }
                                    : () async {
                                        await context.navigateToGroup(e.id!);
                                      },
                                child: Text(
                                  '${e.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.choosingData.remove(e);
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            )),
                      ],
                    ),
                  ))
              .toList(),
        ),
        TextButton(
            onPressed: widget.insertPressed,
            child: widget.insertPressed == null
                ? const MyWaitingAnimation()
                : Text(
                    widget.text,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ))
      ],
    );
  }
}
