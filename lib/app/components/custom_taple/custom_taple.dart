import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTaple extends StatelessWidget {
  const CustomTaple({
    super.key,
    required this.culomn,
    required this.row,
  });
  final List<CustomCulomnCell> culomn;
  final List<CustomRow> row;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomColumn(cells: culomn),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => row[index],
            itemCount: row.length,
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
        color: Theme.of(context).highlightColor,
      ),
      child: Row(
        children: cells,
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.row});
  final List<CustomCell> row;

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
    required this.flex,
    required this.text,
  });
  final int flex;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        // decoration: BoxDecoration(
        //   border: Border.symmetric(
        //     vertical: BorderSide(
        //       color: Theme.of(context).highlightColor,
        //     ),
        //   ),
        // ),
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            text ?? "",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CustomCulomnCell extends StatelessWidget {
  const CustomCulomnCell({
    super.key,
    required this.flex,
    required this.text,
    required this.onSort,
    required this.sortType,
  });
  final int flex;
  final Function() onSort;
  final String text;
  final SortType sortType;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.sort_down,
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
