// import 'package:al_khalil/app/utils/widgets/circle_avatar_button.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerMobile extends StatefulWidget {
//   const ImagePickerMobile(
//       {super.key, required this.imageController, required this.radius});
//   final TextEditingController imageController;
//   final double radius;
//   @override
//   State<ImagePickerMobile> createState() => _ImagePickerMobileState();
// }

// class _ImagePickerMobileState extends State<ImagePickerMobile> {
//   final ImagePicker picker = ImagePicker();

//   fromGallery() async {
//     await picker.pickImage(source: ImageSource.gallery).then((value) async {
//       widget.imageController.text = await imageCroper(value!.path);
//       setState(() {});
//     });
//   }

//   fromCamera() async {
//     await picker.pickImage(source: ImageSource.camera).then((value) async {
//       widget.imageController.text = await imageCroper(value!.path);
//       setState(() {});
//     });
//   }

//   Future<String> imageCroper(String path) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: path,
//         maxHeight: 500,
//         maxWidth: 500,
//         aspectRatio: const CropAspectRatio(ratioX: 500, ratioY: 500),
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Theme.of(context).scaffoldBackgroundColor,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: true,
//             statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//             activeControlsWidgetColor: const Color.fromARGB(255, 94, 8, 75),
//           ),
//         ]);
//     if (croppedFile == null) {
//       return "";
//     }
//     return croppedFile.path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.bottomStart,
//       children: [
//         ClipOval(
//           child: SizedBox.square(
//             dimension: widget.radius * 2,
//             child: CircleAvatarButton(
//                 link: widget.imageController.text, fullName: "", id: 0),
//           ),
//         ),
//         PopupMenuButton(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               onTap: fromGallery,
//               child: const Text("الاستديو"),
//             ),
//             PopupMenuItem(
//               onTap: fromCamera,
//               child: const Text("الكاميرا"),
//             ),
//             PopupMenuItem(
//               onTap: () {
//                 widget.imageController.text = "";
//                 setState(() {});
//               },
//               child:
//                   const Text("حذف الصورة", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//           child: CircleAvatar(
//             radius: widget.radius / 5,
//             child: Icon(Icons.edit, size: widget.radius / 5),
//           ),
//         ),
//       ],
//     );
//   }
// }
