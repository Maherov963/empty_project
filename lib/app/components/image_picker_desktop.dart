// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:drag_and_drop_windows/drag_and_drop_windows.dart' as dd;

// class ImagePickerDesktop extends StatefulWidget {
//   const ImagePickerDesktop({Key? key, required this.imageController})
//       : super(key: key);
//   final TextEditingController imageController;
//   @override
//   State<ImagePickerDesktop> createState() => _ImagePickerDesktopState();
// }

// class _ImagePickerDesktopState extends State<ImagePickerDesktop> {
//   StreamSubscription? _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _subscription ??= dd.dropEventStream.listen((paths) {
//       if (context.mounted) {
//         setState(() {
//           widget.imageController.text = paths[0];
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Visibility(
//         visible: widget.imageController.text != "",
//         replacement: const Text("drop photo here"),
//         child: Stack(
//           children: [
//             Image.file(File(widget.imageController.text)),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     widget.imageController.text = '';
//                   });
//                 },
//                 icon: const Icon(Icons.close))
//           ],
//         ),
//       ),
//     );
//   }
// }
