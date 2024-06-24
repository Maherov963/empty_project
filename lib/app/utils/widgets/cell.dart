// import 'package:flutter/material.dart';

// class MyCell extends StatefulWidget {
//   final String? text;
//   final String? tooltip;
//   final bool isTitle;
//   final bool isButton;
//   final int flex;
//   final Color? color;
//   final Color? textColor;
//   final Future<void> Function()? onTap;
//   const MyCell({
//     super.key,
//     this.flex = 10,
//     required this.text,
//     this.tooltip,
//     this.isTitle = false,
//     this.onTap,
//     this.color,
//     this.textColor,
//     this.isButton = false,
//   });

//   @override
//   State<MyCell> createState() => _MyCellState();
// }

// class _MyCellState extends State<MyCell> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: widget.flex,
//       child: InkWell(
//         onTap: widget.onTap,
//         child: Tooltip(
//           message: widget.tooltip ?? widget.text ?? "",
//           child: Container(
//             padding: const EdgeInsets.only(right: 5),
//             // height: 60,

//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     widget.text ?? "",
//                     maxLines: 2,
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.visible,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: widget.textColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
