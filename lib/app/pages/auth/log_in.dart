import 'package:al_khalil/app/components/my_snackbar.dart';
import 'package:al_khalil/app/pages/home/home_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/domain/models/personality/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/waiting_animation.dart';
import '../../utils/widgets/widgets.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  User user = User();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('جامع إبراهيم الخليل'),
        elevation: 15,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
                SizedBox(
                  width: w * 0.8,
                  child: MyTextFormField(
                    onChanged: (p0) => user.userName = p0,
                    initVal: user.userName,
                    labelText: 'اسم المستخدم',
                    preIcon: const Icon(
                      Icons.account_circle,
                    ),
                    textInputType: TextInputType.name,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.newUsername
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: w * 0.8,
                  child: MyTextPassField(
                    onChanged: (p0) => user.passWord = p0,
                    autofillHints: const [
                      AutofillHints.password,
                      AutofillHints.newPassword,
                    ],
                    labelText: 'كلمة المرور',
                    preIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: w * 0.8,
                  height: 40,
                  child: Selector<CoreProvider, int?>(
                    selector: (p0, p1) => p1.isLoggingIn,
                    shouldRebuild: (previous, next) => previous != next,
                    builder: (_, value, child) => ElevatedButton(
                      onPressed: value != null
                          ? null
                          : () async {
                              ProviderStates logInState =
                                  await context.read<CoreProvider>().logIn(
                                        user,
                                      );
                              if (logInState is PersonState &&
                                  context.mounted) {
                                context.read<CoreProvider>().myAccount =
                                    logInState.person;
                                if (!context
                                    .read<CoreProvider>()
                                    .myAccounts
                                    .contains(logInState.person)) {
                                  context
                                      .read<CoreProvider>()
                                      .myAccounts
                                      .add(logInState.person);
                                }
                                await context
                                    .read<CoreProvider>()
                                    .setCashedAccounts()
                                    .then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                      (route) => false);
                                });
                              } else if (logInState is ErrorState && mounted) {
                                MySnackBar.showMySnackBar(
                                    logInState.failure.message, context,
                                    contentType: ContentType.failure,
                                    title: "حدث خطأ");
                              }
                            },
                      child: value != null
                          ? const MyWaitingAnimation()
                          : const Text(
                              'دخول',
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
