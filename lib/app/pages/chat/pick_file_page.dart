import 'dart:io';
import 'package:al_khalil/app/pages/chat/audio_tile_card.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class PickFilePage extends StatefulWidget {
  const PickFilePage({super.key});

  @override
  State<PickFilePage> createState() => _PickFilePageState();
}

class _PickFilePageState extends State<PickFilePage> {
  List<File> files = [];
  final FileManagerController controller = FileManagerController();
  @override
  void initState() {
    getAudioFiles();
    super.initState();
  }

  getAudioFiles() async {
    await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            List<FileSystemEntity> entities = snapshot;
            return ListView.builder(
              itemCount: entities.length,
              itemBuilder: (context, index) {
                return FileManager.isFile(entities[index]) &&
                        path.extension(entities[index].path) != ".mp3"
                    ? const SizedBox.shrink()
                    : !FileManager.isFile(entities[index])
                        ? ListTile(
                            leading: const Icon(Icons.folder),
                            title: Text(FileManager.basename(entities[index])),
                            onTap: () {
                              controller.openDirectory(entities[index]);
                            })
                        : AudioTileCard(
                            id: index,
                            fileSystemEntity: entities[index],
                          );
              },
            );
          },
        ),
      ),
    );
  }
}
