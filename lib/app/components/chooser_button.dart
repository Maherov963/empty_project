import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:flutter/material.dart';
import 'my_info_card_edit.dart';

class ChooserButtonn extends StatefulWidget {
  const ChooserButtonn(
      {super.key,
      required this.title,
      this.insertPressed,
      this.isState = false,
      required this.text,
      required this.controller,
      this.onPressed,
      this.onDelete});
  final void Function()? onPressed;
  final String title;
  final bool isState;
  final String text;
  final Function()? onDelete;
  final Function()? insertPressed;
  final IdNameModel controller;
  @override
  State<ChooserButtonn> createState() => _ChooserButtonState();
}

class _ChooserButtonState extends State<ChooserButtonn> {
  @override
  Widget build(BuildContext context) {
    return MyInfoCardEdit(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          widget.controller.id == null
              ? TextButton(
                  onPressed: widget.insertPressed,
                  child: (widget.insertPressed == null && !widget.isState)
                      ? const MyWaitingAnimation()
                      : Text(
                          widget.text,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w600),
                        ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      TextButton(
                        onPressed: widget.onPressed,
                        child: widget.onPressed == null && !widget.isState
                            ? const MyWaitingAnimation()
                            : Text(
                                '${widget.controller.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                      ),
                      IconButton(
                          onPressed: () {
                            widget.controller.id = null;
                            widget.controller.name = null;
                            setState(() {});
                            if (widget.onDelete != null) {
                              widget.onDelete!();
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          )),
                    ]),
        ],
      ),
    );
  }
}
