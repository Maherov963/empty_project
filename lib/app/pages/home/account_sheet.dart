import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/models.dart';
import '../../providers/core_provider.dart';
import '../../utils/messges/toast.dart';
import '../auth/log_in.dart';
import 'home_page.dart';

class AccountSheet extends StatelessWidget {
  const AccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Person? myAccount = context.read<CoreProvider>().myAccount;

    return Consumer<CoreProvider>(
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...value.myAccounts.map<Widget>(
              (e) => ListTile(
                title: Text(
                  e.userName!,
                ),
                leading: const Icon(Icons.account_circle_outlined),
                trailing: e.id == myAccount?.id
                    ? Icon(
                        Icons.done,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : IconButton(
                        onPressed: () async {
                          final agreed = await CustomDialog.showDeleteDialig(
                            context,
                            content:
                                'هل تود تسجيل الخروج من حساب ${e.userName}؟',
                          );
                          if (agreed && context.mounted) {
                            await context.read<CoreProvider>().removeAccount(e);
                          }
                        },
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error)),
                onTap: context.watch<CoreProvider>().isLoggingIn == e.id
                    ? null
                    : () async {
                        if (e.id == myAccount?.id) {
                          Navigator.pop(context);
                        } else {
                          final logInState =
                              await context.read<CoreProvider>().logIn(
                                    User(
                                        id: e.id,
                                        passWord: e.password,
                                        userName: e.userName),
                                  );
                          if (logInState is DataState<Person> &&
                              context.mounted) {
                            context.read<CoreProvider>().myAccount =
                                logInState.data;
                            context.myPushReplacmentAll(const HomePage());
                          } else if (logInState is ErrorState &&
                              context.mounted) {
                            CustomToast.showToast(logInState.failure.message);
                          }
                        }
                      },
              ),
            ),
            ListTile(
              title: const Text("إضافة حساب جديد"),
              trailing: const Icon(Icons.add),
              onTap: () {
                context.myPush(const LogIn());
              },
            ),
          ],
        );
      },
    );
  }
}
