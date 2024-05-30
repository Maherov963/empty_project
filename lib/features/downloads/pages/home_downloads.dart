import 'dart:io';

import 'package:al_khalil/features/downloads/widgets/my_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class HomeDownloads extends StatefulWidget {
  const HomeDownloads({super.key});

  @override
  State<HomeDownloads> createState() => _HomeDownloadsState();
}

class _HomeDownloadsState extends State<HomeDownloads> {
  List<String> _paths = [];

  Future<List<String>> getAllFilesInDir() async {
    final tempDir = await getTemporaryDirectory();
    final downloadsDir = Directory("${tempDir.path}/downloads");
    await downloadsDir.create();
    final Directory directory = Directory(downloadsDir.path);
    final List<FileSystemEntity> entities = directory.listSync();
    // Filter the list to only include files.
    final List<File> files = entities.whereType<File>().toList();
    // Get the paths of the files.
    final List<String> filePaths = files.map((file) => file.path).toList();
    return filePaths;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _paths = await getAllFilesInDir();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("التنزيلات")),
      body: ListView.builder(
        itemCount: _paths.length,
        itemBuilder: (context, index) {
          final name = _paths[index].split("/").lastOrNull;
          return ListTile(
            title: Text(name ?? ""),
            leading: name!.contains("apk")
                ? const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/images/res_log.png"),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(File(_paths[index])),
                  ),
            onTap: () {
              OpenFilex.open(_paths[index]);
            },
            trailing: MyPopUpMenu(
              list: [
                MyPopUpMenu.getWithIcon(
                  "حذف",
                  Icons.delete,
                  color: Colors.red,
                  onTap: () async {
                    await File(_paths[index]).delete();
                    _paths = await getAllFilesInDir();
                    setState(() {});
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
