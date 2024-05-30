import 'package:al_khalil/app/utils/widgets/my_pass_form_field.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/waiting_animation.dart';
import '../../providers/core_provider.dart';
import '../../providers/managing/person_provider.dart';
import '../../providers/states/provider_states.dart';
import '../../utils/messges/toast.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController oldPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController sureNewPass = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تغيير كلمة المرور"),
      ),
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  MyTextPassField(
                    labelText: "كلمة المرور القديمة",
                    textEditingController: oldPass,
                  ),
                  15.getHightSizedBox,
                  MyTextPassField(
                    labelText: "كلمة المرور الجديدة",
                    textEditingController: newPass,
                    minChar: 4,
                  ),
                  15.getHightSizedBox,
                  MyTextPassField(
                    labelText: "تأكيد كلمة المرور",
                    textEditingController: sureNewPass,
                    minChar: 4,
                  ),
                  15.getHightSizedBox,
                  ElevatedButton(
                    onPressed: context.watch<PersonProvider>().isLoadingIn
                        ? null
                        : () async {
                            if (_key.currentState!.validate()) {
                              if (oldPass.text !=
                                  context
                                      .read<CoreProvider>()
                                      .myAccount!
                                      .password) {
                                CustomToast.showToast(
                                    "كلمة المرور القديمة غير صحيحة");
                              } else if (sureNewPass.text == newPass.text) {
                                final newAcc = context
                                    .read<CoreProvider>()
                                    .myAccount!
                                    .copy()
                                  ..password = newPass.text;
                                await context
                                    .read<PersonProvider>()
                                    .editPerson(newAcc)
                                    .then((state) {
                                  if (state is MessageState) {
                                    context.read<CoreProvider>().myAccount =
                                        newAcc;
                                    context
                                        .read<CoreProvider>()
                                        .setCashedAccount();
                                    CustomToast.showToast(state.message);

                                    Navigator.pop(context);
                                  }
                                  if (state is ErrorState) {
                                    CustomToast.handleError(state.failure);
                                  }
                                });
                              } else {
                                CustomToast.showToast(
                                    "كلمتا المرور غير متطابقتان");
                              }
                            }
                          },
                    child: context.watch<PersonProvider>().isLoadingIn
                        ? const MyWaitingAnimation()
                        : const Text(
                            'تغيير كلمة المرور',
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
