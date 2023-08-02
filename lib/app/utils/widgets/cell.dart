import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyCell extends StatefulWidget {
  final String? text;
  final String? tooltip;
  final bool isTitle;
  final bool isButton;
  final int flex;
  final Color? color;
  final Color? textColor;
  final Future<void> Function()? onTap;
  const MyCell({
    super.key,
    this.flex = 10,
    required this.text,
    this.tooltip,
    this.isTitle = false,
    this.onTap,
    this.color,
    this.textColor,
    this.isButton = false,
  });

  @override
  State<MyCell> createState() => _MyCellState();
}

class _MyCellState extends State<MyCell> {
  @override
  Widget build(BuildContext context) {
    final Color dafaultColor = widget.isTitle
        ? Theme.of(context).primaryColor
        : Theme.of(context).colorScheme.onInverseSurface;
    return Expanded(
      flex: widget.flex,
      child: InkWell(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.tooltip ?? widget.text ?? "",
          child: Container(
            padding: const EdgeInsets.only(right: 5),
            height: 50,
            decoration: BoxDecoration(
              color: widget.color ?? dafaultColor,
              border: const Border.symmetric(
                horizontal: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.text ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                ),
                widget.isButton && widget.onTap == null
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 15,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
