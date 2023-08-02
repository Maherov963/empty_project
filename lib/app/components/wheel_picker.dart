import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YearPicker extends StatefulWidget {
  final String? initialYear;
  final Function(String)? onYearSelected;
  final List<String> dates;
  const YearPicker(
      {super.key, this.initialYear, this.onYearSelected, required this.dates});

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  String? _selectedYear;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialYear != null) {
        _scrollController.animateToItem(
            widget.dates.indexOf(widget.initialYear!),
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut);
      } else {
        _scrollController.animateToItem(50,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: CupertinoPicker(
        itemExtent: 50,
        magnification: 1,
        scrollController: _scrollController,
        onSelectedItemChanged: (value) {
          HapticFeedback.lightImpact();
          _selectedYear = widget.dates[value];
          widget.onYearSelected!(_selectedYear!);
        },
        children: widget.dates
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 12.5),
                child: Text(e,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onError)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class YearPickerDialog extends StatefulWidget {
  final ValueChanged<String?>? onYearSelected;
  final String? init;
  final List<String> dates;
  const YearPickerDialog(
      {super.key,
      this.onYearSelected,
      required this.init,
      required this.dates});

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late String? _selectedYear = widget.init;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      alignment: Alignment.bottomCenter,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actionsPadding: const EdgeInsets.all(0),
      content: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          margin: const EdgeInsets.all(5),
          height: 300,
          width: double.maxFinite,
          child: ListView(
            children: [
              YearPicker(
                onYearSelected: (p0) {
                  _selectedYear = p0;
                },
                initialYear: _selectedYear,
                dates: widget.dates,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.pop(context, _selectedYear);
                    },
                    child: const Text('موافق'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
