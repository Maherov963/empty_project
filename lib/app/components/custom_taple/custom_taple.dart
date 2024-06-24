import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTaple extends StatelessWidget {
  const CustomTaple({
    super.key,
    required this.culomn,
    required this.row,
    this.controller,
  });
  final List<CustomCulomnCell> culomn;
  final Iterable<CustomRow>? row;
  final ScrollController? controller;
  @override
  Widget build(BuildContext context) {
    final list = row?.toList();
    return Column(
      children: [
        CustomColumn(cells: culomn),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (context, index) => list![index],
            itemCount: list?.length ?? 0,
          ),
        ),
      ],
    );
  }
}

class CustomColumn extends StatelessWidget {
  const CustomColumn({super.key, required this.cells});
  final List<Widget> cells;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Row(children: cells),
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.row});
  final List<Widget> row;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).hoverColor,
      ),
      child: Row(
        children: row,
      ),
    );
  }
}

class CustomCell extends StatelessWidget {
  const CustomCell({
    super.key,
    this.flex = 1,
    required this.text,
    this.onTap,
    this.isDanger = false,
    this.color,
  });

  final int flex;
  final bool isDanger;
  final Color? color;
  final void Function()? onTap;

  final String? text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              text ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ??
                    (isDanger
                        ? theme.error
                        : onTap == null
                            ? null
                            : theme.tertiary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconCell extends StatelessWidget {
  const CustomIconCell({
    super.key,
    this.flex = 1,
    required this.icon,
    this.onTap,
    this.isDanger = false,
  });

  final int flex;
  final bool isDanger;
  final void Function()? onTap;

  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Icon(
              icon,
              color: isDanger
                  ? theme.error
                  : onTap == null
                      ? null
                      : theme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBoxCell extends StatelessWidget {
  const CheckBoxCell({
    super.key,
    this.flex = 1,
    required this.isChecked,
    this.onTap,
    this.enabled = true,
  });

  final int flex;
  final bool isChecked;
  final bool enabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Checkbox(
              isError: !isChecked,
              value: isChecked,
              onChanged: (value) {
                HapticFeedback.heavyImpact();
                onTap?.call();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCulomnCell extends StatelessWidget {
  const CustomCulomnCell({
    super.key,
    this.flex = 1,
    required this.text,
    this.onSort,
    this.sortType = SortType.none,
  });
  final int flex;
  final Function()? onSort;
  final String text;
  final SortType sortType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onSort,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sortType == SortType.dec)
                const Icon(
                  CupertinoIcons.sort_down,
                  size: 14,
                ),
              if (sortType == SortType.inc)
                const Icon(
                  CupertinoIcons.sort_up,
                  size: 14,
                ),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SortType { inc, dec, none }
