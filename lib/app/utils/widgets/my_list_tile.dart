import 'package:flutter/material.dart';
import '../../pages/group/group_profile.dart';

class MyListTile extends StatelessWidget {
  final String? name;
  final String? id;
  final String? image;

  const MyListTile({
    super.key,
    this.name,
    this.image,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5),
              spreadRadius: 1,
              blurStyle: BlurStyle.outer,
              blurRadius: 5)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GroupProfile(),
              ));
        },
        title: Text('$name'),
        trailing: const Icon(Icons.more_horiz),
        subtitle: Text('$id'),
      ),
    );
  }
}
