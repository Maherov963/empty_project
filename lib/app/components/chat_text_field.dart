import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController textEditingController;

  const ChatTextField({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  void initState() {
    super.initState();
  }

  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      focusNode: _focusNode,
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
        // final textSpan = TextSpan(
        //   text: value,
        //   style: const TextStyle(
        //     fontSize:
        //         30, // replace with the actual font size used in the TextField
        //   ),
        // );
        // final textPainter = TextPainter(
        //   text: textSpan,
        //   textDirection: TextDirection.rtl,
        //   textAlign: TextAlign.right,
        //   maxLines: null,
        // )..layout(maxWidth: MediaQuery.of(context).size.width);
        // final numberOfLines = textPainter.computeLineMetrics().length;
        // context.read<ChatProvider>().changeTextState(value, numberOfLines + 1);
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
