import 'package:al_khalil/app/pages/home/dynamic_banner.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/app/utils/widgets/my_compobox.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/custom_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/widgets/my_button_menu.dart';

class StudentStep extends StatefulWidget {
  final Student student;
  final bool fromEdit;
  final int classs;
  final List<Group> groups;

  const StudentStep({
    super.key,
    required this.student,
    required this.groups,
    required this.classs,
    this.fromEdit = false,
  });

  @override
  State<StudentStep> createState() => _StudentStepState();
}

class _StudentStepState extends State<StudentStep> {
  @override
  void initState() {
    if (widget.student.id == null) {
      widget.student.recommendGroup(widget.groups, widget.classs);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAccount = context.read<CoreProvider>().myAccount!;

    if (!myAccount.custom!.appointStudent) {
      return const Center(child: Text("لاتمتلك الصلاحيات لإضافة طلاب"));
    } else {
      if (widget.fromEdit && !myAccount.custom!.appointStudent) {
        return const Center(child: Text("لاتمتلك الصلاحيات لتعديل طلاب"));
      } else {
        return Column(
          children: [
            DynamicBanner(
              color: Colors.red,
              visable: CustomState.getStateFromId(widget.student.state) !=
                  CustomState.active,
              text: "حالة الطالب غير نشط",
              icon: Icons.warning_amber,
            ),
            10.getHightSizedBox,
            MyComboBox(
              text: CustomState.getStateFromId(widget.student.state),
              hint: "حالة الطالب",
              items: CustomState.activationStates,
              onChanged: (value) {
                setState(() {
                  widget.student.state = CustomState.getIdFromState(value);
                });
              },
            ),
            10.getHightSizedBox,
            if (myAccount.custom!.appointStudent)
              MyButtonMenu(
                title: "الحلقة",
                enabled: myAccount.custom?.adder != false,
                value: widget.student.groubName,
                onTap: () async {
                  final group = await CustomSheet.showMyBottomSheet<Group>(
                      context,
                      GroupsShooser(
                        groups: widget.groups,
                        selected: widget.student.groubId,
                      ));
                  if (group != null) {
                    setState(() {
                      widget.student.groubId = group.id;
                      widget.student.groubName = group.groupName;
                    });
                  }
                },
              ),
            10.getHightSizedBox,
          ],
        );
      }
    }
  }
}

class GroupsShooser extends StatelessWidget {
  const GroupsShooser({
    super.key,
    required this.groups,
    required this.selected,
  });
  final List<Group> groups;
  final int? selected;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(groups[index].groupName ?? "",
              style: Theme.of(context).textTheme.titleLarge),
          leading: Text(groups[index].students?.length.toString() ?? "",
              style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(groups[index].getEducations,
              style: Theme.of(context).textTheme.titleSmall),
          trailing: IconButton(
            onPressed: () {
              context.navigateToGroup(groups[index].id!);
            },
            icon: const Icon(Icons.remove_red_eye),
          ),
          selected: selected == groups[index].id,
          onTap: () {
            Navigator.pop(context, groups[index]);
          },
        );
      },
    );
  }
}
