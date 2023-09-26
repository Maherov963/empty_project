import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat/chat_provider.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  const ChatTextField(
      {Key? key, required this.textEditingController, this.focusNode})
      : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      maxLines: 6,
      minLines: 1,
      autofocus: false,
      style: textTheme.titleMedium!.copyWith(
        fontSize: 16,
      ),
      onTap: () {
        if (widget.textEditingController.selection ==
            TextSelection.fromPosition(TextPosition(
                offset: widget.textEditingController.text.length - 1))) {
          widget.textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textEditingController.text.length));
        }
      },
      onChanged: (value) {
        context.read<ChatProvider>().changeTextState(value);
      },
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(5),
        hintText: 'اكتب هنا',
        border: InputBorder.none,
      ),
    );
  }
}
