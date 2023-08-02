import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageT extends StatelessWidget {
  HomePageT({super.key});
  final List<User> users =
      List.generate(30, (index) => User(index, " user $index"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(users[index].id.toString()),
            title: Text(users[index].name),
            onTap: () {
              context.goNamed(
                "profile",
                pathParameters: {
                  "userID": users[index].id.toString(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final int id;
  final String name;

  User(this.id, this.name);
}
