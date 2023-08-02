import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/static/id_name_model.dart';
import 'my_info_card_edit.dart';
import 'waiting_animation.dart';
import '../router/router.dart';

class GroupSelector extends StatelessWidget {
  final String title;
  final List<IdNameModel> data;
  final List<IdNameModel> classsCount;
  final IdNameModel idNameModel;
  final BuildContext ctx;
  const GroupSelector({
    super.key,
    required this.title,
    required this.data,
    required this.classsCount,
    required this.idNameModel,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  itemBuilder: (_, index) => MyInfoCardEdit(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop<IdNameModel>(ctx, data[index]);
                          },
                          //leading: Text(""),
                          subtitle: Text(
                              "${classsCount[index].name} \nالطلاب : ${classsCount[index].id}"),
                          title: Text(
                            data[index].name.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              // fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          trailing:
                              context.watch<GroupProvider>().isLoadingGroup ==
                                      data[index].id
                                  ? const MyWaitingAnimation()
                                  : IconButton(
                                      onPressed: () async {
                                        await MyRouter.navigateToGroup(
                                            context, data[index].id!);
                                      },
                                      icon: const Icon(Icons.remove_red_eye),
                                    ),
                        ),
                      ),
                  itemCount: data.length),
            ),
          ],
        ),
      ),
    );
  }
}
