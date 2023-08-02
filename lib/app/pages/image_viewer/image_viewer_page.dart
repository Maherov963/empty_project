import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String? link;
  final String name;
  const ImageViewer({super.key, this.link, this.tag = 0, required this.name});
  final dynamic tag;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool isShown = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DismissiblePage(
        direction: DismissiblePageDismissDirection.up,
        onDismissed: () => Navigator.of(context).pop(),
        key: const Key("imageViewer"),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isShown = !isShown;
                    });
                  },
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: InteractiveViewer(
                          child: Hero(
                              tag: widget.tag,
                              // child: widget.link == null ||
                              //         widget.link == "" ||
                              //         widget.link!.endsWith("posts/DEFAULT.jpg")?
                              child: Image.asset('assets/images/profile.png')
                              // : Image.file(File(widget.link!)),
                              )),
                    ),
                  ),
                ),
                !isShown
                    ? const SizedBox()
                    : Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            Expanded(
                                child: Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            )),
                          ],
                        )),
              ],
            )),
      ),
    );
  }
}
