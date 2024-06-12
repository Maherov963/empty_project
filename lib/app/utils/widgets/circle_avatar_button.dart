import 'dart:io';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

import '../../pages/image_viewer/image_viewer_page.dart';

class CircleAvatarButton extends StatelessWidget {
  final String? link;
  final String fullName;
  final dynamic id;
  final double radius;

  const CircleAvatarButton({
    super.key,
    this.link,
    required this.fullName,
    required this.id,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: id,
        child: ClipOval(
          child: SizedBox.square(
            dimension: radius * 2,
            child: CircleAvatar(
              child: link == null || link == "" || link!.endsWith("DEFAULT.jpg")
                  ? Image.asset('assets/images/profile.png')
                  : Image.file(
                      File(link!),
                    ),
            ),
          ),
        ),
      ),
      onTap: () async {
        await context
            .pushTransparentRoute(
          ImageViewer(
            name: fullName,
            tag: id,
            link: link,
          ),
        )
            .then((value) {
          FocusScope.of(context).requestFocus(FocusNode());
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => ImageViewer(
        //     name: fullName,
        //     tag: id,
        //     link: link,
        //   ),
        // ));
      },
    );
  }
}
