import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:al_khalil/features/downloads/widgets/my_popup_menu.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeDownloads extends StatefulWidget with WidgetsBindingObserver {
  const HomeDownloads({super.key, this.downloadItem});

  final DownloadItem? downloadItem;

  @override
  State<HomeDownloads> createState() => _HomeDownloadsState();
}

class _HomeDownloadsState extends State<HomeDownloads> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  bool _showContent = false;
  bool _permissionReady = false;
  String? _localPath;
  final ReceivePort _port = ReceivePort();

  Future<String> getDownloadDir() async {
    final isExist = await Directory("/storage/emulated/0/Download/").exists();
    if (isExist) {
      return "/storage/emulated/0/Download/";
    } else {
      return "/storage/emulated/0/Downloads/";
    }
  }

  Future copyToDownloads(String path) async {
    final downloaddir = await getDownloadDir();
    final name = path.split("/").last;
    final downloadAlkhalilDir = Directory("$downloaddir/alkhalil/");
    await downloadAlkhalilDir.create();
    File(path).copySync(downloadAlkhalilDir.path + name);
  }

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;
      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    // print(
    //   'Callback on background isolate: '
    //   'task ($id) is in status ($status) and process ($progress)',
    // );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  Widget _buildDownloadList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: _items.map(
              (item) {
                return DownloadListItem(
                  data: item,
                  onTap: (task) async {
                    OpenFilex.open(item.task?.getlocalpath);
                  },
                  onCopy: (p0) {
                    copyToDownloads(p0.getlocalpath!);
                  },
                  onActionTap: (task) {
                    if (task.status == DownloadTaskStatus.undefined) {
                      _requestDownload(task);
                    } else if (task.status == DownloadTaskStatus.running) {
                      _pauseDownload(task);
                    } else if (task.status == DownloadTaskStatus.paused) {
                      _resumeDownload(task);
                    } else if (task.status == DownloadTaskStatus.complete ||
                        task.status == DownloadTaskStatus.canceled) {
                      _delete(task);
                    } else if (task.status == DownloadTaskStatus.failed) {
                      _retryDownload(task);
                    }
                  },
                  onCancel: _delete,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _retryRequestPermission,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      savedDir: _localPath!,
      showNotification: true,
      openFileFromNotification: true,
      fileName: task.name,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final notifi = await Permission.notification.status;
      if (notifi != PermissionStatus.granted) {
        final result2 = await Permission.notification.request();
        if (result2 != PermissionStatus.granted) {
          return false;
        }
      }

      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted &&
          notifi == PermissionStatus.granted) {
        return true;
      }
      final result = await Permission.storage.request();

      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  Future<void> _prepare() async {
    _permissionReady = await _checkPermission();
    await _prepareSaveDir();

    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];
    _tasks!.addAll(tasks.map((e) {
      return TaskInfo(
        link: e.url,
        name: e.filename,
        localLink: _localPath,
      );
    }).toList());

    if (widget.downloadItem != null &&
        _tasks!.where((e) {
          return widget.downloadItem?.name == e.name;
        }).isEmpty) {
      _tasks!.add(TaskInfo(
        link: widget.downloadItem?.url,
        name: widget.downloadItem?.name,
        localLink: _localPath,
      ));
    }
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    setState(() {
      _showContent = true;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath!);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    final tempDir = await getTemporaryDirectory();
    final downloadsDir = Directory("${tempDir.path}/downloads/");
    await downloadsDir.create();
    return downloadsDir.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التنزيلات"),
      ),
      body: Builder(
        builder: (context) {
          if (!_showContent) {
            return const Center(child: CircularProgressIndicator());
          }
          return _permissionReady
              ? _buildDownloadList()
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.localLink, this.name, this.link});

  final String? name;
  final String? link;
  final String? localLink;
  get getlocalpath {
    return "$localLink$name";
  }

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

class DownloadListItem extends StatelessWidget {
  const DownloadListItem({
    super.key,
    this.data,
    this.onTap,
    this.onActionTap,
    this.onCancel,
    this.onCopy,
  });

  final ItemHolder? data;
  final void Function(TaskInfo?)? onTap;
  final void Function(TaskInfo)? onActionTap;
  final void Function(TaskInfo)? onCancel;
  final void Function(TaskInfo)? onCopy;

  String getFileSize(int fileSize) {
    if (fileSize < 500000) {
      return "${(fileSize / 1024).toStringAsFixed(2)} كيلوبايت";
    } else {
      return "${(fileSize / 1024 / 1024).toStringAsFixed(2)} ميغابايت";
    }
  }

  Widget? _buildTrailing(TaskInfo task, ThemeData theme) {
    if (task.status == DownloadTaskStatus.undefined) {
      return IconButton(
        onPressed: () => onActionTap?.call(task),
        icon: const Icon(Icons.file_download),
        tooltip: 'Start',
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return IconButton(
        onPressed: () => onActionTap?.call(task),
        constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
        icon: Icon(Icons.pause, color: theme.colorScheme.tertiary),
        tooltip: 'Pause',
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onActionTap?.call(task),
            icon: Icon(Icons.play_arrow, color: theme.colorScheme.primary),
            tooltip: 'Resume',
          ),
          if (onCancel != null)
            IconButton(
              onPressed: () => onCancel?.call(task),
              icon: Icon(Icons.cancel, color: theme.colorScheme.error),
              tooltip: 'Cancel',
            ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return MyPopUpMenu(
        list: [
          MyPopUpMenu.getWithIcon(
            "حفظ في التنزيلات",
            Icons.save_alt,
            onTap: () async {
              onCopy?.call(task);
            },
          ),
          MyPopUpMenu.getWithIcon(
            "حذف",
            Icons.delete,
            color: Colors.red,
            onTap: () async {
              onActionTap?.call(task);
            },
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Canceled', style: TextStyle(color: Colors.red)),
          if (onActionTap != null)
            IconButton(
              onPressed: () => onActionTap?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel',
            ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Failed', style: TextStyle(color: Colors.red)),
          IconButton(
            onPressed: () => onCancel?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'حذف',
          ),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.refresh, color: Colors.green),
            tooltip: 'Refresh',
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return const Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  Widget? _buildSubtitle(TaskInfo task, ThemeData theme) {
    if (task.status == DownloadTaskStatus.complete) {
      return Text(getFileSize(File(task.getlocalpath).lengthSync()));
    } else if (task.status == DownloadTaskStatus.running) {
      return Text('${max(0, data!.task!.progress ?? 0)}%');
    } else if (task.status == DownloadTaskStatus.paused) {
      return Text('${max(0, data!.task!.progress ?? 0)}%');
    }
    return null;
  }

  Widget? _buildLeading(TaskInfo task, ThemeData theme) {
    if (task.status == DownloadTaskStatus.complete) {
      return task.name!.contains("apk")
          ? const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("assets/images/res_log.png"),
            )
          : CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: FileImage(File(task.getlocalpath)),
            );
    } else {
      return data!.name!.contains("apk")
          ? const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("assets/images/res_log.png"),
            )
          : const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(CupertinoIcons.doc),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.hoverColor,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(data?.name ?? "", maxLines: 1),
            trailing: _buildTrailing(data!.task!, theme),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: data!.task!.status == DownloadTaskStatus.complete
                ? () {
                    onTap!(data!.task);
                  }
                : null,
            leading: _buildLeading(data!.task!, theme),
            subtitle: _buildSubtitle(data!.task!, theme),
          ),
          if (data!.task!.status == DownloadTaskStatus.running ||
              data!.task!.status == DownloadTaskStatus.paused)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 4, left: 4),
              child: LinearProgressIndicator(
                color: theme.colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(15),
                minHeight: 2,
                value: data!.task!.progress! / 100,
              ),
            ),
        ],
      ),
    );
  }
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}
