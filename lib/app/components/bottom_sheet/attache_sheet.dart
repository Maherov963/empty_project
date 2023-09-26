import 'package:al_khalil/app/pages/chat/pick_audio_page.dart';
import 'package:flutter/material.dart';

class MyAttacheSheet extends StatelessWidget {
  const MyAttacheSheet({super.key, this.onSend});
  final void Function()? onSend;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.3,
      initialChildSize: 0.2,
      minChildSize: 0.2,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            crossAxisSpacing: 30,
          ),
          children: [
            MyFilledIcon(
              text: "ملف صوتي",
              color: Colors.orange,
              icon: Icons.headphones,
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickAudioPage(
                      onSend: onSend,
                    ),
                  ),
                );
              },
            ),
            MyFilledIcon(
              text: "كاميرا",
              color: Colors.red,
              icon: Icons.camera_alt_rounded,
              onPressed: () {},
            ),
            MyFilledIcon(
              text: "ملف pdf",
              color: Colors.purple,
              icon: Icons.picture_as_pdf,
              onPressed: () {},
            ),
            MyFilledIcon(
              text: "معرض الصور",
              color: Colors.pinkAccent,
              icon: Icons.collections_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MyFilledIcon extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final void Function()? onPressed;
  const MyFilledIcon({
    super.key,
    required this.color,
    required this.icon,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      overlayColor: MaterialStatePropertyAll(color.withOpacity(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipOval(
            child: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                  colors: [
                    color,
                    color.withOpacity(0.5),
                  ],
                )),
                child: IconButton(
                  icon: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  onPressed: null,
                )),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}
