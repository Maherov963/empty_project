import 'package:al_khalil/app/pages/auth/log_in.dart';
import 'package:al_khalil/app/pages/home/home_page.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/utils/messges/dialoge.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/personality/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/router.dart';

class CustomSearchBar<T> extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onSearch,
    required this.hint,
    this.showLeading = false,
    required this.title,
    required this.enable,
    this.leading,
    this.trailing,
    this.resultBuilder,
  });
  final List<T> Function(String)? onSearch;
  final String hint;
  final String title;
  final bool enable;
  final bool showLeading;
  final Widget? leading;
  final Widget? trailing;
  // final Widget trailing;
  final Widget Function(BuildContext, int, T)? resultBuilder;

  @override
  Widget build(BuildContext context) {
    final coreProvider = context.read<CoreProvider>();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(100)),
      constraints: const BoxConstraints(minHeight: 50),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: !enable
            ? null
            : () {
                context.myPush(
                  SearchScreen<T>(
                    onSearch: onSearch,
                    hint: hint,
                    resultBuilder: resultBuilder,
                  ),
                );
              },
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            leading != null
                ? leading!
                : IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            trailing != null
                ? trailing!
                : IconButton(
                    onPressed: () {
                      showCupertinoModalPopup<T>(
                        // enableDrag: true,
                        // isScrollControlled: true,

                        // showDragHandle: true,
                        // useSafeArea: true,
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            isDestructiveAction: true,
                            child: const Text("إلغاء"),
                          ),
                          message: const Text("حساباتي"),
                          actions: [
                            ...coreProvider.myAccounts
                                .map<Widget>(
                                  (e) => CupertinoActionSheetAction(
                                    onPressed: () async {
                                      if (e.id == coreProvider.myAccount?.id) {
                                        Navigator.pop(context);
                                      } else {
                                        final logInState = await context
                                            .read<CoreProvider>()
                                            .logIn(
                                              User(
                                                  id: e.id,
                                                  passWord: e.password,
                                                  userName: e.userName),
                                            );
                                        if (logInState is DataState<Person> &&
                                            context.mounted) {
                                          context
                                              .read<CoreProvider>()
                                              .myAccount = logInState.data;
                                          context.myPushReplacmentAll(
                                              const HomePage());
                                        } else if (logInState is ErrorState &&
                                            context.mounted) {
                                          CustomToast.showToast(
                                              logInState.failure.message);
                                        }
                                      }
                                    },
                                    child: CupertinoListTile(
                                      title: cuprtinoText(e.userName!, context),
                                      leading: const Icon(
                                          Icons.account_circle_outlined),
                                      trailing: e.id ==
                                              coreProvider.myAccount?.id
                                          ? Icon(
                                              Icons.done,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                          : IconButton(
                                              onPressed: () async {
                                                final agreed =
                                                    await CustomDialog
                                                        .showDeleteDialig(
                                                  context,
                                                  content:
                                                      'هل تود تسجيل الخروج من حساب ${e.userName}؟',
                                                );
                                                if (agreed && context.mounted) {
                                                  await context
                                                      .read<CoreProvider>()
                                                      .removeAccount(e);
                                                }
                                              },
                                              icon: Icon(Icons.delete,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error)),
                                    ),
                                  ),
                                )
                                .toList(),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                context.myPush(const LogIn());
                              },
                              child: CupertinoListTile(
                                title: cuprtinoText("إضافة حساب جديد", context),
                                trailing: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      );

                      // CustomSheet.showMyBottomSheet(
                      //     context, const AccountSheet());
                    },
                    icon: const Icon(Icons.account_circle_outlined),
                  ),
          ],
        ),
      ),
    );
  }

  Widget cuprtinoText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class SearchScreen<T> extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.onSearch,
    required this.hint,
    this.resultBuilder,
  });
  final String hint;
  final List<T> Function(String)? onSearch;
  final Widget Function(BuildContext, int, T)? resultBuilder;
  @override
  State<SearchScreen<T>> createState() => _SearchScreenState<T>();
}

class _SearchScreenState<T> extends State<SearchScreen<T>> {
  List<T> result = [];
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).focusColor),
              constraints: const BoxConstraints(minHeight: 50),
              child: SafeArea(
                child: Row(
                  children: [
                    const BackButton(),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            result = widget.onSearch?.call(value) ?? [];
                          });
                        },
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            result = [];
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),
            ),
            if (result.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("تم العثور على ${result.length} نتيجة"),
              ),
            if (result.isEmpty && _controller.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("لا توجد نتائج بحث"),
              ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, endIndent: 10, indent: 10),
                itemBuilder: (context, index) =>
                    widget.resultBuilder?.call(context, index, result[index]),
                itemCount: result.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
