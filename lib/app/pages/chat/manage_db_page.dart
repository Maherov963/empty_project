import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ManageDbPage extends StatefulWidget {
  const ManageDbPage({super.key});

  @override
  State<ManageDbPage> createState() => _ManageDbPageState();
}

class _ManageDbPageState extends State<ManageDbPage> {
  late String currentFolder;
  late String baseFolder;
  @override
  void initState() {
    getListFiles();
    super.initState();
  }

  List<FileSystemEntity> items = [];
  getListFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();
    currentFolder = directory.path;
    baseFolder = directory.path;
    items = directory.listSync();
    setState(() {});
  }

  getListFilesFolder(FileSystemEntity folder) async {
    items = (folder as Directory).listSync();
    currentFolder = folder.path;
    setState(() {});
  }

  getParentFolder() async {
    items = Directory(currentFolder).parent.listSync();
    currentFolder = Directory(currentFolder).parent.path;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentFolder == baseFolder) {
          return true;
        } else {
          await getParentFolder();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(FileManager.basename(items[index])),
            leading: FileManager.isDirectory(items[index])
                ? const Icon(Icons.folder)
                : const Icon(Icons.file_copy),
            onTap: () async {
              if (FileManager.isDirectory(items[index])) {
                await getListFilesFolder(items[index]);
              } else {}
            },
          ),
        ),
      ),
    );
  }
}
