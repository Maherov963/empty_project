import 'package:flutter/material.dart';
import '../../router/router.dart';
import '../../utils/messges/sheet.dart';
import 'account_sheet.dart';

class CustomSearchBar<T> extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onSearch,
    required this.hint,
    required this.showLeading,
    required this.title,
    required this.enable,
    this.resultBuilder,
  });
  final List<T> Function(String)? onSearch;
  final String hint;
  final String title;
  final bool enable;
  final bool showLeading;
  // final Widget leading;
  // final Widget trailing;
  final Widget Function(BuildContext, int, T)? resultBuilder;

  @override
  Widget build(BuildContext context) {
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
            IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu)),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                // textAlign: TextAlign.center,
              ),
            ),
            if (showLeading)
              IconButton(
                onPressed: () {
                  CustomSheet.showMyBottomSheet(context, const AccountSheet());
                },
                icon: const Icon(Icons.account_circle_outlined),
              ),
          ],
        ),
      ),
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
