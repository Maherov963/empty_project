// import 'package:al_khalil/app/providers/chat/chat_provider.dart';
// import 'package:al_khalil/app/providers/core_provider.dart';
// import 'package:al_khalil/domain/models/management/person.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../domain/models/messages/message.dart';
// import 'message_bubble.dart';

// class MessageBox extends StatefulWidget {
//   const MessageBox({
//     super.key,
//     required this.message,
//     this.isFirstInSection = false,
//   });

//   final Message message;

//   /// Whether the message is first in a section of messages by same user.
//   final bool isFirstInSection;

//   @override
//   State<MessageBox> createState() => _MessageBoxState();
// }

// class _MessageBoxState extends State<MessageBox> {
//   bool isSelected = false;
//   @override
//   Widget build(BuildContext context) {
//     Person myAccount = context.read<CoreProvider>().myAccount!;
//     return GestureDetector(
//       onLongPress: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//         setState(() {
//           isSelected = true;
//         });
//         showMenu(context: context, position: RelativeRect.fill, items: [
//           PopupMenuItem(
//             child: Icon(
//               Icons.delete,
//               color: Theme.of(context).colorScheme.error,
//             ),
//             onTap: () {
//               context.read<ChatProvider>().deleteMessage(widget.message);
//             },
//           ),
//           PopupMenuItem(
//             child: Icon(
//               Icons.copy,
//               color: Theme.of(context).colorScheme.onError,
//             ),
//             onTap: () {
//               Clipboard.setData(ClipboardData(text: widget.message.text ?? ""));
//             },
//           )
//         ]).then((value) {
//           setState(() {
//             isSelected = false;
//           });
//         });
//       },
//       child: Align(
//         alignment: widget.message.userId == myAccount.id
//             ? Alignment.centerRight
//             : Alignment.centerLeft,
//         child: LayoutBuilder(
//           builder: (context, constrains) {
//             final maxWidth = constrains.maxWidth;
//             return ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: maxWidth - 50,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: maxWidth > 600 ? maxWidth * 0.1 : 0,
//                 ).copyWith(top: widget.isFirstInSection ? 5 : 0),
//                 child: widget.message.audio != null
//                     ? Padding(
//                         padding: const EdgeInsets.all(4),
//                         child: VoiceMessage(
//                           noiseCount: 0,
//                           played: true,
//                           showDuration: true,
//                           duration: Duration(seconds: 15),
//                           me: widget.message.userId ==
//                               context.read<CoreProvider>().myAccount!.id,
//                           audioSrc: widget.message.audio,
//                           meBgColor: Theme.of(context).primaryColor,
//                           mePlayIconColor:
//                               Theme.of(context).appBarTheme.foregroundColor!,
//                           contactFgColor:
//                               Theme.of(context).appBarTheme.foregroundColor!,
//                           contactBgColor:
//                               Theme.of(context).appBarTheme.backgroundColor!,
//                           formatDuration: (duration) => "",
//                         ),
//                       )
//                     : MessageBubble(
//                         isSelected: isSelected,
//                         message: widget.message,
//                         showArrow: widget.isFirstInSection,
//                       ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
